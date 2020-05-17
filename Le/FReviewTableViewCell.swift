//
//  FReviewTableViewCell.swift
//  Le
//
//  Created by Asif Seraje on 16/5/20.
//  Copyright © 2020 Munesan M. All rights reserved.
//

import UIKit

class FReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var rvwName: UILabel!
    @IBOutlet weak var rvwText: UILabel!
    @IBOutlet weak var rvwImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
