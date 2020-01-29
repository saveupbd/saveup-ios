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
    var product_type:String!
    var product_off:String!
    
    init(FiftyPercent: NSDictionary) {
        
        self.product_id = String(FiftyPercent["product_id"] as! NSInteger)
        self.product_title = FiftyPercent["product_title"] as? String
        self.product_type = FiftyPercent["product_type"] as? String
        
        if self.product_type != "all_item"  {
            self.product_price = String(FiftyPercent["product_price"] as! Double)
            self.product_discount_price = String(FiftyPercent["product_discount_price"] as! NSInteger)
            self.product_percentage = String(FiftyPercent["product_percentage"] as! NSInteger)
        }else{
            self.product_off = String(FiftyPercent["product_discount"] as! NSInteger)
        }
        
        
        self.product_image = FiftyPercent["product_image"] as? String
        self.currency_symbol = FiftyPercent["currency_symbol"] as? String
        
        self.merchant_name = FiftyPercent["merchant_name"] as? String
    }
}
