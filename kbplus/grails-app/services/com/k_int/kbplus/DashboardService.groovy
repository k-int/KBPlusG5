package com.k_int.kbplus

import grails.plugin.cache.*

import groovy.util.logging.Slf4j

@Slf4j
class DashboardService {

  private static String TITLE_COUNT_QRY='''
select count(t.id) from TitleInstance as t 
where exists ( 
  select ie from IssueEntitlement as ie 
   where ie.tipp.title = t 
     AND ( exists ( select o from ie.subscription.orgRelations as o where o.roleType.value = 'Subscriber' and o.org = :org ) )
     AND ( ie.subscription.status.value != 'Deleted' ) )
'''
  
  @Cacheable(value="SubCount", key={inst.id.toString()} )
  def getSubCount(Org inst) {
    log.debug("New subscription count for ${inst.name} with id:${inst.id}")
    def subCount = Subscription.executeQuery("select count(s.id) from Subscription as s where ( ( exists ( select o from s.orgRelations as o where o.roleType.value = 'Subscriber' and o.org = :org ) ) ) AND ( s.status.value != 'Deleted' )",[org:inst])[0];
    
    return subCount
  }
  
  @CacheEvict(value="SubCount", key={inst.id.toString()} )
  def clearSubCount(Org inst) {
    log.debug("Remove cached number of Subscriptions for ${inst.name} with id:${inst.id}")
    
    return
  }
  
  @Cacheable(value="LicenceCount", key={inst.id.toString()})
  def getLicenceCount(Org inst) {
    log.debug("New licence count for ${inst.name} with id:${inst.id}")
    def licensee_role = RefdataCategory.lookupOrCreate('Organisational Role', 'Licensee');
    def licence_status = RefdataCategory.lookupOrCreate('License Status', 'Deleted')
    
    def licCount = License.executeQuery("select count(l.id) from License as l where exists ( select ol from OrgRole as ol where ol.lic = l AND ol.org = :lic_org and ol.roleType = :org_role ) AND (l.status!=:lic_status or l.status=null ) ",[lic_org:inst, org_role:licensee_role,lic_status:licence_status])[0];
    
    return licCount
  }
  
  @CacheEvict(value="LicenceCount", key={inst.id.toString()})
  def clearLicenceCount(Org inst) {
    log.debug("Remove cached number of licences for ${inst.name} with id:${inst.id}")
    
    return
  }
  
  @Cacheable(value="TitleCount", key={inst.id.toString()})
  def getTitleCount(Org inst) {
    long start_time = System.currentTimeMillis();
    log.debug("New title count for ${inst.name} with id:${inst.id}")
    def titleCount = TitleInstance.executeQuery(TITLE_COUNT_QRY,[org:inst])[0];
    log.debug("getTitleCount completed after ${System.currentTimeMillis()-start_time}ms and returns ${titleCount}");
    
    return titleCount
  }
  
  @CacheEvict(value="TitleCount", key={inst.id.toString()})
  def clearTitleCount(Org inst) {
    log.debug("Remove cached number of titles for ${inst.name} with id:${inst.id}")
    return
  }

}
