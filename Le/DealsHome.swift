//
//  DealsHome.swift
//  Le
//
//  Created by 2Base MacBook Pro on 16/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class DealsHome: NSObject {

    var deal_id:String!
    var deal_image:String!
    var deal_percentage:String!
    var deal_price:String!
    var deal_discount_price:String!
    var currency_symbol:String!
    
    init(DealsHome: NSDictionary) {
        
        self.deal_id = String(DealsHome["deal_id"] as! NSInteger)
        self.deal_image = DealsHome["deal_image"] as? String
        self.deal_percentage = String(DealsHome["deal_percentage"] as! NSInteger)
        self.deal_price = String(DealsHome["deal_price"] as! NSInteger)
        self.deal_discount_price = String(DealsHome["deal_discount_price"] as! NSInteger)
        self.currency_symbol = DealsHome["currency_symbol"] as? String
    }
}
