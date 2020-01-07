//
//  MenuViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 02/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuTable : UITableView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var userImage : YYAnimatedImageView!
    @IBOutlet weak var storeButton : UIButton!
    @IBOutlet weak var nearmeButton : UIButton!
    @IBOutlet weak var myaccountButton : UIButton!
    @IBOutlet weak var mycartButton : UIButton!
    @IBOutlet weak var logoutButton : UIButton!
    @IBOutlet weak var homeButton : UIButton!
    
    var categoryArray : NSMutableArray = []
    var countArray : NSMutableArray = []
    
    var main_category_id: String! = ""
    var sec_category_id: String! = ""
    var sub_category_id: String! = ""
    var sub_sec_category_id: String! = ""
    var category_name: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        
       // categoryArray.addObjects(from: UserDefaults.standard.object(forKey: "Categories") as! [Any])
        //print(categoryArray)
        for i in 0..<categoryArray.count {
            
            let d = categoryArray[i] as! NSDictionary
            if (d.value(forKey: "sub_category_list") != nil) {
                let ar = d["sub_category_list"] as? [NSDictionary]
                if ar?.count == 0 {
                    
                    countArray.add("0")
                }
                else {
                    countArray.add("1")
                }
            }
            else {
                countArray.add("0")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userImage.yy_imageURL = URL(string: UserDefaults.standard.object(forKey: "UserImage") as! String)
        
        nameLabel.text = String(format: "Hi %@!", UserDefaults.standard.object(forKey: "UserName") as! String)
    }
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.white
        style.messageAlignment = .center
        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        
        self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    
//    func categoryApi() {
//        
//        // 1
//        let reposURL = NSURL(string: String(format:"%@api/category_list", Api_Base_URL))
//        // 2
//        if let JSONData = NSData(contentsOf: reposURL! as URL) {
//            // 3
//            if let json = (try? JSONSerialization.jsonObject(with: JSONData as Data, options: [])) as? NSDictionary {
//                //print(json)
//                // 4
//                if let reposArray = json["categories_list"] as? [NSDictionary] {
//                    // 5
//                    if reposArray.count == 0 {
//                        
//                    }
//                    else {
//                        categoryArray.addObjects(from: reposArray)
//                    }
//                    menuTable!.reloadData()
//                    self.view.hideToastActivity()
//                }
//            }
//        }
//    }
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 0 //1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0 //categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CustomCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
        
//        if (categoryArray[indexPath.row] as! NSDictionary).object(forKey: "level") as! Int == 1 {
//
//            cell.menuLabel.text = String(format: "   %@", ((categoryArray[indexPath.row] as! NSDictionary).object(forKey: "category_name") as! String?)!)
//        }
//        else if (categoryArray[indexPath.row] as! NSDictionary).object(forKey: "level") as! Int == 2 {
//
//            cell.menuLabel.text = String(format: "      %@", ((categoryArray[indexPath.row] as! NSDictionary).object(forKey: "category_name") as! String?)!)
//        }
//        else if (categoryArray[indexPath.row] as! NSDictionary).object(forKey: "level") as! Int == 3 {
//
//            cell.menuLabel.text = String(format: "         %@", ((categoryArray[indexPath.row] as! NSDictionary).object(forKey: "category_name") as! String?)!)
//        }
//        else {
//
//            cell.menuLabel.text = (categoryArray[indexPath.row] as! NSDictionary).object(forKey: "category_name") as! String?
//        }
//
//        if countArray[indexPath.row] as! String == "1" {
//
//            cell.tableImage.isHidden = false
//            cell.tableImage.image = UIImage(named: "menu-plus")
//        }
//        else if countArray[indexPath.row] as! String == "2" {
//
//            cell.tableImage.isHidden = false
//            cell.tableImage.image = UIImage(named: "menu-minus")
//        }
//        else {
//
//            cell.tableImage.isHidden = true
//        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if (categoryArray[indexPath.row] as! NSDictionary).object(forKey: "level") as! Int == 0 {
//
//            main_category_id = String(format: "%d", ((categoryArray[indexPath.row] as! NSDictionary).object(forKey: "category_id") as! NSInteger?)!)
//            category_name = (categoryArray[indexPath.row] as! NSDictionary).object(forKey: "category_name") as! String?
//        }
//        else if (categoryArray[indexPath.row] as! NSDictionary).object(forKey: "level") as! Int == 1 {
//
//            sec_category_id = String(format: "%d", ((categoryArray[indexPath.row] as! NSDictionary).object(forKey: "category_id") as! NSInteger?)!)
//            category_name = (categoryArray[indexPath.row] as! NSDictionary).object(forKey: "category_name") as! String?
//        }
//        else if (categoryArray[indexPath.row] as! NSDictionary).object(forKey: "level") as! Int == 2 {
//
//            sub_category_id = String(format: "%d", ((categoryArray[indexPath.row] as! NSDictionary).object(forKey: "category_id") as! NSInteger?)!)
//            category_name = (categoryArray[indexPath.row] as! NSDictionary).object(forKey: "category_name") as! String?
//        }
//        else if (categoryArray[indexPath.row] as! NSDictionary).object(forKey: "level") as! Int == 3 {
//
//            sub_sec_category_id = String(format: "%d", ((categoryArray[indexPath.row] as! NSDictionary).object(forKey: "category_id") as! NSInteger?)!)
//            category_name = (categoryArray[indexPath.row] as! NSDictionary).object(forKey: "category_name") as! String?
//        }
//
//        tableView.deselectRow(at: indexPath, animated: true)
//        let d = categoryArray[indexPath.row] as! NSDictionary
//        if (d.value(forKey: "sub_category_list") != nil) {
//            let ar = d["sub_category_list"] as? [NSDictionary]
//            if ar?.count == 0 {
//
//                let revealController: SWRevealViewController = self.revealViewController()
//                //let frontNavigationController: UINavigationController = (revealController.frontViewController as AnyObject) as! UINavigationController
//
//                //if !(frontNavigationController.topViewController! is ProductViewController) {
//
//                    let objProduct = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
//                    let navigationController: UINavigationController = UINavigationController(rootViewController: objProduct)
//                    objProduct.main_category_id = main_category_id
//                    objProduct.sec_category_id = sec_category_id
//                    objProduct.sub_category_id = sub_category_id
//                    objProduct.sub_sec_category_id = sub_sec_category_id
//                    objProduct.category_name = category_name
//                    objProduct.screenString = "Menu"
//                    revealController.pushFrontViewController(navigationController, animated: true)
//                //}
//                //else {
//                //    revealController.revealToggle(self)
//                //}
//            }
//            else {
//
//                var isAlreadyInserted: Bool = false
//                for dInner in ar! {
//                    let index: Int = (categoryArray as NSArray).indexOfObjectIdentical(to: dInner)
//                    isAlreadyInserted = (index > 0 && index != NSIntegerMax)
//                    if isAlreadyInserted {
//                        break
//                    }
//                }
//                if isAlreadyInserted {
//                    miniMizeThisRows(ar!)
//                    countArray.replaceObject(at: indexPath.row, with: "1")
//                }
//                else {
//                    countArray.replaceObject(at: indexPath.row, with: "2")
//                    var count: Int = indexPath.row + 1
//                    var arCells = [Any]()
//                    for dInner in ar! {
//                        arCells.append(IndexPath(row: count, section: 0))
//                        categoryArray.insert(dInner, at: count)
//                        let d = categoryArray[count] as! NSDictionary
//                        if (d.value(forKey: "sub_category_list") != nil) {
//                            let ar = d["sub_category_list"] as? [NSDictionary]
//                            if ar?.count == 0 {
//
//                                countArray.insert("0", at: count)
//                            }
//                            else {
//                                countArray.insert("1", at: count)
//                            }
//                        }
//                        else {
//                            countArray.insert("0", at: count)
//                        }
//                        count = count + 1
//                    }
//                    tableView.insertRows(at: arCells as! [IndexPath], with: .left)
//                    menuTable.reloadData()
//                }
//            }
//        }
//        else {
//
//            let revealController: SWRevealViewController = self.revealViewController()
//            //let frontNavigationController: UINavigationController = (revealController.frontViewController as AnyObject) as! UINavigationController
//
//            //if !(frontNavigationController.topViewController! is ProductViewController) {
//
//                let objProduct = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
//                let navigationController: UINavigationController = UINavigationController(rootViewController: objProduct)
//                objProduct.main_category_id = main_category_id
//                objProduct.sec_category_id = sec_category_id
//                objProduct.sub_category_id = sub_category_id
//                objProduct.sub_sec_category_id = sub_sec_category_id
//                objProduct.category_name = category_name
//                objProduct.screenString = "Menu"
//                revealController.pushFrontViewController(navigationController, animated: true)
//            //}
//            //else {
//            //    revealController.revealToggle(self)
//            //}
//        }
    }
    
    func miniMizeThisRows(_ ar: [Any]) {
        
        for dInner in ar {
            let indexToRemove: Int = (categoryArray as NSArray).indexOfObjectIdentical(to: dInner)
            let arInner: [Any]? = ((dInner as AnyObject).value(forKey: "sub_category_list") as? [Any])
            if (arInner != nil) && (arInner?.count)! > 0 {
                miniMizeThisRows(arInner!)
            }
            if (categoryArray as NSArray).indexOfObjectIdentical(to: dInner) != NSNotFound {
                categoryArray.removeObject(identicalTo: dInner)
                countArray.removeObject(at: indexToRemove)
                menuTable.deleteRows(at: [IndexPath(row: indexToRemove, section: 0)], with: .right)
                menuTable.reloadData()
            }
        }
    }
    
    @IBAction func homeButton(sender:UIButton ) {
        
        let revealController: SWRevealViewController = self.revealViewController()
        
        let objHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let navigationController: UINavigationController = UINavigationController(rootViewController: objHome)
        revealController.pushFrontViewController(navigationController, animated: true)
    }
    
    @IBAction func storeButton(sender:UIButton ) {
        
        let revealController: SWRevealViewController = self.revealViewController()
        
        let objStores = self.storyboard?.instantiateViewController(withIdentifier: "StoresViewController") as! StoresViewController
        let navigationController: UINavigationController = UINavigationController(rootViewController: objStores)
        revealController.pushFrontViewController(navigationController, animated: true)
    }
    
    @IBAction func nearmeButton(sender:UIButton ) {
        
        let revealController: SWRevealViewController = self.revealViewController()
        
        let objNearme = self.storyboard?.instantiateViewController(withIdentifier: "NearmeViewController") as! NearmeViewController
        let navigationController: UINavigationController = UINavigationController(rootViewController: objNearme)
        revealController.pushFrontViewController(navigationController, animated: true)
    }
    
    @IBAction func myaccountButton(sender:UIButton ) {
        
        let revealController: SWRevealViewController = self.revealViewController()
        
        let objMyAccount = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
        let navigationController: UINavigationController = UINavigationController(rootViewController: objMyAccount)
        revealController.pushFrontViewController(navigationController, animated: true)
    }
    
    
    @IBAction func helpButton(_ sender: Any) {
        let revealController: SWRevealViewController = self.revealViewController()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HelpVc") as! HelpVc
        let navigationController: UINavigationController = UINavigationController(rootViewController: vc)
        revealController.pushFrontViewController(navigationController, animated: true)
    }
    
    
    @IBAction func mycartButton(sender:UIButton ) {
        
        let revealController: SWRevealViewController = self.revealViewController()
        
        let objMyCart = self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        let navigationController: UINavigationController = UINavigationController(rootViewController: objMyCart)
        objMyCart.screen_value = "Menu"
        revealController.pushFrontViewController(navigationController, animated: true)
    }
    
    @IBAction func logoutButton(sender:UIButton ) {
        
        UserDefaults.standard.removeObject(forKey: "AppStatus")
        UserDefaults.standard.synchronize()
        
        let revealController: SWRevealViewController = self.revealViewController()
        
        let objLogin = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
        let navigationController: UINavigationController = UINavigationController(rootViewController: objLogin)
        revealController.pushFrontViewController(navigationController, animated: true)
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
