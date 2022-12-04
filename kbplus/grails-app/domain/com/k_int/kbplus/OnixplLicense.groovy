package com.k_int.kbplus

import javax.persistence.Transient

import com.k_int.kbplus.auth.Role
import com.k_int.kbplus.onixpl.OnixPLHelperService
import com.k_int.kbplus.onixpl.OnixPLService
import groovy.util.logging.Slf4j

/**
 * An OnixplLicense has many OnixplUsageTerms and OnixplLicenseTexts.
 * It can be associated with many licenses.
 * The OnixplLicenseTexts relation is redundant as UsageTerms refer to the
 * LicenseTexts, but is a convenient way to access the whole license text.
 */

@Slf4j
class OnixplLicense {

  Date lastmod;
  String title;

  // An ONIX-PL license relates to a a doc
  Doc doc;

  // One to many
  static hasMany = [
    licenses: License
  ]

  // Reference to license in the many
  static mappedBy = [
    licenses: 'onixplLicense',
  ]

  static mapping = {
    id column: 'opl_id'
    version column: 'opl_version'
    doc column: 'opl_doc_fk'
    lastmod column: 'opl_lastmod'
    title column: 'opl_title'
  }

  static constraints = {
    doc(nullable: false, blank: false)
    lastmod(nullable: true, blank: true)
    title(nullable: false, blank: false)
  }

  // Only admin has permission to change ONIX-PL licenses;
  // anyone can view them.
  def hasPerm(perm, user) {
    if (perm == 'view') return true;
    // If user is a member of admin role, they can do anything.
    def admin_role = Role.findByAuthority('ROLE_ADMIN');
    if (admin_role) return user.getAuthorities().contains(admin_role);
    false;
  }


  @Override
  public java.lang.String toString() {
    return "OnixplLicense{" +
        "id=" + id +
        ", lastmod=" + lastmod +
        ", title='" + title + '\'' +
        ", doc=" + doc +
        '}';
  }

  static def refdataFind(params) {
      def result = []
      def  ql = findAllByTitleIlike(params.q,params)
      // def ql = OnixplLicense.executeQuery('Select l from OnixplLicense as l where lower(l.title) like :t',[t:params.q?.toLowerCase()],params);
      if ( ql ) {
          ql.each { prop ->
              result.add([id:"${prop.title}||${prop.id}",text:"${prop.title}"])
          }
      }
      result
  }
}
