//
//  MyCategoryName.swift
//  Le
//
//  Created by Akramul Haque on 3/4/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit

class MyCategoryName: NSObject {
    var category_id:String!
    var category_name:String!
    
    init(Products: NSDictionary) {
        
        self.category_id = String(Products["category_id"] as! NSInteger)
        self.category_name = Products["category_name"] as? String
    }
    
}


