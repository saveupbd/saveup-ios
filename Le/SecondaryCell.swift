//
//  SecondaryCell.swift
//  Le
//
//  Created by 2Base MacBook Pro on 10/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class SecondaryCell: UITableViewCell {

    @IBOutlet weak var categoryImage : YYAnimatedImageView!
    @IBOutlet weak var categoryLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
