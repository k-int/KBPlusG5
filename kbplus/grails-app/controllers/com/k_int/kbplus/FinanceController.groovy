package com.k_int.kbplus

import com.k_int.kbplus.auth.*

import grails.converters.JSON;

import grails.plugin.springsecurity.annotation.Secured
import com.k_int.kbplus.auth.*;

import grails.plugin.springsecurity.SpringSecurityUtils

//todo Refactor aspects into service
//todo track state, opt 1: potential consideration of using get, opt 2: requests maybe use the #! stateful style syntax along with the history API or more appropriately history.js (cross-compatible, polyfill for HTML4)
//todo Change notifications integration maybe use : changeNotificationService with the onChange domain event action
//todo Refactor index separation of filter page (used for AJAX), too much content, slows DOM on render/binding of JS functionality
//todo Enable advanced searching, use configurable map, see filterQuery() 
class FinanceController {

  def springSecurityService
  private final def dateFormat      = new java.text.SimpleDateFormat("yyyy-MM-dd")
  private final def dateTimeFormat  = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss") {{setLenient(false)}}
  private final def ci_count        = 'select count(ci.id) from CostItem as ci '
  private final def ci_select       = 'select ci from CostItem as ci '
  private final def maxAllowedVals  = [10,20,50,100,200] //in case user has strange default list size, plays hell with UI

  private boolean userCertified(User user, Org institution) {

    if (!user.getAuthorizedOrgs().id.contains(institution.id)) {
        log.error("User ${user.id} trying to access financial Org information not privy to ${institution.name}")
        return false
    }

    return true
  }

    boolean isFinanceAuthorised(Org org, User user) {

      def retval = false

      if ( org ) {
        Role admin_role = Role.findByAuthority('INST_ADM')
        if (org && org.hasUserWithRole(user,admin_role)) //ROLE_ADMIN
            retval = true
      }
      else {
        throw new RuntimeException("isFinanceAuthorised called with NULL org");
      }
      return retval
    }

