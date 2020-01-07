//
//  AdImages.swift
//  Le
//
//  Created by 2Base MacBook Pro on 15/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class AdImages: NSObject {

    var ad_image:String!
    
    init(AdImages: NSDictionary) {
        
        self.ad_image = AdImages["ad_image"] as? String
    }
}
