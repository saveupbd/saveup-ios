//
//  Sizes.swift
//  Le
//
//  Created by 2Base MacBook Pro on 09/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class Sizes: NSObject {

    var size_name:String!
    var product_size_id:String!
    var size_status:String!
    
    init(Sizes: NSDictionary) {
        
        self.size_name = Sizes["size_name"] as? String
        self.product_size_id = String(Sizes["product_size_id"] as! NSInteger)
        self.size_status = "0"
    }
}
