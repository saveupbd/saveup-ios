//
//  FDetailsProductDescriptionTableViewCell.swift
//  Le
//
//  Created by Asif Seraje on 12/21/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit

class FDetailsProductDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var proDescriptionDetailsTextView: UITextView!
    @IBOutlet weak var proHeaderLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
