//
//  FTopPicksCollectionViewCell.swift
//  Le
//
//  Created by Asif Seraje on 2/15/20.
//  Copyright © 2020 Munesan M. All rights reserved.
//

import UIKit

class FTopPicksCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var cutOffPrice: UILabel!
    @IBOutlet weak var offPercentage: UILabel!
    
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productCategory: UILabel!
}
