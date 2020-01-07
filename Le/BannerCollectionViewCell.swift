//
//  BannerCollectionViewCell.swift
//  Le
//
//  Created by Asif Seraje on 11/9/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage! {
        didSet {
            imageView.image = image
        }
    }
    
    
}
