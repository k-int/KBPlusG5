<!doctype html>
<html lang="en" class="no-js">
<head>
    <meta name="layout" content="base"/>
    <parameter name="pagetitle" value="Finance" />
    <parameter name="pagestyle" value="Finance" />
    <parameter name="actionrow" value="financeList" />
</head>
<body class="finance">

  <div class="row">
    <div class="col s12 l10">
        <h1 class="page-title">Add Cost Item</h1>
    </div>
  </div>

  <g:form controller="finance" action="newCostItem" >
     <input type="hidden" name="defaultInstShortcode" value="${params.defaultInstShortcode}"/>

     <div class="row row-content">
        
        <div class="col s12 m6 l3">
           <div class="card-panel drop-line">
              <p class="card-title">Invoice No</p>
              <p class="card-caption">
                <input type="text" name="newInvoiceNumber" class="input-medium" placeholder="New item invoice number" id="newInvoiceNumber" value="">
              </p>
           </div>
           <div class="card-panel drop-line">
              <p class="card-title">Invoice Date</p>
              <p class="card-caption">
                <input class="datepicker" type="date" placeholder="Date issued" name="newDate" id="newDatePaid" value="">
              </p>
          </div>
        </div>

        <div class="col s12 m6 l3">

          <div class="card-panel">
            <p class="card-title">Start Date</p>
            <p class="card-caption">
                <input class="datepicker" placeholder="Start Date" type="date" id="newStartDate" name="newStartDate">
            </p>
         </div>

          <div class="card-panel hide-text">
              <p class="card-title">End Date</p>
              <p class="card-caption">
                <input class="datepicker" placeholder="End Date" type="date" id="newEndDate" name="newEndDate">
              </p>
          </div>

        </div>

        <div class="col s12 m6 l3">

          <div class="card jisc_card small white">
            <div class="card-content text-navy">
              <span class="card-title">Amount (Billing currency)</span>
              <div class="card-detail">
                <ul class="collection">
                  <li class="collection-item plain"><span>Billing Currency:</span> 
                     <g:select name="newCostCurrency"
                               from="${com.k_int.kbplus.RefdataValue.executeQuery('select rdv from RefdataValue as rdv where rdv.owner.desc=?','Currency')}"
                               optionKey="id"
                               noSelection="${['':'No Currency']}"/>
                  </li>
                  <li class="collection-item plain"><span>Subtotal:</span> 
                    <input type="number" name="newCostInBillingCurrencyExVAT" class="calc" placeholder="New Cost Ex-Tax - Billing Currency" id="newCostInBillingCurrencyExVAT" step="0.01">
                  </li>
                  <li class="collection-item plain"><span>VAT:</span> 
                    <input type="number" name="newTaxInBillingCurrency" class="calc" placeholder="New Tax - Billing Currency" id="newTaxInBillingCurrency" step="0.01">
                  </li>
                  <li class="collection-item plain last">Total: 
                    <input type="number" name="newCostInBillingCurrencyIncVAT" class="calc" placeholder="New Cost Inc-Tax - Billing Currency" id="newCostInBillingCurrencyIncVAT" step="0.01">
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>

        <div class="col s12 m6 l3">
          <div class="card jisc_card small white">
            <div class="card-content text-navy">
              <span class="card-title">Local Currency (GBP)</span>
              <div class="card-detail">
                <ul class="collection">
                  <li class="collection-item plain"><span>Subtotal:</span> 
                    <input type="number" class="calc" name="newCostInLocalCurrencyExVAT" placeholder="New Cost Ex-Tax - Local Currency" id="newCostInLocalCurrencyExVAT" step="0.01">
                  </li>
                  <li class="collection-item plain"><span>VAT:</span> 
                    <input type="number" class="calc" name="newTaxInLocalCurrency" placeholder="New Tax - Local Currency" id="newTaxInLocalCurrency" step="0.01">
                  </li>
                  <li class="collection-item plain last">Total: 
                    <input type="number" class="calc" name="newCostInLocalCurrencyIncVAT" placeholder="New Cost Inc-Tax - Local Currency" id="newCostInLocalCurrencyIncVAT" step="0.01">
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>

     </div>

    <div class="row">
  <!--*** Documents card***-->
    <div class="col s12 l6">
      <div class="card white mobilecard" style="min-height: 250px;">
      <!--*** Internal Cards ***-->
        <div class="internal-card-panel">
          <p class="card-title">Status</p>
          <p class="card-caption">
            <g:select name="newCostItemStatus"
                      from="${com.k_int.kbplus.RefdataValue.executeQuery('select rdv from RefdataValue as rdv where rdv.owner.desc=?','CostItemStatus')}"
                      optionKey="id"
                      noSelection="${['':'No Status']}"/>
          </p>
        </div>
      <div class="internal-card-panel">
        <p class="card-title">Element</p>
        <p class="card-caption">
          <g:select name="newCostItemElement"
                    from="${com.k_int.kbplus.RefdataValue.executeQuery('select rdv from RefdataValue as rdv where rdv.owner.desc=?','CostItemElement')}"
                    optionKey="id"
                    noSelection="${['':'No Element']}"/>
        </p>

      </div>

      <div class="internal-card-panel">
        <p class="card-title">Category</p>
        <p class="card-caption">
          <g:select name="newCostItemCategory"
                    from="${com.k_int.kbplus.RefdataValue.executeQuery('select rdv from RefdataValue as rdv where rdv.owner.desc=?','CostItemCategory')}"
                    optionKey="id"
                    noSelection="${['':'No Category']}"/>

        </p>
      </div>

      <div class="internal-card-panel">
        <p class="card-title">Tax Type</p>
        <p class="card-caption">
          <g:select name="newCostTaxType"
                    from="${com.k_int.kbplus.RefdataValue.executeQuery('select rdv from RefdataValue as rdv where rdv.owner.desc=?','TaxType')}"
                    optionKey="id"
                    noSelection="${['':'No Tax Type']}"/>

        </p>
      </div>

      <!--*** Internal Cards end ***-->
      </div>

      <div class="row row-inset">
        <div class="col s12 m6">
          <div class="card-panel drop-line">
                  <p class="card-title">Codes</p>
                  <p class="card-caption">
                    <input type="text" name="newReference" placeholder="New Item Reference" id="newCostItemReference" value="${params.newReference}"/><br/>
                    <input type="text" name="newBudgetCode" placeholder="New Item Budget Code" id="newBudgetCode" ></td>
                  </p>
                 </div>
               </div>

        <div class="col s12 m6">
                 <div class="card-panel drop-line">
                  <p class="card-title">Notes</p>
                  <p class="card-caption">
                    <textarea name="newDescription" placeholder="New Note" id="newCostItemDescription"></textarea>
                  </p>
                 </div>
               </div>
             </div>


      </div>
      <!--*** Documents card end ***-->

      <div class="col s12 l6">
        <div class="card-panel drop-line">
              <p class="card-title">Subscription</p>
              <p class="card-caption">
                <input type="hidden" name="newSubscription" class="KBPlusTypeDown" 
                        id="newSubscription" 
                        data-base-class="com.k_int.kbplus.Subscription" 
                        data-inst-shortcode="${params.defaultInstShortcode}"
                        value="${params.newSubscription}"/>
              </p>
        </div>

        <div class="card-panel drop-line">
              <p class="card-title">Package</p>
              <p class="card-caption">
                <input type="hidden" name="newPackage" class="KBPlusTypeDown" 
                        id="newPackage" 
                        data-base-class="com.k_int.kbplus.SubscriptionPackage" 
                        data-inst-shortcode="${params.defaultInstShortcode}"
                        data-qpsub-Filter="123"
                        value="${params.newPackage}"/>
              </p>
        </div>

        <div class="card-panel drop-line">
              <p class="card-title">Title</p>
              <p class="card-caption">
                <select name="newIssueEntitlement" class="input-medium" id="newIssueEntitlement" value="${params.newIssueEntitlement}">
                  <option value="">Not Set</option>
                </select>
                <input type="hidden" name="newIssueEntitlement" class="KBPlusTypeDown" 
                        id="newIssueEntitlement" 
                        data-base-class="com.k_int.kbplus.IssueEntitlement" 
                        data-inst-shortcode="${params.defaultInstShortcode}"
                        data-qp-subFilter="123"
                        value="${params.newPackage}"/>

              </p>
        </div>
      </div>

    </div>
    <button type="submit">Add cost item</button>
  </g:form>

</body>
</html>
