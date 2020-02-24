//
//  RelatedProducts.swift
//  Le
//
//  Created by 2Base MacBook Pro on 09/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class RelatedProducts: NSObject {

    /*
     "product_id": 111,
     "product_title": "Enjoy a 10% discount on all items at Banglar Thala.",
     "product_price": 1,
     "product_discount_price": 0,
     "product_percentage": 0,
     "product_image": "https://saveupbd.com/storage/products/September2019/34xvkHQJHfN7adzwdstg.jpg",
     "currency_symbol": "৳",
     "currency_code": "BDT",
     "merchant_name": "Hidden Chef"
     */
    
    var product_id:String!
    var product_title:String!
    var product_price:String!
    var product_image:String!
    var currency_symbol:String!
    var merchant_name:String!
    var product_discount_price:String!
    var product_percentage:String!
    var product_type:String!
    var product_off:String!
    init(RelatedProducts: NSDictionary) {
        
        self.product_id = String(RelatedProducts["product_id"] as! NSInteger)
        self.product_title = RelatedProducts["product_title"] as? String
        
        self.product_image = RelatedProducts["product_image"] as? String
        self.currency_symbol = RelatedProducts["currency_symbol"] as? String
        self.merchant_name = RelatedProducts["merchant_name"] as? String
        self.product_type = RelatedProducts["product_type"] as? String
//        if self.product_type != "all_item"  {
//            self.product_price = String(RelatedProducts["product_price"] as! Double)
//            self.product_discount_price = RelatedProducts["product_discount_price"] as? String
//            self.product_percentage = RelatedProducts["product_percentage"] as? String
//        }else{
//            self.product_off = String(RelatedProducts["product_discount"] as! NSInteger)
//        }
        
        if self.product_type != "all_item"{
            if !(RelatedProducts["product_price"] is NSNull){
                self.product_price = String(RelatedProducts["product_price"] as! Double)
            }else{
                self.product_price = "-"
            }
            
            if !(RelatedProducts["product_discount_price"] is NSNull){
                self.product_discount_price = String(RelatedProducts["product_discount_price"] as! NSInteger)
            }else{
                self.product_discount_price = "-"
            }
            
            
            self.product_percentage = String(RelatedProducts["product_percentage"] as! NSInteger)
        }else{
            self.product_off = String(RelatedProducts["product_discount"] as! NSInteger)
        }
        
    }
}
