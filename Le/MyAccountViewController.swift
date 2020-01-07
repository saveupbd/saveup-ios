//
//  MyAccountViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 26/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController, EditProfileDelegate {

    @IBOutlet weak var profileScroll : UIScrollView!
    @IBOutlet weak var profileView : UIView!
    @IBOutlet weak var profileImage : YYAnimatedImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var mobileLabel : UILabel!
    @IBOutlet weak var emailLabel : UILabel!
    @IBOutlet weak var shippingLabel : UILabel!
    @IBOutlet weak var ordersButton : UIButton!
    @IBOutlet weak var passwordButton : UIButton!
    @IBOutlet weak var mywishlistButton : UIButton!
    @IBOutlet weak var mycartButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "My Account"
        
        if revealViewController() != nil {
            
            let rightRevealButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu")!, style: .done, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.navigationItem.leftBarButtonItem = rightRevealButtonItem
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        let editButton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        editButton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        editButton.setImage(UIImage(named: "edit-icon"), for: UIControl.State())
        editButton.addTarget(self, action: #selector(MyAccountViewController.editAction(_:)), for: UIControl.Event.touchUpInside)
        
        let rightButton = UIBarButtonItem(customView: editButton)
        self.navigationItem.rightBarButtonItem = rightButton
        
        profileScroll.contentSize = CGSize(width:UIScreen.main.bounds.size.width, height:800)
        
        let color1 = UIColor(red: 25.0/255.0, green:39.0/255.0, blue: 63.0/255.0, alpha: 1.0).cgColor
        let color2 = UIColor(red: 44.0/255.0, green: 61.0/255.0, blue: 94.0/255.0, alpha: 1.0).cgColor
        let color3 = UIColor(red: 25.0/255.0, green:39.0/255.0, blue: 63.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color1, color2, color3]
        gradientLayer.frame = profileView.bounds
        profileView.layer.addSublayer(gradientLayer)
        
        profileView.addSubview(profileImage)
        profileView.addSubview(nameLabel)
        profileView.addSubview(mobileLabel)
        profileView.addSubview(emailLabel)
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            myaccountApi()
        }
        else {
            
            showNetworkErrorAlert()
        }
    }

    @objc func editAction(_ sender: UIButton!) {
        
        let objEdit = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        objEdit.editProfileDelegate = self
        self.navigationController?.pushViewController(objEdit, animated: true)
    }
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.black
        style.messageAlignment = .center
        style.backgroundColor = UIColor.white
        
        self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    
    func myaccountApi() {
        
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
                            
                            if let reposArray = parseJSON.object(forKey: "user_details") as? [NSDictionary] {
                                // 5
                                print(reposArray)
                                if reposArray.count != 0 {
                                    
                                    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
                                    self.profileImage.yy_imageURL = URL(string: reposArray[0].object(forKey: "user_image") as! String)
                                    UserDefaults.standard.set(reposArray[0].object(forKey: "user_image") as! String, forKey: "UserImage")
                                    UserDefaults.standard.synchronize()
                                    
                                    self.nameLabel.text = reposArray[0].object(forKey: "user_name") as? String
                                    UserDefaults.standard.set(reposArray[0].object(forKey: "user_name") as? String, forKey: "UserName")
                                    UserDefaults.standard.synchronize()
                                    
                                    self.mobileLabel.text = reposArray[0].object(forKey: "user_phone") as? String
                                    self.emailLabel.text = reposArray[0].object(forKey: "user_email") as? String
                                }
                            }
                            
                            if let reposArray = parseJSON.object(forKey: "shipping_details") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    self.shippingLabel.text = String(format:"%@\n%@\n%@\n%@\n%@\n%@\n%@", (reposArray[0].object(forKey: "ship_name") as? String)!, (reposArray[0].object(forKey: "ship_address1") as? String)!, (reposArray[0].object(forKey: "ship_address2") as? String)!, (reposArray[0].object(forKey: "ship_city_name") as? String)!, (reposArray[0].object(forKey: "ship_state") as? String)!, (reposArray[0].object(forKey: "ship_postalcode") as? String)!, (reposArray[0].object(forKey: "ship_phone") as? String)!)
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
    
    @IBAction func ordersButton(sender:UIButton ) {
        
//        let objMyOrders = self.storyboard?.instantiateViewController(withIdentifier: "MyOrdersViewController") as! MyOrdersViewController
//        self.navigationController?.pushViewController(objMyOrders, animated: true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyOrdersViewController" ) as! MyOrdersViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    @IBAction func mycartButton(sender:UIButton ) {
        
        let objMyCart = self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        objMyCart.screen_value = ""
        self.navigationController?.pushViewController(objMyCart, animated: true)
    }
    
    @IBAction func passwordButton(sender:UIButton ) {
        
        let objPassword = self.storyboard?.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
        self.navigationController?.pushViewController(objPassword, animated: true)
    }
   
    @IBAction func mywishlistButton(sender:UIButton ) {
        
        let objMyWishlist = self.storyboard?.instantiateViewController(withIdentifier: "FWishListTableViewController") as! FWishListTableViewController
        self.navigationController?.pushViewController(objMyWishlist, animated: true)
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
