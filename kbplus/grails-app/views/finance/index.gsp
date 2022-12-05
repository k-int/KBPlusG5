<!doctype html>
<html lang="en" class="no-js">
  <head>
    <meta name="layout" content="base" />
    <parameter name="pagetitle" value="Finance" />
    <parameter name="pagestyle" value="finance" />
    <parameter name="actionrow" value="financeList" />
  </head>
  <body class="finance">
    <g:set var="fin_params_sc" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>
    <div class="row">
      <div class="col s12 l12">
        <h1 class="page-title left">${institution.name} Cost Items</h1>
      </div>
    </div>
    
    <div class="row">
      <div class="col s12">
        <div class="mobile-collapsible-header" data-collapsible="subscription-list-collapsible">Search <i class="material-icons">expand_more</i></div>
        <div class="search-section z-depth-1 mobile-collapsible-body" id="subscription-list-collapsible">
          <div class="col s12 mt-10">
            <h3 class="page-title left">Search Finance</h3>
          </div>
          
          <g:form controller="finance" action="index" params="${fin_params_sc}" method="post">
            <g:if test="${params.sort}">
              <input type="hidden" name="sort" value="${params.sort}">
            </g:if>
            <div class="col s12 l2 mt-10">
              <div class="input-field">
                <input name="invoiceNumberFilter" id="filterInvoiceNumber" type="text" value="${params.invoiceNumberFilter}" class="validate">
                <label for="filterInvoiceNumber">Invoice Number</label>
              </div>
            </div>
            <div class="col s12 l2 mt-10">
              <div class="input-field">
                <input name="orderNumberFilter" id="filterOrderNumber" type="text" value="${params.orderNumberFilter}" class="validate">
                <label for="filterOrderNumber">Order Number</label>
              </div>
            </div>
            <div class="col s12 l3 mt-20">
              <div class="input-field">
                <input type="hidden" name="subscriptionFilter" class="KBPlusTypeDown"
                       id="subscriptionFilter" 
                       data-base-class="com.k_int.kbplus.Subscription" 
                       data-inst-shortcode="${params.defaultInstShortcode}"
                       value="${params.subscriptionFilter}"
                       data-defaulttext="${subtext?:''}"/>
                <label class="active" style="transform: translateY(-200%);">Subscription</label>
                <g:hiddenField name="sub" value="${fixedSubscription?.id}"/>
              </div>
            </div>
            <div class="col s12 l3 mt-20">
              <div class="input-field">
                <input type="hidden" name="packageFilter" class="KBPlusTypeDown"
                       id="packageFilter"
                       data-base-class="com.k_int.kbplus.SubscriptionPackage" 
                       data-inst-shortcode="${params.defaultInstShortcode}"
                       value="${params.packageFilter}"
                       data-defaulttext="${subpkgtext?:''}"/>
                <label class="active" style="transform: translateY(-200%);">Package</label>
              </div>
            </div>
            
            <div class="col s6 m3 l1">
              <input type="submit" class="btn" value="Search"/>
            </div>
            <div class="col s6 m3 l1">
              <g:link controller="finance" action="index" params="${fin_params_sc}" class="resetsearch">Reset</g:link>
            </div>
            
            <!--search filter -->
            <div class="col s12">
              <ul class="collapsible jisc_collapsible search-filter" data-collapsible="accordion">
                <li>
                  <div class="collapsible-header trigger-accordian"><i class="material-icons trigger-accordian">expand_more</i>Filter Search</div>
                  <div class="collapsible-body">
                    <!--row1-->
                    <div class="col s12 l3 mt-20">
                      <div class="input-field">
                        <input type="hidden" name="adv_codes" class="KBPlusTypeDown"
                               id="adv_codes"
                               data-base-class="com.k_int.kbplus.CostItemGroup"
                               data-inst-shortcode="${params.defaultInstShortcode}"
                               value="${params.adv_codes}"
                               data-defaulttext="${bctext?:''}"/>
                        <label class="active" style="transform: translateY(-160%);">Budget Code</label>
                      </div>
                    </div>
                    <div class="col s12 l3 mt-20">
                      <div class="input-field">
                        <input type="hidden" name="adv_ie" class="KBPlusTypeDown"
                               id="adv_ie"
                               data-base-class="com.k_int.kbplus.IssueEntitlement"
                               data-inst-shortcode="${params.defaultInstShortcode}"
                               value="${params.adv_ie}"
                               data-defaulttext="${ietext?:''}"/>
                        <label class="active" style="transform: translateY(-160%);">Issue Entitlement</label>
                      </div>
                    </div>
                    <div class="col s12 l3 mt-10">
                      <div class="input-field">
                        <g:kbplusDatePicker inputid="adv_start" name="adv_start" value="${params.adv_start}"/>
                        <label>From (Valid Period)</label>
                      </div>
                    </div>
                    <div class="col s12 l3 mt-10">
                      <div class="input-field">
                        <g:kbplusDatePicker inputid="adv_end" name="adv_end" value="${params.adv_end}"/>
                        <label>To (Valid Period)</label>
                      </div>
                    </div>
                    
                    <!--row 2-->
                    <div class="col s6 mt-10">
                      <div class="input-field">
                        <g:select id="adv_costItemStatus"
                                  name="adv_costItemStatus"
                                  from="${com.k_int.kbplus.RefdataValue.executeQuery('select rdv from RefdataValue as rdv where rdv.owner.desc=? order by rdv.sortKey, rdv.value asc','CostItemStatus')}"
                                  optionKey="id"
                                  optionValue="value"
                                  noSelection="${['':'No Status']}"
                                  value="${params.adv_costItemStatus}"/>
                        <label>Cost Item Status</label>
                      </div>
                    </div>
                    
                    <div class="col s6 mt-10">
                      <div class="input-field">
                        <g:select id="adv_costItemCategory"
                                  name="adv_costItemCategory"
                                  from="${com.k_int.kbplus.RefdataValue.executeQuery('select rdv from RefdataValue as rdv where rdv.owner.desc=? order by rdv.sortKey, rdv.value asc','CostItemCategory')}"
                                  optionKey="id"
                                  optionValue="value"
                                  noSelection="${['':'No Category']}"
                                  value="${params.adv_costItemCategory}"/>
                        <label>Cost Item Category</label>
                      </div>
                    </div>
                    
                    <!--row 3-->
                    <div class="col s6 l2 mt-20">
                      <div class="input-field">
                        <select name="adv_amountType" id="adv_amountType">
                          <option value="eq" ${params.adv_amountType=='eq'?'selected':''}>==</option>
                          <option value="gt" ${params.adv_amountType=='gt'?'selected':''}>&gt;</option>
                          <option value="lt" ${params.adv_amountType=='lt'?'selected':''}>&lt;</option>
                        </select>
                        <label>Local Amount Operator</label>
                      </div>
                    </div>
                    
                    <div class="col s6 l4 mt-10">
                      <div class="input-field">
                        <input id="adv_amount" name="adv_amount" type="number" step="0.01" value="${params.adv_amount}">
                        <label for="adv_amount">Local Amount</label>
                      </div>
                    </div>
                  </div>
                </li>
              </ul>
            </div>
            <!--search filter end -->
          </g:form>
        </div>
      </div>
    </div>
    <!-- search-section end-->
    
    <!-- list returning/results-->
    <div class="row">
      <div class="col s12 page-response">
        <g:if test="${cost_item_count}">
          <h2 class="list-response text-navy">You have <span>${cost_item_count}</span> Results: <span>Ordered by 'A-Z'</span> (Showing ${cost_items?.size()})</h2>
        </g:if>
        <g:else>
          <h2 class="list-response text-navy">No cost items found</h2>
        </g:else>
      </div>
    </div>
    
    <g:if test="${cost_item_count}">
      <div class="row">
        <div class="col s12">
          <div class="filter-section z-depth-1">
            <div class="col s12 l6">
              <div class="input-field">
                <g:form controller="finance" action="index" params="${fin_params_sc}" method="post">
                  <g:select name="sort" value="${params.sort}"
                            keys="['ci.invoice.invoiceNumber:asc','ci.invoice.invoiceNumber:desc','ci.order.orderNumber:asc','ci.order.orderNumber:desc','date_created:asc','date_created:desc','ci_start_date:asc','ci_start_date:desc','ci_end_date:asc','ci_end_date:desc','ci.sub.name:asc','ci.sub.name:desc','ci.subPkg.pkg.name:asc','ci.subPkg.pkg.name:desc']"
                            from="${['Invoice A-Z','Invoice Z-A','Order A-Z','Order Z-A','Date Created A-Z','Date Created Z-A','Start Date A-Z','Start Date Z-A','End Date A-Z','End Date Z-A','Subscription A-Z','Subscription Z-A','Package A-Z','Package Z-A']}"
                            onchange="this.form.submit();" />
                  <label>Sort Cost Items</label>
                  
                  <g:set var="params_not_wanted" value="${['sort','controller','action','defaultInstShortcode','shortcode']}"/>
                  <g:each in="${params}" var="${prm}">
                    <g:if test="${!params_not_wanted.contains(prm.key)}">
                      <g:if test="${prm.value}">
                        <input type="hidden" name="${prm.key}" value="${prm.value}">
                      </g:if>
                    </g:if>
                  </g:each>
                </g:form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </g:if>
    <!-- list returning/results end-->
    
    <!-- list accordian start-->
    <div class="row">
      <div class="col s12 l12">
        <ul class="collapsible jisc_collapsible" data-collapsible="accordion">
          <!--accordian item-->
          <g:each in="${cost_items}" var="cost_item">
            <li>
              <!--accordian header-->
              <div class="collapsible-header">
                <div class="col s11">
                  <i class="icon-accordian trigger-accordian tooltipped" data-position="top" data-delay="50" data-tooltip="Expand/Collapse"></i>
                  <ul class="collection">
                    <li class="collection-item">
                      <h2 class="first navy-text">
                        <g:if test="${cost_item?.invoice}">
                          <a href="#">Invoice No. ${cost_item?.invoice?.invoiceNumber?.encodeAsHTML()}</a>
                        </g:if>
                        <g:else>
                          Cost Item ${cost_item.id} - no invoice
                        </g:else>
                      </h2>
                    </li>
                    
                    <li class="collection-item">Order No: <span>${cost_item?.order?.orderNumber}</span></li>
                    <li class="collection-item">Date of Issue: <span><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${cost_item?.dateCreated}"/></li>
                    <li class="collection-item">
                      Start date: <span> <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${cost_item?.startDate}"/></span> 
                      End date: <span><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${cost_item.endDate}"/></span>
                    </li>
                    <g:if test="${cost_item?.datePaid}">
                      <li class="collection-item">Date Paid: <span><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${cost_item?.datePaid}"/></span></li>
                    </g:if>
                    <li class="collection-item">
                      Amount
                      <span class="indicator">Subtotal: ${cost_item?.costInBillingCurrencyExVAT}</span>
                      <span class="indicator">VAT: ${cost_item?.taxInBillingCurrency}</span>
                    </li>
                    <li class="collection-item">
                      <h3>Total: ${cost_item.costInBillingCurrencyIncVAT}</h3>
                    </li>
                  </ul>
                </div>
                
                <div class="col s1 full-height-divider">
                  <ul class="collection">
                    <li class="collection-item actions first">
                      <div class="actions-container">
                        <g:if test="${editable}">
                          <a href="#kbmodal" ajax-url="${createLink(controller:'finance', action:'editCostItem', id:cost_item.id, params:fin_params_sc)}" class="btn-floating modal-trigger modalButton"><i class="material-icons tooltipped" data-delay="50" data-position="left" data-tooltip="Edit Cost Item">create</i></a>
                          <g:link controller="finance" action="deleteCostItem" id="${cost_item.id}" params="${fin_params_sc}" class="btn-floating right no-js" onclick="return confirm('Are you sure you want to delete this Cost Item?')"><i class="material-icons tooltipped" data-delay="50" data-position="left" data-tooltip="Delete Cost Item">delete_forever</i></g:link>
                        </g:if>
                      </div>
                    </li>
                  </ul>
                </div>
              </div>
              <!-- accordian header end-->
              
              <!-- accordian body-->
              <div class="collapsible-body">
                <div class="row">
                  <div class="col s6 l2">
                    <h3>Codes</h3>
                    <ul class="content-list">
                      <g:each in="${cost_item?.budgetcodes}" var="bc">
                        <li>${bc.value}</li>
                      </g:each>
                    </ul>
                  </div>
                  
                  <div class="col s6 l2">
                    <h3>Local Currency <span>(${cost_item?.billingCurrency?.value})</span></h3>
                    <ul class="content-list">
                      <li><span>Subtotal:</span> ${cost_item?.costInLocalCurrencyExVAT}</li>
                      <li><span>VAT:</span> ${cost_item.taxInLocalCurrency}</li>
                      <li><span>Total:</span> ${cost_item?.costInLocalCurrencyIncVAT}</li>
                    </ul>
                  </div>
                  
                  <div class="col s6 l2">
                    <h3>&nbsp;</h3>
                    <ul class="content-list">
                      <li><span>Status:</span> ${cost_item?.costItemStatus?.value}</li>
                      <li><span>Category:</span> ${cost_item?.costItemCategory?.value}</li>
                      <li><span>Element:</span> ${cost_item?.costItemElement?.value}</li>
                      <li><span>Tax Type:</span> ${cost_item?.taxCode?.value}</li>
                    </ul>
                  </div>
                  
                  <div class="col s6 l2">
                    <h3>Notes</h3>
                    ${cost_item?.costDescription}
                  </div>
                  
                  <div class="col s12 l4">
                    <h3>Subscription</h3>
                    <p>
                      <g:if test="${cost_item?.sub}">
                          <g:link controller="subscriptionDetails" 
                                  action="index" 
                                  params="${[defaultInstShortcode:params.defaultInstShortcode]}" id="${cost_item?.sub?.id}">${cost_item?.sub?.name}</g:link>
                      </g:if>
                    </p>
                    <h3>Package</h3>
                    <p>${cost_item?.subPkg?.pkg?.name}</p>
                    <h3>Title</h3>
                    <g:if test="${cost_item?.issueEntitlement}">
                      <p>${cost_item?.issueEntitlement?.tipp?.title?.title}
                        (<g:link controller="issueEntitlement" id="${cost_item?.issueEntitlement?.id}" action="show" 
                                 params="${[defaultInstShortcode:params.defaultInstShortcode]}" class="list-title">Entitlement</g:link>)
                      </p>
                    </g:if>
                  </div>
                  
                  <div class="row">
                    <div class="col s12">
                      <div class="cta">
                        <!--
                        <a href="#" class="waves-effect waves-light btn">View All</a>
                        <a href="#" class="waves-effect waves-light btn">Edit</a>
                        <a href="#" class="waves-effect btn">Delete <i class="material-icons right">delete_forever</i></a>
                        -->
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <!-- accordian body end-->
            </li>
          </g:each>
        </ul>
      </div>
    </div>
    
    <div class="row">
      <div class="col s12">
        <div class="pagination">
          <g:paginate controller="finance" action="index" params="${params}" next="chevron_right" prev="chevron_left" maxsteps="10" total="${cost_item_count?:0}" />
        </div>
      </div>
    </div>
    
    <script type="text/javascript">
      function setupPage() {
        var sub_obj = "input[name=subscriptionFilter]";
        var pkg_obj = "input[name=packageFilter]";
        var ie_obj = "input[name=adv_ie]";
        var sf_val = $(sub_obj).val();
        var sf_df_txt = $(sub_obj).data("defaulttext");
        
        console.log("text: " + sf_df_txt);
        console.log("val: " + sf_val);
        
        if (sf_df_txt != null && sf_df_txt.trim().length > 0 && sf_val != null && sf_val.trim().length > 0) {
          console.log("enabling...");
          $(pkg_obj).select2('enable');
          $(pkg_obj).data('subfilter', sf_val.split(":")[1]);
          $(ie_obj).select2('enable');
          $(ie_obj).data('subfilter', sf_val.split(":")[1]);
        }
        else {
          console.log("disabling...");
          $(pkg_obj).select2('disable');
          $(ie_obj).select2('disable');
        }
        
        $('body').on("select2-selecting select2-removed", sub_obj, function(e) {
          var isRemoved = e.type === 'select2-removed';
          var element = $(this);
          var id = isRemoved === true? null : e.choice.id;
          var currentText = isRemoved === true? null : e.choice.text;
          element.data('subFilter',id);
          console.log(isRemoved);
          console.log(element);
          console.log(id);
          console.log(currentText);
          console.log('end of stuff');
          $(pkg_obj).select2((isRemoved? 'disable' : 'enable'));
          $(ie_obj).select2(isRemoved? 'disable' : 'enable');
          
          if (isRemoved) {
            $(pkg_obj).select2('data', null);
            $(ie_obj).select2('data', null);
            $(pkg_obj).data('subfilter',null);
            $(ie_obj).data('subfilter',null);
          }
          else {
            $(pkg_obj).data('subfilter',id.split(":")[1]);
            $(ie_obj).data('subfilter',id.split(":")[1]);
          }
        });
      }
      
      setTimeout(function(){ setupPage(); }, 1000);
    </script>
  </body>
</html>
