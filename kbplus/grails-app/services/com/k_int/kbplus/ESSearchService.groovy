package com.k_int.kbplus

import org.elasticsearch.client.*
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.search.builder.*;
import org.elasticsearch.action.search.SearchRequestBuilder;
import org.elasticsearch.search.sort.SortOrder;
import org.elasticsearch.search.sort.FieldSortBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import groovy.util.logging.Slf4j



/**
 * See: https://www.elastic.co/guide/en/elasticsearch/client/java-rest/6.5/_changing_the_client_8217_s_initialization_code.html
 */

@Slf4j
class ESSearchService{
  // Map the parameter names we use in the webapp with the ES fields
  def reversemap = ['subject':'subject', 
                    'provider':'provid',
                    'type':'rectype.keyword',
                    'endYear':'endYear.keyword',
                    'startYear':'startYear.keyword',
                    'consortiaName':'consortiaName.keyword',
                    'cpname':'cpname.keyword',
                    'availableToOrgs':'availableToOrgs',
                    'isPublic':'isPublic',
                    'lastModified':'lastModified']

  def ESWrapperService
  def grailsApplication
  String es_index;

  @javax.annotation.PostConstruct
  def init () {
    log.debug("ESSearchService::init");
    es_index= grailsApplication.config.aggr_es_index ?: 'kbplus'
  }


  def search(params){
    search(params,reversemap)
  }

  def search(params, field_map){
    def result = [:]

    RestHighLevelClient esclient = ESWrapperService.getClient()

    try {
      def es_index = grailsApplication.config.aggr_es_index ?: "kbplus"
      def search_results = null

      if ( (params.q && params.q.length() > 0) || params.rectype) {

        if ((!params.all) || (!params.all?.equals("yes"))) {
          params.max = Math.min(params.max ? params.int('max') : 15, 100)
        }

        params.offset = params.offset ? params.int('offset') : 0

        def query_str = buildQuery(params,field_map)

        if (params.tempFQ) {
          log.debug("found tempFQ, adding to query string")
          query_str = query_str + " AND ( " + params.tempFQ + " ) "
          params.remove("tempFQ") //remove from GSP access
        }

        log.debug("index:${es_index} query: ${query_str}");

        log.debug("start to build srb with index: " + es_index)
        // SearchRequestBuilder srb = esclient.prepareSearch(es_index)

        SearchRequest sr = new SearchRequest(es_index);
        SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();

        if (params.sort) {
          SortOrder order = SortOrder.ASC
          if (params.order) {
            order = SortOrder.valueOf(params.order?.toUpperCase())
          }
          searchSourceBuilder.sort(params.sort, order);
        }
        log.debug("srb start to add query and aggregration query string is ${query_str}")

        searchSourceBuilder.query(QueryBuilders.queryStringQuery(query_str))//QueryBuilders.wrapperQuery(query_str)

        searchSourceBuilder.aggregation(AggregationBuilders.terms('consortiaName').size(25).field('consortiaName.keyword'))
        searchSourceBuilder.aggregation(AggregationBuilders.terms('cpname').size(25).field('cpname.keyword'))
        searchSourceBuilder.aggregation(AggregationBuilders.terms('type').field('rectype.keyword'))
        searchSourceBuilder.aggregation(AggregationBuilders.terms('startYear').size(25).field('startYear.keyword'))
        searchSourceBuilder.aggregation(AggregationBuilders.terms('endYear').size(25).field('endYear.keyword'))

        searchSourceBuilder.from(params.offset)
        searchSourceBuilder.size(params.max)
         
        // log.debug("finished srb and aggregrations: " + srb)
        // search_results = srb.get()
        sr.source(searchSourceBuilder)

        search_results = esclient.search(sr, RequestOptions.DEFAULT);

        if (search_results) {
          def search_hits = search_results.getHits()
          result.hits = search_hits.getHits()
          result.resultsTotal = search_hits.totalHits
      
          if (search_results.getAggregations()) {
            result.facets = [:]
            search_results.getAggregations().each { entry ->
              log.debug("Aggregation entry ${entry} ${entry.getName()}");
              def facet_values = []
              entry.buckets.each { bucket ->
                bucket.each { bi ->
                  facet_values.add([term:bi.getKey(),display:bi.getKey(),count:bi.getDocCount()])
                }
              }
              result.facets[entry.getName()] = facet_values
            }
          }
        }
        log.debug("finished results facets (${result.resultsTotal})")
      }
      else {
        log.debug("No query.. Show search page")
      }
    }
    catch ( Exception e ) {
      log.error("Problem",e);
    }
    
    result
  }
  def search2(params, field_map){
    log.debug("ESSearchService::search - ${params}")

    def result = [:]

    RestHighLevelClient esclient = ESWrapperService.getClient()
  
    try {
       //  See https://www.elastic.co/guide/en/elasticsearch/client/java-rest/current/_changing_the_application_8217_s_code.html
       SearchRequest searchRequest = new SearchRequest(es_index); 
       SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder(); 
       // searchSourceBuilder.query(QueryBuilders.termQuery("user", "kimchy")); 
       searchSourceBuilder.query(QueryBuilders.matchAllQuery()); 
       searchRequest.source(searchSourceBuilder); 

       // searchSourceBuilder.sort(new ScoreSortBuilder().order(SortOrder.DESC)); 
       // searchSourceBuilder.sort(new FieldSortBuilder("_uid").order(SortOrder.ASC));

       // TermsAggregationBuilder aggregation = AggregationBuilders.terms("by_company").field("company.keyword");
       // aggregation.subAggregation(AggregationBuilders.avg("average_age").field("age"));
       // searchSourceBuilder.aggregation(aggregation);

       SearchResponse searchResponse = esclient.search(searchRequest, RequestOptions.DEFAULT);
    }
    catch ( Exception e ) {
      log.error("Problem",e);
    }
    finally {
    }
    result
  }
  
