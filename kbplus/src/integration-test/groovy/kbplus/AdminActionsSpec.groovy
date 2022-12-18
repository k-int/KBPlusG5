package kbplus

import kbplus.pages.DashboardPage;
import kbplus.pages.LogInPage;
import kbplus.pages.OrgsImportPage;
import kbplus.pages.ProfilePage;
import kbplus.pages.PublicPage;
import grails.testing.mixin.integration.Integration
import spock.lang.*
import geb.spock.*
// import grails.plugins.rest.client.RestBuilder
// import com.jayway.restassured.RestAssured
import org.apache.http.HttpStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import grails.gorm.transactions.*

/**
 * See http://www.gebish.org/manual/current/ for more instructions
 */
@Integration
@Rollback
class AdminActionsSpec extends GebSpec {

  final static Logger logger = LoggerFactory.getLogger(AdminActionsSpec.class);


    
    def setup() {
      // RestAssured.port = 8080
    }

    def cleanup() {
    }

    void "login as admin"() {
    setup:
      to PublicPage
      
    when:
      loginLink()

      at LogInPage
      
      login('admin', 'admin')

    then:
      if (title) {
        println title
      }
      else {
        println 'No values found for title'
      }
      at ProfilePage
    }
  
  void "Orgs import upload"() {

    logger.info("Orgs import upload");
    
    when:
      logger.info("Navigate to orgs import page");
      to OrgsImportPage

      logger.info("Get path for orgs file");
      ClassLoader classLoader = this.getClass().getClassLoader();
      File orgs_file = new File(classLoader.getResource('orgs1.csv').getFile())

      // File orgs_file = new File('src/test/resources/orgs1.csv')
      if ( orgs_file != null ) {
        String absolute_path = orgs_file.getAbsolutePath();
        logger.debug("Attempt to load orgs from ${absolute_path}");
        uploadOrgs(absolute_path)
      }
      else {
        logger.warn("Unable to get a handle to orgs import file");
        throw new RuntimeException("Unable to get hold of orgs import file");
      }
    
    then:
      logger.debug("Test result");
      at OrgsImportPage
      alertInfo() == 'CSV of Orgs Successfully loaded'
  }
  
  void "Orgs import upload fails"() {

    logger.info("Orgs import upload (Invalid file)");
    
    when:
      to OrgsImportPage
    
      uploadOrgs(new File('src/test/resources/subscribing organisations.csv').getAbsolutePath())
  
    then:
      at OrgsImportPage
      alertInfo() == 'Incorrect number of columns in import csv'
  }

  void "Trigger Index update for Orgs"() {

    logger.info("ES update");

    when: "Request index update"
      go "/admin/esIndexUpdate"
    
    then: "Server responds OK"
      // resp.status == OK.value()
      //  resp.json.size() == 0
      1==1

  }

  /*
   RestBuilder restBuilder() {
        new RestBuilder()
    }
  */



  // https://stackoverflow.com/questions/36719439/rest-assured-with-spock-and-groovy-as-integration-test
  // void "Create Subscription API works"() {
  //  given:
  //    def request = given()
  //      .accept(JSON)
  //      .contentType("application/json")
  //      .body('{"name":"value"}')
  //      .log().all()
  //      // .auth().oauth2(getToken(accessor.name))
  //  when:
  //    def response = request.with().post("/api/createSubscription")
  //  then:
  //    response.then().log().all()
  //      .statusCode(status)
  //  where:
  //    accessor                                    || status       || specification
  //    [name: 'admin-login', role: 'super admin']  || HttpStatus.SC_OK        || 'none'
  //
  //}

}
