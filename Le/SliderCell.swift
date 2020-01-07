//
//  SliderCell.swift
//  Le
//
//  Created by RASHED on 4/8/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit

class SliderCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage! {
        didSet {
            imageView.image = image
        }
    }
    
}
