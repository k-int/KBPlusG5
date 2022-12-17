package kbplus

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.*
import spock.lang.*
import geb.spock.*

/**
 * See http://www.gebish.org/manual/current/ for more instructions
 */
@Integration
@Rollback
class PublichomeSpec extends GebSpec {

    def setup() {
    }

    def cleanup() {
    }

    void "Check Public Home Page Renders OK"() {
        when:"User visits /"
            go '/'
            report "Check Public home page title is \"Knowledge Base+\""

        then:"The title is \"Knowledge Base+\""
        	title == "Knowledge Base+"
    
    }
}
