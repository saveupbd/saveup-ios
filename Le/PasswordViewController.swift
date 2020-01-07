//
//  PasswordViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 27/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var passwordScroll : UIScrollView!
    @IBOutlet weak var oldText : UITextField!
    @IBOutlet weak var newText : UITextField!
    @IBOutlet weak var confirmText : UITextField!
    @IBOutlet weak var updateButton : UIButton!
    @IBOutlet weak var oldshowButton : UIButton!
    @IBOutlet weak var newshowButton : UIButton!
    @IBOutlet weak var confirmshowButton : UIButton!
    
    var oldBool: Bool! = false
    var newBool: Bool! = false
    var confirmBool: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Change Password"
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(PasswordViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        self.navigationItem.leftBarButtonItem = LeftButton
        
        oldText.attributedPlaceholder! = NSAttributedString(string: "Old Password", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font :oldText.font!])
        newText.attributedPlaceholder! = NSAttributedString(string: "New Password", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font :newText.font!])
        confirmText.attributedPlaceholder! = NSAttributedString(string: "Confirm Password", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font :confirmText.font!])
        
        let scrollGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleTap))
        scrollGesture.delegate = self
        passwordScroll.addGestureRecognizer(scrollGesture)
    }

    @IBAction func oldshowButton(sender:UIButton ) {
        
        if oldBool == false {
            
            oldBool = true
            oldText.isSecureTextEntry = false
            oldshowButton.setTitle("Hide", for: .normal)
        }
        else {
            
            oldBool = false
            oldText.isSecureTextEntry = true
            oldshowButton.setTitle("Show", for: .normal)
        }
    }
    
    @IBAction func newshowButton(sender:UIButton ) {
        
        if newBool == false {
            
            newBool = true
            newText.isSecureTextEntry = false
            newshowButton.setTitle("Hide", for: .normal)
        }
        else {
            
            newBool = false
            newText.isSecureTextEntry = true
            newshowButton.setTitle("Show", for: .normal)
        }
    }
    
    @IBAction func confirmshowButton(sender:UIButton ) {
        
        if confirmBool == false {
            
            confirmBool = true
            confirmText.isSecureTextEntry = false
            confirmshowButton.setTitle("Hide", for: .normal)
        }
        else {
            
            confirmBool = false
            confirmText.isSecureTextEntry = true
            confirmshowButton.setTitle("Show", for: .normal)
        }
    }
    
    @objc func backAction(_ sender: UIButton!) {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        // Resign keypads
        oldText.resignFirstResponder()
        newText.resignFirstResponder()
        confirmText.resignFirstResponder()
    }
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.black
        style.messageAlignment = .center
        style.backgroundColor = UIColor.white
        
        self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    
    @IBAction func updateButton(sender:UIButton ) {
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            if oldText.text?.count == 0 {
                
                messageToast(messageStr: Old_Message)
                oldText.becomeFirstResponder()
            }
            else if newText.text?.count == 0 {
                
                messageToast(messageStr: New_Message)
                newText.becomeFirstResponder()
            }
            else if (newText.text?.count)! < 6 {
                
                messageToast(messageStr: Length_Message)
                newText.becomeFirstResponder()
            }
            else if confirmText.text?.count == 0 {
                
                messageToast(messageStr: Confirm_Message)
                confirmText.becomeFirstResponder()
            }
            else if (newText.text != confirmText.text!){
                
                messageToast(messageStr: Match_Message)
                confirmText.becomeFirstResponder()
            }
            else {
                
                updateButton.isEnabled = false
                
                self.view.hideToastActivity()
                self.view.makeToastActivity(.center)
                
                passwordApi()
            }
        }
        else {
            
            showNetworkErrorAlert()
        }
    }
    
    func passwordApi() {
        
        let myUrl = URL(string: String(format:"%@api/reset_password", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&old_password=\(oldText.text!)&new_password=\(newText.text!)&lang=en"
        
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
                            
                            let alert = UIAlertController(title: "Success", message: parseJSON.object(forKey: "message") as? String, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ (ACTION :UIAlertAction!)in
                                
                                self.navigationController!.popViewController(animated: true)
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
                    self.view.hideToastActivity()
                    self.updateButton.isEnabled = true
                }
            }
        })
        task.resume()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == oldText) {
            
            oldText.resignFirstResponder()
            newText.becomeFirstResponder()
        }
        else if (textField == newText) {
            
            newText.resignFirstResponder()
            confirmText.becomeFirstResponder()
        }
        else if (textField == confirmText) {
            
            confirmText.resignFirstResponder()
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
