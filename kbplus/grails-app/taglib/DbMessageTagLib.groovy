import com.k_int.kbplus.*


import org.springframework.web.servlet.support.RequestContextUtils as RCU

class DbMessageTagLib {

  def messageService
  def messageSource 

  def dbContent = { attrs, body ->
    def locale = RCU.getLocale(request)
    out << messageService.getMessage(attrs.key, locale?.toString())
  }

  def kiMessage = { attrs, body ->
    def locale = RCU.getLocale(request)
    out << messageSource.getMessage(attrs.code, attrs.args, attrs.code, locale)
    out << '<a href="http://wibble">*</a>'
  }

  def localiseBtn = { attrs, body ->
    if ( session.showLocaliseButton?:'N' == 'Y' ) {
      String showLocaliseCmd="alert(\"${attrs.code}\")"
      out << "<b><a onClick=\"${showLocaliseCmd}\">!</a></b>"
    }
  }
}

