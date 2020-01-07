//
//  Deals.swift
//  Le
//
//  Created by 2Base MacBook Pro on 19/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class Deals: NSObject {

    var deal_id:String!
    var deal_title:String!
    var deal_original_price:String!
    var deal_discount_price:String!
    var deal_discount_percentage:String!
    var deal_image:String!
    var deal_currency_symbol:String!
    var ios_deal_end_date:String!
    
    init(Deals: NSDictionary) {
        
        self.deal_id = String(Deals["deal_id"] as! NSInteger)
        self.deal_title = Deals["deal_title"] as? String
        self.deal_original_price = String(Deals["deal_original_price"] as! NSInteger)
        self.deal_discount_price = String(Deals["deal_discount_price"] as! NSInteger)
        self.deal_discount_percentage = String(Deals["deal_discount_percentage"] as! NSInteger)
        self.deal_image = Deals["deal_image"] as? String
        self.deal_currency_symbol = Deals["deal_currency_symbol"] as? String
        self.ios_deal_end_date = Deals["ios_deal_end_date"] as? String
    }
}
