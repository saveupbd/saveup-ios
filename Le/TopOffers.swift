//
//  TopOffers.swift
//  Le
//
//  Created by 2Base MacBook Pro on 16/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class TopOffers: NSObject {

    var product_id:String!
    var product_title:String!
    var product_price:String!
    var product_discount_price:String!
    var product_percentage:String!
    var product_image:String!
    var currency_symbol:String!
    var merchant_name:String!
    var product_type:String!
    var product_off:String!
    
    init(TopOffers: NSDictionary) {
        
        /*product_type all_items hobe tokhon product discount percentage show koraben tokhon ar price dekhaben na only discount
         */
        
        self.product_id = String(TopOffers["product_id"] as! NSInteger)
        self.product_title = TopOffers["product_title"] as? String
        self.product_type = TopOffers["product_type"] as? String
        
        if self.product_type != "all_item"  {
            self.product_price = String(TopOffers["product_price"] as! Double)
            self.product_discount_price = String(TopOffers["product_discount_price"] as! NSInteger)
            self.product_percentage = String(TopOffers["product_percentage"] as! NSInteger)
        }else{
            self.product_off = String(TopOffers["product_discount"] as! NSInteger)
        }
    
        self.product_image = TopOffers["product_image"] as? String
        self.currency_symbol = TopOffers["currency_symbol"] as? String
        self.merchant_name = TopOffers["merchant_name"] as? String
    }
}
