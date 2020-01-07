//
//  Country.swift
//  Le
//
//  Created by 2Base MacBook Pro on 14/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class Country: NSObject {

    var country_id:NSInteger!
    var country_name:String!
    
    init(Country: NSDictionary) {
        
        self.country_id = Country["country_id"] as! NSInteger
        self.country_name = Country["country_name"] as? String
    }
}
