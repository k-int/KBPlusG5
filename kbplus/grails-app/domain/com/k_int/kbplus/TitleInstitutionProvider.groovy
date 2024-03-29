package com.k_int.kbplus
import javax.persistence.Transient
import groovy.util.logging.Slf4j

@Slf4j
class TitleInstitutionProvider {
  
  static belongsTo = [
                      title: TitleInstance, 
                      institution: Org, 
                      provider: Org]

  static hasMany = [
    coreDates:CoreAssertion
  ]

  static mappedBy = [
    coreDates:'tiinp'
  ]

  static mapping = {
    id column:'tiinp_id'
    title column:'tttnp_title', index:'tiinp_idx'
    institution column:'tttnp_inst_org_fk', index:'tiinp_idx'
    provider column:'tttnp_prov_org_fk', index:'tiinp_idx'
    version column:'title_inst_prov_ver'
  }

  @Transient
  def coreStatus(lookupDate) {
    // log.debug("TitleInstitutionProvider::coreStatus(${lookupDate})")
    if(!coreDates) return null;
    //Should this be here or on a higher level?
    if(lookupDate == null) lookupDate = new Date();
    // log.debug("coreDates: ${coreDates}")
    def isCore = false
    coreDates.each{ coreDate ->
        if(lookupDate > coreDate.startDate){
          if(coreDate.endDate == null) {
            isCore = true
            return true;
          }
          if(coreDate.endDate > lookupDate) {
            isCore = true
            return true;
          }
        }
    }

    return isCore;
  }
  /**
  * 1 DateA After (>) Date B
  * 0 Date A equals Date B 
  * -1 DataA Before(<) DateB
  **/
  @Transient
  def compareDates(dateA, dateB){
    def daysDiff
    def duration
    if(dateA == null && dateB == null) return 0;
    if(dateA== null && dateB != null) return 1;
    if(dateA != null && dateB == null) return -1; 
    use(groovy.time.TimeCategory) {
        duration =  dateA - dateB
        daysDiff = duration.days
    }
    //we accept up to two days difference 
    if(daysDiff >= -1 && daysDiff <= 1 ){
      return 0 ;
    }
    if (daysDiff > 1){
     return 1
    }
    return -1;
  }

  public void extendCoreExtent(java.util.Date givenStartDate, java.util.Date givenEndDate) {
    log.debug("TIP:${this.id} :: extendCoreExtent(${givenStartDate}, ${givenEndDate})");
    // See if we can extend and existing CoreAssertion or create a new one to represent this
    // We soften then edges for extending by a day.
    def startDate = new Date(givenStartDate.getTime())
    def endDate = givenEndDate ? new Date(givenEndDate.getTime()) : null;

    log.debug("For matching purposes, using ${startDate} and ${endDate}");
    
    def cont = true;

    if ( endDate != null ) {
      log.debug("Working with a set endDate")
      // Test 1 : Does the given range fall entirely within an existing assertion?
      coreDates.each {
        if ( compareDates(it.startDate,startDate) <=0 && compareDates(it.endDate,givenEndDate) >=0 ) {
          log.debug("date range is subsumed (${it.startDate} <= ${givenStartDate}) && (${it.endDate} >= ${givenEndDate})  ");
          cont = false;
          return;
        }
      }

      if ( cont ) {
        // Not fully enclosed - see if we are extending (Backwards or forewards) any existing 
        coreDates.each {
          // Given range overlaps end date of existing statement
          if ( compareDates(it.startDate,startDate) <= 0  && compareDates(it.endDate,startDate) >=0 ) {
            // the start date given falls between the start and end dates of an existing core statement
            // because test 1 did not catch this, the end date must be after the end of this assertion, so we simply extend
            log.debug("Extending end date");
            it.endDate = givenEndDate;
            it.save(flush:true)
            cont=false
            return;
          }
    
          // Given range overlaps start date of existing statement
          if ( compareDates(it.startDate,endDate) <= 0 && compareDates(it.endDate,endDate) >= 0 ) {
            log.debug("Extending start date");
            it.startDate = givenStartDate;
            it.save(flush:true)
            cont=false
            return;
          }
        }  
      }
    }
    else {
      log.debug("Working with an open endDate")

      coreDates.each {
        if ( it.endDate == null ) {
          log.debug("Testing ${it} ")

          if ( compareDates(startDate,it.startDate) == -1 ) {
            log.debug("Open ended core status, with an earlier start date than we had previously")
            it.startDate = startDate
            it.endDate = null
            it.save(flush:true)
          }else{
            log.debug("Open ended core status, with an later start date than we had previously. New date ignored.")
          }
          cont=false

        }
        else {
          if ( compareDates(startDate,it.startDate) == -1 ) {
            log.debug("New coverage start date pushes back a previous one, AND extends the end date to open")
            it.startDate = startDate
            it.endDate = null
            it.save(flush:true)
            cont=false
          }   
          else if(compareDates(startDate,it.endDate) == -1){
            log.debug("New statement opens up end date, but existing start date should stand")
            it.endDate = null
            it.save(flush:true)
            cont=false
          }
        }
      }
    }

    if ( cont ) {
      log.debug("No obvious overlaps -Create new core assertion ${givenStartDate} - ${givenEndDate}");
      System.out.println("No obvious overlaps -Create new core assertion ${givenStartDate} - ${givenEndDate}");
      
      /*AF Note: following two lines commented out as new_core_statement is empty here and remains so,
        hence when the check at line if(it.id != new_core_statement?.id){ in eah closure for coreDates will always
        allow entry inside the if statement which results in the newly added core assertion being deleted as soon as it is created!
        Changed the code around so new_core_statement is created and added to core dates, saved and as a result is populated with an
        id which can be used to check against in above noted if statement, so if the ids match, it cannot go inside if statement,
        and then remove the core assertion we just created.
        Also added some system outs for debugging as log.debug is not showing in console when running in dev mode
      */
      //def new_core_statement = new CoreAssertion()
      //this.addToCoreDates(startDate:givenStartDate, endDate:givenEndDate)
      
      def new_core_statement = new CoreAssertion(startDate:givenStartDate, endDate:givenEndDate)
      this.addToCoreDates(new_core_statement)
      this.save(flush:true, failOnError:true)
      System.out.println("added and saved");
      System.out.println("new core assertion id: " + new_core_statement?.id);
      // See if the new range fully encloses any current assertions
      coreDates.each {
        System.out.println("checking...");
        if(it.id != new_core_statement?.id){
          if ( ( it.startDate >= givenStartDate ) && ( it.endDate ) && ( it.endDate <= givenEndDate ) ) {
            log.debug("Encloses current assertion: ${it}. Remove it");
            System.out.println("Encloses current assertion: ${it}. Remove it");
            
            //AF Note: This has been commented out as it was causing a ConcurrentModificationException, replaced with
            //following line below: coreDates-=it
            //coreDates.remove(it);
            
            coreDates-=it
            System.out.println("removed");
            it.delete(flush:true);
            System.out.println("deleted");
          }
        }
      }
    }

  }

  public String getTextSummary() {
    StringWriter result = new StringWriter();
   
    boolean first=true
    coreDates.each { cd ->
      if ( first ) {
        first = false;
      }
      else {
        result.write('; ');
      }
      result.write("from ${cd.startDate?:'OPEN'} to ${cd.endDate?:'OPEN'} ");
    }

    return result.toString();
  }

}
