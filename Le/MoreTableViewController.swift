//
//  MoreTableViewController.swift
//  Le
//
//  Created by Asif Seraje on 11/2/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {
    var moreOptions:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "More Options"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let buildString = "Version: \(appVersion ?? ""); Build: \(build ?? "")"
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            print("No need to show floating button")
            moreOptions = ["My Account", "How To Use App", "Help","Log Out",buildString]
        }else{
            self.setupFloatingButton()
            moreOptions = ["How To Use App","Help",buildString]
        }
        tableView.tableFooterView = UIView()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return moreOptions!.count
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let profileCell = tableView.dequeueReusableCell(withIdentifier: "profileImageCell", for: indexPath) as? MoreImageTableViewCell
            if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
                profileCell?.profileImage.yy_imageURL = URL(string: UserDefaults.standard.object(forKey: "UserImage") as! String)
                profileCell?.profileNameLabel.text = String(format: UserDefaults.standard.object(forKey: "UserName") as! String)
            }else{
                profileCell?.profileImage.image = UIImage(named: "no-image-icon")
                profileCell?.profileNameLabel.text = "No User Info Available"
            }
            return profileCell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath)
            cell.textLabel?.text = moreOptions?[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            if indexPath.section == 0{
                return
            }else{//["My Account", "How to use", "Help","Log Out",buildString]
                switch indexPath.row {
                case 0:
                    let theViewController = self.storyboard!.instantiateViewController(withIdentifier: "MyAccViewController")
                    self.navigationController!.pushViewController(theViewController, animated: true)
                    return
                case 1:
                    let theViewController = self.storyboard!.instantiateViewController(withIdentifier: "HowToUseViewController")
                    self.navigationController!.pushViewController(theViewController, animated: true)
                    return
                case 2:
                    let theViewController = self.storyboard!.instantiateViewController(withIdentifier: "HelpVc")
                    self.navigationController!.pushViewController(theViewController, animated: true)
                    return
                case 3:
                    let alert = UIAlertController(title: "Log Out", message: "Are you sure to Log Out from app?", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler:{ (ACTION :UIAlertAction!)in
                        let theViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
                        theViewController.modalPresentationStyle = .fullScreen
                        self.present(theViewController, animated: true, completion: nil)
                        UserDefaults.standard.removeObject(forKey: "AppStatus")
                        UserDefaults.standard.removeObject(forKey: "productId")
                        UserDefaults.standard.removeObject(forKey: "merchant_id")
                        UserDefaults.standard.removeObject(forKey: "phoneNumber")
                        UserDefaults.standard.removeObject(forKey: "UserID")
                        UserDefaults.standard.removeObject(forKey: "UserName")
                        UserDefaults.standard.removeObject(forKey: "UserImage")
                        UserDefaults.standard.removeObject(forKey: "CartCount")
                        UserDefaults.standard.synchronize()
                        
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{ (ACTION :UIAlertAction!)in
                        return
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                default:
                    return
                }
            }
        }else{//["How To Use App","Help",buildString]
            if indexPath.section == 0{
                return
            }else{
                switch indexPath.row {
                
                case 0:
                    let theViewController = self.storyboard!.instantiateViewController(withIdentifier: "HowToUseViewController")
                    self.navigationController!.pushViewController(theViewController, animated: true)
                    return
                case 1:
                    let theViewController = self.storyboard!.instantiateViewController(withIdentifier: "HelpVc")
                    self.navigationController!.pushViewController(theViewController, animated: true)
                    return
                default:
                    return
                }
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 240
        }else{
            return 55
        }
    }
    
    var floatButton = UIButton(type: .custom)
    func setupFloatingButton(){
        floatButton.frame = CGRect(x: 0, y: (tabBarController?.tabBar.frame.minY)! - 60 , width: self.view.frame.width/2.0, height: 50)
        floatButton.setTitle("Log In", for: .normal)
        floatButton.backgroundColor = UIColor(named: "appThemeColor")
        //floatButton.setImage(UIImage(named: "tick-icon"), for: .normal)
        floatButton.layer.shadowColor = UIColor.black.cgColor
        floatButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        floatButton.layer.masksToBounds = false
        floatButton.layer.shadowRadius = 2.0
        floatButton.layer.shadowOpacity = 0.5
        floatButton.layer.cornerRadius = 5
        floatButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        floatButton.layer.borderWidth = 0.8
        floatButton.center.x = self.view.center.x
        floatButton.addTarget(self,action: #selector(doThisWhenButtonIsTapped(_:)), for: .touchUpInside)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(floatButton)
        }
    }
    
    @IBAction private func doThisWhenButtonIsTapped(_ sender: Any) {
        self.floatButton.removeFromSuperview()
        let theViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        theViewController.modalPresentationStyle = .fullScreen
        self.present(theViewController, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard floatButton.superview != nil else {  return }
        DispatchQueue.main.async {
            self.floatButton.removeFromSuperview()
        }
    }

}
