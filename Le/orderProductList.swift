//
//  orderProductList.swift
//  Le
//
//  Created by Akramul Haque on 28/3/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit

class orderProductList: NSObject {
    
    var order_id:String!
    var product_title:String!
    var product_image:String!
    var order_qty:String!
    var product_price:String!
    var image:String!

    
    init(orderProductList: NSDictionary) {//order_total
        
        self.order_id = orderProductList["order_id"] as? String
        self.product_title = orderProductList["product_title"] as? String
        if orderProductList["product_image"] as? String != nil {
            
          self.image = orderProductList["product_image"] as? String
        }
        else {
           // self.image = UIImage(named: "no-image-icon")
        }

        self.order_qty = orderProductList["order_qty"] as? String
        self.product_price = orderProductList["product_price"] as? String
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let date = dateFormatter.date(from: (OrdersCOD["order_date"] as? String)!)
//        self.orderDate = date! as Date

    }
}



