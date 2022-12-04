package com.k_int.utils;

import java.util.Map;
import java.text.SimpleDateFormat;


public class FuzzyDateParser {

  private List default_possible_date_formats = [
    [regexp:'[0-9]{2}/[0-9]{2}/[0-9]{4}', format: new SimpleDateFormat('dd/MM/yyyy')],
    [regexp:'[0-9]{4}/[0-9]{2}/[0-9]{2}', format: new SimpleDateFormat('yyyy/MM/dd')],
    [regexp:'[0-9]{4}-[0-9]{2}-[0-9]{2}', format: new SimpleDateFormat('yyyy-MM-dd')],
    [regexp:'[0-9]{2}/[0-9]{2}/[0-9]{2}', format: new SimpleDateFormat('dd/MM/yy')],
    [regexp:'[0-9]{4}/[0-9]{2}', format: new SimpleDateFormat('yyyy/MM')],
    [regexp:'[0-9]{4}', format: new SimpleDateFormat('yyyy')]
  ];
  
  public Date parseDate(String datestr) {
    return parseDate(datestr, default_possible_date_formats);
  }

  public Date parseDate(String datestr, List possible_formats) {
    Date parsed_date = null;
    for(Iterator i = possible_formats.iterator(); ( i.hasNext() && ( parsed_date == null ) ); ) {
      try {
        def date_format_info = i.next();

        if ( datestr ==~ date_format_info.regexp ) {
          def formatter = date_format_info.format
          parsed_date = formatter.parse(datestr);
          java.util.Calendar c = new java.util.GregorianCalendar();
          c.setTime(parsed_date)
          if ( ( 0 <= c.get(java.util.Calendar.MONTH) ) && ( c.get(java.util.Calendar.MONTH) <= 11 ) ) {
            // Month is valid
          }
          else {
            // Invalid date
            parsed_date = null
          }
        }
      }
      catch ( Exception e ) {
      }
    }
    parsed_date
  }

}
