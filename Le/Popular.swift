//
//  Popular.swift
//  Le
//
//  Created by 2Base MacBook Pro on 16/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class Popular: NSObject {

    var product_id:String!
    var product_title:String!
    var product_price:String!
    var product_image:String!
    var currency_symbol:String!
    var product_discount_price:String!
    var product_percentage:String!
    var merchant_name:String!
    
    init(Popular: NSDictionary) {
        
        self.product_id = String(Popular["product_id"] as! NSInteger)
        self.product_title = Popular["product_title"] as? String
        self.product_price = String(Popular["product_price"] as! String)
        self.product_image = Popular["product_image"] as? String
        self.currency_symbol = Popular["currency_symbol"] as? String
        self.product_discount_price = String(Popular["product_discount_price"] as! String)
        self.product_percentage = String(Popular["product_percentage"] as! NSInteger)
        self.merchant_name = Popular["merchant_name"] as? String
    }
}
