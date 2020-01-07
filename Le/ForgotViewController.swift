//
//  ForgotViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 10/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class ForgotViewController: UIViewController {

    @IBOutlet weak var emailText : UITextField!
    @IBOutlet weak var sendButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bgimg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Forgot Password"
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(ForgotViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        self.navigationItem.leftBarButtonItem = LeftButton
        
        emailText.attributedPlaceholder! = NSAttributedString(string: "Enter your email ID", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font :emailText.font!])
        
        emailText.becomeFirstResponder()
    }

    @objc func backAction(_ sender: UIButton!) {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func sendButton(sender:UIButton ) {
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            if emailText.text?.count == 0 {
                self.showAlertViewController(titleText: "Error!", messageText: "Failed to send email. Please check your mail address and try again.", leftSideText: "Dismiss", rightSideText: "")
                //messageToast(messageStr: Email_Message)
                emailText.becomeFirstResponder()
            }
            else if isValidEmail(emailText.text!) == false {
                self.showAlertViewController(titleText: "Error!", messageText: "Failed to send email. Please check your mail address and try again.", leftSideText: "Dismiss", rightSideText: "")
                //messageToast(messageStr: Valid_Email_Message)
                emailText.becomeFirstResponder()
            }
            else {
                
                sendButton.isEnabled = false
                
                self.view.hideToastActivity()
                self.view.makeToastActivity(.center)
                
                forgotApi()
            }
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    func forgotApi() {
        
        let myUrl = URL(string: String(format:"%@api/login_user_forgot_password", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "email=\(emailText.text!)&lang=en"
        
        //print(postString)
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    self.view.hideToastActivity()
                    self.sendButton.isEnabled = true
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    self.sendButton.isEnabled = true
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            let alert = UIAlertController(title: "Success", message: parseJSON.object(forKey: "message") as? String, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ (ACTION :UIAlertAction!)in
                                self.dismiss(animated: true, completion: nil)
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else {
                            self.showAlertViewController(titleText: "Error!", messageText: "Failed to send mail. Please check your mail address and try again.", leftSideText: "Dismiss", rightSideText: "")
                            //self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
                        }
                    }
                }
                catch {
                    
                    //print(error)
                    self.view.hideToastActivity()
                    self.sendButton.isEnabled = true
                }
            }
        })
        task.resume()
    }
    
    func showAlertViewController(titleText:String,messageText:String,leftSideText:String,rightSideText:String){
        let alertController = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        
        let leftAction = UIAlertAction(title: leftSideText, style: .default, handler: nil)
        let rightAction = UIAlertAction(title: rightSideText, style: .default, handler: nil)
        
        if rightSideText == ""{
            alertController.addAction(leftAction)
        }else{
            alertController.addAction(leftAction)
            alertController.addAction(rightAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
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
        
        self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .center, style: style)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == emailText) {
            
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