    def checkUserIsMember(user, org) {
        def result = false;
        // def uo = UserOrg.findByUserAndOrg(user,org)
        def uoq = UserOrg.where {
            (user == user && org == org && (status == 1 || status == 3))
        }

        if (uoq.count() > 0)
            result = true;

        result
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def index() {
      log.debug("FinanceController::index() ${params} / ${params.sub} ${params.sub?'TRUE':'FALSE'}");

      def result = [:]

      try {

        //Check nothing strange going on with financial data
        result.institution =  request.getAttribute('institution')//Org.findByShortcode(params.defaultInstShortcode)

        def user           =  User.get(springSecurityService.principal.id)
        if (!isFinanceAuthorised(result.institution, user)) {
            log.error("Sending 401 - forbidden");
            flash.error=message(code: 'financials.permission.unauthorised', args: [result.institution? result.institution.name : 'N/A'])
            response.sendError(401)
        }

        //Accessed from Subscription page, 'hardcoded' set subscription 'hardcode' values
        //todo Once we know we are in sub only mode, make nessesary adjustments in setupQueryData()
        result.inSubMode   = params.sub ? true : false
        if (result.inSubMode) {

            result.fixedSubscription = Subscription.get(params.int('sub'))

            if (!result.fixedSubscription) {
                log.error("Financials in FIXED subscription mode, sent incorrect subscription ID: ${params?.sub}")
                response.sendError(400, "No relevant subscription, please report this error to an administrator")
            }
            else {
              result.filterMode='ON'
            }
        }
        else {
          log.debug("not in fixed sub mode");
        }

        //Grab the financial data
        financialData(result,params,user)

        result.isXHR = request.isXhr()
        //Other than first run, request will always be AJAX...
        if (result.isXHR) {
            log.debug("XHR Request");
            render (template: "filter", model: result)
        }
        else
        {
            log.debug("HTML Request");
            //First run, make a date for recently updated costs AJAX operation
            use(groovy.time.TimeCategory) {
                result.from = dateTimeFormat.format(new Date() - 3.days)
            }
        }
      }
      catch ( Exception e ) {
        log.error("Error processing index",e);
      }
      finally {
        log.debug("finance::index returning");
      }


      result
    }

    /**
     * Setup the data for the financials processing (see financialData())
     * @param result
     * @param params
     * @param user
     * @return Query data to performing selection, ordering/sorting, and query parameters (e.g. institution)
     */
    private def setupQueryData(result, params, user) {
        //Setup params

        Role admin_role = Role.findByAuthority('INST_ADM')
        result.editable    =  result.institution.hasUserWithRole(user,admin_role)

        request.setAttribute("editable", result.editable) //editable Taglib doesn't pick up AJAX request, REQUIRED!

        // Jesus this is pig ugly:: If params.filterMode is set, use it. If we have a fixedSubscription, filter using that. #Then Cry into beer
        result.filterMode  =  params.filterMode ?: ( result.fixedSubscription ? 'ON' : 'OFF' )
        result.info        =  [] as List
        params.max         =  params.max && params.int('max') ? Math.min(params.int('max'),200) : (user?.defaultPageSize? maxAllowedVals.min{(it-user.defaultPageSize).abs()} : 10)
        result.max         =  params.max
        result.offset      =  params.int('offset',0)?: 0
        result.sort        =  ["desc","asc"].contains(params.sort)? params.sort : "desc" //defaults to sort & order of desc id 
        result.sort        =  params.boolean('opSort')==true? ((result.sort=="asc")? 'desc' : 'asc') : result.sort //opposite
        result.isRelation  =  params.orderRelation? params.boolean('orderRelation',false) : false
        result.wildcard    =  params._wildcard == "off"? false: true //defaulted to on
        params.shortcode   =  result.institution.shortcode
        result.advSearch   =  params.boolean('advSearch',false)
        params.remove('opSort')

        if (params.csvMode && request.getHeader('referer')?.endsWith("${params?.defaultInstShortcode}/finance")) {
            params.max = -1 //Adjust so all results are returned, in regards to present user screen query
            log.debug("Making changes to query setup data for an export...")
        }
        //Query setup options, ordering, joins, param query data....
        def (order, join, gspOrder) = CostItem.orderingByCheck(params.order) //order = field, join = left join required or null, gsporder = to see which field is ordering by
        result.order = gspOrder
        
        //todo Add to query params and HQL query if we are in sub mode e.g. result.inSubMode, result.fixedSubscription
        def cost_item_qry_params  =  [] //[result.institution]
        def cost_item_qry         =  (join)? "LEFT OUTER JOIN ${join} AS j " :"" //(join)? "LEFT OUTER JOIN ${join} AS j WHERE ci.owner = ? " :"  where ci.owner = ? "
        def orderAndSortBy        =  (join)? "ORDER BY COALESCE(j.${order}, ${Integer.MAX_VALUE}) ${result.sort}, ci.id ASC" : " ORDER BY ci.${order} ${result.sort}"

        return [cost_item_qry_params, cost_item_qry, orderAndSortBy]
    }

  //original method above, made a copy so it can be re written using only what is needed instead off the completely fucking unnecessary filter mode on or off bullshit
  private def financialData(result,params,user) {
    //Setup using param data, returning back DB query info
    def (cost_item_qry_params, cost_item_qry, orderAndSortBy) = setupQueryData(result,params,user)

    log.debug("FinanceController::index()  -- Performing filtering processing...")
    def qryOutput = filterQuery(result,params,result.wildcard)
    
    def query = cost_item_qry
    def count_query = cost_item_qry
    
    //add any joins
    if (qryOutput.qry_joins) {
      query += qryOutput.qry_joins
      count_query += qryOutput.qry_joins
    }
    
    //add where statement
    if (qryOutput.qry_where) {
      query += qryOutput.qry_where
      count_query += qryOutput.qry_where
    }
    
    //add sort
    def sortclause = " ORDER BY ci.id desc"
    if ((params.sort != null) && (params.sort.length() > 0)) {
      def sortOpts = params.sort.tokenize(':')
      if (sortOpts.size() == 2) {
        sortclause = " ORDER BY ${sortOpts[0]} ${sortOpts[1]}"
      }
    }
    query += sortclause
    
    if (qryOutput.fqParams) {
      cost_item_qry_params.addAll(qryOutput.fqParams)
    }
    
    log.debug("executing query: ${ci_select + query}")
    log.debug("with query params: ${cost_item_qry_params}")
    
    if (qryOutput.subtext) {
      result.subtext = qryOutput.subtext
    }
    
    if (qryOutput.subpkgtext) {
      result.subpkgtext = qryOutput.subpkgtext
    }
    
    if (qryOutput.ietext) {
      result.ietext = qryOutput.ietext
    }
    
    if (qryOutput.bctext) {
      result.bctext = qryOutput.bctext
    }
    
    result.cost_items =  CostItem.executeQuery(ci_select + query, cost_item_qry_params, params);
    result.cost_item_count =  CostItem.executeQuery(ci_count + count_query, cost_item_qry_params).first();
    log.debug("FinanceController::index()  -- Performed filtering process... ${result.cost_item_count} result(s) found")
    //result.info.addAll(qryOutput.failed)
    //result.info.addAll(qryOutput.valid)
  }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def financialsExport()  {
        log.debug("Financial Export :: ${params}")

        if (params.format == 'csv' || params.format=='tsv' ) {
            def result = [:]
            result.institution =  Org.findByShortcode(params.defaultInstShortcode)
            def user           =  User.get(springSecurityService.principal.id)

            if (!isFinanceAuthorised(result.institution, user)) {
                flash.error=message(code: 'financials.permission.unauthorised', args: [result.institution? result.institution.name : 'N/A'])
                response.sendError(403)
                return
            }

            def separator = "\t";
            if ( params.format == 'csv') {
              separator = ",";
            }

            log.debug("financialData...");
            financialData(result,params,user) //Grab the financials!
            def filename = result.institution.name
            response.setHeader("Content-disposition", "attachment; filename=\"${filename}_financialExport.${params.format}\"")
            response.contentType = "text/${params.format}"
            def out = response.outputStream
            def useHeader = params.header? true : false //For batch processing...

            log.debug("Sending finance csv export");
            processFinancialCSV(out,result,useHeader, separator)
            out.close()
        }
        else {
            log.debug("Sending error response 400");
            response.sendError(400)
        }
    }


    /**
     * Make a CSV export of cost item results
     * @param out    - Output stream
     * @param result - passed from index
     * @param header - true or false
     * @return
     */
    //todo change for batch processing... don't want to kill the server, defaulting to all results presently!
    def private processFinancialCSV(out, result, header, separator) {
        def generation_start = new Date()
        def processedCounter = 0

        switch (params.csvMode)
        {
            case "code":
                log.debug("Processing code mode... Estimated total ${params.estTotal?: 'Unknown'}")

                def categories = RefdataValue.findAllByOwner(RefdataCategory.findByDesc('CostItemStatus')).collect {it.value.toString()} << "Unknown"

                def codeResult = [:].withDefault {
                    categories.collectEntries {
                        [(it): 0 as Double]
                    }
                }

                result.cost_items.each { c ->
                    if (!c.budgetcodes.isEmpty())
                    {
                        log.debug("${c.budgetcodes.size()} codes for Cost Item: ${c.id}")

                        def status = c?.costItemStatus?.value? c.costItemStatus.value.toString() : "Unknown"

                        c.budgetcodes.each {code ->
                            if (!codeResult.containsKey(code.value))
                                codeResult[code.value] //sets up with default values

                            if (!codeResult.get(code.value).containsKey(status))
                            {
                                log.warn("Status should exist in list already, unless additions have been made? Code:${code} Status:${status}")
                                codeResult.get(code.value).put(status, c?.costInLocalCurrencyExVAT? c.costInLocalCurrencyExVAT : 0.0)
                            }
                            else
                            {
                                codeResult[code.value][status] += c?.costInLocalCurrencyExVAT?: 0.0
                            }
                        }
                    }
                    else
                    {
                        log.debug("skipped cost item ${c.id} NO codes are present")
                    }
                }

                def catSize = categories.size()-1
                out.withWriter { writer ->
                    writer.write(separator + categories.join(separator) + "\n") //Header

                    StringBuilder sb = new StringBuilder() //join map vals e.g. estimate : 123

                    codeResult.each {code, cat_statuses ->
                        sb.append(code).append(separator)
                        cat_statuses.eachWithIndex { status, amount, idx->
                            sb.append(amount)
                            if (idx < catSize)
                                sb.append(separator)
                        }
                        sb.append("\n")
                    }
                    writer.write(sb.toString())
                    writer.flush()
                    writer.close()
                }

                processedCounter = codeResult.size()
                break

            case "sub":
                log.debug("Processing subscription data mode... calculation of costs Estimated total ${params.estTotal?: 'Unknown'}")

                def categories = RefdataValue.findAllByOwner(RefdataCategory.findByDesc('CostItemStatus')).collect {it.value} << "Unknown"

                def subResult = [:].withDefault {
                    categories.collectEntries {
                        [(it): 0 as Double]
                    }
                }

                def skipped = []

                result.cost_items.each { c ->
                    if (c?.sub)
                    {
                        def status = c?.costItemStatus?.value? c.costItemStatus.value.toString() : "Unknown"
                        def subID  = c.sub.name

                        if (!subResult.containsKey(subID))
                            subResult[subID] //1st time around for subscription, could 1..* cost items linked...

                        if (!subResult.get(subID).containsKey(status)) //This is here as a safety precaution, you're welcome :P
                        {
                            log.warn("Status should exist in list already, unless additions have been made? Sub:${subID} Status:${status}")
                            subResult.get(subID).put(status, c?.costInLocalCurrencyExVAT? c.costInLocalCurrencyExVAT : 0.0)
                        }
                        else
                        {
                            subResult[subID][status] += c?.costInLocalCurrencyExVAT?: 0.0
                        }
                    }
                    else
                    {
                        skipped.add("${c.id}")
                    }
                }

                log.debug("Skipped ${skipped.size()} out of ${result.cost_items.size()} Cost Item's (NO subscription present) IDs : ${skipped} ")

                def catSize = categories.size()-1
                out.withWriter { writer ->
                    writer.write(separator + categories.join("\t") + separator) //Header

                    StringBuilder sb = new StringBuilder() //join map vals e.g. estimate : 123

                    subResult.each {sub, cat_statuses ->
                        sb.append(sub).append(separator)
                        cat_statuses.eachWithIndex { status, amount, idx->
                            sb.append(amount)
                            if (idx < catSize)
                                sb.append(separator)
                        }
                        sb.append("\n")
                    }
                    writer.write(sb.toString())
                    writer.flush()
                    writer.close()
                }

                processedCounter = subResult.size()
                break

            case "all":
            default:
                log.debug("Processing all mode... Estimated total ${params.estTotal?: 'Unknown'}")

                out.withWriter { writer ->

                    if ( header ) {
                        writer.write("Institution${separator}Generated Date${separator}Cost Item Count${separator}")
                        writer.write("${result.institution.name?:''}${separator}${dateFormat.format(generation_start)}${separator}${result.cost_item_count}${separator}")
                    }

                    // Output the body text
                    writer.write("cost_item_id"+separator+
                                 "owner"+separator+
                                 "invoice_no"+separator+
                                 "order_no"+separator+
                                 "subscription_name"+separator+
                                 "subscription_package"+separator+
                                 "issueEntitlement"+separator+
                                 "date_paid"+separator+
                                 "date_valid_from"+separator+
                                 "date_valid_to"+separator+
                                 "cost_Item_Category"+separator+
                                 "cost_Item_Status"+separator+
                                 "billing_Currency"+separator+
                                 "cost_In_Billing_Currency_Ex_VAT"+separator+
                                 "tax_In_Billing_Currency"+separator+
                                 "cost_In_Billing_Currency_Inc_VAT"+separator+
                                 "cost_In_Local_Currency_Ex_VAT"+separator+
                                 "tax_In_Local_Currency"+separator+
                                 "cost_In_Local_Currency_Inc_VAT"+separator+
                                 "tax_Code"+separator+
                                 "cost_Item_Element"+separator+
                                 "cost_Description"+separator+
                                 "reference"+separator+
                                 "codes"+separator+
                                 "created_by"+separator+
                                 "date_created"+separator+
                                 "edited_by"+separator+
                                 "date_last_edited"+
                                 "\n");

                    result.cost_items.each { ci ->

                        def codes = CostItemGroup.findAllByCostItem(ci).collect { it?.budgetcode?.value+'\t' }

                        def start_date   = ci.startDate ? dateFormat.format(ci?.startDate) : ''
                        def end_date     = ci.endDate ? dateFormat.format(ci?.endDate) : ''
                        def paid_date    = ci.datePaid ? dateFormat.format(ci?.datePaid) : ''
                        def created_date = ci.dateCreated ? dateFormat.format(ci?.dateCreated) : ''
                        def edited_date  = ci.lastUpdated ? dateFormat.format(ci?.lastUpdated) : ''

                        writer.write("\"${ci.id}\"${separator}\"${ci?.owner?.name}\"${separator}\"${ci?.invoice?ci.invoice.invoiceNumber:''}\"${separator}${ci?.order? ci.order.orderNumber:''}${separator}" +
                                "${ci?.sub? ci.sub.name:''}${separator}${ci?.subPkg?ci.subPkg.pkg.name:''}${separator}${ci?.issueEntitlement?ci.issueEntitlement?.tipp?.title?.title:''}${separator}" +
                                "${paid_date}${separator}${start_date}${separator}\"${end_date}\"${separator}\"${ci?.costItemCategory?ci.costItemCategory.value:''}\"${separator}\"${ci?.costItemStatus?ci.costItemStatus.value:''}\"${separator}" +
                                "\"${ci?.billingCurrency.value?:''}\"${separator}\"${ci?.costInBillingCurrencyExVAT?:''}\"${separator}\"${ci?.taxInBillingCurrency?:''}\"${separator}\"${ci?.costInBillingCurrencyIncVAT?:''}\"${separator}" +
                "\"${ci?.costInLocalCurrencyExVAT?:''}\"${separator}\"${ci?.taxInLocalCurrency?:''}\"${separator}\"${ci?.costInLocalCurrencyIncVAT?:''}\"${separator}\"${ci?.taxCode?ci.taxCode.value:''}\"${separator}" +
                                "\"${ci?.costItemElement?ci.costItemElement.value:''}\"${separator}\"${ci?.costDescription?:''}\"${separator}\"${ci?.reference?:''}\"${separator}\"${codes?codes.toString():''}\"${separator}" +
                                "\"${ci.createdBy.username}\"${separator}\"${created_date}\"${separator}\"${ci.lastUpdatedBy.username}\"${separator}\"${edited_date}\"\n")
                    }
                    writer.flush()
                    writer.close()
                }

                processedCounter = result.cost_items.size()
                break
        }
        groovy.time.TimeDuration duration = groovy.time.TimeCategory.minus(new Date(), generation_start)
        log.debug("CSV export operation for ${params.csvMode} mode -- Duration took to complete (${processedCounter} Rows of data) was: ${duration} --")
    }

  //original method commented out above as it is absolutely ridiculous, hacking a copy to build up query properly!
  def private filterQuery(LinkedHashMap result, Map params, boolean wildcard) {
    def fqResult = [:]
    fqResult.qry_joins = "" //probably do not need this now as query is looking like it is working with at least the four parameters so far combined
    fqResult.qry_where = ""
    fqResult.fqParams = [:] as List //HQL list parameters for user data, can't be trusted!

    fqResult.qry_where += " WHERE ci.owner = :owner "
    fqResult.fqParams.owner = result.institution
    
    if (params.orderNumberFilter) {
      //fqResult.qry_joins += " INNER JOIN kbplus_ord ord on ci.ci_ord_fk=ord.ord_id "
      fqResult.qry_where += " AND ci.order.orderNumber like :on " //" AND ci.order.orderNumber = ? "
      fqResult.fqParams.on = "%${params.orderNumberFilter}%"
    }

    if (params.invoiceNumberFilter) {
      fqResult.qry_where += " AND ci.invoice.invoiceNumber like :in " //" AND ci.invoice.invoiceNumber = ? "
      fqResult.fqParams.in = "%${params.invoiceNumberFilter}%"
    }

    if (params?.subscriptionFilter?.startsWith("com.k_int.kbplus.Subscription:")) {
      //fqResult.qry_joins += " INNER JOIN subscription sub on ci.ci_sub_fk=sub.sub_id "
      def subid = params.subscriptionFilter.split(":")[1]
      fqResult.qry_where += " AND ci_sub_fk = :sub "
      fqResult.fqParams.sub = subid
      
      def sub = Subscription.get(subid)
      if (sub) {
        fqResult.subtext = sub.name
      }
    }

    if (params?.packageFilter?.startsWith("com.k_int.kbplus.SubscriptionPackage:")) {
      //fqResult.qry_joins += " INNER JOIN subscription_package subpkg on ci.ci_subPkg_fk=subpkg.sp_id "
      def pkgid = params.packageFilter.split(":")[1]
      fqResult.qry_where += " AND ci_subPkg_fk = :pkg "
      fqResult.fqParams.pkg = pkgid
      
      def subpkg = SubscriptionPackage.get(pkgid)
      if (subpkg) {
        fqResult.subpkgtext = subpkg.pkg.name
      }
    }
    
    if (params?.adv_ie?.startsWith("com.k_int.kbplus.IssueEntitlement:")) {
      def ieid = params.adv_ie.split(":")[1]
      fqResult.qry_where += " AND ci_e_fk = :cifk "
      fqResult.fqParams.cifk = ieid
      
      def ie = IssueEntitlement.get(ieid)
      if (ie) {
        fqResult.ietext = ie?.tipp?.title?.title
      }
    }
    
    if (params.adv_codes) {
      def bc = RefdataValue.get(params.adv_codes)
      if (bc) {
        fqResult.qry_where += " AND (exists ( select cig from CostItemGroup as cig where cig.costItem=ci and ( cig.budgetcode = :bc ) ) ) "
        fqResult.fqParams.bc = bc
        
        fqResult.bctext = bc.value
      }
    }
    
    if (params.adv_costItemStatus) {
      fqResult.qry_where += " AND ci_status_rv_fk = :srvfk "
      fqResult.fqParams.srvfk = params.adv_costItemStatus
    }
    
    if (params.adv_costItemCategory) {
      fqResult.qry_where += " AND ci_cat_rv_fk = :cifk "
      fqResult.fqParams.cifk = params.adv_costItemCategory
    }
    
    if (params.adv_start || params.adv_end) {
      def sdf = new java.text.SimpleDateFormat(session?.sessionPreferences?.globalDateFormat)
      if (params.adv_start) {
        def start = sdf.parse(params.adv_start)
        fqResult.qry_where += " AND ci_start_date >= :cisd "
        fqResult.fqParams.cisd = start
      }
      
      if (params.adv_end) {
        def end = sdf.parse(params.adv_end)
        fqResult.qry_where += " AND ci_end_date <= :cied "
        fqResult.fqParams.cied = end
      }
    }

    if (params.adv_amount) { 
      def operator = ""
      switch (params.adv_amountType) {
        case 'gt':
          operator = " > "
          break;
        case 'lt':
          operator = " < "
          break;
        case 'eq':
        default:
          operator = " = "
          break;
      }
      
      fqResult.qry_where += " AND ci_cost_in_local_currency_inc_vat"
      fqResult.qry_where += operator
      fqResult.qry_where += ":cst "
      fqResult.fqParams.cst = params.adv_amount
    }

    return fqResult
  }

    //todo complete a configurable search which can be extended via external properties if necessary
    //Not sure if this is the best approach
    private static qry_conf = [
            'ci'  : [
                    selectQry:'select ci from CostItem as ci ',
                    countQry: 'select count(ci.id) from CostItem as ci '
             ],
            'invoice' : [
                    stdQry: 'AND ci.invoice.invoiceNumber like :inv ',
                    wildQry: 'AND ci.invoice.invoiceNumber like :inv ',
                    countQry:"",
            ],
            'adv' : [
                 'adv_ref' : [

                 ],
                 'adv_codes':[

                 ],
                 'adv_start':[

                 ],
                 'adv_end':[

                 ],
                 'adv_costItemStatus':[

                 ],
                 'adv_costItemCategory':[

                 ],
                 'adv_amount':[

                 ],
                 'adv_dateCreated':[

                 ],
                 'adv_ie':[

                 ],
            ]
    ]


    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def newCostItem() {

      def defaultCurrency = RefdataCategory.lookupOrCreate('Currency','GBP - United Kingdom Pound')

      def result =  [:]
      def newCostItem = null;

      try {
        log.debug("FinanceController::newCostItem() ${params}");

        result.institution  =  request.getAttribute('institution')//Org.findByShortcode(params.defaultInstShortcode)
        def user            =  User.get(springSecurityService.principal.id)
        result.error        =  [] as List

        if (!isFinanceAuthorised(result.institution, user))
        {
            result.error=message(code: 'financials.permission.unauthorised', args: [result.institution? result.institution.name : 'N/A'])
            response.sendError(403)
        }

        def order = null
        if (params.newOrderNumber)
            order = Order.findByOrderNumberAndOwner(params.newOrderNumber, result.institution) ?: new Order(orderNumber: params.newOrderNumber, owner: result.institution).save(flush: true);

        def invoice = null
        if (params.newInvoiceNumber)
            invoice = Invoice.findByInvoiceNumberAndOwner(params.newInvoiceNumber, result.institution) ?: new Invoice(invoiceNumber: params.newInvoiceNumber, owner: result.institution).save(flush: true);

        def sub = null;
        if (params.newSubscription?.contains("com.k_int.kbplus.Subscription:"))
        {
            try {
                sub = Subscription.get(params.newSubscription.split(":")[1]);
            } catch (Exception e) {
                log.error("Non-valid subscription sent ${params.newSubscription}",e)
            }

        }

        def pkg = null;
        if (params.newPackage?.contains("com.k_int.kbplus.SubscriptionPackage:"))
        {
            try {
                pkg = SubscriptionPackage.load(params.newPackage.split(":")[1])
            } catch (Exception e) {
                log.error("Non-valid sub-package sent ${params.newPackage}",e)
            }
        }

        def dateCreated = null
        if (params.newDate)
        {
            try {
                dateCreated = dateFormat.parse(params.newDate)
            } catch (Exception e) {
                log.debug("Unable to parse date : ${params.newDate} in format ${dateFormat.toPattern()}")
            }
        }

        def startDate = null
        if (params.newStartDate)
        {
            try {
                startDate = dateFormat.parse(params.newStartDate)
            } catch (Exception e) {
                log.debug("Unable to parse date : ${params.newStartDate} in format ${dateFormat.toPattern()}")
            }
        }

        def endDate = null
        if (params.newEndDate)
        {
            try {
                endDate = dateFormat.parse(params.newEndDate)
            } catch (Exception e) {
                log.debug("Unable to parse date : ${params.newEndDate} in format ${dateFormat.toPattern()}")
            }
        }

        def ie = null
        if(params.newIE)
        {
            try {
                ie = IssueEntitlement.load(params.newIE.split(":")[1])
            } catch (Exception e) {
                log.error("Non-valid IssueEntitlement sent ${params.newIE}",e)
            }
        }

        def billing_currency = null
        if (params.long('newCostCurrency')) //GBP,etc
        {
            billing_currency = RefdataValue.get(params.newCostCurrency)
            if (!billing_currency)
                billing_currency = defaultCurrency
        }

        def tempCurrencyVal               = params.newCostExchangeRate? params.double('newCostExchangeRate',1.00) : 1.00
        def cost_item_status              = params.newCostItemStatus ? (RefdataValue.get(params.long('newCostItemStatus'))) : null;    //estimate, commitment, etc
        def cost_item_element             = params.newCostItemElement ? (RefdataValue.get(params.long('newCostItemElement'))): null    //admin fee, platform, etc
        def cost_tax_type                 = params.newCostTaxType ? (RefdataValue.get(params.long('newCostTaxType'))) : null           //on invoice, self declared, etc
        def cost_item_category            = params.newCostItemCategory ? (RefdataValue.get(params.long('newCostItemCategory'))): null  //price, bank charge, etc
        def cost_billing_currency_ex_vat  = params.newCostInBillingCurrencyExVAT? params.double('newCostInBillingCurrencyExVAT',0.00) : 0.00
        def tax_billing_currency          = params.newTaxInBillingCurrency? params.double('newTaxInBillingCurrency',0.00) : 0.00
        def cost_billing_currency_inc_vat = params.newCostInBillingCurrencyIncVAT? params.double('newCostInBillingCurrencyIncVAT',0.00) : 0.00
        def cost_local_currency_ex_vat    = params.newCostInLocalCurrencyExVAT?   params.double('newCostInLocalCurrencyExVAT', cost_billing_currency_ex_vat * tempCurrencyVal) : 0.00
        def tax_local_currency            = params.newTaxInLocalCurrency?   params.double('newTaxInLocalCurrency', tax_billing_currency * tempCurrencyVal) : 0.00
        def cost_local_currency_inc_vat   = params.newCostInLocalCurrencyIncVAT?   params.double('newCostInLocalCurrencyIncVAT', cost_billing_currency_inc_vat * tempCurrencyVal) : 0.00

        if ( cost_local_currency_inc_vat == 0 ) {
          cost_local_currency_inc_vat = ( cost_local_currency_ex_vat + tax_local_currency) as Double;
        }

        //def inclSub = params.includeInSubscription? (RefdataValue.get(params.long('includeInSubscription'))): defaultInclSub //todo Speak with Owen, unknown behaviour

        newCostItem = new CostItem(
                owner: result.institution,
                sub: sub,
                subPkg: pkg,
                issueEntitlement: ie,
                order: order,
                invoice: invoice,
                costItemCategory: cost_item_category,
                costItemElement: cost_item_element,
                costItemStatus: cost_item_status,
                billingCurrency: billing_currency, //Not specified default to GBP
                taxCode: cost_tax_type,
                costDescription: params.newDescription? params.newDescription.trim()?.toLowerCase():null,
        costInBillingCurrencyExVAT: cost_billing_currency_ex_vat as Double,
        taxInBillingCurrency: tax_billing_currency as Double,
        costInBillingCurrencyIncVAT: cost_billing_currency_inc_vat as Double,
        costInLocalCurrencyExVAT: cost_local_currency_ex_vat as Double,
        taxInLocalCurrency: tax_local_currency as Double,
        costInLocalCurrencyIncVAT: cost_local_currency_inc_vat as Double,
                dateCreated: dateCreated,
                startDate: startDate,
                endDate: endDate,
                includeInSubscription: null, //todo Discussion needed, nobody is quite sure of the functionality behind this...
                reference: params.newReference? params.newReference.trim()?.toLowerCase() : null
        )


        if (!newCostItem.validate())
        {
            result.error = newCostItem.errors.allErrors.collect {
                log.error("Field: ${it.properties.field}, user input: ${it.properties.rejectedValue}, Reason! ${it.properties.code}")
                message(code:'finance.addNew.error',args:[it.properties.field])
            }
        }
        else
        {
            if (newCostItem.save(flush: true))
            {
                if (params.newBudgetCode)
                    createBudgetCodes(newCostItem, params.newBudgetCode?.trim()?.toLowerCase(), result.institution.shortcode)
            } else {
                result.error = "Unable to save!"
            }
        }
      }
      catch ( Exception e ) {
        log.error("Problem in add cost item",e);
      }

      params.remove("Add")
      // render ([newCostItem:newCostItem.id, error:result.error]) as JSON

      def params_sc = []
    if (params.defaultInstShortcode) {
        params_sc = [defaultInstShortcode:params.defaultInstShortcode]
    }
      redirect(controller:'finance', action:'index', params:params_sc);
    }

    private def createBudgetCodes(CostItem costItem, String budgetcodes, String owner)
    {
        def result = []
        if(budgetcodes && owner && costItem)
        {
            def budgetOwner = RefdataCategory.findByDesc("budgetcode_"+owner)?:new RefdataCategory(desc: "budgetcode_"+owner).save(flush: true)
            budgetcodes.split(",").each { c ->
                def rdv = null
                if (c.startsWith("-1")) //New code option from select2 UI
                    rdv = new RefdataValue(owner: budgetOwner, value: c.substring(2).toLowerCase()).save(flush: true)
                else
                    rdv = RefdataValue.get(c)

                if (rdv != null)
                    result.add(new CostItemGroup(costItem: costItem, budgetcode: rdv).save(flush: true))
            }
        }

        result
    }


    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def getRecentCostItems() {
        def  institution       = Org.findByShortcode(params.defaultInstShortcode)
        def  result            = [:]
        def  recentParams      = [max:10, order:'desc', sort:'lastUpdated']
        result.to              = new Date()
        result.from            = params.from? dateTimeFormat.parse(params.from): new Date()
        result.recentlyUpdated = CostItem.findAllByOwnerAndLastUpdatedBetween(institution,result.from,result.to,recentParams)
        result.from            = dateTimeFormat.format(result.from)
        result.to              = dateTimeFormat.format(result.to)
        log.debug("FinanceController - getRecentCostItems, rendering template with model: ${result}")
        render(template: "/finance/recentlyAdded", model: result)
    }


    @Secured(['ROLE_USER'])
    def newCostItemsPresent() {
        def institution = Org.findByShortcode(params.defaultInstShortcode)
        Date dateTo     = params.to? dateTimeFormat.parse(params.to):new Date()//getFromToDate(params.to,"to")
        int counter     = CostItem.countByOwnerAndLastUpdatedGreaterThan(institution,dateTo)

        def builder = new groovy.json.JsonBuilder()
        def root    = builder {
            count counter
            to dateTimeFormat.format(dateTo)
        }
        log.debug("Finance - newCostItemsPresent ? params: ${params} JSON output: ${builder.toString()}")
        render(text: builder.toString(), contentType: "text/json", encoding: "UTF-8")
    }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def deleteCostItem() {
    log.debug("FinanceController::deleteCostItem() ${params}");
    def user = User.get(springSecurityService.principal.id)
    def institution = request.getAttribute('institution')
    
    if (!isFinanceAuthorised(institution, user))
    {
      response.sendError(403)
      return
    }
    
    def ci = CostItem.findByIdAndOwner(params.id, institution)
    if (ci) {
      CostItemGroup.deleteAll(CostItemGroup.findAllByCostItem(ci))
      log.debug("cost item groups with id ${ci.id} deleted")
      ci.delete(flush:true, failOnError:true)
      log.debug("cost item deleted")
    }
    
    redirect(url: request.getHeader('referer'))
  }
  
    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def delete() {
        log.debug("FinanceController::delete() ${params}");

        def results        =  [:]
        results.successful =  []
        results.failures   =  []
        results.message    =  null
        results.sentIDs    =  JSON.parse(params.del) //comma seperated list
        def user           =  User.get(springSecurityService.principal.id)
        def institution    =  Org.findByShortcode(params.defaultInstShortcode)
        if (!isFinanceAuthorised(institution, user))
        {
            response.sendError(403)
            return
        }

        if (results.sentIDs && institution)
        {
            def _costItem = null
            def _props

            results.sentIDs.each { id ->
                _costItem = CostItem.findByIdAndOwner(id,institution)
                if (_costItem)
                {
                    try {
                        _props = _costItem.properties
                        CostItemGroup.deleteAll(CostItemGroup.findAllByCostItem(_costItem))
                        _costItem.delete(flush: true)
                        results.successful.add(id)
                        log.debug("User: ${user.username} deleted cost item with properties ${_props}")
                    } catch (Exception e)
                    {
                        log.error("FinanceController::delete() : Delete Exception",e)
                        results.failures.add(id)
                    }
                }
                else
                    results.failures.add(id)
            }

            if (results.successful.size() > 0 && results.failures.isEmpty())
                results.message = "All ${results.successful.size()} Cost Items completed successfully : ${results.successful}"
            else if (results.successful.isEmpty() && results.failures.size() > 0)
                results.message = "All ${results.failures.size()} failed, unable to delete, have they been deleted already? : ${results.failures}"
            else
                results.message = "Success completed ${results.successful.size()} out of ${results.sentIDs.size()}  Failures as follows : ${results.failures}"

        } else
            results.message = "Incorrect parameters sent, not able to process the following : ${results.sentIDs.size()==0? 'Empty, no IDs present' : results.sentIDs}"

        render results as JSON
    }


    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def financialRef() {
        log.debug("Financials :: financialRef - Params: ${params}")

        def result      = [:]
        result.error    = [] as List
        def institution = Org.findByShortcode(params.defaultInstShortcode)
        def owner       = refData(params.owner)
        log.debug("Financials :: financialRef - Owner instance returned: ${owner.obj}")

        //check in reset mode e.g. subscription changed, meaning IE & SubPkg will have to be reset
        boolean resetMode = params.boolean('resetMode',false) && params.fields
        boolean wasReset  = false


        if (owner) {
            if (resetMode)
                wasReset = refReset(owner,params.fields,result)


            if (resetMode && !wasReset)
                log.debug("Field(s): ${params.fields} should have been reset as relation: ${params.relation} has been changed")
            else {
                //continue happy path...
                def relation = refData(params.relation)
                log.debug("Financials :: financialRef - relation obj or stub returned " + relation)

                if (relation) {
                    log.debug("Financials :: financialRef - Relation needs creating: " + relation.create)
                    if (relation.create) {
                        if (relation.obj.hasProperty(params.relationField)) {
                            relation.obj."${params.relationField}" = params.val
                            relation.obj.owner = institution
                            log.debug("Financials :: financialRef -Creating Relation val:${params.val} field:${params.relationField} org:${institution.name}")
                            if (relation.obj.save())
                                log.debug("Financials :: financialRef - Saved the new relational inst ${relation.obj}")
                            else
                                result.error.add([status: "FAILED: Creating ${params.ownerField}", msg: "Invalid data received to retrieve from DB"])
                        } else
                            result.error.add([status: "FAILED: Setting value", msg: "The data you are trying to set does not exist"])
                    }

                    if (owner.obj.hasProperty(params.ownerField)) {
                        log.debug("Using owner instance field of ${params.ownerField} to set new instance of ${relation.obj.class} with ID ${relation.obj.id}")
                        owner.obj."${params.ownerField}" = relation.obj
                        result.relation = ['class':relation.obj.id, 'id':relation.obj.id] //avoid excess data leakage
                    }
                } else
                    result.error.add([status: "FAILED: Related Cost Item Data", msg: "Invalid data received to retrieve from DB"])
            }
        } else
            result.error.add([status: "FAILED: Cost Item", msg: "Invalid data received to retrieve from DB"])



        render result as JSON
    }

    /**
     *
     * @param costItem - The owner instance passed from financialRef
     * @param fields - comma seperated list of fields to reset, has to be in allowed list (see below)
     * @param result - LinkedHashMap from financialRef
     * @return
     */
    def private refReset(costItem, String fields, result) {
        log.debug("Attempting to reset a reference for cost item data ${costItem} for field(s) ${fields}")
        def wasResetCounter = 0
        def f               = fields?.split(',')
        def allowed         = ["sub", "issueEntitlement", "subPkg", "invoice", "order"]
        boolean validFields = false

        if (f)
        {
            validFields = f.every { allowed.contains(it) && costItem.obj.hasProperty(it) }

            if (validFields)
                f.each { field ->
                    costItem.obj."${field}" = null
                    if (costItem.obj."${field}" == null)
                        wasResetCounter++
                    else
                        result.error.add([status: "FAILED: Cost Item", msg: "Problem resetting data for field ${field}"])
                }
            else
                result.error.add([status: "FAILED: Cost Item", msg: "Problem resetting data, invalid fields received"])
        }
        else
            result.error.add([status: "FAILED: Cost Item", msg: "Invalid data received"])

        return validFields && wasResetCounter == f.size()
    }

    def private refData(String oid) {
        def result         = [:]
        result.create      = false
        def oid_components = oid.split(':');
        def dynamic_class  = grailsApplication.getArtefact('Domain',oid_components[0]).getClazz()
        if ( dynamic_class)
        {
            if (oid_components[1].equals("create"))
            {
                result.obj    = dynamic_class.newInstance()
                result.create = true
            }
            else
                result.obj = dynamic_class.get(oid_components[1])
        }
        result
    }

    @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
    def removeBC() {
        log.debug("Financials :: remove budget code - Params: ${params}")
        def result      = [:]
        result.success  = [status:  "Success: Deleted code", msg: "Deleted instance of the budget code for the specified cost item"]
        def user        = User.get(springSecurityService.principal.id)
        def institution = Org.findByShortcode(params.defaultInstShortcode)

        if (!user.getAuthorizedOrgs().id.contains(institution.id))
        {
            log.error("User ${user.id} has tried to delete budget code information for Org not privy to ${institution.name}")
            response.sendError(403)
            return
        }
        def ids = params.bcci ? params.bcci.split("_")[1..2] : null
        if (ids && ids.size()==2)
        {
            def cig = CostItemGroup.get(ids[0])
            def ci  = CostItem.get(ids[1])
            if (cig && ci)
            {
                if (cig.costItem == ci)
                    cig.delete(flush: true)
                else
                    result.error = [status: "FAILED: Deleting budget code", msg: "Budget code is not linked with the cost item"]
            }
        } else
            result.error = [status: "FAILED: Deleting budget code", msg: "Incorrect parameter information sent"]

        render result as JSON
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def createCode() {
        def result      = [:]
        def user        = springSecurityService.currentUser
        def institution = Org.findByShortcode(params.defaultInstShortcode)

        if (!userCertified(user,institution))
        {
            response.sendError(403)
            return
        }
        def code  = params.code?.trim()
        def ci    = CostItem.findByIdAndOwner(params.id, institution)

        if (code && ci)
        {
            def cig_codes = createBudgetCodes(ci,code,institution.defaultInstShortcode)
            if (cig_codes.isEmpty())
                result.error = "Unable to create budget code(s): ${code}"
            else
            {
                result.success = "${cig_codes.size()} new code(s) added to cost item"
                result.codes   = cig_codes.collect {
                    "<span class='budgetCode'>${it.budgetcode.value}</span><a id='bcci_${it.id}_${it.costItem.id}' class='badge budgetCode'>x</a>"
                }
            }
        } else
            result.error = "Invalid data received for code creation"

        render result as JSON
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def addCostItem() {
      def result      = [:]
      def user        = springSecurityService.currentUser
      def institution = Org.findByShortcode(params.defaultInstShortcode)
      result
    }
    
    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def editCostItem() {
      def result = [:]
      result.user = User.get(springSecurityService.principal.id)
      result.institution = Org.findByShortcode(params.defaultInstShortcode)
    result.costitem = CostItem.get(params.id)
      result
  }
    

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def processEditCostItem() {

    log.debug("edit cost item params: ${params}")
    def user = User.get(springSecurityService.principal.id)
    def institution  =  request.getAttribute('institution')  
    def defaultCurrency = RefdataCategory.lookupOrCreate('Currency','GBP - United Kingdom Pound')
    
    def ci = CostItem.get(params.id)
    if (ci) {
      log.debug("found costitem: ${ci}")
      if (params.invoiceField) {
        if (params.invoiceField.contains('com.k_int.kbplus.Invoice')) {
          def invoice = Invoice.get(params.invoiceField.split(":")[1])
          if (invoice) {
            ci.invoice = invoice
          }
        }
        else if (params.invoiceField.contains(':create')) {
          def invoice_number = params.invoiceField.split(":")[0]
          def invoice = new Invoice(invoiceNumber: invoice_number, owner: institution).save(flush: true, failOnError:true)
          ci.invoice = invoice
        }
      }
      else {
        ci.invoice = null
      }
      
      if (params.orderField) {
        if (params.orderField.contains('com.k_int.kbplus.Order')) {
          def order = Order.get(params.orderField.split(":")[1])
          if (order) {
            ci.order = order
          }
        }
        else if (params.orderField.contains(':create')) {
          def order_number = params.orderField.split(":")[0]
          def order = new Order(orderNumber: order_number, owner: institution).save(flush: true, failOnError:true)
          ci.order = order
        }
      }
      else {
        ci.order = null
      }
      
      if (params.dateCreated) {
        ci.dateCreated = dateFormat.parse(params.dateCreated)
      }
      else {
        ci.dateCreated = null
      }
      
      if (params.reference) {
        ci.reference = params.reference.trim().toLowerCase()
      }
      else {
        ci.reference = null
      }
      
      if (params.costItemStatus) {
        def cis = RefdataValue.get(params.costItemStatus)
        if (cis) {
          ci.costItemStatus = cis
        }
      }
      else {
        ci.costItemStatus = null
      }
      
      if (params.costItemCategory) {
        def cic = RefdataValue.get(params.costItemCategory)
        if (cic) {
          ci.costItemCategory = cic
        }
      }
      else {
        ci.costItemCategory = null
      }
    
      if (params.costItemElement) {
        def cie = RefdataValue.get(params.costItemElement)
        if (cie) {
          ci.costItemElement = cie
        }
      }
      else {
        ci.costItemElement = null
      }
      
      if (params.taxCode) {
        def tc = RefdataValue.get(params.taxCode)
        if (tc) {
          ci.taxCode = tc
        }
      }
      else {
        ci.taxCode = null
      }
      
      if (params.subscription) {
        if (params.subscription?.contains("com.k_int.kbplus.Subscription:"))
        {
          try {
            ci.sub = Subscription.get(params.subscription.split(":")[1]);
          } catch (Exception e) {
            log.error("Non-valid subscription sent ${params.subscription}",e)
          }
        }
      }
      else {
        ci.sub = null
      }
      
      if (params.subpackage) {
        if (params.subpackage?.contains("com.k_int.kbplus.SubscriptionPackage:"))
        {
          try {
            ci.subPkg = SubscriptionPackage.load(params.subpackage.split(":")[1])
          } catch (Exception e) {
            log.error("Non-valid sub-package sent ${params.subpackage}",e)
          }
        }
      }
      else {
        ci.subPkg = null
      }
      
      if (params.title) {
        try {
          ci.issueEntitlement = IssueEntitlement.load(params.title.split(":")[1])
        } catch (Exception e) {
          log.error("Non-valid IssueEntitlement sent ${params.title}",e)
        }
      }
      else {
        ci.issueEntitlement = null
      }
      
      if (params.startDate) {
        ci.startDate = dateFormat.parse(params.startDate)
      }
      else {
        ci.startDate = null
      }
      
      if (params.endDate) {
        ci.endDate = dateFormat.parse(params.endDate)
      }
      else {
        ci.endDate = null
      }
      
      if (params.description) {
        ci.costDescription = params.description.trim().toLowerCase()
      }
      else {
        ci.costDescription = null
      }
      
      if (params.costInBillingCurrencyExVAT) {
        def cost_billing_currency_ex_vat = params.double('costInBillingCurrencyExVAT',0.00)
        ci.costInBillingCurrencyExVAT = cost_billing_currency_ex_vat as Double
      }
      else {
        ci.costInBillingCurrencyExVAT = 0.00
      }
      
      if (params.taxInBillingCurrency) {
        def tax_billing_currency = params.double('taxInBillingCurrency',0.00)
        ci.taxInBillingCurrency = tax_billing_currency as Double
      }
      else {
        ci.taxInBillingCurrency = 0.00
      }
      
      if (params.costInBillingCurrencyIncVAT) {
        def cost_billing_currency_inc_vat = params.double('costInBillingCurrencyIncVAT',0.00)
        ci.costInBillingCurrencyIncVAT = cost_billing_currency_inc_vat as Double
      }
      else {
        ci.costInBillingCurrencyIncVAT = 0.00
      }
      
      if (params.billingCurrency) {
        def billing_currency = RefdataValue.get(params.billingCurrency)
        if (!billing_currency) {
          billing_currency = defaultCurrency
        }
        ci.billingCurrency = billing_currency
      }
      else {
        ci.billingCurrency = defaultCurrency
      }
      
      if (params.costInLocalCurrencyExVAT) {
        def cost_local_currency_ex_vat = params.double('costInLocalCurrencyExVAT',0.00)
        ci.costInLocalCurrencyExVAT = cost_local_currency_ex_vat as Double
      }
      else {
        ci.costInLocalCurrencyExVAT = 0.00
      }
      
      if (params.taxInLocalCurrency) {
        def tax_local_currency = params.double('taxInLocalCurrency',0.00)
        ci.taxInLocalCurrency = tax_local_currency as Double
      }
      else {
        ci.taxInLocalCurrency = 0.00
      }
      
      if (params.costInLocalCurrencyIncVAT) {
        def cost_local_currency_inc_vat = params.double('costInLocalCurrencyIncVAT',0.00)
        ci.costInLocalCurrencyIncVAT = cost_local_currency_inc_vat as Double
      }
      else {
        ci.costInLocalCurrencyIncVAT = 0.00
      }
      
        //special case: newBudgetCode:536,538,
      
        ci.save(flush:true, failOnError:true)
      
      log.debug("budget codes: ${params.budgetCode}")
      def bcs_to_add = []
      def bcs_to_check = []
      if (params.budgetCode) {
        params.budgetCode.trim().toLowerCase().split(",").each { bc ->
          if (bc.startsWith("-1")) {
            bcs_to_add.add(bc)
          }
          else {
            bcs_to_check.add(bc as Long)
          }
        }
      }
      log.debug("budget codes to add: ${bcs_to_add}")
      log.debug("budget codes to check: ${bcs_to_check}")
      def cig_to_delete = []
      def existing_cigs = CostItemGroup.findAllByCostItem(ci)
      existing_cigs.each { cig ->
        if (cig?.budgetcode?.id in bcs_to_check) {
          bcs_to_check.remove(cig.budgetcode.id)
        }
        else {
          cig_to_delete.add(cig.id)
        }
      }
      
      log.debug("remaining codes in list for adding: ${bcs_to_check}")
      log.debug("cigs to delete: ${cig_to_delete}")
      
      cig_to_delete.each { cigid ->
        def del_cig = CostItemGroup.get(cigid)
        if (del_cig) {
          del_cig.delete(flush:true, failOnError:true)
        }
      }
      
      bcs_to_add.each { bc ->
        addBudgetCode(ci, bc, institution.shortcode)
      }
      
      bcs_to_check.each { bc ->
        addBudgetCode(ci, bc as String, institution.shortcode)
      }
    }
    
    def params_sc = []
    if (params.defaultInstShortcode) {
      params_sc = [defaultInstShortcode:params.defaultInstShortcode]
    }
    redirect(controller:'finance', action:'index', params:params_sc)
  }
  
  private def addBudgetCode(CostItem costItem, String budgetcode, String owner)
  {
    def budgetOwner = RefdataCategory.findByDesc("budgetcode_"+owner)?:new RefdataCategory(desc: "budgetcode_"+owner).save(flush: true, failOnError:true)
    def rdv = null
    if (budgetcode.startsWith("-1")) //New code option from select2 UI
      rdv = new RefdataValue(owner: budgetOwner, value: budgetcode.substring(2).toLowerCase()).save(flush: true, failOnError:true)
    else
      rdv = RefdataValue.get(budgetcode)

    def cig = null
    if (rdv != null)
      cig = new CostItemGroup(costItem: costItem, budgetcode: rdv).save(flush: true, failOnError:true)
    
    cig
  }
}
