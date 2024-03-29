package com.k_int.kbplus

import com.k_int.kbplus.auth.User
import grails.plugin.springsecurity.annotation.Secured

class OnixplLicenseDetailsController {

    def springSecurityService

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def index() {
        def user = User.get(springSecurityService.principal.id)
        def ghost_licence = OnixplLicense.findByTitle(grails.util.Holders.config.onix_ghost_licence)
        def licences = ghost_licence?[params.id,ghost_licence.id] : params.id
        forward (action:'matrix', params:[Compare:"Compare", id:"compare",compareAll:true,selectedLicences:licences],controller:"onixplLicenseCompare")
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def notes() {
        log.debug("licenseDetails id:${params.id}");
        def user = User.get(springSecurityService.principal.id)
        def onixplLicense = OnixplLicense.get(params.id)
        [onixplLicense: onixplLicense, user: user]
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def documents() {
        log.debug("licenseDetails id:${params.id}");
        def user = User.get(springSecurityService.principal.id)
        def onixplLicense = OnixplLicense.get(params.id)
        [onixplLicense: onixplLicense, user: user]
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def history() {
        log.debug("licenseDetails id:${params.id}");
        def user = User.get(springSecurityService.principal.id)
        def onixplLicense = OnixplLicense.get(params.id)
        def max = params.max ?: 20;
        def offset = params.offset ?: 0;

        def qry_params = [c:onixplLicense.class.name, o:"${onixplLicense.id}"]
        def historyLines = AuditLogEvent.executeQuery("select e from AuditLogEvent as e where className=:c and persistedObjectId=:o order by id desc", qry_params, [max:max, offset:offset]);
        def historyLinesTotal = AuditLogEvent.executeQuery("select count(e.id) from AuditLogEvent as e where className=:c and persistedObjectId=:o",qry_params)[0];
        [onixplLicense: onixplLicense, user: user, max: max, offset: offset, historyLines: historyLines, historyLinesTotal: historyLinesTotal]
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def additionalInfo() {
        def user = User.get(springSecurityService.principal.id)
        def onixplLicense = OnixplLicense.get(params.id)
        [onixplLicense: onixplLicense, user: user]
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [onixplLicenseInstanceList: OnixplLicense.list(params), onixplLicenseInstanceTotal: OnixplLicense.count()]
    }
}
