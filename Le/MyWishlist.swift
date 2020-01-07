//
//  MyWishlist.swift
//  Le
//
//  Created by 2Base MacBook Pro on 27/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class MyWishlist: NSObject {

    var product_id:Int!
    var product_title:String!
    var product_discount_price:String!
    var product_original_price:String!
    var product_discount_percentage:String!
    var product_image:String!
    var product_currency_symbol:String!
    
    init(MyWishlist: NSDictionary) {
        
        self.product_id = MyWishlist["product_id"] as? Int
        self.product_title = MyWishlist["product_title"] as? String
        self.product_discount_price = String(MyWishlist["product_discount_price"] as! NSInteger)
        self.product_original_price = String(MyWishlist["product_original_price"] as! NSInteger)
        self.product_discount_percentage = MyWishlist["product_discount_percentage"] as? String ?? "0"
        self.product_image = MyWishlist["product_image"] as? String
        self.product_currency_symbol = MyWishlist["product_currency_symbol"] as? String
    }
}
