//
//  RelatedDeals.swift
//  Le
//
//  Created by 2Base MacBook Pro on 19/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class RelatedDeals: NSObject {

    var deal_id:String!
    var deal_title:String!
    var deal_discount_price:String!
    var deal_image:String!
    var deal_currency_symbol:String!
    
    init(RelatedDeals: NSDictionary) {
        
        self.deal_id = String(RelatedDeals["deal_id"] as! NSInteger)
        self.deal_title = RelatedDeals["deal_title"] as? String
        self.deal_discount_price = String(RelatedDeals["deal_discount_price"] as! NSInteger)
        self.deal_image = RelatedDeals["deal_image"] as? String
        self.deal_currency_symbol = RelatedDeals["deal_currency_symbol"] as? String
    }
}
