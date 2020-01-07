//
//  City.swift
//  Le
//
//  Created by 2Base MacBook Pro on 14/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class City: NSObject {

    var city_id:NSInteger!
    var city_name:String!
    
    init(City: NSDictionary) {
        
        self.city_id = City["city_id"] as! NSInteger
        self.city_name = City["city_name"] as? String
    }
}
