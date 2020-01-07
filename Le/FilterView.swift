//
//  FilterView.swift
//  Le
//
//  Created by 2Base MacBook Pro on 05/06/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class FilterView: UIView {

    @IBOutlet weak var backView : UIView!
    @IBOutlet weak var underButton : UIButton!
    @IBOutlet weak var oneButton : UIButton!
    @IBOutlet weak var twoButton : UIButton!
    @IBOutlet weak var fiveButton : UIButton!
    @IBOutlet weak var overButton : UIButton!
    @IBOutlet weak var zeroButton : UIButton!
    @IBOutlet weak var tenButton : UIButton!
    @IBOutlet weak var twentyButton : UIButton!
    @IBOutlet weak var thirtyButton : UIButton!
    @IBOutlet weak var fourtyButton : UIButton!
    @IBOutlet weak var fiftyButton : UIButton!
    @IBOutlet weak var outButton : UIButton!
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
        let viewName = "FilterView"
        let view: UIView = Bundle.main.loadNibNamed(viewName,
                                                    owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
}
