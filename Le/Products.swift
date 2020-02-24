//
//  Products.swift
//  Le
//
//  Created by 2Base MacBook Pro on 08/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class Products: NSObject {

    var product_id:String!
    var product_title:String!
    var product_price:String!
    var product_discount_price:String!
    var product_percentage:String!
    var product_image:String!
    var currency_symbol:String!
    var is_wishlist:Bool!
    //var category_id:String!
    var merchant_name:String!
    var product_type:String!
    var product_off:String!
    init(Products: NSDictionary) {
        
        self.product_id = String(Products["product_id"] as! NSInteger)
        self.product_title = Products["product_title"] as? String
        self.product_type = Products["product_type"] as? String
        
        if self.product_type != "all_item"{
            if !(Products["product_price"] is NSNull){
                self.product_price = String(Products["product_price"] as! Double)
            }else{
                self.product_price = "-"
            }
            
            if !(Products["product_discount_price"] is NSNull){
                self.product_discount_price = String(Products["product_discount_price"] as! NSInteger)
            }else{
                self.product_discount_price = "-"
            }
            
            
            self.product_percentage = String(Products["product_percentage"] as! NSInteger)
        }else{
            self.product_off = String(Products["product_discount"] as! NSInteger)
        }
        
//
//        if self.product_type != "all_item"  {
//            self.product_price = String(Products["product_price"] as! Double)
//            self.product_discount_price = String(Products["product_discount_price"] as! NSInteger)
//            self.product_percentage = String(Products["product_percentage"] as! NSInteger)
//        }else{
//            self.product_off = String(Products["product_discount"] as! NSInteger)
//        }
        self.product_image = Products["product_image"] as? String
        self.currency_symbol = Products["currency_symbol"] as? String
        self.is_wishlist = Products["is_wishlist"] as! Bool
//        self.category_id = String(Products["category_id"] as! NSInteger)
        self.merchant_name = Products["merchant_name"] as? String
    }
}
