//
//  BannersHome.swift
//  Le
//
//  Created by 2Base MacBook Pro on 16/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class BannersHome: NSObject {

    var banner_image:String!
    var banner_id:String!
    
    init(BannersHome: NSDictionary) {
        
        self.banner_image = BannersHome["banner_image"] as? String
        self.banner_id = String(BannersHome["banner_id"] as! NSInteger)
    }
}
