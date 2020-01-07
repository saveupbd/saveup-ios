//
//  OrdersCOD.swift
//  Le
//
//  Created by MUNESAN on 17/01/18.
//  Copyright © 2018 Munesan M. All rights reserved.
//

import UIKit

class OrdersCOD: NSObject {

    var order_id:String!
    var order_title:String!
    var order_date:String!
    var order_status:String!
    var payment_status:String!
    var currency_symbol:String!
   // var order_total:String!
     var order_total:String!
    var image:String!
    var orderDate : Date
    var shipping_name:String!
    var merchant_name:String!
    var coupon_code:String!
    var is_redeem:String!
    var day:String!
    
    init(OrdersCOD: NSDictionary) {//order_total
        
       // self.order_id = OrdersCOD["order_id"] as? Int
        self.order_id = String(OrdersCOD["order_id"] as! NSInteger)
        //self.order_title = OrdersCOD["order_title"] as? String
        self.order_date = OrdersCOD["order_date"] as? String
        //self.order_status = OrdersCOD["order_status"] as? String
        self.payment_status = "0"
        self.currency_symbol = OrdersCOD["currency_symbol"] as? String
        //self.order_total = String((OrdersCOD["order_total"] as? Double)!)//order_amount
       // self.order_total = OrdersCOD["order_total"] as? String
       // self.order_total = String(OrdersCOD["order_total"] as! NSInteger)
         self.order_total = String((OrdersCOD["order_total"] as? Double)!)
        
        if OrdersCOD["product_image"] as? String == nil {
            
            self.image = OrdersCOD["deal_image"] as? String
        }
        else {
            self.image = OrdersCOD["product_image"] as? String
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: (OrdersCOD["order_date"] as? String)!)
        self.orderDate = date! as Date
        
        self.shipping_name = OrdersCOD["shipping_name"] as? String
        self.merchant_name = OrdersCOD["merchant_name"] as? String
        self.coupon_code = OrdersCOD["coupon_code"] as? String
        self.is_redeem = OrdersCOD["is_redeem"] as? String
        self.day = String(OrdersCOD["day"] as! NSInteger)
    }
}
