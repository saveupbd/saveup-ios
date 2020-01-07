//
//  SubViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 10/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class SubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //@IBOutlet weak var subTable : UITableView!
    @IBOutlet weak var topoffersTable : UITableView!
    @IBOutlet weak var popularTable : UITableView!
    //@IBOutlet weak var secondaryTable : UITableView!
    @IBOutlet weak var bottomImage : UIImageView!
    @IBOutlet weak var popularAllButton : UIButton!
    //@IBOutlet weak var bannerImage : UIImageView!
    //@IBOutlet weak var adTable : UITableView!
    @IBOutlet weak var footerView : UIView!
    //@IBOutlet weak var headerView : UIView!
    
    var topOffersArray = [TopOffers]()
    var popularArray = [Popular]()
    var secondaryArray = [SecondayCategory]()
    var submoduleArray = [SubModule]()
    var bannersArray = [BannersHome]()
    var adimagesArray = [AdImages]()
    
    var parent_category_id: String!
    var parent_category_name: String!
    var sec_category_id: String!
    
    var isFirstStarted: Bool = false
    var totalFirstCount: Int = 0
    var currentFirst: Int = 0
    
    var BANNER_Y_AXIX = CGFloat()
    
    var flag: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mycartApi()
        
        print(parent_category_id!)
        print(parent_category_name!)
        sec_category_id = parent_category_id
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        let img = UIImageView(image: UIImage(named: "header-logo"))
        self.navigationItem.titleView = img
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(SubViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
       // self.navigationItem.leftBarButtonItem = LeftButton
//        secondaryTable.isHidden = true
//        adTable.isHidden = true
        topoffersTable.isHidden = true
        
        //BANNER_Y_AXIX = self.bannerImage.frame.minY
        
        let rotateTable1 = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi / 2))
//        secondaryTable.transform = rotateTable1
//        secondaryTable.frame = CGRect(x: CGFloat(0), y: CGFloat(330), width: CGFloat(secondaryTable.frame.size.height), height: CGFloat(secondaryTable.frame.size.width))
        
