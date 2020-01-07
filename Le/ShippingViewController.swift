//
//  ShippingViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 03/05/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class ShippingViewController: UIViewController, UIGestureRecognizerDelegate, CountryDelegate, CityDelegate {

    @IBOutlet weak var shippingScroll : UIScrollView!
    @IBOutlet weak var nameText : UITextField!
    @IBOutlet weak var addressline1Text : UITextField!
    @IBOutlet weak var addressline2Text : UITextField!
    @IBOutlet weak var cityText : UITextField!
    @IBOutlet weak var stateText : UITextField!
    @IBOutlet weak var countryText : UITextField!
    @IBOutlet weak var phoneText : UITextField!
    @IBOutlet weak var zipcodeText : UITextField!
    @IBOutlet weak var emailText : UITextField!
    @IBOutlet weak var updateButton : UIButton!
    @IBOutlet weak var countryButton : UIButton!
    @IBOutlet weak var cityButton : UIButton!
    
    var countryidString: String!
    var cityidString: String!
    var shipidString: String!
    
    var no_of_items: String!
    var shipping_charge: String!
    var amount: String!
    var total_amount: String!
    var tax: String!
    var product_id: String! = ""
    var product_size_id: String! = ""
    var product_color_id: String! = ""
    var product_qty: String! = ""
    
    var deal_id: String! = ""
    var deal_qty: String! = ""
    var currencySymbol = String()
    var screen_value: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        
        
       // shippingScroll.contentSize = CGSize(width:UIScreen.main.bounds.size.width, height:318)
        
