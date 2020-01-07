//
//  MyCart.swift
//  Le
//
//  Created by 2Base MacBook Pro on 18/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class MyCart: NSObject {

    var cart_image:String!
    var cart_title:String!
    var cart_currency_symbol:String!
    var cart_price:String!
    var cart_color_details:[NSDictionary]
    var cart_size_details:[NSDictionary]
    var cart_id:String!
    var cart_quantity:NSInteger!
    var product_available_qty:NSInteger!
    var cart_product_id:String!
    
    init(MyCart: NSDictionary) {
        
        self.cart_image = MyCart["cart_image"] as? String
        self.cart_title = MyCart["cart_title"] as? String
        self.cart_currency_symbol = MyCart["cart_currency_symbol"] as? String
        self.cart_price = String(MyCart["cart_price"] as! NSInteger)
        self.cart_color_details = (MyCart.object(forKey: "cart_color_details") as? [NSDictionary])!
        self.cart_size_details = (MyCart.object(forKey: "cart_size_details") as? [NSDictionary])!
        self.cart_id = String(MyCart["cart_id"] as! NSInteger)
        self.cart_quantity = MyCart["cart_quantity"] as! NSInteger
        self.product_available_qty = MyCart["product_available_qty"] as! NSInteger
        self.cart_product_id = String(MyCart["cart_product_id"] as! NSInteger)
    }
}
