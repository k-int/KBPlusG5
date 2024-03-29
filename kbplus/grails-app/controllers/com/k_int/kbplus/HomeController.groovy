package com.k_int.kbplus

import grails.converters.*
import org.elasticsearch.groovy.common.xcontent.*
import groovy.xml.MarkupBuilder
import grails.plugin.springsecurity.annotation.Secured
import com.k_int.kbplus.auth.*;

class HomeController {

  def springSecurityService
  def ESSearchService
  
 
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def index() { 
    def result = [:]

    log.debug("HomeController::index - ${springSecurityService.principal.id} ${params}");

    result.user = User.get(springSecurityService.principal.id)

    log.debug("User: ${result.user}");

    if ( result.user != null ) {
      if ( params.defaultInstShortcode ) {
        redirect(controller:'myInstitutions', action:'instdash', params:[defaultInstShortcode:params.defaultInstShortcode]);
      }
      else if ( result.user?.defaultDash != null ) {
        redirect(controller:'myInstitutions', action:'instdash', params:[defaultInstShortcode:result.user.defaultDash.shortcode]);
      }
      else {
        log.warn("User does not have a default dash set, and no defaultInstShortcode in params - infer from user affiliation");

        if ( result.user.affiliations.size() == 1 ) {
          def newdef = result.user.affiliations.first().org
          log.debug("But user has only 1 affiliation, so lets use that :: ${newdef}");
          result.user.defaultDash = newdef
          result.user.save(flush:true, failOnError:true);
          redirect(controller:'myInstitutions', action:'instdash', params:[defaultInstShortcode:newdef.shortcode]);
        }
        else {
          log.warn("Unable to infer institution.. Redirect to profile page");
          flash.message="Please select an institution to use as your default home instdash"
          redirect(controller:'profile', action:'index')
        }
      }
    }
    else {
      log.error("Unable to lookup user for principal id :: ${springSecurityService.principal.id}");
    }
  }

  // Normally, we want to redirect the user to their default institutional instdash at login, but
  // If the user has no instdash, or has no affiliations, or has no username, etc, etc, send them
  // to a configure screen that guides the user through the process of setting up.
  def configure() {
    def result = [:]
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def search() { 

    def result = [:]
  
    result.user = springSecurityService.getCurrentUser()
    params.max = result.user.defaultPageSize

    if (springSecurityService.isLoggedIn()) {
      result =  ESSearchService.search(params)     
    }  
    withFormat {
      html {
        render(view:'search',model:result)
      }
      rss {
        renderRSSResponse(result)
      }
      atom {
        renderATOMResponse( result,params.max )
      }
      xml {
        render result as XML
      }
      json {
        render result as JSON
      }
    }
  }

  def renderRSSResponse(results) {

    def output_elements = buildOutputElements(results.hits)

    def writer = new StringWriter()
    def xml = new MarkupBuilder(writer)

    xml.rss(version: '2.0') {
      channel {
        title("KBPlus")
        description("KBPlus")
        "opensearch:totalResults"(results.resultsTotal)
        // "opensearch:startIndex"(results.search_results.results.start)
        "opensearch:itemsPerPage"(10)
        output_elements.each { i ->  // For each record
          entry {
            i.each { tuple ->   // For each tuple in the record
              "${tuple[0]}"("${tuple[1]}")
            }
          }
        }
      }
    }

    render(contentType:"application/rss+xml", text: writer.toString())
  }


  def renderATOMResponse(results,hpp) {

    def writer = new StringWriter()
    def xml = new MarkupBuilder(writer)

    def output_elements = buildOutputElements(results.hits)

    xml.feed(xmlns:'http://www.w3.org/2005/Atom') {
        // add the top level information about this feed.
        title("KBPlus")
        description("KBPlus")
        "opensearch:totalResults"(results.resultsTotal)
        // "opensearch:startIndex"(results.search_results.results.start)
        "opensearch:itemsPerPage"("${hpp}")
        // subtitle("Serving up my content")
        //id("uri:uuid:xxx-xxx-xxx-xxx")
        link(href:"http://a.b.c")
        author {
          name("KBPlus")
        }
        //updated sdf.format(new Date());

        // for each entry we need to create an entry element
        output_elements.each { i ->
          entry {
            i.each { tuple ->
                "${tuple[0]}"("${tuple[1]}")
            }
          }
        }
    }

    render(contentType:'application/xtom+xml', text: writer.toString())
  }

  def buildOutputElements(searchresults) {
    // Result is an array of result elements
    def result = []

    searchresults.hits?.each { doc ->
      ////  log.debug("adding ${doc} ${doc.getSource().title}");
      def docinfo = [];

      docinfo.add(['dc.title',doc.getSource().title])
      docinfo.add(['dc.description',doc.getSource().description])
      docinfo.add(['dc.identifier',doc.getSource()._id])
      result.add(docinfo)
    }
    result
  }
}
