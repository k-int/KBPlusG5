<g:set var="editcostitem_params_sc" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>
<g:set var="dateFormatter" value="${new java.text.SimpleDateFormat(session.sessionPreferences?.globalDateFormat)}"/>
<div class="container" data-theme="finance">
  <div class="row">
    <div class="col s12">
      <h1 class="form-title flow-text navy-text">Edit Cost Item</h1>
      <p class="form-caption flow-text grey-text">Description text here</p>
      <!--form-->
      <div class="row">
        <g:form controller="finance" action="processEditCostItem" id="${costitem.id}" params="${editcostitem_params_sc}" class="col s12">
          <div class="row">
            <div class="col s12">
              <h3 class="indicator">Invoice details</h3>
              <p class="grey-text">instructions to be written here</p>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6 mt-35">
              <input type="hidden" name="invoiceField" id="${costitem.id}_sub" data-defaultValue="${costitem?.invoice?.invoiceNumber?.encodeAsHTML()}" data-defaultId="${costitem.invoice?.id}"
                     data-domain="com.k_int.kbplus.Invoice" data-shortcode="${params.defaultInstShortcode}"
                     data-placeholder="Enter invoice number" data-ownerfield="invoice" data-ownerid="${costitem.id}"
                     data-owner="${costitem.class.name}" class="modifiedReferenceTypedown refData"
                     data-relationID="${costitem?.invoice!=null? costitem.invoice.id:'create'}" data-relationField="invoiceNumber"/>
              <label class="active" style="transform: translateY(-200%);">Invoice Number</label>
            </div>
            <div class="input-field col s12 m6">
              <g:kbplusDatePicker inputid="dateCreated" name="dateCreated" value="${costitem.dateCreated?dateFormatter.format(costitem.dateCreated):''}"/>
              <label class="active">Date Invoice Issued</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6 mt-35">
              <input type="hidden" name="orderField" id="${costitem.id}_sub" data-defaultValue="${costitem?.order?.orderNumber}" data-defaultId="${costitem.order?.id}"
                     data-domain="com.k_int.kbplus.Order" data-shortcode="${params.defaultInstShortcode}"
                     data-placeholder="Enter order number" data-ownerfield="order" data-ownerid="${costitem.id}"
                     data-owner="${costitem.class.name}" class="modifiedReferenceTypedown refData"
                     data-relationID="${costitem?.order!=null? costitem.order.id:'create'}" data-relationField="orderNumber"/>
              <label class="active" style="transform: translateY(-200%);">Purchase Order Number</label>
            </div>
            <div class="input-field col s6">
              <input type="text" name="reference" id="costItemReference" value="${costitem.reference}"/>
              <label for="costItemReference" class="active">Item Reference</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <input type="text" name="budgetCode" id="budgetCode">
              <label class="active" style="transform: translateY(-200%);">Budget Codes</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <g:select name="costItemStatus"
                        from="${com.k_int.kbplus.RefdataValue.executeQuery('select rdv from RefdataValue as rdv where rdv.owner.desc=? order by rdv.sortKey, rdv.value asc','CostItemStatus')}"
                        optionKey="id"
                        optionValue="value"
                        noSelection="${['':'No Status']}"
                        value="${costitem?.costItemStatus?.id}"/>
              <label>Payment Status</label>
            </div>
            <div class="input-field col s6">
              <g:select name="costItemCategory"
                        from="${com.k_int.kbplus.RefdataValue.executeQuery('select rdv from RefdataValue as rdv where rdv.owner.desc=? order by rdv.sortKey, rdv.value asc','CostItemCategory')}"
                        optionKey="id"
                        optionValue="value"
                        noSelection="${['':'No Category']}"
                        value="${costitem?.costItemCategory?.id}"/>
              <label>Debit/Credit</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <g:select name="costItemElement"
                        from="${com.k_int.kbplus.RefdataValue.executeQuery('select rdv from RefdataValue as rdv where rdv.owner.desc=? order by rdv.sortKey, rdv.value asc','CostItemElement')}"
                        optionKey="id"
                        optionValue="value"
                        noSelection="${['':'No Element']}"
                        value="${costitem?.costItemElement?.id}"/>
              <label>Element</label>
            </div>
            <div class="input-field col s6">
              <g:select name="taxCode"
                        from="${com.k_int.kbplus.RefdataValue.executeQuery('select rdv from RefdataValue as rdv where rdv.owner.desc=? order by rdv.sortKey, rdv.value asc','TaxType')}"
                        optionKey="id"
                        optionValue="value"
                        noSelection="${['':'No Tax Type']}"
                        value="${costitem?.taxCode?.id}"/>
              <label>Tax Type</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <input type="hidden" name="subscription" id="${costitem.id}_sub" data-defaultValue="${costitem.sub?.name}" data-defaultId="${costitem.sub?.id}"
                     data-domain="com.k_int.kbplus.Subscription" data-mode="sub" data-isSubPkg="${false}" data-shortcode="${params.defaultInstShortcode}"
                     data-placeholder="Enter sub name" data-ownerfield="sub" data-ownerid="${costitem.id}"
                     data-owner="${costitem.class.name}" class="modifiedReferenceTypedown refObj"/>
              <label class="active" style="transform: translateY(-200%);">Subscription</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <input type="hidden" name="subpackage" id="${costitem.id}_subPkg" data-defaultValue="${costitem?.subPkg?.pkg?.name}" data-defaultId="${costitem?.subPkg?.id}"
                     data-domain="com.k_int.kbplus.SubscriptionPackage" data-mode="pkg" data-isSubPkg="${true}" data-shortcode="${params.defaultInstShortcode}"
                     data-placeholder="Enter package name" data-ownerfield="subPkg" data-ownerid="${costitem.id}"
                     data-owner="${costitem.class.name}" data-subfilter="${costitem?.sub?.id}" class="modifiedReferenceTypedown refObj"/>
              <label class="active" style="transform: translateY(-200%);">Package</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <input type="hidden" name="title" id="${costitem.id}_ie" data-defaultValue="${costitem?.issueEntitlement?.tipp?.title?.title}" data-defaultId="${costitem?.issueEntitlement?.id}"
                     data-domain="com.k_int.kbplus.IssueEntitlement" data-mode="ie" data-isSubPkg="${false}" data-shortcode="${params.defaultInstShortcode}"
                     data-placeholder="Enter IE name" data-ownerfield="issueEntitlement" data-ownerid="${costitem.id}"
                     data-owner="${costitem.class.name}" data-subfilter="${costitem?.sub?.id}" class="modifiedReferenceTypedown refObj"/>
              <label class="active" style="transform: translateY(-200%);">Issue Entitlement</label>
            </div>
          </div>
          
          <div class="row">
            <div class="col s12">
              <h3 class="indicator">Invoice period</h3>
              <p class="grey-text">instructions to be written here</p>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <g:kbplusDatePicker inputid="_startDate" name="startDate" value="${costitem.startDate?dateFormatter.format(costitem.startDate):''}"/>
              <label class="active">From</label>
            </div>
            <div class="input-field col s6">
              <g:kbplusDatePicker inputid="_endDate" name="endDate" value="${costitem.endDate?dateFormatter.format(costitem.endDate):''}"/>
              <label class="active">To</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <textarea name="description" id="costItemDescription" class="materialize-textarea">${costitem.costDescription}</textarea>
              <label for="costItemDescription" class="active">Note</label>
            </div>
          </div>
          
          <div class="row">
            <div class="col s12">
              <h3 class="indicator">Amount (Billing currency)</h3>
              <p class="grey-text">instructions to be written here</p>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <input type="number" name="costInBillingCurrencyExVAT" class="calc" placeholder="New Cost Ex-Tax - Billing Currency" id="costInBillingCurrencyExVAT" step="0.01" value="${costitem.costInBillingCurrencyExVAT}"/>
              <label for="costInBillingCurrencyExVAT" class="active">Cost excluding VAT</label>
            </div>
            <div class="input-field col s6">
              <input type="number" name="taxInBillingCurrency" class="calc" placeholder="New Tax - Billing Currency" id="taxInBillingCurrency" step="0.01" value="${costitem.taxInBillingCurrency}"/>
              <label for="taxInBillingCurrency" class="active">VAT Amount</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <input type="number" name="costInBillingCurrencyIncVAT" class="calc" placeholder="New Cost Inc-Tax - Billing Currency" id="costInBillingCurrencyIncVAT" step="0.01" value="${costitem.costInBillingCurrencyIncVAT}"/>
              <label for="costInBillingCurrencyIncVAT" class="active">Cost including VAT</label>
            </div>
          </div>
          
          <div class="row">
            <div class="col s12">
              <h3 class="indicator">Amount (Local currency)</h3>
              <p class="grey-text">instructions to be written here</p>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <g:select name="billingCurrency"
                        from="${com.k_int.kbplus.CostItem.orderedCurrency()}"
                        optionKey="id"
                        optionValue="text"
                        value="${costitem?.billingCurrency?.id}"/>
              <label>Billing Currency</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <input type="number" class="calc" name="costInLocalCurrencyExVAT" placeholder="New Cost Ex-Tax - Local Currency" id="costInLocalCurrencyExVAT" step="0.01" value="${costitem.costInLocalCurrencyExVAT}"/>
              <label for="costInLocalCurrencyExVAT" class="active">Cost excluding VAT</label>
            </div>
            <div class="input-field col s6">
              <input type="number" class="calc" name="taxInLocalCurrency" placeholder="New Tax - Local Currency" id="taxInLocalCurrency" step="0.01" value="${costitem.taxInLocalCurrency}"/>
              <label for="taxInLocalCurrency" class="active">VAT Amount</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <input type="number" class="calc" name="costInLocalCurrencyIncVAT" placeholder="New Cost Inc-Tax - Local Currency" id="costInLocalCurrencyIncVAT" step="0.01" value="${costitem.costInLocalCurrencyIncVAT}"/>
              <label for="costInLocalCurrencyIncVAT" class="active">Cost including VAT</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <input type="submit" class="waves-effect waves-light btn" value="Save">
            </div>
          </div>
        </g:form>
      </div>
      <!--form end-->
    </div>
  </div>
