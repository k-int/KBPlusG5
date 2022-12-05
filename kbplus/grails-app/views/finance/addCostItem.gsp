<%@ page import="com.k_int.kbplus.RefdataValue" %>
<%@ page import="com.k_int.kbplus.CostItem" %>

<g:set var="addcostitem_params_sc" value="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}"/>
<div class="container" data-theme="finance">
  <div class="row">
    <div class="col s12">
      <h1 class="form-title flow-text navy-text">Add new cost item</h1>
      <p class="form-caption flow-text grey-text">Description text here</p>
      <!--form-->
      <div class="row">
        <g:form controller="finance" action="newCostItem" params="${addcostitem_params_sc}" class="col s12">
          <div class="row">
            <div class="col s12">
              <h3 class="indicator">Invoice details</h3>
            </div>
          </div>
          
          <div class="row ">
            <div class="input-field col s6">
              <input type="text" name="newInvoiceNumber" id="newInvoiceNumber">
              <label for="newInvoiceNumber" class="active">Invoice Number</label>
            </div>
            <div class="input-field col s12 m6">
              <g:kbplusDatePicker inputid="newDatePaid" name="newDate" value=""/>
              <label class="active">Date Invoice Issued</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <input type="text" name="newOrderNumber" id="newOrderNumber" value="${params.newOrderNumber}"/>
              <label for="newOrderNumber" class="active">Purchase Order Number</label>
            </div>
            <div class="input-field col s6">
              <input type="text" name="newReference" id="newCostItemReference" value="${params.newReference}"/>
              <label for="newCostItemReference" class="active">Item Reference</label>
            </div>

          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <input type="text" name="newBudgetCode" id="newBudgetCode">
              <label class="active" style="transform: translateY(-200%);">Budget Codes</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <g:select name="newCostItemStatus"
                        from="${RefdataValue.executeQuery('select rdv from RefdataValue as rdv where rdv.owner.desc=? order by rdv.sortKey, rdv.value asc','CostItemStatus')}"
                        optionKey="id"
                        optionValue="value"
                        noSelection="${['':'No Status']}"/>
              <label>Payment Status</label>
            </div>
            <div class="input-field col s6">
              <g:select name="newCostItemCategory"
                        from="${RefdataValue.executeQuery('select rdv from RefdataValue as rdv where rdv.owner.desc=? order by rdv.sortKey, rdv.value asc','CostItemCategory')}"
                        optionKey="id"
                        optionValue="value"
                        noSelection="${['':'No Category']}"/>
              <label>Debit/Credit</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <g:select name="newCostItemElement"
                        from="${RefdataValue.executeQuery('select rdv from RefdataValue as rdv where rdv.owner.desc=? order by rdv.sortKey, rdv.value asc','CostItemElement')}"
                        optionKey="id"
                        optionValue="value"
                        noSelection="${['':'No Element']}"/>
              <label>Element</label>
            </div>
            <div class="input-field col s6">
              <g:select name="newCostTaxType"
                        from="${RefdataValue.executeQuery('select rdv from RefdataValue as rdv where rdv.owner.desc=? order by rdv.sortKey, rdv.value asc','TaxType')}"
                        optionKey="id"
                        optionValue="value"
                        noSelection="${['':'No Tax Type']}"/>
              <label>Tax Type</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <input name="newSubscription" id="newSubscription" value="${params.newSubscription}"/>
              <label class="active" style="transform: translateY(-200%);">Subscription</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <input name="newPackage" id="newPackage" disabled='disabled' data-disableReset="true"/>
              <label class="active" style="transform: translateY(-200%);">Package</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <input name="newIE" id="newIE" disabled='disabled' data-disableReset="true"/>
              <label class="active" style="transform: translateY(-200%);">Issue Entitlement</label>
            </div>
          </div>
          
          <div class="row top30">
            <div class="col s12">
              <h3 class="indicator">Invoice period</h3>
              <p class="grey-text">The period of subscription which the cost item is related to</p>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <g:kbplusDatePicker inputid="newStartDate" name="newStartDate" value=""/>
              <label class="active">From</label>
            </div>
            <div class="input-field col s6">
              <g:kbplusDatePicker inputid="newEndDate" name="newEndDate" value=""/>
              <label class="active">To</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <textarea name="newDescription" id="newCostItemDescription" class="materialize-textarea"></textarea>
              <label for="newCostItemDescription" class="active">Note</label>
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
              <g:select name="newCostCurrency"
                        from="${CostItem.orderedCurrency()}"
                        optionKey="id"
                        optionValue="text"/>
              <label>Billing Currency</label>
            </div>
            <div class="input-field col s6">
              <input type="number" name="newCostInBillingCurrencyExVAT" class="calc" placeholder="New Cost Ex-Tax - Billing Currency" id="newCostInBillingCurrencyExVAT" step="0.01"/> <br/>
              <label for="newCostInBillingCurrencyExVAT" class="active">Cost excluding VAT</label>
            </div>
            <div class="input-field col s6">
              <input type="number" name="newTaxInBillingCurrency" class="calc" placeholder="New Tax - Billing Currency" id="newTaxInBillingCurrency" step="0.01"/> <br/>
              <label for="newTaxInBillingCurrency" class="active">VAT Amount</label>
            </div>
            <div class="input-field col s6">
              <input type="number" name="newCostInBillingCurrencyIncVAT" class="calc" placeholder="New Cost Inc-Tax - Billing Currency" id="newCostInBillingCurrencyIncVAT" step="0.01"/>
              <label for="newCostInBillingCurrencyIncVAT" class="active">Cost including VAT</label>
            </div>
          </div>
          
          <div class="row">
            <div class="col s12">
              <h3 class="indicator">Amount (Local currency)</h3>
              <p class="grey-text">This amount will appear in your subscription screen</p>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <input type="number" class="calc" name="newCostInLocalCurrencyExVAT" placeholder="New Cost Ex-Tax - Local Currency" id="newCostInLocalCurrencyExVAT" step="0.01"/> <br/>
              <label for="newCostInLocalCurrencyExVAT" class="active">Cost excluding VAT</label>
            </div>
            <div class="input-field col s6">
              <input type="number" class="calc" name="newTaxInLocalCurrency" placeholder="New Tax - Local Currency" id="newTaxInLocalCurrency" step="0.01"/> <br/>
              <label for="newTaxInLocalCurrency" class="active">VAT Amount</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s6">
              <input type="number" class="calc" name="newCostInLocalCurrencyIncVAT" placeholder="New Cost Inc-Tax - Local Currency" id="newCostInLocalCurrencyIncVAT" step="0.01"/>
              <label for="newCostInLocalCurrencyIncVAT" class="active">Cost including VAT</label>
            </div>
          </div>
          
          <div class="row">
            <div class="input-field col s12">
              <input type="submit" class="waves-effect waves-light btn" value="Add Cost Item">
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
  var new_sub = "input[name=newSubscription]";
  $(new_sub).select2({
    placeholder: "Type subscription name...",
    width: '100%',
    minimumInputLength: 1,
    global: false,
    ajax: {
      url: ajax_lookup_url,
      dataType: 'json',
      data: function (term, page) {
        return {
          hideDeleted: 'true',
          hideIdent: 'true',
          inclSubStartDate: 'false',
          inst_shortcode: '${params.defaultInstShortcode}',
          q: '%'+term , // contains search term
          page_limit: 20,
          baseClass:'com.k_int.kbplus.Subscription'
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
  });
  
  $('input[name=newPackage]').select2({
    placeholder: "Type package name...",
    width: '100%',
    minimumInputLength: 1,
    global: false,
    ajax: {
      url: ajax_lookup_url,
      dataType: 'json',
      data: function (term, page) {
        console.log("sub " + $(this).attr('subfilter'));
        return {
          hideDeleted: 'true',
          hideIdent: 'true',
          inclSubStartDate: 'false',
          inst_shortcode: '${params.defaultInstShortcode}',
          q: '%'+term , // contains search term
          page_limit: 20,
          subFilter: $(this).attr('subfilter').split(":")[1],
          baseClass:'com.k_int.kbplus.SubscriptionPackage'
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
  });
  
  $('input[name=newIE]').select2({
    placeholder: "Journal title",
    width: '100%',
    minimumInputLength: 1,
    ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
      url: ajax_lookup_url,
      dataType: 'json',
      data: function (term, page) {
        return {
          format:'json',
          q: term,
          subFilter: $(this).attr('subfilter').split(":")[1],
          baseClass:'com.k_int.kbplus.IssueEntitlement'
        };
      },
      results: function (data, page) {
        return {results: data.values};
      }
    },
    allowClear: true
  });

  $('input[name=newBudgetCode]').select2({
    placeholder: "New code or lookup  code",
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
  });
  
  //If we want to do something upon selection
  $('input[name=newBudgetCode]').on("select2-selecting", function(e) {
    var presentSelections = $('input[name=newBudgetCode]').select2('data');
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
  
  $('body').on("select2-selecting select2-removed", new_sub, function(e) {
    var isRemoved     = e.type === 'select2-removed';
    var element       = $(this);
    var id            = isRemoved === true? null : e.choice.id;
    var currentText   = isRemoved === true? null : e.choice.text;
    element.attr('subFilter',id);
    console.log(isRemoved);
    console.log(element);
    console.log(id);
    console.log(currentText);
    console.log('end of stuff');
    $('input[name=newPackage]').select2((isRemoved? 'disable' : 'enable'));
    $('input[name=newPackage]').attr('subfilter',id);
    $('input[name=newIE]').select2(isRemoved? 'disable' : 'enable');
    $('input[name=newIE]').attr('subfilter',id);
  });
</script>
