//
//  SortView.swift
//  Le
//
//  Created by 2Base MacBook Pro on 01/06/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class SortView: UIView {

    @IBOutlet weak var backView : UIView!
    @IBOutlet weak var mostButton : UIButton!
    @IBOutlet weak var lowButton : UIButton!
    @IBOutlet weak var highButton : UIButton!
    @IBOutlet weak var newestButton : UIButton!
    @IBOutlet weak var resetButton : UIButton!
    @IBOutlet weak var cancelButton : UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    func loadViewFromNib() {
        let viewName = "SortView"
        let view: UIView = Bundle.main.loadNibNamed(viewName,
                                                              owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
}
