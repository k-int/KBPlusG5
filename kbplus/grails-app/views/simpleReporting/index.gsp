<!doctype html>
<html>
  <head>
    <meta name="layout" content="base"/>
    <parameter name="pagetitle" value="Simple Reporting::${report_title:'Unnamed Report'}" />
    <title>KB+ Simple Reporting</title>
  </head>
  <body class="admin">
    <div class="row">
      <div class="col s6">
        <h2>Select a query to run</h2>
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Export</th>
              <th>Ref</th>
              <th>Type</th>
              <th>Owner</th>
            </tr>
            <tr>
              <th>Query</th>
            </tr>
          </thead>
          <tbody>
            <g:each in="${queries}" var="qry">
              <tr>
                <td><g:link controller="simpleReporting" action="run" params="${[savedQueryId:qry.id]}">Run #${qry.id} (HTML)</g:link></td>
                <td><g:link controller="simpleReporting" action="run" params="${[savedQueryId:qry.id,format:'csv']}">Export #${qry.id} (CSV)</g:link></td>
                <td><g:if test="${qry.ref!=null}"><g:link controller="simpleReporting" action="run" params="${[savedQueryRef:qry.ref,savedQueryId:qry.id]}">${qry.ref}</g:link></g:if></td>
                <td>${qry.type}</td>
                <td>${qry.owner?.display}</td>
              </tr>
              <tr>
                <td colspan="5">${qry.query}</td>
              </tr>
            </g:each>
          </tbody>
        </table>

      </div>
      <div class="col s6">
        <h2>Or enter a new query</h2>
        <div class="row">
          <g:form controller="simpleReporting" action="run">
            <div class="col s2">
              <div class="md-radio">
                <input id="radio_hql" type="radio" name="queryType" value="hql"><label for="radio_hql">HQL</label>
              </div>
              <div class="md-radio">
                <input id="radio_sql" type="radio" name="queryType" value="sql" checked="checked"><label for="radio_sql">SQL</label>
              </div>
            </div>
            <div class="col s10">
              <textarea name="query" rows="15">${params.query}</textarea>
              <button name="RunButton" type="submit" value="Go" class="waves-effect waves-light btn">Run Query</button>
            </div>
          </g:form>
        </div>
        <div class="row">
          <div class="col s12">
            <ul>
              <li>
                <h3>SQL - duplicate titles
                <pre>
select dt.ti_id TitleId, dt.ti_title Title, tis.ids TitleIds
from duplicate_titles dt, title_identifiers tis 
where tis.ti_id = dt.ti_id
                </pre>
              <li>
            <ul>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
