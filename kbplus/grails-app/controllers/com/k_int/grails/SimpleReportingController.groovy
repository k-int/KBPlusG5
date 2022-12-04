package com.k_int.grails;

import com.k_int.kbplus.auth.*;
import grails.plugin.springsecurity.annotation.Secured
import grails.converters.*
import org.apache.commons.io.FileUtils
import org.hibernate.SQLQuery;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import com.k_int.kbplus.SavedQuery;


public class SimpleReportingController {

  def sessionFactory
  def springSecurityService
  
  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def index() {
    def result=[:]
    result.queries = SavedQuery.list()
    result
  }

  @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
  def run() {
    def result = null;

    log.debug("SimpleReportingController::run ${params}");

    if ( params.SaveButton=='Go' ) {
      log.debug("Save");
      if (params.query && params.queryType) {
        def sq = new SavedQuery(ref:params.queryRef, query:params.query, type:params.queryType, owner:User.get(springSecurityService.principal.id)).save(flush:true, failOnError:true);
        result = runQuery(sq.type, sq.query, params)
      }
      else {
        flash.message = "Saving a query requires a valid query and query type."
      }
    }
    else if ( params.RunButton=='Go' && params.query && ( params.query.trim().length() > 0 ) ) {
      log.debug("Run");
      // If we have been given a query to run, then run that, above all else - the user might have modified it in some way
      result = runQuery(params.queryType, params.query, params)
    }
    else if ( params.savedQueryId ) {
      log.debug("Run by ID");
      def query = SavedQuery.get(params.savedQueryId)
	  if(response.format == "csv") params.max = "250000";
      result = runQuery(query.type, query.query, params)
      result.savedQueryId = params.savedQueryId
    }
    else if ( params.savedQueryRef ) {
      log.debug("Run by Ref");
      def query = SavedQuery.findByRef(params.savedQueryRef)
	  if(response.format == "csv") params.max = "250000";
      result = runQuery(query.type, query.query, params)
      result.savedQueryRef = query.ref
      result.savedQueryId = query.id
    }

	withFormat {
      html {
        result
      }
      csv {
		log.debug("Format: ${response.format}");
		response.contentType = "text/csv"
		response.setHeader("Content-disposition", "attachment; filename=\"export_query_${result.savedQueryId}.csv\"")
		render(template: 'report_csv', model:result, contentType: "text/csv", encoding: "UTF-8")
	  }
	}
  }


  private Map runQuery(String query_type,
                       String query,
                       Map param_map) {

    def result = null;

    if ( query_type.equals('sql') ) {
      result = runSql(query, param_map)
    }
    else if ( query_type.equals('hql') ) {
      result = runHql(query, param_map)
    }
    else {
      result=[message:"Unhandled query type ${query_type}"]
      flash.message = "A query type is required."
      log.error(result.message)
    }
	
    return result
  }

  private Map runSql(String query, Map params) {
    log.debug("runSql(${query},${params}");
    def result = [:]
	
    Session session = sessionFactory.currentSession
    Transaction tx = session.beginTransaction();
	
	result.user = User.get(springSecurityService.principal.id)
    result.max = params.max ? Integer.parseInt(params.max) : (int)result.user.defaultPageSize;
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;
	
    SQLQuery sql_query = session.createSQLQuery(query);
	result.num_results = sql_query.list().size();
    // set parameter values, e.g.
    // query.setString("name", "Matthias");
    sql_query.setFirstResult(result.offset);
    sql_query.setMaxResults(result.max);
    sql_query.setProperties(params)
	
    result.aliases = []; // sql_query.getReturnAliases()
    result.query_text = query
    result.query_type = 'sql'
    result.data = sql_query.list();
	
    tx.commit();

    return result;
  }

  private Map runHql(String query, Map params) {
    log.debug("runHql(${query},${params}");
    def result = [:]

    Session session = sessionFactory.currentSession
    Transaction tx = session.beginTransaction();
	
	result.user = User.get(springSecurityService.principal.id)
    result.max = params.max ? Integer.parseInt(params.max) : (int)result.user.defaultPageSize;
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;

    Query hql_query = session.createQuery(query);
	result.num_results = hql_query.list().size();
    // set parameter values, e.g.
    // query.setString("name", "Matthias");
    hql_query.setFirstResult(result.offset);
    hql_query.setMaxResults(result.max);
    hql_query.setProperties(params)
	
    result.aliases = []; // hql_query.getReturnAliases();
    result.query_text = query
    result.query_type = 'hql'
	result.data = hql_query.list();

    tx.commit();

    return result;
  }
}
