<%@ page import="com.k_int.kbplus.*" %>
<%@ page import="com.k_int.custprops.PropertyDefinition" %>
<!doctype html>
<html lang="en" class="no-js">
  <head>
    <parameter name="pagetitle" value="Organisation Details: ${orgInstance.name}" />
    <parameter name="pagestyle" value="organisations" />
    <meta name="layout" content="base"/>
    <title>KB+ Organisation: ${orgInstance.name}</title>
  </head>
  <body class="organisations">
    <div class="row">
      <div class="col s12">
        <div class="row row-content">
          <div class="col s12 m6">
            <div class="card jisc_card small white fullheight">
              <div class="card-content text-navy">
                <div class="col m12 section">
                  <div class="col m6 title">Organisation Name:</div>
                  <div class="col m6 result">${orgInstance.name?:'None'}</div>
                </div>
              </div>
            </div>
          </div>
          
          <div class="col s12 m6">
            <div class="card jisc_card small white fullheight">
              <div class="card-content text-navy">
                <div class="col m12 section">
                  <div class="col m6 title">Sector:</div>
                  <div class="col m6 result">${orgInstance.sector?:'None'}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
       	
        <div class="row row-content">
          <div class="col s12">
            <div class="card jisc_card small white fullheight">
              <div class="card-content text-navy">
                <p class="card-title pack-detail">Identifiers</p>
                <div class="card-detail"></div>
                <div class="card-form">
                  <div class="input-field padding col s12 m6">
                    <ul class="collection">
                      <g:each in="${orgInstance.ids}" var="i">
                        <li class="collection-item"><g:link controller="identifier" action="show" id="${i.identifier.id}">${i?.identifier?.ns?.ns?.encodeAsHTML()} : ${i?.identifier?.value?.encodeAsHTML()}</g:link></li>
                      </g:each>
                      
                      <g:if test="${((orgInstance.ids == null) || (orgInstance.ids?.size() == 0)) }">
                        <li class="collection-item">None</li>
                      </g:if>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <div class="row">
          <div class="col s12">
            <div class="tab-table z-depth-1">
              <ul class="tabs jisc_content_tabs">
                <li class="tab"><a href="#other">Other Organisation Link</a></li>
              </ul>
              
              <div id="other" class="tab-content">
                <ul class="collection">
                  <g:if test="${orgInstance?.links}">
                    <g:each in="${orgInstance.links}" var="i">
                      <li class="collection-item">
                        <g:if test="${i.pkg}"><g:link controller="packageDetails" action="show" id="${i.pkg.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Package: ${i.pkg.name} (${i.pkg?.packageStatus?.value})</g:link></g:if>
                        <g:if test="${i.sub}">
                          <g:link controller="subscriptionDetails" action="index" id="${i.sub.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Subscription: ${i.sub.name} (${i.sub.status?.value})</g:link>
                        </g:if>
                        <g:if test="${i.lic}">Licence: ${i.lic.id} (${i.lic.status?.value})</g:if>
                        <g:if test="${i.title}"><g:link controller="titleInstance" action="show" id="${i.title.id}" params="${params.defaultInstShortcode?[defaultInstShortcode:params.defaultInstShortcode]:[]}">Title: ${i.title.title} (${i.title.status?.value})</g:link></g:if>
                        <g:if test="${i.roleType?.value}">
                          (${i.roleType.value})
                        </g:if>
                      </li>
                    </g:each>
                  </g:if>
                  <g:else>
                    <li class="collection-item">No Other Organisation Links</li>
                  </g:else>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
