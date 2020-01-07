//
//  FiftyPercent.swift
//  Le
//
//  Created by 2Base MacBook Pro on 16/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class FiftyPercent: NSObject {

    var product_id:String!
    var product_title:String!
    var product_price:String!
    var product_percentage:String!
    var product_image:String!
    var currency_symbol:String!
    var product_discount_price:String!
    var merchant_name:String!
    
    init(FiftyPercent: NSDictionary) {
        
        self.product_id = String(FiftyPercent["product_id"] as! NSInteger)
        self.product_title = FiftyPercent["product_title"] as? String
        self.product_price = String(FiftyPercent["product_price"] as! Double)
        self.product_percentage = String(FiftyPercent["product_percentage"] as! NSInteger)
        self.product_image = FiftyPercent["product_image"] as? String
        self.currency_symbol = FiftyPercent["currency_symbol"] as? String
        self.product_discount_price = String(FiftyPercent["product_discount_price"] as! NSInteger)
        self.merchant_name = FiftyPercent["merchant_name"] as? String
    }
}
