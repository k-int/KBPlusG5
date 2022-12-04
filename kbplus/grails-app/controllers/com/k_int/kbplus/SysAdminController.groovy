package com.k_int.kbplus

import grails.plugin.springsecurity.annotation.Secured
import grails.util.Holders

class SysAdminController {
    def zenDeskSyncService
    def juspSyncService
    def dataloadService

    @Secured(['ROLE_ADMIN','IS_AUTHENTICATED_FULLY'])
    def appConfig() {
        def result = [:]
        //SystemAdmin should only be created once in BootStrap
        result.adminObj = SystemAdmin.list().first()
        result.editable = true
        if (request.method == "POST") {
            result.adminObj.refresh()
        }
        result.currentconf = grails.util.Holders.config
        result
    }

    @Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
    def appInfo() {

        def result = [:]

        result.juspSyncService=[:]
        result.dataloadService=[:]
        result.juspSyncService.running=juspSyncService.running

        result.juspSyncService.submitCount=juspSyncService.submitCount
        result.juspSyncService.completedCount=juspSyncService.completedCount
        result.juspSyncService.newFactCount=juspSyncService.newFactCount
        result.juspSyncService.totalTime=juspSyncService.totalTime
        result.juspSyncService.threads=juspSyncService.FIXED_THREAD_POOL_SIZE
        result.juspSyncService.queryTime=juspSyncService.queryTime
        result.juspSyncService.activityHistogram=juspSyncService.activityHistogram
        result.juspSyncService.syncStartTime=juspSyncService.syncStartTime
        result.juspSyncService.syncElapsed=juspSyncService.syncElapsed
        result.dataloadService.update_running=dataloadService.update_running
        result.dataloadService.lastIndexUpdate = dataloadService.lastIndexUpdate
        result;
    }
    @Secured(['ROLE_ADMIN','IS_AUTHENTICATED_FULLY'])
    def logViewer(){
		
		def logWatchFile
		
		def base = System.getProperty("catalina.base")
		
		if (base) {
			logWatchFile = new File ("${base}/logs/catalina.out")
		 
			if (!logWatchFile.exists()) {
		 
			  // Need to create one in current context.
			  base = false;
			}
		 }
		 
		 if (!base) {
		   logWatchFile = new File("logs/kbplus.log")
		 }
		
        def f = new File (logWatchFile.canonicalPath)

        return [file: "${f.canonicalPath}"]
    }
}
