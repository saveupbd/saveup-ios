//
//  NearMe.swift
//  Le
//
//  Created by 2Base MacBook Pro on 06/05/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class NearMe: NSObject {

    var store_id:String!
    var merchant_id:String!
    var store_name:String!
    var deal_count:String?
    var product_count:String!
    var store_img:String!
    var store_latitude:String!
    var store_longitude:String!
    
    init(NearMe: NSDictionary) {

        self.store_id = String(NearMe["store_id"] as! NSInteger)
        self.merchant_id = String(NearMe["merchant_id"] as! NSInteger)
        self.store_name = NearMe["store_name"] as? String
      //  self.deal_count = String(NearMe["deal_count"] as? NSInteger)
        self.deal_count = String(NearMe["deal_count"] as? NSInteger ?? 0)
        self.product_count = String(NearMe["product_count"] as! NSInteger)
        self.store_img = NearMe["store_img"] as? String
        self.store_latitude = NearMe["store_latitude"] as? String
        self.store_longitude = NearMe["store_longitude"] as? String
    }
}
