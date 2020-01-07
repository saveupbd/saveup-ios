//
//  CategoryHome.swift
//  Le
//
//  Created by 2Base MacBook Pro on 16/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class CategoryHome: NSObject {

    var category_id:String!
    var category_name:String!
    var category_image:String!
    var sub_category_list:[NSDictionary]
    
    init(CategoryHome: NSDictionary) {
        
        self.category_id = String(CategoryHome["category_id"] as! NSInteger)
        self.category_name = CategoryHome["category_name"] as? String
        self.category_image = CategoryHome["category_image"] as? String
        self.sub_category_list = (CategoryHome["sub_category_list"] as? [NSDictionary])!
    }
}
