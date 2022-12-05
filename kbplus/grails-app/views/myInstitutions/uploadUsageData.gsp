<!doctype html>
<html lang="en" class="no-js">
  <head>
    <parameter name="pagetitle" value="Manual Usage Upload" />
    <parameter name="pagestyle" value="titles" />
    <meta name="layout" content="base"/>
    <title>KB+ Manual Usage Upload</title>
  </head>
  <body class="subscriptions">
    <p>
      Use this form to manually upload usage data. The file MUST be a tab separated. You can export a tab separated file from excel by using the Export option and 
      changing the file-type to tab-delimted. The TSV file must contain the following columns:
    </p>
    <div class="container">
      <div class="row">
        <div class="col s6">
          <table class="table table-bordered table-striped">
            <thead>
              <tr>
                <th>Column Name</th>
                <th>Type</th>
                <th>Mandatory</th>
                <th>Notes/Examples</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>usage.type</td>
                <td>String</td>
                <td>Yes</td>
                <td>The type of usage statistic - currently one of: JUSP:JR1, JUSP:JR1a, JUSP:JR1-JR1a, JUSP:JR1GOA</td>
              </tr>
              <tr>
                <td>title.[_id, issn, isbn,...]</td>
                <td>String</td>
                <td>Yes</td>
                <td>A column that identifies the title. If known, you should use the KB+ internal title id and specify title._id. You may, however, use title.issn if you know the issn, or title.juspid if you know the title Jusp ID AND that ID has been set in KB+.</td>
              </tr>
              <tr>
                <td>supplier.[_id, juspsid]</td>
                <td>String</td>
                <td>Yes</td>
                <td>The ID of the organisation acting as a supplier - use the internal KB+ id, or the jusp supplier id code. For example if the column is supplier.juspsid then the value 18 would be used for suppplier. If you wanted to use supplier._id then the internal KB+ ID for wiley is 37 </td>
              </tr>
              <tr>
                <td>institution.[_id,jusplogin,shortcode]</td>
                <td>String</td>
                <td>Yes</td>
                <td>The ID of the institution. You must have rights to upload data for any ID used. To upload data for De Montfort University you could use institution._id with a value of 409, or institution.jusplogin with a value of "dmu", or institution.shortcode with a value of "De_Montfort_University"</td>
              </tr>
              <tr>
                <td>reportingYear</td>
                <td>Integer</td>
                <td>Yes</td>
                <td></td>
              </tr>
              <tr>
                <td>reportingMonth</td>
                <td>Integer</td>
                <td>Yes</td>
                <td>The usage value</td>
              </tr>
    
              <tr>
                <td>usage</td>
                <td>Integer</td>
                <td>Yes</td>
                <td>The usage value</td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="col s6">
          <g:form class="container" action="uploadUsageData">
            <div class="row admin-form">
              <div class="input-field col s12">
                <input id="usageDataFile" type="file"  class="form-control" name="usageDataFile"/>
                <label for="usageDataFile">TSV Usage Data File</label>
              </div>
              <div class="input-field col s12">
                <button type="submit" value="Upload" class="waves-effect waves-light btn">Upload</button>
              </div>
            </div>
          </g:form>
        </div>
      </div>
    </div>
  </body>
</html>
