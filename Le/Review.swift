//
//  Review.swift
//  Le
//
//  Created by 2Base MacBook Pro on 17/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class Review: NSObject {

    var ratings:String!
    var review_comments:String!
    var review_title:String!
    var user_name:String!
    
    init(Review: NSDictionary) {
        
        self.ratings = Review["ratings"] as? String
        self.review_comments = Review["review_comments"] as? String
        self.review_title = Review["review_title"] as? String
        self.user_name = Review["user_name"] as? String
    }
}
