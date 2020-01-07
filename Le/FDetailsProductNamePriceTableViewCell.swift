//
//  FDetailsProductNamePriceTableViewCell.swift
//  Le
//
//  Created by Asif Seraje on 12/21/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit

class FDetailsProductNamePriceTableViewCell: UITableViewCell {
    @IBOutlet weak var proNameLabel: UILabel!
    
    @IBOutlet weak var proRightLabel: UILabel!
    @IBOutlet weak var proMiddleLable: UILabel!
    @IBOutlet weak var proLeftLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
