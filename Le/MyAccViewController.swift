//
//  MyAccViewController.swift
//  Le
//
//  Created by Asif Seraje on 12/4/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit

class MyAccViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,EditProfileDelegate {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileOptionsTableView: UITableView!
    @IBOutlet weak var profileImg: YYAnimatedImageView!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelName: UILabel!
    
    var profileOptionsArray:[String]?
    var profileOptionsSubArray:[String]?
    let reachability = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileOptionsTableView.tableFooterView = UIView()
        profileOptionsArray = ["My Transactions"/*,"My Cart"*/,"My Wishlist","Change Password"]
        profileOptionsSubArray = ["View transactions and loyality points",/*"Show all cart items",*/"View all Wishlist items",""]
        self.profileOptionsTableView.delegate = self
        self.profileOptionsTableView.dataSource = self
        
        let editButton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        editButton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        editButton.setImage(UIImage(named: "edit-icon"), for: UIControl.State())
        editButton.addTarget(self, action: #selector(self.editAction(_:)), for: UIControl.Event.touchUpInside)
        
        let rightButton = UIBarButtonItem(customView: editButton)
        //self.navigationItem.rightBarButtonItem = rightButton
        profileImg.layer.borderColor = UIColor.systemTeal.cgColor
        profileImg.layer.borderWidth = 0.5
        if reachability.isReachable {
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            myaccountApi()
        }
        else{
            showNetworkErrorAlert()
        }
        
    }
    
    @objc func editAction(_ sender: UIButton!) {
        
        let objEdit = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        objEdit.editProfileDelegate = self
        self.navigationController?.pushViewController(objEdit, animated: true)
    }
    
    func myaccountApi() {
        
        let myUrl = URL(string: String(format:"%@api/my_account", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&lang=en"
        }else{
            postString = "lang=en"
        }
        
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
                                    
                                    self.profileImg.layer.cornerRadius = self.profileImg.frame.size.width / 2
                                    self.profileImg.yy_imageURL = URL(string: reposArray[0].object(forKey: "user_image") as! String)
                                    UserDefaults.standard.set(reposArray[0].object(forKey: "user_image") as! String, forKey: "UserImage")
                                    UserDefaults.standard.synchronize()
                                    
                                    self.labelName.text = reposArray[0].object(forKey: "user_name") as? String
                                    UserDefaults.standard.set(reposArray[0].object(forKey: "user_name") as? String, forKey: "UserName")
                                    UserDefaults.standard.synchronize()
                                    
                                    self.labelPhoneNumber.text = reposArray[0].object(forKey: "user_phone") as? String
                                    self.labelEmail.text = reposArray[0].object(forKey: "user_email") as? String
                                }
                            }
                            
                            if let reposArray = parseJSON.object(forKey: "shipping_details") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    //self.shippingLabel.text = String(format:"%@\n%@\n%@\n%@\n%@\n%@\n%@", (reposArray[0].object(forKey: "ship_name") as? String)!, (reposArray[0].object(forKey: "ship_address1") as? String)!, (reposArray[0].object(forKey: "ship_address2") as? String)!, (reposArray[0].object(forKey: "ship_city_name") as? String)!, (reposArray[0].object(forKey: "ship_state") as? String)!, (reposArray[0].object(forKey: "ship_postalcode") as? String)!, (reposArray[0].object(forKey: "ship_phone") as? String)!)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileOptionsArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let accountCell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath)
        accountCell.textLabel?.text = profileOptionsArray?[indexPath.row]
        accountCell.detailTextLabel?.text = profileOptionsSubArray?[indexPath.row]
        return accountCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0://voucher
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TransactionsViewController" ) as! TransactionsViewController
            //vc.cameFromMyAcc = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
//        case 1://cart
//            let objMyCart = self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
//            objMyCart.screen_value = ""
//            self.navigationController?.pushViewController(objMyCart, animated: true)
//            return
        case 1://wishlist
            let objMyWishlist = self.storyboard?.instantiateViewController(withIdentifier: "FWishListTableViewController") as! FWishListTableViewController
            self.navigationController?.pushViewController(objMyWishlist, animated: true)
            return
        case 2://change password
            let objPassword = self.storyboard?.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
            self.navigationController?.pushViewController(objPassword, animated: true)
            return
        default:
            return
        }
    }

}
