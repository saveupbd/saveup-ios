//
//  Stores.swift
//  Le
//
//  Created by 2Base MacBook Pro on 26/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class Stores: NSObject {

    var store_id:String!
    var store_name:String!
    var deal_count:String!
    var product_count:String!
    var store_img:String!
    
    init(Stores: NSDictionary) {
        
        self.store_id = String(Stores["store_id"] as! NSInteger)
        self.store_name = Stores["store_name"] as? String
        self.deal_count = String(Stores["deal_count"] as! NSInteger)
        self.product_count = String(Stores["product_count"] as! NSInteger)
        self.store_img = Stores["store_img"] as? String
    }
}
