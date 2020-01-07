//
//  RegisterViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 10/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit
import AccountKit
class RegisterViewController: UIViewController, UIGestureRecognizerDelegate, CountryDelegate, CityDelegate {
var accountKit: AKFAccountKit!
    //@IBOutlet weak var registerScroll : UIScrollView!
    //@IBOutlet weak var bgImage : UIImageView!
    @IBOutlet weak var nameText : UITextField!
    @IBOutlet weak var emailText : UITextField!
    @IBOutlet weak var passwordText : UITextField!
    @IBOutlet weak var countryText : UITextField!
    @IBOutlet weak var cityText : UITextField!
    //@IBOutlet weak var countryButton : UIButton!
    //@IBOutlet weak var cityButton : UIButton!
    @IBOutlet weak var acceptButton : UIButton!
    @IBOutlet weak var termsButton : UIButton!
    @IBOutlet weak var registerButton : UIButton!
    
    var acceptBool = false
    var countryidString: String!
    var cityidString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setAwsomeBackgroundImage()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Register"
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(RegisterViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        self.navigationItem.leftBarButtonItem = LeftButton
        
//        if UIScreen.main.bounds.size.height == 480 {
//            let image = UIImage(named: "bg_image_1.png")
//            bgImage.image = image
//        }
//        else if UIScreen.main.bounds.size.height == 568 {
//            let image = UIImage(named: "bg_image_2.png")
//            bgImage.image = image
//        }
//        else if UIScreen.main.bounds.size.height == 667 {
//            let image = UIImage(named: "bg_image_3.png")
//            bgImage.image = image
//        }
//        else if UIScreen.main.bounds.size.height == 736 {
//            let image = UIImage(named: "bg_image_4.png")
//            bgImage.image = image
//        }
//        else {
//            let image = UIImage(named: "bg_image_4.png")
//            bgImage.image = image
//        }
        
        //registerScroll.contentSize = CGSize(width:UIScreen.main.bounds.size.width, height:650)
        
        nameText.attributedPlaceholder! = NSAttributedString(string: "Name", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font :nameText.font!])
        emailText.attributedPlaceholder! = NSAttributedString(string: "Email", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font :emailText.font!])
        passwordText.attributedPlaceholder! = NSAttributedString(string: "Password", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font :passwordText.font!])
        countryText.attributedPlaceholder! = NSAttributedString(string: "Country", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font :countryText.font!])
        cityText.attributedPlaceholder! = NSAttributedString(string: "City", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font :cityText.font!])
        
        let scrollGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleTap))
        scrollGesture.delegate = self
        //registerScroll.addGestureRecognizer(scrollGesture)
        
        
        
        if accountKit == nil {
            self.accountKit = AKFAccountKit(responseType: .accessToken)
            
            accountKit.requestAccount({ (account, error) in
               // let accountID = account?.accountID
                //if the user is logged with Phone
                if account?.phoneNumber?.phoneNumber != nil {
                    let phone = account!.phoneNumber?.stringRepresentation()
                    UserDefaults.standard.set("\(phone)", forKey: "phoneNumber")
                    print("-----------------=============================\(phone)")
                }
            })
        }
        accountKit.logOut()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 210)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 210)
    }
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    

    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        // Resign keypads
        nameText.resignFirstResponder()
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
    }
    
    @objc func backAction(_ sender: UIButton!) {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func countryButton(sender:UIButton ) {
        
        nameText.resignFirstResponder()
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        
        let objCountry = self.storyboard?.instantiateViewController(withIdentifier: "CountryViewController") as! CountryViewController
        objCountry.countryDelegate = self
        self.navigationController?.pushViewController(objCountry, animated: true)
    }
    
    func updateCountry(countryName: String, countryId:String) {
        
        countryText.text = countryName
        countryidString = countryId
    }
    
    @IBAction func cityButton(sender:UIButton ) {
        //print("I am here")
        if countryText.text?.count == 0 {
            
            messageToast(messageStr: Country_Message)
        }
        else {
            
            nameText.resignFirstResponder()
            emailText.resignFirstResponder()
            passwordText.resignFirstResponder()
            
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
    
    @IBAction func acceptButton(sender:UIButton ) {
        
        if acceptBool == false {
            
            acceptBool = true
            acceptButton.isSelected = true
        }
        else {
            
            acceptBool = false
            acceptButton.isSelected = false
        }
    }
    
    @IBAction func termsButton(sender:UIButton ) {
        
        let objTerms = self.storyboard!.instantiateViewController(withIdentifier: "TermsViewController")
        self.present(objTerms, animated: true, completion: nil)
        //self.navigationController!.pushViewController(objTerms, animated: true)
    }
    
    @IBAction func registerButton(sender:UIButton ) {
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            if nameText.text?.count == 0 {
                
                messageToast(messageStr: Name_Message)
                nameText.becomeFirstResponder()
            }
            else if emailText.text?.count == 0 {
                
                messageToast(messageStr: Email_Message)
                emailText.becomeFirstResponder()
            }
            else if isValidEmail(emailText.text!) == false {
                
                messageToast(messageStr: Valid_Email_Message)
                emailText.becomeFirstResponder()
            }
            else if passwordText.text?.count == 0 {
                
                messageToast(messageStr: Password_Message)
                passwordText.becomeFirstResponder()
            }
//            else if (passwordText.text?.count)! < 6 {
//
//                messageToast(messageStr: Length_Message)
//                passwordText.becomeFirstResponder()
//            }
            else if countryText.text?.count == 0 {
                
                messageToast(messageStr: Country_Message)
            }
            else if cityText.text?.count == 0 {
                
                messageToast(messageStr: City_Message)
            }
            else if acceptBool == false {
                
                messageToast(messageStr: Accept_Message)
            }
            else {

                registerButton.isEnabled = false
                
                self.view.hideToastActivity()
                self.view.makeToastActivity(.center)
                
                registerApi()
            }
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    func registerApi() {
        
        let myUrl = URL(string: String(format:"%@api/registration", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "name=\(nameText.text!)&email=\(emailText.text!)&password=\(passwordText.text!)&country_id=1&city_id=1&user_city_name=\(cityText.text!)&user_country_name=\(countryText.text!)&phone=\(UserDefaults.standard.string(forKey: "phoneNumber"))&lang=en"
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    self.registerButton.isEnabled = true
                    self.view.hideToastActivity()
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    print("Here\(json!)")
                    
                    self.registerButton.isEnabled = true
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            let alert = UIAlertController(title: "Success", message: parseJSON.object(forKey: "message") as? String, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ (ACTION :UIAlertAction!)in
                                
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else {
                            
                            self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
                        }
                    }
                }
                catch {
                    
                    //print(error)
                    self.registerButton.isEnabled = true
                    self.view.hideToastActivity()
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
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.white
        style.messageAlignment = .center
        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        
        self.view.makeToast(messageStr, duration: 3.0, position: .center, style: style)
       // self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .center, style: style)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == nameText) {
            
            nameText.resignFirstResponder()
            emailText.becomeFirstResponder()
        }
        else if (textField == emailText) {
            
            emailText.resignFirstResponder()
            passwordText.becomeFirstResponder()
        }
        else if (textField == passwordText) {
            
            passwordText.resignFirstResponder()
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


