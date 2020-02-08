//
//  FDetailsImagesCollectionViewCell.swift
//  Le
//
//  Created by Asif Seraje on 2/8/20.
//  Copyright © 2020 Munesan M. All rights reserved.
//

import UIKit

class FDetailsImagesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    var image: UIImage! {
        didSet {
            productImage.image = image
        }
    }
    
}
