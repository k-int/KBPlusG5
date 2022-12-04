package com.k_int.kbplus

import java.text.SimpleDateFormat
import java.net.InetAddress;

import org.elasticsearch.client.RestClientBuilder;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.index.IndexResponse;
import org.apache.http.HttpHost;
import static groovy.json.JsonOutput.*;
import org.elasticsearch.action.delete.DeleteRequest;
import org.elasticsearch.action.delete.DeleteResponse;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.action.bulk.BulkRequest;
import org.elasticsearch.action.bulk.BulkResponse;

import org.elasticsearch.client.RequestOptions;
import groovy.util.logging.Slf4j


/**
 * This service insulates KB+ from ES API changes - gather all ES calls in here and proxy them with local interface defintions
 */
@Slf4j
class ESWrapperService {

  static transactional = false

  def grailsApplication

  RestHighLevelClient esclient = null;

  @javax.annotation.PostConstruct
  def init() {
    log.info("init ES wrapper service eshost: ${grailsApplication.config?.eshost ?: 'default to eskbplusg3'}");
  }

  private RestHighLevelClient ensureClient() {

    if ( esclient == null ) {
      def es_host_name = grailsApplication.config?.eshost ?: 'eskbplusg3'

      esclient = new RestHighLevelClient(RestClient.builder( new HttpHost(es_host_name, 9200, "http")));
      log.debug("ES wrapper service init completed OK");
    }

    return esclient
  }

  def index(index,typename,record_id,record) {
    log.debug("index... ${typename},${record_id},...");
    Object result = null;
    try {
      // See https://bigcode.me/elasticsearch/
      IndexRequest request = new IndexRequest(index, '_doc', record_id).source(record);
      IndexResponse response = getClient().index(request);
      result = response.getResult(); 
    }
    catch ( Exception e ) {
      log.error("Error processing ${toJson(record)}",e);
      e.printStackTrace()
    }
    log.debug("Index complete");
    result
  }


  public RestHighLevelClient getClient() {
    return ensureClient()
  }

  @javax.annotation.PreDestroy
  def destroy() {
    log.debug("Destroy");
     if ( esclient ) {
       esclient.close();
     }
  }

  public doDelete(es_index, domain, record_id) {
    log.debug("doDelete(${es_index},${domain},${record_id})");
    // See https://www.elastic.co/guide/en/elasticsearch/client/java-rest/current/_motivations_around_a_new_java_client.html
    DeleteRequest request = new DeleteRequest(es_index, domain, record_id);
    DeleteResponse response = client.delete(request, RequestOptions.DEFAULT); 
  }

  public doIndex(String es_index, 
                 String domain, 
                 String record_id, 
                 Map idx_record) {

    // See also BulkRequest bulk = new BulkRequest()

    log.debug("doIndex(${es_index},${domain},${record_id},...)");

    IndexRequest request = new IndexRequest(es_index,domain,record_id)
    request.source(idx_record)
    IndexResponse response = client.index(request, RequestOptions.DEFAULT);
  }

  public bulkIndex(String es_index,
                   String domain,
                   String record_id,
                   List<Map> idx_records) {

    // See also BulkRequest bulk = new BulkRequest()

    log.debug("doIndex(${es_index},${domain},${record_id},...)");

    BulkRequest bulk_request = new BulkRequest()
    idx_records.each { idx_record ->
      IndexRequest idx_request = new IndexRequest(es_index,domain,record_id)
      idx_request.source(idx_record)
      bulk_request.add(idx_request)
    }

    BulkResponse bulkResponse = client.bulk(bulk_request, RequestOptions.DEFAULT);
  }


}
