//
//  MoreImageTableViewCell.swift
//  Le
//
//  Created by Asif Seraje on 11/2/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit

class MoreImageTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: YYAnimatedImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
