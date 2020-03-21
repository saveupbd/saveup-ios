//
//  RedemOptionsViewController.swift
//  Le
//
//  Created by Asif Seraje on 22/3/20.
//  Copyright © 2020 Munesan M. All rights reserved.
//

import UIKit

class RedemOptionsViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var inputTxtField: UITextField!
    @IBOutlet weak var operatorIgView: UIImageView!
    @IBOutlet weak var amountPickerView: UIPickerView!
    @IBOutlet weak var smallView: UIView!
    
    var cameForBkash = false
    override func viewDidLoad() {
        super.viewDidLoad()
        amountPickerView.delegate = self
        amountPickerView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0{
            return "50"
        }else{
            return "100"
        }
    }

}
