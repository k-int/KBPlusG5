<%@ page import="com.k_int.kbplus.RefdataValue; com.k_int.custprops.PropertyDefinition" %>
<!doctype html>
<html>
  <head>
      <meta name="layout" content="base">
      <g:set var="entityName" value="${message(code: 'propertyDefinition.label', default: 'Property Definition')}"/>
      <parameter name="pagetitle" value="Create ${entityName}" />
      <title><g:message code="default.create.label" args="[entityName]"/></title>
      <parameter name="actionrow" value="none" />
  </head>

<body class="admin">

<!--page title start-->
    <div class="row">
        <div class="col s12 l12">
            <h1 class="page-title left">Create ${entityName}</h1>
        </div>
    </div>
<!--page title end-->

<!-- Error messages -->
    <g:if test="${flash.message}">
        <div class="row">
            <div class="col s12">
                <div class="card-panel blue lighten-1">
                    <span class="white-text"> ${flash.message}</span>
                </div>
            </div>
        </div>
    </g:if>
    <g:if test="${flash.error}">
        <div class="row">
            <div class="col s12">
                <div class="card-panel red lighten-1">
                    <span class="white-text"> ${flash.error}</span>
                </div>
            </div>
        </div>
    </g:if>
    <g:hasErrors bean="${newProp}">
        <div class="row">
            <div class="col s12">
                <div class="card-panel red lighten-1">
                    <span class="white-text">
                        <ul>
                            <g:eachError bean="${newProp}" var="error">
                                <li><g:message error="${error}"/></li>
                            </g:eachError>
                        </ul>
                    </span>
                </div>
            </div>
        </div>
    </g:hasErrors>
<!-- Error messages end -->
    <div class="row">
        <div class="col s12">
            <div class="row strip-table z-depth-1">
                <!-- Form -->
                <g:form id="create_cust_prop" url="[controller: 'ajax', action: 'addCustPropertyType']" >
                    <input type="hidden" name="redirect" value="yes"/>
                    <input type="hidden" name="ownerClass" value="${this.class}"/>

                    <div class="row">
                        <div class="input-field col s12">
                            <input type="text" name="cust_prop_name" id="cust_prop_name"/>
                            <label for="cust_prop_name">Name</label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="input-field col s12">
                            <g:select
                                    from="${PropertyDefinition.validTypes.entrySet()}"
                                    optionKey="value" optionValue="key"
                                    name="cust_prop_type"
                                    id="cust_prop_modal_select" />
                            <label>Type</label>
                        </div>
                    </div>
                    <div class="row hide" id="cust_prop_ref_data_name">
                            <div class="input-field col s12">
                                <label class="property-label select2label">Refdata Category:</label>
                                <input type="hidden" name="refdatacategory" id="cust_prop_refdatacatsearch"/>
                            </div>
                    </div>
                    <div class="row">
                        <div class="input-field col s12">
                            <g:select name="cust_prop_desc"  from="${PropertyDefinition.AVAILABLE_DESCR}"/>
                            <label>Context</label>
                        </div>
                    </div>

                    <div class="row">
                        <button type="submit" class="btn btn-success">
                            <i class="icon-ok icon-white"></i>
                            Create Property
                        </button>
                    </div>

                </g:form>
            </div>
        </div>
    </div>
<!-- End Form -->

%{--
    <div class="row-fluid">

        <div class="span3">
            <div class="well">
                <ul class="nav nav-list">
                    <li class="nav-header">${entityName}</li>
                    <li>
                        <g:link class="list" action="list">
                            <i class="icon-list"></i>
                            <g:message code="default.list.label" args="[entityName]"/>
                        </g:link>
                    </li>
                    <li>
                        <g:link class="create" action="create">
                            <i class="icon-plus"></i>
                            <g:message code="default.create.label" args="[entityName]"/>
                        </g:link>
                    </li>
                </ul>
            </div>
        </div>

        <div class="span9">

            <div class="page-header">
                <h1><g:message code="default.create.label" args="[entityName]"/></h1>
            </div>

        <g:if test="${flash.message}">
          <div class="container">
            <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
          </div>
        </g:if>

        <g:if test="${flash.error}">
          <div class="container">
            <bootstrap:alert class="error-info">${flash.error}</bootstrap:alert>
          </div>
        </g:if>

        <g:hasErrors bean="${newProp}">
            <bootstrap:alert class="alert-error">
            <ul>
                <g:eachError bean="${newProp}" var="error">
                    <li> <g:message error="${error}"/></li>
                </g:eachError>
            </ul>
            </bootstrap:alert>
        </g:hasErrors>


          <p>Use the following form to create additional property definitions. Property definition names are unique.</p>
           <g:form id="create_cust_prop" url="[controller: 'ajax', action: 'addCustPropertyType']" >
              <input type="hidden" name="redirect" value="yes"/>
              <input type="hidden" name="ownerClass" value="${this.class}"/>

              <div class="modal-body">
                  <dl>
                      <dt><label class="control-label">New Property Definition:</label></dt>
                      <dd>
                          <label class="property-label">Name:</label> <input type="text" name="cust_prop_name"/>
                      </dd>
                      <dd>
                          <label class="property-label">Type:</label> <g:select
                              from="${PropertyDefinition.validTypes.entrySet()}"
                                      optionKey="value" optionValue="key"
                                      name="cust_prop_type"
                                      id="cust_prop_modal_select" />
                      </dd>

                      <div class="hide" id="cust_prop_ref_data_namea">
                          <dd>
                              <label class="property-label">Refdata Category:</label>
                              <input type="hidden" name="refdatacategory" id="cust_prop_refdatacatsearch"/>
                          </dd>
                      </div>
                      <dd>
                          <label class="property-label">Context:</label>
                             <g:select name="cust_prop_desc"  from="${PropertyDefinition.AVAILABLE_DESCR}"/>

                      </dd>
                      <button type="submit" class="btn btn-success">
                        <i class="icon-ok icon-white"></i>
                        Create Property
                    </button>
                  </dl>
              </div>
              </g:form>

        </div>

    </div>
    --}%
<script>

    function chk(n1,n2) {
        if ( n1===0 && n2 ===0 ) {
            return true;
        }
        else {
            return confirm("Deleting this property will also delete "+n1+" License Value[s] and "+n2+" Subscription Value[s]. Are you sure you want to HARD delete these values? Deletions will NOT be recoverable!");
        }
        return false;
    }
    function setuppage(){


        $('#cust_prop_modal_select').change(function() {
            var selectedText = $( "#cust_prop_modal_select option:selected" ).val();
            if( selectedText == "com.k_int.kbplus.RefdataValue") {
                $("#cust_prop_ref_data_name").removeClass('hide').show();
            }else{
                $("#cust_prop_ref_data_name").addClass('hide').hide();
            }
        });

        $("#cust_prop_refdatacatsearch").select2({
            placeholder: "Type category...",
            minimumInputLength: 1,
            ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
                url: '${createLink(controller:'ajax', action:'lookup')}',
                dataType: 'json',
                data: function (term, page) {
                    return {
                        q: term, // search term
                        page_limit: 10,
                        baseClass:'com.k_int.kbplus.RefdataCategory'
                    };
                },
                results: function (data, page) {
                    return {results: data.values};
                }
            }
        });
    }

    setTimeout(function(){
        setuppage();
    }, 100);



</script>
  </body>



</html>
