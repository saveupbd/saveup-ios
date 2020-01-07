//
//  CategoryCell.swift
//  Le
//
//  Created by 2Base MacBook Pro on 21/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryImage : YYAnimatedImageView!
    @IBOutlet weak var categorynameLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
