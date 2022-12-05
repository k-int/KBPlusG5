<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
    <parameter name="pagetitle" value="Simple Reporting::${report_title:'Unnamed Report'}" />
    <title>KB+ Simple Reporting</title>
  </head>
  <body class="admin">
    <g:form controller="simpleReporting" action="run" method="get">

      <input type="hidden" name="queryId" value="${params.queryId ?: query_id}"/>
      <input type="hidden" name="queryType" value="${params.queryType ?: query_type}"/>
      <input type="hidden" name="savedQueryId" value="${savedQueryId}"/>
      <input type="hidden" name="savedQueryRef" value="${savedQueryRef}"/>

      <g:if test="${flash.message}">
        <div class="row">
          <div class="col s12">
            <div class="card-panel blue lighten-1">
              <span class="white-text"> ${flash.message}</span>
            </div>
          </div>
        </div>
      </g:if>
      <div class="row">
        <div class="col s2">
          Query ID ${params.savedQueryId}
        </div>
        <div class="col s2">
          Query Type : ${params.queryType ?: query_type}
        </div>
        <div class="col s8">
          <input type="text" name="queryRef" value="${params.savedQueryRef}" placeholder="Query Name"/>
        </div>
      </div>
      <div class="row">
        <div class="col s12">
          <textarea name="query" rows="15">${query_text}</textarea>
        </div>
      </div>
        <div class="input-field col s6">
          <button name="RunButton" type="submit" value="Go" class="waves-effect waves-light btn">Run New Query</button>
          <button name="SaveButton" type="submit" value="Go" class="waves-effect waves-light btn">Save New Query</button>
          <g:link class="waves-effect waves-light btn pull-right" controller="simpleReporting" action="index">Back to Query List</g:link>
        </div>
      </div>
      <div class="row">
        <div class="col s12">
          <div class="row tab-table z-depth-1">       
            <table>
              <tr>
                <g:each in="${aliases}" var="alias">
                  <th>${alias}</th>
                </g:each>
              </tr>
              <g:each in="${data}" var="data_row">
                <tr>
                <g:if test="${(data_row instanceof Object[])}">
                  <g:each in="${data_row}" var="data_item">
                    <td>${data_item}</td>
                  </g:each>
                </g:if>
                <g:else>
                  <td>${data_row}</td>
                </g:else>
                </tr>
              </g:each>
            </table>
          </div>
		</div>
	  </div>
	  <div class="row">
		<div class="col s12">
		  <g:if test="${data && data.size() > 0}" >
	        <div class="pagination">
			  <g:paginate action="run" controller="simpleReporting" params="${params}" next="chevron_right" prev="chevron_left" max="${max}" total="${num_results}" class="showme" />
		    </div>
		  </g:if>
		</div>
      </div>
    </g:form>
  </body>
</html>