//        subTable.transform = rotateTable1
//        subTable.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(subTable.frame.size.height), height: CGFloat(subTable.frame.size.width))
//
//        adTable.transform = rotateTable1
//        adTable.frame = CGRect(x: CGFloat(0), y: CGFloat(220), width: CGFloat(adTable.frame.size.height), height: CGFloat(adTable.frame.size.width))
        
        popularTable.layer.cornerRadius = 5
        popularTable.layer.borderWidth = 0.5
        popularTable.layer.borderColor = UIColor(red: 230.0/255.0, green:230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            subcategoryApi()
        //    subcategoryApiOne()
        }
        else {
            self.showNetworkErrorAlert()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mycartApi()
        let cartButton   = MIBadgeButton()
        cartButton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        cartButton.setImage(UIImage(named: "cart-icon"), for: UIControl.State())
        cartButton.addTarget(self, action: #selector(SubViewController.cartAction(_:)), for: UIControl.Event.touchUpInside)
       // cartButton.badgeString = String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
//        if UserDefaults.standard.bool(forKey: "CartCount") == false {
//            print("Cart is  empty-----")
//        } else {
//            print("I am not empty")
//            cartButton.badgeString = String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
//            UserDefaults.standard.removeObject(forKey: "CartCount")
//        }
        cartButton.badgeTextColor = UIColor.white
        
        let rightButton = UIBarButtonItem(customView: cartButton)
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    //for cart update
    func mycartApi() {
        
        let myUrl = URL(string: String(format:"%@api/cart_list", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
             postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&lang=en"
        }else{
            postString = "lang=en"
        }
        
        print(postString)
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
                            
                            if let reposArray = parseJSON.object(forKey: "cart_details") as? [NSDictionary] {
                                // 5
                                print(reposArray)
                                
                                let cartNumber = (parseJSON.object(forKey: "cart_count") as? NSInteger)
                                print("I am giving you the cart amount -- \(cartNumber ??  0 )")
                                let cartValue = "\(cartNumber ?? 0 )"
                                
                                
                                let cartButton  = MIBadgeButton()
                                cartButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                                cartButton.setImage(UIImage(named: "cart-icon"), for: UIControl.State())
                                cartButton.addTarget(self, action: #selector(HomeViewController.cartAction(_:)), for: UIControl.Event.touchUpInside)
                                
                                cartButton.badgeString = "\(cartValue)" //String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
                                cartButton.badgeTextColor = UIColor.white
                                
                                //label
                                let rightButton = UIBarButtonItem(customView: cartButton)
                                self.navigationItem.rightBarButtonItem = rightButton

                            }
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

    
    
    //end
    
    override func viewDidAppear(_ animated: Bool) {
        //         BANNER_Y_AXIX = self.bannerImage.frame.minY
        //        canHideBanner()
    }
    
    @objc func backAction(_ sender: UIButton!) {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    @objc func cartAction(_ sender: UIButton!) {
        if (UserDefaults.standard.object(forKey: "UserID") != nil){
            let objMyCart = self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
            objMyCart.screen_value = ""
            self.navigationController?.pushViewController(objMyCart, animated: true)
        }else{
            let alert = UIAlertController(title: "Error", message: "You need to login to access this feature", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler:{ (ACTION :UIAlertAction!)in
                self.dismiss(animated: true, completion: nil)
                
            }))
            alert.addAction(UIAlertAction(title: "Log In", style: UIAlertAction.Style.default, handler:{ (ACTION :UIAlertAction!)in
                self.dismiss(animated: true, completion: nil)
                let theViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
                theViewController.modalPresentationStyle = .fullScreen
                self.present(theViewController, animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    }
    
    func subcategoryApi() {
        
        let myUrl = URL(string: String(format:"%@api/product_list_by_category", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "main_category_id=\(sec_category_id!)"  //&main_category_id=\(sec_category_id!)//&sec_category_id=\(sec_category_id!)&lang=en
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
                    print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    self.topoffersTable.isHidden = false
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                      
                  
                            
                            if let reposArray = parseJSON["categories_list"] as? [NSDictionary] {
                                
                            
                                
                                //                    "main_category_id": 1,
                                //                    "main_category_name": "FOOD",
                                //                    "main_category_image": "https://saveupbd.com/storage/category/March2019/XGdbamXsxC1UlgIV2bYm.png",
                                //                    "main_category_status": 1,
                                
                                
                
                                if self.flag {
                                    let localObject = SubModule()
                                    localObject.pushData(sec_category_id:"\(String(describing: self.parent_category_id))", sec_category_name: self.parent_category_name)
                                    
                                    print("after inserting \(localObject.sec_category_name)")
                                    
                                    self.submoduleArray.append(localObject)
                                
                              
                                
                                
                                // 5
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        
                                        if let reposArray1 = item["sec_maincategory_list"] as? [NSDictionary] {
                                            
                                            if reposArray1.count != 0 {
                                                print(reposArray1.count)
                                                for item1 in reposArray1 {
                                                    
                                                    self.submoduleArray.append(SubModule(SubModule: item1))
                                              

                                                    //print(self.sec_category_id)
                                                    
                                                    if String((item1["sec_category_id"] as? Int)!) == self.sec_category_id {
                                                        
                                                        if let reposArray2 = item1["sub_category_list"] as? [NSDictionary] {
                                                            
                                                            if reposArray2.count != 0 {
                                                                
                                                                for item2 in reposArray2 {
                                                                    
                                                                       self.secondaryArray.append(SecondayCategory(SecondayCategory: item2))
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                self.flag = false
                                }
                                
                            self.toggleStatus()
                                print("here is the submodule array after array--\(self.submoduleArray.count)")

//
                                if self.secondaryArray.count == 0 {

//                                    self.secondaryTable.isHidden = true
//                                    self.headerView.frame = CGRect(x: CGFloat(self.headerView.frame.origin.x), y: CGFloat(self.headerView.frame.origin.y), width: CGFloat(self.headerView.frame.size.width), height: CGFloat(50))
//                                    self.topoffersTable.tableHeaderView = self.headerView
                                }
                                else {
//                                    self.secondaryTable.isHidden = false
//                                    self.headerView.frame = CGRect(x: CGFloat(self.headerView.frame.origin.x), y: CGFloat(self.headerView.frame.origin.y), width: CGFloat(self.headerView.frame.size.width), height: CGFloat(50))
//                                    self.topoffersTable.tableHeaderView = self.headerView
                                }

                               //self.subTable.reloadData()
                                //self.secondaryTable.reloadData()
                                self.topoffersTable.reloadData()
                            }
                            
                            
                            
                            if let reposArray = parseJSON["product_top_offer"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    //  self.messageToast(messageStr: "No deals available")
                                    
                                    
                                }
                                else {
                                    for item in reposArray {
                                        self.topOffersArray.append(TopOffers(TopOffers: item))
                                    }
                                }
                                self.topoffersTable.reloadData()
                            }
                            
                            
                        }
                        else{

                            self.toggleStatus()

//                            self.subTable.reloadData()
//                            self.secondaryTable.reloadData()
                            self.topoffersTable.reloadData()
                            
                            var style = ToastStyle()
                            style.messageFont = messageFont!
                            style.messageColor = UIColor.white
                            style.messageAlignment = .center
                            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                            
                            self.view.makeToast("No Data Available!", duration: 3.0, position: .center, style: style)
                        }
     
                        
                    }
                    self.view.hideToastActivity()
                }
                catch {
                    
                    //print(error)
                    self.view.hideToastActivity()
                }
            }
        })
        task.resume()
    }
    
    
    
    func toggleStatus(){
        print("here is the submodule array--\(self.submoduleArray.count)")
        
        //
        if self.submoduleArray.count != 0 {
            
            for i in 0..<self.submoduleArray.count {
                
                if self.submoduleArray[i].sec_category_id == self.sec_category_id {
                    self.submoduleArray[i].selected_value = "1"
                }
                else {
                    self.submoduleArray[i].selected_value = "0"
                }
            }
        }
    }
    
    
    
    
    
    func setBannerImages(_ bannerArray: [BannersHome]) {
        
        totalFirstCount = bannerArray.count
        if totalFirstCount == 1 {
            //bannerImage.kf.setImage(with: StringToURL(text: bannerArray[0].banner_image))
            //bannerImage.yy_imageURL = URL(string: bannerArray[0].banner_image)
        }
        else if !isFirstStarted && (totalFirstCount > 1) {
            isFirstStarted = true
            totalFirstCount = 0
            self.perform(#selector(self.setImage), with: bannerArray, afterDelay: 0.0)
        }
    }
    
     @objc func setImage(_ thumbArray: [BannersHome]) {
        
        if currentFirst == thumbArray.count {
            currentFirst = 0
        }
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.fade
        //bannerImage.layer.add(transition, forKey: kCATransition)
        //bannerImage.kf.setImage(with: StringToURL(text: thumbArray[currentFirst].banner_image))
        //bannerImage.yy_imageURL = URL(string: thumbArray[currentFirst].banner_image)
        currentFirst += 1
        self.perform(#selector(self.setImage), with: thumbArray, afterDelay: 3.0)
    }
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.white
        style.messageAlignment = .center
        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        
        self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == popularTable {
            
            if indexPath.row == 1 {
                return 209
            }
            else {
                return 210
            }
        }
//        else if tableView == secondaryTable {
//            return 130
//        }
//        else if tableView == adTable {
//            return 110
//        }
//        else if tableView == subTable {
//
//            if submoduleArray.count > 3 {
//
//                return UIScreen.main.bounds.size.width / 3
//            }
//            else {
//
//                let divide = CGFloat(submoduleArray.count)
//                return UIScreen.main.bounds.size.width / divide
//            }
//        }
        else {
            
            return 220
        }
    }
    
    // Customize the number of rows in the table view.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == popularTable {
            var devide: Int = popularArray.count / 2
            if popularArray.count % 2 > 0 {
                devide += 1
            }
            return devide
        }
//        else if tableView == secondaryTable {
//
//            return secondaryArray.count
//        }
//        else if tableView == adTable {
//
//            return adimagesArray.count
//        }
//        else if tableView == subTable {
//
//            return submoduleArray.count
//        }
        else {
            var devide: Int = topOffersArray.count / 2
            if topOffersArray.count % 2 > 0 {
                devide += 1
            }
            return devide
        }
    }
    // Customize the appearance of table view cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == popularTable {
            
            let cellIdentifier = "SubCategoryTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SubCategoryTableViewCell
//
//            var xyz = Int(indexPath.row)
//            xyz = xyz * 2
//
//            //cell.popularImage1.yy_imageURL = URL(string: popularArray[xyz].product_image)
//            cell.popularImage1.kf.setImage(with: StringToURL(text: popularArray[xyz].product_image))
//            cell.popularTitleLabel1.text = popularArray[xyz].product_title
//            cell.popularPriceLabel1.text = String(format:"%@%@", popularArray[xyz].currency_symbol, popularArray[xyz].product_price)
//
//            if (xyz + 1) >= popularArray.count {
//
//                cell.popularView2.isHidden = true
//            }
//            else {
//
//                cell.popularView2.isHidden = false
//                cell.popularImage2.kf.setImage(with: StringToURL(text: popularArray[xyz+1].product_image))
//                //cell.popularImage2.yy_imageURL = URL(string: popularArray[xyz+1].product_image)
//                cell.popularTitleLabel2.text = popularArray[xyz+1].product_title
//                cell.popularPriceLabel2.text = String(format:"%@%@", popularArray[xyz+1].currency_symbol, popularArray[xyz+1].product_price)
//            }
//
//            cell.tapButton1.tag = xyz
//            cell.tapButton1.addTarget(self, action: #selector(popularTapped), for: .touchUpInside)
//            cell.tapButton2.tag = xyz + 1
//            cell.tapButton2.addTarget(self, action: #selector(popularTapped), for: .touchUpInside)
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
//        else if tableView == secondaryTable {
//
//            let CellIdentifier: String = "SecondaryCell"
//            var cell: SecondaryCell? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? SecondaryCell)
//            if cell == nil {
//                var topLevelObjects: [Any] = Bundle.main.loadNibNamed("SecondaryCell", owner: self, options: nil)!
//                cell = (topLevelObjects[0] as? SecondaryCell)
//            }
//
//            if secondaryArray[indexPath.row].sub_category_image == "" {
//                cell!.categoryImage.image = UIImage(named: "no-image-icon")
//            }
//            else {
//                cell!.categoryImage.kf.setImage(with: StringToURL(text: secondaryArray[indexPath.row].sub_category_image))
//                //cell!.categoryImage.yy_imageURL = URL(string: secondaryArray[indexPath.row].sub_category_image)
//            }
//
//            cell?.categoryLabel.text = secondaryArray[indexPath.row].sub_category_name
//
//            let rotateImage = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
//            cell!.transform = rotateImage
//            cell!.selectionStyle = UITableViewCell.SelectionStyle.none
//            return cell!
//        }
//        else if tableView == adTable {
//
//            let CellIdentifier: String = "AdCell"
//            var cell: AdCell? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? AdCell)
//            if cell == nil {
//                var topLevelObjects: [Any] = Bundle.main.loadNibNamed("AdCell", owner: self, options: nil)!
//                cell = (topLevelObjects[0] as? AdCell)
//            }
//
//            cell!.adImage.kf.setImage(with: StringToURL(text: adimagesArray[indexPath.row].ad_image))
//            // cell!.adImage.yy_imageURL = URL(string: adimagesArray[indexPath.row].ad_image)
//
//            let rotateImage = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
//            cell!.transform = rotateImage
//            cell!.selectionStyle = UITableViewCell.SelectionStyle.none
//            return cell!
//        }
//        else if tableView == subTable {
//
//            let CellIdentifier: String = "SubCell"
//            var cell: SubCell? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? SubCell)
//            if cell == nil {
//                var topLevelObjects: [Any] = Bundle.main.loadNibNamed("SubCell", owner: self, options: nil)!
//                cell = (topLevelObjects[0] as? SubCell)
//            }
//           // cell?.subcategoryLabel.text = submoduleArray[indexPath.row].main_category_name
//            cell?.subcategoryLabel.text =  submoduleArray[indexPath.row].sec_category_name
//
//            if submoduleArray[indexPath.row].selected_value == "1" {
//
//                cell?.selectImage.backgroundColor = UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0)
//            }
//            else {
//                cell?.selectImage.backgroundColor = UIColor.clear
//            }
//
//            let rotateImage = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
//            cell!.transform = rotateImage
//            cell!.selectionStyle = UITableViewCell.SelectionStyle.none
//            return cell!
//        }
        else {
            
            let cellIdentifier = "SubCategoryTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SubCategoryTableViewCell
            
//            var xyz = Int(indexPath.row)
//            xyz = xyz * 2
//
//            cell.bgView.layer.cornerRadius = 5.0
//            cell.bgView.layer.borderWidth = 0.5
//            cell.bgView.layer.borderColor = UIColor(red: 230.0/255.0, green:230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
//
//             cell.topofferImage1.yy_imageURL = URL(string: topOffersArray[xyz].product_image)
//            cell.topofferImage1.kf.setImage(with: StringToURL(text: topOffersArray[xyz].product_image))
//            cell.topTitleLabel1.text = topOffersArray[xyz].product_title
//            cell.subCatMerchantName1.text = topOffersArray[xyz].merchant_name
//            cell.topPriceLabel1.text = String(format:"%@%@", topOffersArray[xyz].currency_symbol, topOffersArray[xyz].product_discount_price)
//            cell.topDiscountPriceLabel1.text = String(format:"%@%@", topOffersArray[xyz].currency_symbol, topOffersArray[xyz].product_price)
//            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.topDiscountPriceLabel1.text!)
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//            cell.topDiscountPriceLabel1.attributedText = attributeString
//
//            cell.topPercentageLabel1.text = String(format:"%@%% OFF", topOffersArray[xyz].product_percentage)
//
//            if (xyz + 1) >= topOffersArray.count {
//
//                cell.topOfferView2.isHidden = true
//            }
//            else {
//
//                cell.topOfferView2.isHidden = false
//                cell.topofferImage2.kf.setImage(with: StringToURL(text: topOffersArray[xyz+1].product_image))
//                // cell.topofferImage2.yy_imageURL = URL(string: topOffersArray[xyz+1].product_image)
//                cell.topTitleLabel2.text = topOffersArray[xyz+1].product_title
//                cell.subCatMerchantName2.text = topOffersArray[xyz+1].merchant_name
//                cell.topPriceLabel2.text = String(format:"%@%@", topOffersArray[xyz+1].currency_symbol, topOffersArray[xyz+1].product_discount_price)
//                cell.topDiscountPriceLabel2.text = String(format:"%@%@", topOffersArray[xyz+1].currency_symbol, topOffersArray[xyz+1].product_price)
//                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.topDiscountPriceLabel2.text!)
//                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//                cell.topDiscountPriceLabel2.attributedText = attributeString
//
//                cell.topPercentageLabel2.text = String(format:"%@%% OFF", topOffersArray[xyz+1].product_percentage)
//            }
//
//            cell.tapButton1.tag = xyz
//            cell.tapButton1.addTarget(self, action: #selector(detailTapped), for: .touchUpInside)
//            cell.tapButton2.tag = xyz + 1
//            cell.tapButton2.addTarget(self, action: #selector(detailTapped), for: .touchUpInside)
//
//            cell.topallButton.addTarget(self, action: #selector(topallTapped), for: .touchUpInside)
//
////            if self.bannersArray.count == 0 {
////                cell.frame = CGRect(x: 0, y: self.secondaryTable.frame.maxY, width: cell.frame.width, height: cell.frame.height)
////            }
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if tableView == secondaryTable {
//
//            let objProduct = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
//            objProduct.main_category_id = parent_category_id
//            objProduct.sec_category_id = sec_category_id
//            objProduct.sub_category_id = secondaryArray[indexPath.row].sub_category_id
//            objProduct.sub_sec_category_id = ""
//            objProduct.category_name = secondaryArray[indexPath.row].sub_category_name
//            objProduct.screenString = ""
//            self.navigationController?.pushViewController(objProduct, animated: true)
//        }
//        else if tableView == subTable {
//
//            if indexPath.row == 0 {
//                    sec_category_id = parent_category_id
//                print("vai  i am wero  -----\(sec_category_id)")
//
//            } else {
//                  sec_category_id = submoduleArray[indexPath.row].sec_category_id
//            }
//
//
//
//            topOffersArray = [TopOffers]()
//            popularArray = [Popular]()
//            secondaryArray = [SecondayCategory]()
//          //  submoduleArray = [SubModule]()
//            bannersArray = [BannersHome]()
//            adimagesArray = [AdImages]()
//
//            let reachability = Reachability()!
//
//            if reachability.isReachable {
//
//                self.view.hideToastActivity()
//                self.view.makeToastActivity(.center)
//
//               subcategoryApi()
//            //   subcategoryApiOne()
//            }
//            else {
//
//                showNetworkErrorAlert()
//            }
//        }
        
    }
    
     @objc func detailTapped(sender:UIButton ) {
        
        let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "FProductDetailsTableViewController") as! FProductDetailsTableViewController
        objProductDetails.category_name = "Top Offers"
        objProductDetails.product_id = topOffersArray[sender.tag].product_id
        UserDefaults.standard.set(topOffersArray[sender.tag].product_id, forKey: "temp_pro_id")
        self.navigationController?.pushViewController(objProductDetails, animated: true)
    }
    
     @objc func popularTapped(sender:UIButton ) {
        
        let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "FProductDetailsTableViewController") as! FProductDetailsTableViewController
        objProductDetails.category_name = "Most Popular"
        objProductDetails.product_id = popularArray[sender.tag].product_id
        UserDefaults.standard.set(popularArray[sender.tag].product_id, forKey: "temp_pro_id")
        self.navigationController?.pushViewController(objProductDetails, animated: true)
    }
    
    @IBAction func popularAllButton(sender:UIButton ) {
        
        let objProduct = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        objProduct.main_category_id = parent_category_id
        objProduct.sec_category_id = sec_category_id
        objProduct.sub_category_id = ""
        objProduct.sub_sec_category_id = ""
        objProduct.category_name = "Most Popular"
        objProduct.sort_order_by = "1"
        objProduct.screenString = ""
        self.navigationController?.pushViewController(objProduct, animated: true)
    }
    
    @objc func topallTapped(sender:UIButton ) {
        
        let objProduct = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        objProduct.main_category_id = parent_category_id
        objProduct.sec_category_id = sec_category_id
        objProduct.sub_category_id = ""
        objProduct.sub_sec_category_id = ""
        objProduct.category_name = "Top Offers"
        objProduct.discount = "6"
        objProduct.screenString = ""
        self.navigationController?.pushViewController(objProduct, animated: true)
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
