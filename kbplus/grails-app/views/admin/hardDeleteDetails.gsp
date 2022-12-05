<div class="container" data-theme="admin">
  <div class="row">
    <div class="col s12">
      <h1 class="form-title flow-text navy-text">Hard Delete: ${pkg}</h1>
      <p class="form-caption flow-text text-grey">Items requiring action are marked with a red cross. When these items are addressed, 'Confirm Delete' button will be enabled.</p>
      <div class="row">
        <div class="col s12">
          <div class="tab-table z-depth-1  table-responsive-scroll">
            <table class="highlight bordered">
              <thead>
                <tr>
                  <th>Item</th>
                  <th>Details</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
                <g:set var="actions_needed" value="false"/>
                <g:each in="${conflicts_list}" var="conflict_item">
                  <tr>
                    <td>${conflict_item.name}</td>
                    <td style="white-space:wrap; word-wrap: break-word;">
                      <ul>
                        <g:each in="${conflict_item.details}" var="detail_item">
                          <li> 
                            <g:if test="${detail_item.link}">
                              <a href="${detail_item.link}" target="_blank">${detail_item.text}</a>
                            </g:if>
                            <g:else>
                              ${detail_item.text}
                            </g:else>
                          </li>
                        </g:each>
                      </ul>
                    </td>
                    <td style="white-space:wrap; word-wrap: break-word;">
                      <g:if test="${conflict_item.action.actionRequired}">
                        <i style="color:red" class="material-icons">clear</i>
                        <g:set var="actions_needed" value="true"/>
                      </g:if>
                      <g:else>
                        <i style="color:green" class="material-icons">done</i>
                      </g:else>
                      ${conflict_item.action.text}
                    </td>
                  </tr>
                </g:each>
              </tbody>
            </table>
          </div>
        </div>
      </div>
      
      <div class="row">
        <div class="col s12">
          <g:form action="performPackageDelete" id="${pkg.id}" onsubmit="return confirm('Deleting this package is PERMANENT. Delete package?')" method="POST">
            <g:if test="${actions_needed == 'true'}">
              <button type="submit" disabled="disabled" class="btn btn-small">Confirm Delete</button>
            </g:if>
            <g:else>
              <button type="submit"class="btn btn-small">Confirm Delete</button>
            </g:else>
          </g:form>
        </div>
      </div>
    </div>
  </div>
</div>
