//
//  DealImages.swift
//  Le
//
//  Created by 2Base MacBook Pro on 19/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class DealImages: NSObject {

    var images:String!
    
    init(DealImages: NSDictionary) {
        
        self.images = DealImages["images"] as? String
    }
}
