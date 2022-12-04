package com.k_int.kbplus

import java.util.concurrent.ConcurrentHashMap

import groovy.util.logging.Slf4j

@Slf4j
class ExecutorWrapperService {

	def executorService
	ConcurrentHashMap<Object,java.util.concurrent.FutureTask> activeFuture = [:]

	def processClosure(clos,owner){

    if ( owner) {

      if ( owner.id ) {

    		def owner_oid = "${owner.class.name}:${owner.id}"
    		//see if we got a process running for owner already
	    	def existingFuture = activeFuture.get(owner_oid)
    		if(!existingFuture){
          log.debug("got existing future (${owner_oid})....");
    			//start new thread and store the process
		      def future = executorService.submit(clos as java.lang.Runnable)
		      activeFuture.put(owner_oid,future)
    		}else{
    			//if a previous process for this owner is done, remove it and start new one
          log.debug("Start new future for ${owner_oid}....");
    			if(existingFuture.isDone()){
	    			activeFuture.remove(owner_oid)
    				processClosure(clos,owner)
    			}
	  		//if not done, do something else
    		}
      }
      else {
        throw new RuntimeException("processClosure called with an owner that seems not to be a domain class. ${owner} ${owner.class.name}");
      }
    }
    else {
      throw new RuntimeException("processClosure called null owner");
    }
	}

	def hasRunningProcess(owner){
		owner = "${owner.class.name}:${owner.id}"
		// There is no process running for this owner
		if(activeFuture.get(owner) == null){
			return false
		// there was a process, but now its done.
		}else if(activeFuture.get(owner).isDone()){
			activeFuture.remove(owner)
			return false
		// we have a running process
		}else if(activeFuture.get(owner).isDone() == false){
			return true
		}
	}

  def getActiveFutures() {
    return activeFuture
  }
}

