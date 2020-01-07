//
//  SecondayCategory.swift
//  Le
//
//  Created by 2Base MacBook Pro on 10/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class SecondayCategory: NSObject {

    var sub_category_id:String!
    var sub_category_name:String!
    var sub_category_image:String!
    
    init(SecondayCategory: NSDictionary) {
        
        self.sub_category_id = SecondayCategory["sub_category_id"] as? String
        self.sub_category_name = SecondayCategory["sub_category_name"] as? String
        self.sub_category_image = SecondayCategory["sub_category_image"] as? String
    }
}