  def phraseSearch(params){
    phraseSearch(params,reversemap)
  }
  
  def buildQuery(params,field_map) {

    log.debug("BuildQuery... with params ${params}. ReverseMap: ${field_map}");

    StringWriter sw = new StringWriter()

    if ( params?.q != null ){
      sw.write(params.q)
    }
      
    if(params?.rectype){
      if(sw.toString()) sw.write(" AND ");
      sw.write(" rectype.keyword:${params.rectype} ")
    } 

    field_map.each { mapping ->

      if ( params[mapping.key] != null ) {

        if ( params[mapping.key].class == java.util.ArrayList) {
          log.debug("mapping is an arraylist: ${mapping} ${mapping.key} ${params[mapping.key]}")
          if(sw.toString()) sw.write(" AND ");
          sw.write(" ( ( ( NOT _type:\"com.k_int.kbplus.Subscription\" ) AND ( NOT _type:\"com.k_int.kbplus.License\" )) OR ( ")

          params[mapping.key].each { p ->  
            if ( p ) {
                sw.write(mapping.value?.toString())
                sw.write(":".toString())
                sw.write(quoteIfNeeded(p.toString()))
                if(p == params[mapping.key].last()) {
                  sw.write(" ) ) ")
                }else{
                  sw.write(" OR ")
                }
            }
          }
        }
        else {
          // Only add the param if it's length is > 0 or we end up with really ugly URLs
          // II : Changed to only do this if the value is NOT an *

          log.debug("Processing - scalar value : ${params[mapping.key]}");

          try {
            if ( params[mapping.key].length() > 0 && ! ( params[mapping.key].equalsIgnoreCase('*') ) ) {

                if(sw.toString()) sw.write(" AND ");

                sw.write(quoteIfNeeded(mapping.value))
                sw.write(":")

                if(params[mapping.key].startsWith("[") && params[mapping.key].endsWith("]")){
                  sw.write(quoteIfNeeded(params[mapping.key]))
                }else{
                  sw.write(quoteIfNeeded(params[mapping.key]))
                }
            }
          }
          catch ( Exception e ) {
            log.error("Problem procesing mapping, key is ${mapping.key} value is ${params[mapping.key]}",e);
          }
        }
      }
    }

    def result = sw.toString();
    log.debug("Result of buildQuery is ${result}");

    result;
  }

  private String quoteIfNeeded(input_string) {
    def result = input_string
    if ( input_string.contains(' ') ) {
      if ( ! input_string.startsWith('"') ) {
        result = '"'+input_string+'"'
      }
    }
    return result;
  }
}
