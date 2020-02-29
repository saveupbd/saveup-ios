//
//  LoyalityModel.swift
//  Le
//
//  Created by Asif Seraje on 2/2/20.
//  Copyright © 2020 Munesan M. All rights reserved.
//

import UIKit

class LoyalityModel: NSObject {
    var order_id:String?
    var order_total:String?
    var user_payable_amount:String?
    var user_savings:String?
    var date:String?
    var merchant_name:String?
    var payment_status:String?
    /*
     "order_id": 50,
                 "user_id": 475,
                 "order_total": 32.8599999999999994315658113919198513031005859375,
                 "user_payable_amount": 30,
                 "user_savings": 2.859999999999999875655021241982467472553253173828125,
                 "dagte": "2020-01-17 13:19:07",
                 "merchant_name": "Café Milano",
                 "status": "verified"
     
     */
    
    init(LoyalityModel: NSDictionary) {
        if LoyalityModel["order_id"] != nil{
            self.order_id = String(LoyalityModel["order_id"] as! NSInteger)
        }
        if LoyalityModel["order_total"] != nil{
            self.order_total = String((LoyalityModel["order_total"] as! Double).rounded(.up).removeZerosFromEnd())
        }
        if LoyalityModel["user_payable_amount"] != nil{
            self.user_payable_amount = String(LoyalityModel["user_payable_amount"] as! String)
        }
        if LoyalityModel["user_savings"] != nil{
            self.user_savings = String(LoyalityModel["user_savings"] as! Double)
        }
//        if LoyalityModel["dagte"] != nil{
//            self.order_id = String(LoyalityModel["dagte"])
//        }
        if LoyalityModel["merchant_name"] != nil{
            self.merchant_name = LoyalityModel["merchant_name"] as? String
        }
        if LoyalityModel["status"] != nil{
            self.payment_status = LoyalityModel["status"] as? String
        }
        
    }
}
