//
//  ProductImages.swift
//  Le
//
//  Created by 2Base MacBook Pro on 09/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class ProductImages: NSObject {
    
    var images:String!
    
    init(ProductImages: NSDictionary) {
        
        self.images = ProductImages["images"] as? String
    }
}
