<!-- Datepicker via g:kbplusDatePicker taglib, with view in ~/grails-app/views/taglibTemplates/_datepicker.gsp -->
<input placeholder="YYYY-MM-DD"  id="${inputid}" name="${name}" type="text" value="${value?:''}" ${required?'required':''}>
<div class="datepickericon" data-field="${inputid}"><i class="material-icons">event</i></div>