</div>

<script type="text/javascript">
  var ajax_lookup_url = "<g:createLink controller='ajax' action='lookup'/>";
  var mod_ref_obj = ".modifiedReferenceTypedown.refObj";
  var mod_ref_data = ".modifiedReferenceTypedown.refData";
  var sub_obj = "input[name=subscription]";
  
  //select2 setup for subs, pkgs, ie
  var sel2_b_objs = $(mod_ref_obj);
  
  //setup options for subs, pkgs, ie
  var sel2_b_opts = {
    placeholder:'test',
    initSelection : function (element, callback) {
      if(element.data('defaultvalue')) //If default value has been set in the markup!
      {
        var data = {id: element.data('domain')+':'+element.data('defaultid'), text: element.data('defaultvalue')};
        callback(data);
      }
    },
    minimumInputLength: 1,
    width: '100%',
    ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
      url: ajax_lookup_url,
      dataType: 'json',
      global: false,
      data: function (term, page){
        return {
          format:'json',
          q: '%'+term,
          baseClass:$(this).data('domain'),
          inst_shortcode: $(this).data('shortcode'),
          subFilter: $(this).data('subfilter'),
          hideDeleted: 'true',
          hideIdent: 'false',
          inclSubStartDate: 'false',
          page_limit: 10
        };
      },
      results: function (data, page) {
        return {results: data.values};
      }
    },
    allowClear: true,
    formatSelection: function(data) {
      return data.text;
    }
  };
  
  var currentSub  = null;
  sel2_b_objs.each(function(index) {
    $(this).select2(sel2_b_opts).select2('val',':');
    if(index % 3) //pkg & ie inputs
    {
      if(currentSub.data().defaultvalue == null)
      {
       console.log('ok here');
        $(this).select2('disable');
        console.log('huh');
      }
    }
    else  //sub inp
    {
      currentSub = $(this);
    }
  });
  currentSub = null;
  
  $('input[name=budgetCode]').select2({
    placeholder: "New code or lookup  code",
    initSelection: function(element, callback) {
      var preselections = [];
      <g:each in="${costitem.getBudgetcodesAsRefDataValues()}" var="bc">
        preselections.push({id:${bc.id}, text:"${bc.value}"});
      </g:each>
      callback(preselections);
    },
    width: '100%',
    allowClear: true,
    tags: true,
    tokenSeparators: [',', ' '],
    minimumInputLength: 1,
    ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
      url: ajax_lookup_url,
      dataType: 'json',
      data: function (term, page) {
        return {
          format:'json',
          q: term,
          inst_shortcode: '${params.defaultInstShortcode}',
          baseClass:'com.k_int.kbplus.CostItemGroup'
        };
      },
      results: function (data, page) {
        return {results: data.values};
      }
    },
    createSearchChoice:function(term, data) {
      var existsAlready     = false;
      for (var i = 0; i < data.length; i++)
      {
        if(term.toLowerCase() == data[i].text.toLowerCase())
        {
          existsAlready = true;
          break;
        }
      }
      if(!existsAlready)
      {
        return {id:-1+term, text:"new code: "+term};
      }
    }
  }).select2('val',[]);
  
  //If we want to do something upon selection
  $('input[name=budgetCode]').on("select2-selecting", function(e) {
    var presentSelections = $('input[name=budgetCode]').select2('data');
    var current           = e.choice.text.trim().toLowerCase();
    if(current.indexOf("new code: ",0) == 0)
    {
      current = current.substring(10,current.length);
    }
    
    if(presentSelections.length > 0)
    {
      for (var i = 0; i < presentSelections.length; i++)
      {
        var p = (presentSelections[i].text.indexOf("new code: ",0) == 0)? presentSelections[i].text.trim().toLowerCase().substring(10,presentSelections[i].text.length):presentSelections[i].text.trim().toLowerCase();
        if(p == current)
        {
          e.preventDefault();
          break;
        }
      }
    }
  });
  
  $('body').on("select2-selecting select2-removed", sub_obj, function(e) {
    var isRemoved     = e.type === 'select2-removed';
    var element       = $(this);
    var id            = isRemoved === true? null : e.choice.id;
    var currentText   = isRemoved === true? null : e.choice.text;
    element.data('subFilter',id);
    console.log(isRemoved);
    console.log(element);
    console.log(id);
    console.log(currentText);
    console.log('end of stuff');
    $('input[name=subpackage]').select2((isRemoved? 'disable' : 'enable'));
    $('input[name=title]').select2(isRemoved? 'disable' : 'enable');
    
    if (isRemoved) {
      $('input[name=subpackage]').select2('data', null);
      $('input[name=title]').select2('data', null);
      $('input[name=subpackage]').data('subfilter',null);
      $('input[name=title]').data('subfilter',null);
    }
    else {
      $('input[name=subpackage]').data('subfilter',id.split(":")[1]);
      $('input[name=title]').data('subfilter',id.split(":")[1]);
    }
  });
  
  $(mod_ref_data).select2({
    initSelection : function (element, callback) {
      //If default value has been set in the markup!
      if(element.data('defaultvalue')) {
        var data = {id: element.data('domain')+':'+element.data('relationid'), text: element.data('defaultvalue')};
        callback(data);
      }
    },
    minimumInputLength: 1,
    width: '100%',
    ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
      url: ajax_lookup_url,
      dataType: 'json',
      global: false,
      data: function (term, page){
        return {
          format:'json',
          q: term,
          baseClass:$(this).data('domain'),
          inst_shortcode: $(this).data('shortcode')
        };
      },
      results: function (data, page) {
        return {results: data.values};
      }
    },
    allowClear: true,
    createSearchChoice:function(term, data) {
      var existsAlready = false;
      for (var i = 0; i < data.length; i++)
      {
        if(term.toLowerCase() == data[i].text.toLowerCase()) {
          existsAlready = true;
          break;
        }
      }
      if(!existsAlready) {
        return {id:term+':create', text:"new code:"+term};
      }
    }
  }).select2('val',':');
  
  //not sure we need this method
  /*$('body').on("select2-selecting", mod_ref_data, function(e) {
    var element = $(this);
    var currentText = "";
    var rel = "";
    var prevSelection = element.select2("data");
    
    if(e.choice.id.split(':')[1] == 'create')
    {
      rel         = element.data('domain') + ':create';
      currentText = e.choice.text.trim().toLowerCase().substring(9);
    }
    else {
      rel         = e.choice.id;
      currentText = e.choice.text.trim().toLowerCase();
    }
    
    $.ajax({
      method: "POST",
      url: s.url.ajaxFinanceRefData,
      data: {
        owner:element.data('owner')+':'+element.data('ownerid'), //org.kbplus.CostItem:1
        ownerField: element.data("ownerfield"), //order
        relation: rel,  //org.kbplus.Order:100
        relationField: element.data('relationfield'), //orderNumber
        val:currentText,         //123456
        inst_shortcode:element.data('shortcode')
      },
      global: false
    })
    .fail(function( jqXHR, textStatus, errorThrown ) {
      alert('Reset back to the original value, there was an error trying to save the data');
      element.select2('data', prevSelection ? prevSelection : '');
    })
    .done(function(data) {
      if(data.error.length > 0) {
        element.select2('data', prevSelection);
      }
      else {
        element.data('previous',prevSelection ? prevSelection.id+'_'+prevSelection.text : '');
        element.data('defaultvalue',e.choice.text);
        element.data('relationid',data.relation.id);
      }
    });
  });*/
</script>