//        let scrollGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleTap))
//        scrollGesture.delegate = self
      //  shippingScroll.addGestureRecognizer(scrollGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ShippingViewController.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ShippingViewController.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            myshippingApi()
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Billing Address"
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(ShippingViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        self.navigationItem.leftBarButtonItem = LeftButton
    }

    
    @objc func keyboardWillShow(sender: NSNotification) {

        if phoneText.isFirstResponder || zipcodeText.isFirstResponder || emailText.isFirstResponder {

            self.view.frame.origin.y = 0  //-140 // Move view 150 points upward
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @objc func backAction(_ sender: UIButton!) {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        
        // Resign keypads
        nameText.resignFirstResponder()
        addressline1Text.resignFirstResponder()
        addressline2Text.resignFirstResponder()
        cityText.resignFirstResponder()
        stateText.resignFirstResponder()
        countryText.resignFirstResponder()
        phoneText.resignFirstResponder()
        zipcodeText.resignFirstResponder()
        emailText.resignFirstResponder()
    }
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.white
        style.messageAlignment = .center
        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        
        self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .center, style: style)
    }
    
    func myshippingApi() {
        
        let myUrl = URL(string: String(format:"%@api/my_account", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&lang=en"
        //print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
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
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON.object(forKey: "shipping_details") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    self.nameText.text = reposArray[0].object(forKey: "ship_name") as? String
                                    self.addressline1Text.text = reposArray[0].object(forKey: "ship_address1") as? String
                                    self.addressline2Text.text = reposArray[0].object(forKey: "ship_address2") as? String
                                    self.cityText.text = reposArray[0].object(forKey: "ship_city_name") as? String
                                    self.stateText.text = reposArray[0].object(forKey: "ship_state") as? String
                                    self.countryText.text = reposArray[0].object(forKey: "ship_country_name") as? String
                                    self.phoneText.text = reposArray[0].object(forKey: "ship_phone") as? String
                                    self.zipcodeText.text = reposArray[0].object(forKey: "ship_postalcode") as? String
                                    self.emailText.text = reposArray[0].object(forKey: "ship_email") as? String
                                    self.shipidString = String(format: "%d", (reposArray[0].object(forKey: "ship_id") as? String)!)
                                    self.countryidString = String(format: "%d", (reposArray[0].object(forKey: "ship_country_id") as? String)!)
                                    self.cityidString = String(format: "%d", (reposArray[0].object(forKey: "ship_city_id") as? String)!)
                                }
                            }
                        }
                        else {
                            
                            var style = ToastStyle()
                            style.messageFont = messageFont!
                            style.messageColor = UIColor.white
                            style.messageAlignment = .center
                            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                            
                            self.view.makeToast("No Data Available!", duration: 3.0, position: .center, style: style)
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
    
    @IBAction func countryButton(sender:UIButton ) {
        let objCountry = self.storyboard?.instantiateViewController(withIdentifier: "CountryViewController") as! CountryViewController
        objCountry.countryDelegate = self
        self.navigationController?.pushViewController(objCountry, animated: true)
    }
    
    func updateCountry(countryName: String, countryId:String) {
        
        countryText.text = countryName
        countryidString = countryId
    }
    
    @IBAction func cityButton(sender:UIButton ) {
        
        if countryText.text?.count == 0 {
            
            messageToast(messageStr: Country_Message)
        }
        else {
            
            let objCity = self.storyboard?.instantiateViewController(withIdentifier: "CityViewController") as! CityViewController
            objCity.countryId = Int(countryidString)!
            objCity.cityDelegate = self
            self.navigationController?.pushViewController(objCity, animated: true)
        }
    }
    
    func updateCity(cityName: String, cityId:String) {
        
        cityText.text = cityName
        cityidString = cityId
    }
    
    @IBAction func updateButton(sender:UIButton ) {
        
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            if nameText.text?.count == 0 {
                
                messageToast(messageStr: Name_Message)
                nameText.becomeFirstResponder()
            }
            else if addressline1Text.text?.count == 0 {
                
                messageToast(messageStr: "Please enter your address line1")
                addressline1Text.becomeFirstResponder()
            }
//            else if addressline2Text.text?.count == 0 {
//                
//                messageToast(messageStr: "Please enter your address line2")
//                addressline2Text.becomeFirstResponder()
//            }
//            else if countryText.text?.count == 0 {
//                
//                messageToast(messageStr: "Please select your country")
//            }
            else if stateText.text?.count == 0 {
                
                messageToast(messageStr: "Please enter your state")
                stateText.becomeFirstResponder()
            }
            else if cityText.text?.count == 0 {
                
                messageToast(messageStr: "Please select your city")
            }
            else if phoneText.text?.count == 0 {
                
                messageToast(messageStr: Phone_Message)
                phoneText.becomeFirstResponder()
            }
            else if zipcodeText.text?.count == 0 {
                
                messageToast(messageStr: "Please enter your zip code")
                zipcodeText.becomeFirstResponder()
            }
            else if emailText.text?.count == 0 {
                
                messageToast(messageStr: Email_Message)
                emailText.becomeFirstResponder()
            }
            else if isValidEmail(emailText.text!) == false {
                
                messageToast(messageStr: Valid_Email_Message)
                emailText.becomeFirstResponder()
            }
            else {
                
                updateButton.isEnabled = false
                
                self.view.hideToastActivity()
                self.view.makeToastActivity(.center)
                
                updateApi()
                
                let secondVC = storyboard?.instantiateViewController(withIdentifier: "PymentVC") as! PymentVC
                self.navigationController?.pushViewController(secondVC, animated: true)
            }
        }
        else {
            
            self.showNetworkErrorAlert()
        }
        
//        let reachability = Reachability()!
//
//        if reachability.isReachable {
//
//            if nameText.text?.count == 0 {
//
//                messageToast(messageStr: Name_Message)
//                nameText.becomeFirstResponder()
//            }
//            else if addressline1Text.text?.count == 0 {
//
//                messageToast(messageStr: "Please enter your address line1")
//                addressline1Text.becomeFirstResponder()
//            }
//            else if addressline2Text.text?.count == 0 {
//
////                messageToast(messageStr: "Please enter your address line2")
////                addressline2Text.becomeFirstResponder()
//            }
//            else if countryText.text?.count != nil && countryText.text?.count == 0  {
//
//                messageToast(messageStr: "Please select your country")
//                countryText.becomeFirstResponder()
//            }
//            else if stateText.text?.count == 0 {
//
//                messageToast(messageStr: "Please enter your state")
//                stateText.becomeFirstResponder()
//            }
//            else if cityText.text?.count == 0 {
//
//                messageToast(messageStr: "Please select your city")
//            }
//            else if phoneText.text?.count == 0 {
//
//                messageToast(messageStr: Phone_Message)
//           //     phoneText.becomeFirstResponder()
//            }
//            else if zipcodeText.text?.count == 0 {
//
//                messageToast(messageStr: "Please enter your zip code")
//            //    zipcodeText.becomeFirstResponder()
//            }
//            else if isValidEmail(emailText.text!) == false {
//
//                messageToast(messageStr: Valid_Email_Message)
//            //    emailText.becomeFirstResponder()
//            }
//            else if isValidEmail(emailText.text!) == false {
//
//                messageToast(messageStr: Valid_Email_Message)
////                emailText.becomeFirstResponder()
//            } else if nameText.text?.count != nil && addressline1Text.text?.count != nil{
//
//            }
//
//            else {
//
//                updateButton.isEnabled = false
//
//                self.view.hideToastActivity()
//                self.view.makeToastActivity(.center)
//
//                updateApi()
//            }
//        }
//        else {
//            self.showNetworkErrorAlert()
//        }
        
        
        let userDefaultStore = UserDefaults.standard //userDefault object
        userDefaultStore.set(nameText.text, forKey: "name") //store textView value in userDefault
        userDefaultStore.set(addressline1Text.text, forKey: "address")
        userDefaultStore.set(stateText.text, forKey: "state")
        userDefaultStore.set(cityText.text, forKey: "city")
        userDefaultStore.set(phoneText.text, forKey: "phoneNumber")
        userDefaultStore.set(zipcodeText.text, forKey: "zip")
        userDefaultStore.set(emailText.text, forKey: "email")
        //navigate secondViewController
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !text.isEmpty{
            //make isUserInteractionEnabled = true
        } else {
            //make isUserInteractionEnabled = false
        }
        
        return true
    }
    
    func updateApi() {
        
        let myUrl = URL(string: String(format:"%@api/update_my_account", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&ship_id=\(shipidString!)&ship_name=\(nameText.text!)&ship_address1=\(addressline1Text.text!)&ship_address2=\(addressline2Text.text!)&ship_city_id=\(cityidString!)&ship_state=\(stateText.text!)&ship_country_id=\(countryidString!)&ship_phone=\(phoneText.text!)&ship_postalcode=\(zipcodeText.text!)&ship_email=\(emailText.text!)&lang=en"
        
        //print(postString)
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    self.view.hideToastActivity()
                    self.updateButton.isEnabled = true
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    self.updateButton.isEnabled = true
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            let alert = UIAlertController(title: "Success", message: "Shipping added successfully!", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ (ACTION :UIAlertAction!)in
                                
                                let objPayments = self.storyboard?.instantiateViewController(withIdentifier: "PaymentsViewController") as! PaymentsViewController
                                objPayments.no_of_items = self.no_of_items
                                objPayments.shipping_charge = self.shipping_charge
                                objPayments.amount = self.amount
                                objPayments.total_amount = self.total_amount
                                objPayments.ship_name = self.nameText.text!
                                objPayments.ship_address1 = self.addressline1Text.text!
                                objPayments.ship_address2 = self.addressline2Text.text!
                                objPayments.ship_email = self.emailText.text!
                                objPayments.ship_phone = self.phoneText.text!
                                objPayments.ship_country_id = self.countryidString!
                                objPayments.ship_city_id = self.cityidString!
                                objPayments.ship_state = self.stateText.text!
                                objPayments.ship_postalcode = self.zipcodeText.text!
                                objPayments.screen_value = self.screen_value!
                                objPayments.tax = self.tax
                                objPayments.currencySymbol = self.currencySymbol
                                objPayments.product_id = self.product_id!
                                objPayments.product_size_id = self.product_size_id!
                                objPayments.product_color_id = self.product_color_id!
                                objPayments.product_qty = self.product_qty!
                                
                                objPayments.deal_id = self.deal_id!
                                objPayments.deal_qty = self.deal_qty!
                                self.navigationController?.pushViewController(objPayments, animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else {
                            
                         //   self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
                        }
                    }
                }
                catch {
                    
                    //print(error)
                    self.view.hideToastActivity()
                    self.updateButton.isEnabled = true
                }
            }
        })
        task.resume()
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        
        let emailRegEx = "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == nameText) {
            
            nameText.resignFirstResponder()
            addressline1Text.becomeFirstResponder()
        }
        else if (textField == addressline1Text) {
            
            addressline1Text.resignFirstResponder()
            addressline2Text.becomeFirstResponder()
        }
        else if (textField == addressline2Text) {
            
            addressline2Text.resignFirstResponder()
            cityText.becomeFirstResponder()
        }
        else if (textField == cityText) {
            
            cityText.resignFirstResponder()
            stateText.becomeFirstResponder()
        }
        else if (textField == stateText) {
            
            stateText.resignFirstResponder()
            countryText.becomeFirstResponder()
        }
        else if (textField == countryText) {
            
            countryText.resignFirstResponder()
            phoneText.becomeFirstResponder()
        }
        else if (textField == phoneText) {
            
            phoneText.resignFirstResponder()
            zipcodeText.becomeFirstResponder()
        }
        else if (textField == zipcodeText) {
            
            zipcodeText.resignFirstResponder()
            emailText.becomeFirstResponder()
        }
        else if (textField == emailText) {
            
            emailText.resignFirstResponder()
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ShippingViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
