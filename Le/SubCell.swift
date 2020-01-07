//
//  SubCell.swift
//  Le
//
//  Created by 2Base MacBook Pro on 11/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class SubCell: UITableViewCell {

    @IBOutlet weak var subcategoryLabel : UILabel!
    @IBOutlet weak var selectImage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
