package com.k_int;

import com.k_int.kbplus.*


class DatepickerTagLib {

  def kbplusDatePicker = { attrs, body ->
    out << render(template:"/taglibTemplates/datepicker", model:attrs)
  }
}

