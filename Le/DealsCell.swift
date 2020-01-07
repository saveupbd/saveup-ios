//
//  DealsCell.swift
//  Le
//
//  Created by 2Base MacBook Pro on 28/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class DealsCell: UITableViewCell {

    @IBOutlet weak var dealsImage : YYAnimatedImageView!
    @IBOutlet weak var dealpercentageLabel : UILabel!
    @IBOutlet weak var dealpriceLabel : UILabel!
    @IBOutlet weak var dealdiscountpriceLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
