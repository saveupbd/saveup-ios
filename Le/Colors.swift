//
//  Colors.swift
//  Le
//
//  Created by 2Base MacBook Pro on 09/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class Colors: NSObject {

    var color_code:String!
    var product_color_id:String!
    var color_status:String!
    
    init(Colors: NSDictionary) {
        
        if Colors["color_code"] as? String == nil {
            
            self.color_code = ""
        }
        else {
            self.color_code = Colors["color_code"] as? String
        }
        
        self.product_color_id = String(Colors["product_color_id"] as! NSInteger)
        self.color_status = "0"
    }
}
