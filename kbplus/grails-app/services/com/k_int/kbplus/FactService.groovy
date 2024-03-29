package com.k_int.kbplus

import groovy.util.logging.Slf4j

@Slf4j
class FactService {

  static transactional = false;

    def registerFact(fact) {
      // log.debug("Enter registerFact");
      def result = false;

      if ( ( fact.type == null ) || 
           ( fact.type == '' ) ) 
        return result;

      try {
          def fact_type_refdata_value = RefdataCategory.lookupOrCreate('FactType',fact.type);

          // Are we updating an existing fact?
          if ( fact.uid != null ) {
            def current_fact = Fact.findByFactUid(fact.uid)

            if ( current_fact == null ) {
              // log.debug("Create new fact..");
              current_fact = new Fact(factType:fact_type_refdata_value, 
                                      factFrom:fact.from,
                                      factTo:fact.to,
                                      factValue:fact.value,
                                      factUid:fact.uid,
                                      relatedTitle:fact.title,
                                      supplier:fact.supplier,
                                      inst:fact.inst,
                                      juspio:fact.juspio,
                                      reportingYear:fact.reportingYear,
                                      reportingMonth:fact.reportingMonth)
              if ( current_fact.save() ) {
                result=true
              }
              else {
                log.error("Problem saving fact: ${current_fact.errors}");
              }
            }
            else {
              log.debug("update existing fact ${current_fact.id} (${fact.uid} ${fact_type_refdata_value})");
            }
          }
      }
      catch ( Exception e ) {
        log.error("Problem registering fact",e);
      }
      finally {
        // log.debug("Leave registerFact");
      }
      return result;
    }


  def generateMonthlyUsageGrid(title_id, org_id, supplier_id) {

    def result=[:]

    if ( title_id != null &&
         org_id != null &&
         supplier_id != null ) {

      def q = "select sum(f.factValue),f.reportingYear,f.reportingMonth,f.factType from Fact as f where f.relatedTitle.id=:rtid and f.supplier.id=:sid and f.inst.id=:oid group by f.factType, f.reportingYear, f.reportingMonth order by f.reportingYear desc,f.reportingMonth desc,f.factType.value desc"
      def l1 = Fact.executeQuery(q,[rtid:title_id, sid:supplier_id, oid:org_id])

      def y_axis_labels = []
      def x_axis_labels = []

      l1.each { f ->
        def y_label = "${f[1]}-${String.format('%02d',f[2])}"
        def x_label = f[3].value
        if ( ! y_axis_labels.contains(y_label) )
          y_axis_labels.add(y_label)
        if ( ! x_axis_labels.contains(x_label) )
          x_axis_labels.add(x_label)
      }

      x_axis_labels.sort();
      y_axis_labels.sort();

      // log.debug("X Labels: ${x_axis_labels}");
      // log.debug("Y Labels: ${y_axis_labels}");

      result.usage = new long[y_axis_labels.size()][x_axis_labels.size()]

      l1.each { f ->
        def y_label = "${f[1]}-${String.format('%02d',f[2])}"
        def x_label = f[3].value
        result.usage[y_axis_labels.indexOf(y_label)][x_axis_labels.indexOf(x_label)] += Long.parseLong(f[0])
      }

      result.x_axis_labels = x_axis_labels;
      result.y_axis_labels = y_axis_labels;
    }
    result
  }

