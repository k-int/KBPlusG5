package com.k_int

import org.grails.orm.hibernate.cfg.GrailsHibernateUtil

class ClassUtils {
  public static <T> T deproxy(def element) {
    GrailsHibernateUtil.unwrapIfProxy(element)
//    if (element instanceof HibernateProxy) {
//      return (T) ((HibernateProxy) element).getHibernateLazyInitializer().getImplementation();
//    }
//    return (T) element;
  }
}
