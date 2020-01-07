//
//  TopOffers.swift
//  Le
//
//  Created by 2Base MacBook Pro on 16/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class TopOffers: NSObject {

    var product_id:String!
    var product_title:String!
    var product_price:String!
    var product_discount_price:String!
    var product_percentage:String!
    var product_image:String!
    var currency_symbol:String!
    var merchant_name:String!
    
    init(TopOffers: NSDictionary) {
        
        self.product_id = String(TopOffers["product_id"] as! NSInteger)
        self.product_title = TopOffers["product_title"] as? String
        self.product_price = String(TopOffers["product_price"] as! Double)
        self.product_discount_price = String(TopOffers["product_discount_price"] as! NSInteger)
        self.product_percentage = String(TopOffers["product_percentage"] as! NSInteger)
        self.product_image = TopOffers["product_image"] as? String
        self.currency_symbol = TopOffers["currency_symbol"] as? String
        self.merchant_name = TopOffers["merchant_name"] as? String
    }
}
