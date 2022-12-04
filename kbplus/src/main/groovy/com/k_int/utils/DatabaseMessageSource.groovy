package com.k_int.utils;

import com.k_int.kbplus.ContentItem
import org.springframework.context.support.AbstractMessageSource
import java.text.MessageFormat;
import java.util.concurrent.ConcurrentHashMap
import groovy.util.logging.Slf4j

/**
 * @See https://stackoverflow.com/questions/8297505/grails-i18n-from-property-files-backed-up-by-a-db
 */
@Slf4j
class DatabaseMessageSource extends AbstractMessageSource {

  def messageBundleMessageSource
  private static Map message_cache = new ConcurrentHashMap();

  @javax.annotation.PostConstruct
  def init() {
    log.debug("init database message source");
  }

  protected MessageFormat resolveCode(String code, Locale locale) {

    long start_time = System.currentTimeMillis();
    log.debug("DatabaseMessageSource::resolveCode(${code},${locale}})");

    String cache_key = getCacheKey(code, locale)
    MessageFormat format = message_cache.get(cache_key)


    if ( format == null ) {
      try {
        log.debug("No message found in cache for ${code}/${locale} create transaction for lookup");
        ContentItem.withTransaction {
          log.debug("Find by key(${code}) and locale(${locale})");
          ContentItem ci = ContentItem.findByKeyAndLocale(code, locale.toString())
          if ( ci ) {
            log.debug("Create new message with lookup result");
            format = new MessageFormat(ci.content, locale)
          }
          else {
            log.debug("No content item found -- Default message");
            if ( messageBundleMessageSource != null && code != null ) {
              log.debug("Get message from bundle...");
              format = messageBundleMessageSource.resolveCode(code, locale)
            }
            else {
              log.error("messageBundleMessageSource is null");
            }
          }
        }
      }
      catch ( Exception e ) {
        log.error("Problem looking up message ${code}/${locale}")
      }


      if ( format != null ) {
        log.debug("Cache message");
        message_cache.put(cache_key, format);
      }
    }

    long elapsed = System.currentTimeMillis() - start_time;
    log.debug("DatabaseMessageSource::resolveCode. elapsed ${elapsed}");

    return format;
  }
  
  private static String getCacheKey (String code, Locale locale) {
    getCacheKey (code, locale.toString())
  }
  
  private static String getCacheKey (String code, String locale) {
    "${code}:${locale}"
  }
  
  public static void clearCacheEntry ( String code, String locale ) {
    message_cache.remove(getCacheKey(code, locale))
  }
  
  public static void clearCache() {
    message_cache = message_cache.clear()
  }

  public void evictFromCache(String code, Locale locale) {
    String cache_key = code+':'+locale.toString();
    message_cache.remove(cache_key);
  }
}
