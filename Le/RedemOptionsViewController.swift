//
//  RedemOptionsViewController.swift
//  Le
//
//  Created by Asif Seraje on 22/3/20.
//  Copyright © 2020 Munesan M. All rights reserved.
//

import UIKit

class RedemOptionsViewController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var inputTxtField: UITextField!
    @IBOutlet weak var operatorIgView: UIImageView!
    @IBOutlet weak var amountTxtField: UITextField!
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var btnConfirm: UIButton!
    
    var cameForBkash = false
    
    var tap: UITapGestureRecognizer!
    var phoneNumber = ""
    var amount = ""
    var operatorName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.smallView.layer.cornerRadius = 8
        self.smallView.layer.masksToBounds = true
        self.smallView.layer.borderColor = UIColor.white.cgColor
        self.smallView.layer.borderWidth = 0.8
        
        self.btnConfirm.layer.cornerRadius = 5
        self.btnConfirm.layer.masksToBounds = true
        self.btnConfirm.layer.borderColor = UIColor.white.cgColor
        self.btnConfirm.layer.borderWidth = 0.5
        
        headerLabel.text = "Enter phone number & amount"
        inputTxtField.delegate = self
        inputTxtField.tag = 500
        inputTxtField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        amountTxtField.delegate = self
        amountTxtField.tag = 600
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        view.addGestureRecognizer(tap)
        
        view?.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        self.operatorIgView.image = UIImage(named: "mop")
    }
    
    @objc private func onTap(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 500{//numberTxt
            if let numberText = textField.text{
                if numberText != ""{
                    self.phoneNumber = numberText
                }
            }
            
        }else if textField.tag == 600{//amountTxt
            if let amountText = textField.text{
                if amountText != ""{
                    self.amount = amountText
                }
            }
        }else{
            print("Shouldn't come here")
        }
    }
    
    @objc func textFieldDidChange(textField : UITextField){
        if textField.tag == 500{//numberTxt
            if let numberText = textField.text{
                if numberText.contains("017") {
                    self.operatorName = "grameenphone"
                    self.operatorIgView.image = UIImage(named: "gp")
                }else if numberText.contains("019") {
                    self.operatorName = "banglalink"
                    self.operatorIgView.image = UIImage(named: "bl")
                }else if numberText.contains("018") {
                    self.operatorName = "robi"
                    self.operatorIgView.image = UIImage(named: "robi")
                }else if numberText.contains("016") {
                    self.operatorName = "airtel"
                    self.operatorIgView.image = UIImage(named: "airtel")
                }else if numberText.contains("015") {
                    self.operatorName = "teletalk"
                    self.operatorIgView.image = UIImage(named: "tt")
                }else{
                    self.operatorIgView.image = UIImage(named: "mop")
                }
            }
            
        }else if textField.tag == 600{//amountTxt
            
        }else{
            print("Shouldn't come here")
        }
    }
    
    
    @IBAction func btnConfirmPressed(_ sender: UIButton) {
        print("confirmed")
        self.view.endEditing(true)
        self.postRechargeInfo()
    }
    
    func postRechargeInfo() {
        self.view.makeToastActivity(.center)
        let myUrl = URL(string: String(format:"%@api/recharge-by-loyalty", Api_Base_URL));
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"
        
        var postString = ""
        if self.phoneNumber == "" || self.amount == "" {
            var style = ToastStyle()
            style.messageFont = messageFont!
            style.messageColor = UIColor.white
            style.messageAlignment = .center
            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
            
            self.view.makeToast("Please insert phone number and amount properly.", duration: 3.0, position: .center, style: style)
            return
        }
        
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            postString = "operator_name=\(self.operatorName)&user_id=\(tempUserID)&mobile_number=\(self.phoneNumber)&amount=\(self.amount)"
        }else{
            postString = "operator_name=\(self.operatorName)&&mobile_number=\(self.phoneNumber)&amount=\(self.amount)"
        }
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    self.view.hideToastActivity()
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 || parseJSON.object(forKey: "status") as! NSInteger == 400 {
                            
                            let mess = parseJSON.object(forKey: "message") as? String
//                            let point = parseJSON.object(forKey: "loyality_point") as? String
//                            UserDefaults.standard.set(point, forKey: "loyality_point")
//                            let total_point = parseJSON.object(forKey: "total_loyality_point") as? String
//                            UserDefaults.standard.set(total_point, forKey: "total_loyality_point")
//                            let pointmessage = "You have got \(point!) points. Your total loyality point is \(total_point!)."
                            
                            let alert = UIAlertController(title: "Success", message: mess, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler:{ (ACTION :UIAlertAction!)in
                                self.dismiss(animated: true, completion: nil)
                                
                            }))

                            DispatchQueue.main.async {
                                self.view.hideToastActivity()
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                        }
                        else {
                            
                            var style = ToastStyle()
                            style.messageFont = messageFont!
                            style.messageColor = UIColor.white
                            style.messageAlignment = .center
                            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                            
                            self.view.makeToast(parseJSON.object(forKey: "message") as! String, duration: 3.0, position: .center, style: style)
                        }
                    }
                }
                catch {
                    
                    //print(error)
                    self.view.hideToastActivity()
                }
            }
        })
        task.resume()
        
    }
    

}
