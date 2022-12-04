package com.k_int.kbplus

import com.k_int.custprops.PropertyDefinition
import com.k_int.kbplus.abstract_domain.CustomProperty

/**
 * Created by ioannis on 26/06/2014.
 */
class SubscriptionCustomProperty implements CustomProperty {
    static belongsTo = [
            type   : PropertyDefinition,
            owner: Subscription
    ]
}
