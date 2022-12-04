package com.k_int.kbplus

import grails.plugin.cache.CacheEvict
import grails.plugin.cache.Cacheable
import grails.plugin.cache.CachePut
import groovy.util.logging.Slf4j

@Slf4j
class MessageService {

  String getMessage(String key, String locale) {
    String result = internalGetMessage(key,locale);
    if ( result == null ) {
      result=internalGetMessage(key)
    }

    if ( result == null )
      result = "No value currently available for key ${key}(${locale}). Please set in Admin -> Manage Content Items"

    return result;
  }

  String getMessage(String key) {
    result=internalGetMessage(key)
    return result;
  }

  @Cacheable(value='message', key={key+locale})
  String internalGetMessage(String key,String locale) {
    log.debug("getMessage(${key},${locale})");
    def ci=ContentItem.findByKeyAndLocale(key,locale)
    if ( ci != null ) {
      return ci.content
    }

    // If we didn't find a locale specific string, try and return the default no-locale string
    // return getMessage(key)
    return null
  }

  @Cacheable(value='message', key={key})
  String internalGetMessage(String key) {
    log.debug("getMessage(${key})");
    def ci = ContentItem.findByKeyAndLocale(key,'')
    if ( ci != null )
      return ci.content
     
    return null
  }

  @CachePut(value='message', key={key+locale})
  String update(String key,String locale) {
    log.debug("getMessage(${key},${locale})");
    def ci=ContentItem.findByKeyAndLocale(key,locale)
    if ( ci != null ) {
	  clearMessages(key+locale)
      return ci.content
    }

    // If we didn't find a locale specific string, try and return the default no-locale string
	clearMessages(key)
    return getMessage(key)
  }
  
  @CacheEvict(value='message', key={key})
  def clearMessages(String key) {
	log.debug("Removed cache of ${key}")
	return
  }
}
