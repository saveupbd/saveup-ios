//
//  SubModule.swift
//  Le
//
//  Created by 2Base MacBook Pro on 11/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class SubModule: NSObject {

    var sec_category_id: String!
    var sec_category_name:String!
    var selected_value:String!
    var main_category_name:String!
    
  override init() {
      print("empty constructor")
    }
    
    init(SubModule: NSDictionary) {
        let id  = SubModule["sec_category_id"] as? Int
        self.sec_category_id = String(id!)
        self.sec_category_name = SubModule["sec_category_name"] as? String
        self.selected_value = "0"
        self.main_category_name = SubModule["main_category_name"] as? String
    }
    
    func pushData(sec_category_id: String!, sec_category_name:String!){
    self.sec_category_id = sec_category_id
    
        self.selected_value = "1"
  self.sec_category_name = sec_category_name
        self.main_category_name = sec_category_name
    }
    
}
