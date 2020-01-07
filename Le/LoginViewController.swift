//
//  LoginViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 07/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import AccountKit
class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UIGestureRecognizerDelegate, AKFViewControllerDelegate {
    var accountKit: AKFAccountKit!
    @IBOutlet weak var loginScroll : UIScrollView!
    @IBOutlet weak var bgImage : UIImageView!
    @IBOutlet weak var emailText : UITextField!
    @IBOutlet weak var passwordText : UITextField!
    @IBOutlet weak var loginButton : UIButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    @IBOutlet weak var forgotButton : UIButton!
    @IBOutlet weak var registerButton : UIButton!
    
    @IBOutlet weak var btnGuest: UIButton!
    var nameString:String?
    var emailString:String?
    var fbidString:String?
    var fbtokenString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init Account Kit
        self.setAwsomeBackgroundImage()
        self.dismissKeyBoardTappedOutside()
        if accountKit == nil {
            self.accountKit = AKFAccountKit.init(responseType: .accessToken)
        }

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
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
        
        emailText.attributedPlaceholder! = NSAttributedString(string: "Email", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font :emailText.font!])
        passwordText.attributedPlaceholder! = NSAttributedString(string: "Password", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font :passwordText.font!])
        
        configureFacebook()
        
        //let scrollgesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleTap))
        //scrollgesture.delegate = self
        //loginScroll.addGestureRecognizer(scrollgesture)
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (accountKit.currentAccessToken != nil) {
            print("User already logged in, go to the home screen.")
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            self.present(loginVC, animated: true, completion: nil)
           // accountKit.logOut()
        }
        self.navigationController?.isNavigationBarHidden = true
        
    }
    func PrepareloginViewController(_loginViewController:AKFViewController)  {
        _loginViewController.delegate = self
        //_loginViewController.setAdvancedUIManager(nil)
        
        /*Basic theme with background*/
        
        _loginViewController.uiManager = AKFSkinManager(skinType: AKFSkinType.translucent, primaryColor:UIColor(red:0.02, green:0.67, blue:0.87, alpha:1.0), backgroundImage: UIImage(named: "saveuplogo.png"), backgroundTint: AKFBackgroundTint.black, tintIntensity: 0.70)
        
        _loginViewController.defaultCountryCode = "BD"
        /*
         //Customize the theme (Advance)
         let theme = AKFTheme.default()
         theme.headerBackgroundColor = UIColor(red: 0.4706, green: 0.7882, blue: 0, alpha: 1.0)
         theme.headerTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
         theme.iconColor = UIColor(red: 0.749, green: 0, blue: 0.2235, alpha: 1.0)
         theme.inputTextColor = UIColor(white: 0.4, alpha: 1.0)
         theme.statusBarStyle = .default
         theme.textColor = UIColor(white: 0.3, alpha: 1.0)
         theme.titleColor = UIColor(red: 0.749, green: 0, blue: 0.2235, alpha: 1.0)
         _loginViewController.setTheme(theme)
         */
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        // Resign keypads
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
    }
    
    @IBAction func btnGuestPressed(_ sender: UIButton) {
        self.view.makeToastActivity(.center)
        var rootVC : UIViewController?
        rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RootTabBarController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        UserDefaults.standard.set(true, forKey: AppConfig.UserdefaultKeys.GUEST_MODE)
    }
    
    
    @IBAction func loginButton(sender:UIButton ) {
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            if emailText.text?.count == 0 {
                
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
            else {
                
                loginButton.isEnabled = false
                
                self.view.hideToastActivity()
                self.view.makeToastActivity(.center)
                
                loginApi()
            }
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    func loginApi() {
        
        let myUrl = URL(string: String(format:"%@api/user_login", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "email=\(emailText.text!)&password=\(passwordText.text!)&lang=en"
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    self.loginButton.isEnabled = true
                    self.view.hideToastActivity()
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //print("Here\(json!)")
                    
                    self.loginButton.isEnabled = true
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["user_details"] as? [NSDictionary] {
                                
                                if reposArray.count != 0 {
                                    
                                    let userDict = reposArray[0]
                                    
                                    UserDefaults.standard.set(userDict.value(forKey: "user_id") as! NSInteger, forKey: "UserID")
                                    UserDefaults.standard.synchronize()
                                    
                                    UserDefaults.standard.set(userDict.value(forKey: "user_name") as! String, forKey: "UserName")
                                    UserDefaults.standard.synchronize()
                                    
                                    UserDefaults.standard.set(userDict.value(forKey: "user_image") as! String, forKey: "UserImage")
                                    UserDefaults.standard.synchronize()
                                    
                                    UserDefaults.standard.set(parseJSON.object(forKey: "cart_count") as! NSInteger, forKey: "CartCount")
                                    UserDefaults.standard.synchronize()
                                    
                                    UserDefaults.standard.set("AppInside", forKey: "AppStatus")
                                    UserDefaults.standard.synchronize()
                                    let objHome = self.storyboard?.instantiateViewController(withIdentifier: "RootTabBarController") as! RootTabBarController
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.window?.rootViewController = objHome
                                    
                                }
                            }
                        }
                        else {
                            
                            let alert = UIAlertController(title: "Login Error.", message: parseJSON.object(forKey: "message") as? String,preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { _ in
                                //Cancel Action
                            }))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                }
                catch {
                    
                    //print(error)
                    self.loginButton.isEnabled = true
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
    }
    
    @IBAction func forgotButton(sender:UIButton ) {
        
        let objForgot = self.storyboard!.instantiateViewController(withIdentifier: "ForgotViewController")
        self.present(objForgot, animated: true, completion: nil)
        //self.navigationController!.pushViewController(objForgot, animated: true)
    }
    
    @IBAction func registerButton(sender:UIButton ) {
        //login with Phone
        let inputState = UUID().uuidString
        let VC = accountKit.viewControllerForPhoneLogin(with: nil, state: inputState) as AKFViewController
        VC.enableSendToFacebook = true
        self.PrepareloginViewController(_loginViewController: VC)
        (VC as! UIViewController).modalPresentationStyle = .fullScreen
        self.present(VC as! UIViewController, animated: true, completion: nil)
        //        let objRegister = self.storyboard!.instantiateViewController(withIdentifier: "RegisterViewController")
        //        self.navigationController!.pushViewController(objRegister, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == emailText) {
            
            emailText.resignFirstResponder()
            passwordText.becomeFirstResponder()
        }
        else if (textField == passwordText) {
            
            passwordText.resignFirstResponder()
        }
        
        return true
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, email, picture.type(large)"]).start { (connection, result, error) -> Void in
            
            if (error == nil) {
                
                print(result as! NSDictionary)
                let json = result as! NSDictionary
                self.fbidString = json.object(forKey: "id") as! String?
                self.nameString = json.object(forKey: "first_name") as! String?
                
                if ((json.object(forKey: "email")) != nil) {
                    self.emailString = (json.object(forKey: "email") as? String)!
                }
                else {
                    self.emailString = ""
                }
                
                let reachability = Reachability()!
                
                if reachability.isReachable {
                    
                    // Make toast activity
                    self.view.hideToastActivity()
                    self.view.makeToastActivity(.center)
                    
                    self.facebookApi()
                }
                else {
                    
                    self.showNetworkErrorAlert()
                }
            }
            else {
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        FBSDKAccessToken.current()
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
    }
    
    //    MARK: Other Methods
    func configureFacebook()
    {
        facebookButton.readPermissions = ["public_profile", "email"];
        facebookButton.delegate = self
    }
    
    func facebookApi() {
        
        FBSDKAccessToken.current()
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
        
        let myUrl = URL(string: String(format:"%@api/facebook_login", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "name=\(nameString!)&email=\(emailString!)&facebook_id=\(fbidString!)&device_token=14t4ghyu676785t45g5&device_type=iOS&image=http://graph.facebook.com/\(fbidString!)/picture?type=large&lang=en"
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    //                    self.loginButton.isEnabled = true
                    self.view.hideToastActivity()
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //print("Here\(json!)")
                    
                    //                    self.loginButton.isEnabled = true
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["user_details"] as? [NSDictionary] {
                                
                                if reposArray.count != 0 {
                                    
                                    let userDict = reposArray[0]
                                    
                                    UserDefaults.standard.set(userDict.value(forKey: "user_id") as! NSInteger, forKey: "UserID")
                                    UserDefaults.standard.synchronize()
                                    
                                    UserDefaults.standard.set(userDict.value(forKey: "user_name") as! String, forKey: "UserName")
                                    UserDefaults.standard.synchronize()
                                    
                                    UserDefaults.standard.set(userDict.value(forKey: "user_image") as! String, forKey: "UserImage")
                                    UserDefaults.standard.synchronize()
                                    
                                    UserDefaults.standard.set(parseJSON.object(forKey: "cart_count") as! NSInteger, forKey: "CartCount")
                                    UserDefaults.standard.synchronize()
                                    
//                                    UserDefaults.standard.set("AppInside", forKey: "AppStatus")
//                                    UserDefaults.standard.synchronize()
//
//                                    let objHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//                                    self.navigationController?.pushViewController(objHome, animated: true)
                                    UserDefaults.standard.set("AppInside", forKey: "AppStatus")
                                    UserDefaults.standard.synchronize()
                                    let objHome = self.storyboard?.instantiateViewController(withIdentifier: "RootTabBarController") as! RootTabBarController
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.window?.rootViewController = objHome
                                }
                            }
                        }
                        else {
                            
                            self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
                        }
                    }
                }
                catch {
                    
                    //print(error)
                    //self.loginButton.isEnabled = true
                    self.view.hideToastActivity()
                }
            }
        })
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension UIViewController{
    func setAwsomeBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bgimg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
}
