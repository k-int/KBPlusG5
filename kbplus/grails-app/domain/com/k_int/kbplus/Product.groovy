package com.k_int.kbplus

import java.text.Normalizer
import javax.persistence.Transient

class Product {

	String identifier
	String name
	
	static hasMany = [
		packages: PackageProduct]
	
	static mappedBy = [
		packages: 'product']
	
	static mapping = {
		              id column:'prd_id'
                 version column:'prd_version'
              identifier column:'prd_identifier'
	                name column:'prd_name'
	}
}
