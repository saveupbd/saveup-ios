//
//  OrdersPaypal.swift
//  Le
//
//  Created by MUNESAN on 17/01/18.
//  Copyright © 2018 Munesan M. All rights reserved.
//

import UIKit

class OrdersPaypal: NSObject {

    var order_id:String!
    var order_title:String!
    var order_date:String!
    var order_status:String!
    var payment_status:String!
    var currency_symbol:String!
    var order_total:String!
    var image:String!
    var orderDate : Date
    var shipping_name:String!
    var merchant_name:String!
    var coupon_code:String!
    var is_redeem:String!
    var day:String!
    
    init(OrdersPaypal: NSDictionary) {
        
//        self.order_id = OrdersPaypal["order_id"] as? Int
        self.order_id = String(OrdersPaypal["order_id"] as! NSInteger)
        self.order_title = OrdersPaypal["order_title"] as? String
        self.order_date = OrdersPaypal["order_date"] as? String
        self.order_status = OrdersPaypal["order_status"] as? String
        self.payment_status = "0"
       // self.product_currency_symbol = OrdersPaypal["product_currency_symbol"] as? String
        self.currency_symbol = OrdersPaypal["currency_symbol"] as? String
        self.order_total = String(OrdersPaypal["order_total"] as! NSInteger)
        
        self.shipping_name = OrdersPaypal["shipping_name"] as? String
        self.merchant_name = OrdersPaypal["merchant_name"] as? String
        self.order_total = String(OrdersPaypal["order_total"] as! NSInteger)
        self.coupon_code = OrdersPaypal["coupon_code"] as? String
          self.is_redeem = OrdersPaypal["is_redeem"] as? String
         self.day = String(OrdersPaypal["day"] as! NSInteger)
       // self.order_total = String((OrdersPaypal["order_total"] as? Double)!)
        //self.order_total = OrdersPaypal["order_total"] as? String
        
        if OrdersPaypal["product_image"] as? String == nil {
            
            self.image = OrdersPaypal["deal_image"] as? String
        }
        else {
            self.image = OrdersPaypal["product_image"] as? String
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: (OrdersPaypal["order_date"] as? String)!)
        self.orderDate = date! as Date
    }
}
