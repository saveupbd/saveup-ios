//
//  CartDetails.swift
//  Le
//
//  Created by 2Base MacBook Pro on 18/05/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class CartDetails: NSObject {

    var cart_image:String!
    var cart_title:String!
    var cart_order_date:String!
    
    init(CartDetails: NSDictionary) {
        
        self.cart_image = CartDetails["cart_image"] as? String
        self.cart_title = CartDetails["cart_title"] as? String
        self.cart_order_date = CartDetails["cart_order_date"] as? String
    }
}
