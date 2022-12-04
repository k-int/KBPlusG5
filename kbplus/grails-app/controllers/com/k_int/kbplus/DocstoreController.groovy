package com.k_int.kbplus

import grails.converters.*
import grails.plugin.springsecurity.annotation.Secured

import org.apache.poi.hslf.model.*
import org.apache.poi.hssf.usermodel.*
import org.apache.poi.ss.usermodel.*
import org.elasticsearch.groovy.common.xcontent.*

import com.k_int.kbplus.auth.*

class DocstoreController {

  def docstoreService

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def index() { 
    def doc = Doc.findByUuid(params.id);
    if ( doc ) {
      switch ( doc.contentType ) {
        case 0:
          break;
        case 3:
          docstoreService.streamDocResponse(response,doc)
          break;
        default:
          break;
      }
    }
  }
}