  def generateYearlyUsageGrid(title_id, org_id, supplier_id) {

    def result=[:]

    if ( title_id != null &&
         org_id != null &&
         supplier_id != null ) {

      def q = "select sum(f.factValue),f.reportingYear,f.factType from Fact as f where f.relatedTitle.id=:tid and f.supplier.id=:sid and f.inst.id=:oid group by f.factType, f.reportingYear  order by f.reportingYear,f.factType.value"
      def l1 = Fact.executeQuery(q,[tid:title_id, sid:supplier_id, oid:org_id])

      def y_axis_labels = []
      def x_axis_labels = []

      l1.each { f ->
        def y_label = "${f[1]}"
        def x_label = f[2].value
        if ( ! y_axis_labels.contains(y_label) )
          y_axis_labels.add(y_label)
        if ( ! x_axis_labels.contains(x_label) )
          x_axis_labels.add(x_label)
      }

      x_axis_labels.sort();
      y_axis_labels.sort();

      // log.debug("X Labels: ${x_axis_labels}");
      // log.debug("Y Labels: ${y_axis_labels}");

      result.usage = new long[y_axis_labels.size()][x_axis_labels.size()]

      l1.each { f ->
        def y_label = "${f[1]}"
        def x_label = f[2].value
        result.usage[y_axis_labels.indexOf(y_label)][x_axis_labels.indexOf(x_label)] += Long.parseLong(f[0])
      }

      result.x_axis_labels = x_axis_labels;
      result.y_axis_labels = y_axis_labels;
    }

    result
  }


  /**
   *  Return an array of size n where array[0] = total for year, array[1]=year-1, array[2]=year=2 etc
   *  Array is zero padded for blank years
   */
  def lastNYearsByType(title_id, org_id, supplier_id, report_type, n, year) {

    def result = new String[n+1]

    // def c = new GregorianCalendar()
    // c.setTime(new Date());
    // def current_year = c.get(Calendar.YEAR)

    if ( title_id != null &&
         org_id != null &&
         supplier_id != null ) {

      def q = "select sum(f.factValue),f.reportingYear,f.factType from Fact as f where f.relatedTitle.id=:rid and f.supplier.id=:sid and f.inst.id=:oid and f.factType.value = :rt and f.reportingYear >= :ry group by f.factType, f.reportingYear  order by f.reportingYear desc,f.factType.value"

      def l1 = Fact.executeQuery(q,[rid:title_id, sid:supplier_id, oid:org_id, rt:report_type, ry:(long)(year-n)])

      l1.each{ y ->
        if ( y[1] >= (year - n) ) {
          int idx = year - y[1]
          // log.debug("IDX = ${idx} year = ${y[1]} value=${y[0]}");
          result[idx] = y[0].toString()
        }
      }
    }

    // result.each{r->
    //   log.debug(r)
    // }
    result
  }

  def generateExpandableMonthlyUsageGrid(title_id, org_id, supplier_id) {

    def result=[:]

    if ( title_id != null &&
         org_id != null &&
         supplier_id != null ) {

      def q = "select sum(f.factValue),f.reportingYear,f.reportingMonth,f.factType from Fact as f where f.relatedTitle.id=:t and f.supplier.id=:s and f.inst.id=:i group by f.factType, f.reportingYear, f.reportingMonth order by f.reportingYear desc,f.reportingMonth desc,f.factType.value desc"
      def l1 = Fact.executeQuery(q,[t:title_id, s:supplier_id, i:org_id])

      def y_axis_labels = []
      def x_axis_labels = []

      l1.each { f ->
        def y_label = "${f[1]}-${String.format('%02d',f[2])}"
        def x_label = f[3].value
        if ( ! y_axis_labels.contains(y_label) ) {
          // log.debug("Adding y axis label: ${y_label}");
          y_axis_labels.add(y_label)
        }
        if ( ! x_axis_labels.contains(x_label) ) {
          // log.debug("Adding x axis label: ${x_label}");
          x_axis_labels.add(x_label)
        }
      }

      x_axis_labels.sort();

      // log.debug("X Labels: ${x_axis_labels}");
      // log.debug("Y Labels: ${y_axis_labels}");

      result.usage = new long[y_axis_labels.size()][x_axis_labels.size()]

      l1.each { f ->
        def y_label = "${f[1]}-${String.format('%02d',f[2])}"
        def x_label = f[3].value
        result.usage[y_axis_labels.indexOf(y_label)][x_axis_labels.indexOf(x_label)] += Long.parseLong(f[0])
      }

      result.x_axis_labels = x_axis_labels;
      result.y_axis_labels = y_axis_labels;
    }

    result
  }

}
