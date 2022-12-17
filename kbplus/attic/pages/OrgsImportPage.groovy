package kbplus.pages

class OrgsImportPage extends BasePage {
  static url = "/admin/orgsImport"
  static at = { browser.page.title.startsWith "KB+ Import Organisations" };
  
  static content = {
    uploadOrgs { orgs_file ->
      $('#orgsUploadForm').orgs_file = orgs_file
      $('#uploadOrgsCSV').click()
    }
    alertInfo {
      $('#alert-info').text()
    }
  }
}
