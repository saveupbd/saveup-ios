//
//  ListViewController.swift
//  Le
//
//  Created by Asif Seraje on 11/22/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit

class ListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var listColeectionView: UICollectionView!
    
//    var topOffersArray = [TopOffers]()//latest deals
//    var fiftyPercentArray = [FiftyPercent]()//hot deals
    
    var main_category_id: String!
    var category_id: String!
    var categoryIdForFilter: String!
    var sec_category_id: String!
    var sub_category_id: String!
    var sub_sec_category_id: String!
    var category_name: String!
    var page_no: Int! = 1
    var sort_order_by:String! = ""
    var price_min:String! = ""
    var price_max:String! = ""
    var value_id: Int?
    var discount:String! = ""
    var availability:String! = ""
    var titleString:String! = ""
    var is_approved: Int = 1
    var is_published: Int = 1
    var featured: Int = 1
    var screenString: String!
    var outBool: Bool! = false
    
    var productsArray = [Products]()
    
    var sortView:SortView!
    var filterView:FilterView!
    var three = UserDefaults.standard.bool(forKey: "Key3")
    
    var loadForLatestDeals = false
    var loadForHotDeals = false
    var loadForTopDeals = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listColeectionView.delegate = self
        self.listColeectionView.dataSource = self
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(ProductViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        //self.navigationItem.leftBarButtonItem = LeftButton
        
        sortView =  SortView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(sortView)
        sortView.isHidden = true
        sortView.backView.layer.cornerRadius = 10
        // sortView.mostButton.addTarget(self, action: #selector(ProductViewController.mostAction(_:)), for: UIControlEvents.touchUpInside)
        sortView.lowButton.addTarget(self, action: #selector(ProductViewController.lowAction(_:)), for: UIControl.Event.touchUpInside)
        sortView.highButton.addTarget(self, action: #selector(ProductViewController.highAction(_:)), for: UIControl.Event.touchUpInside)
        //        sortView.newestButton.addTarget(self, action: #selector(ProductViewController.newestAction(_:)), for: UIControlEvents.touchUpInside)
        sortView.resetButton.addTarget(self, action: #selector(ProductViewController.resetAction(_:)), for: UIControl.Event.touchUpInside)
        sortView.cancelButton.addTarget(self, action: #selector(ProductViewController.cancelAction(_:)), for: UIControl.Event.touchUpInside)
        
        
        filterView =  FilterView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(filterView)
        filterView.isHidden = true
        filterView.backView.layer.cornerRadius = 10
        
        filterView.underButton.addTarget(self, action: #selector(self.underAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.oneButton.addTarget(self, action: #selector(self.oneAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.twoButton.addTarget(self, action: #selector(self.twoAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.fiveButton.addTarget(self, action: #selector(self.fiveAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.overButton.addTarget(self, action: #selector(self.overAction(_:)), for: UIControl.Event.touchUpInside)
        
        filterView.zeroButton.addTarget(self, action: #selector(self.zeroAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.tenButton.addTarget(self, action: #selector(self.tenAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.twentyButton.addTarget(self, action: #selector(self.twentyAction(_:)), for: UIControl.Event.touchUpInside)
        // filterView.thirtyButton.addTarget(self, action: #selector(ProductViewController.thirtyAction(_:)), for: UIControlEvents.touchUpInside)
        //filterView.fourtyButton.addTarget(self, action: #selector(ProductViewController.fourtyAction(_:)), for: UIControlEvents.touchUpInside)
        filterView.fiftyButton.addTarget(self, action: #selector(self.fiftyAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.outButton.addTarget(self, action: #selector(self.outAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.resetButton.addTarget(self, action: #selector(self.resetFilterAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.cancelButton.addTarget(self, action: #selector(self.cancelFilterAction(_:)), for: UIControl.Event.touchUpInside)
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            
            // print("i am hot deals--\(three!)")
            if  UserDefaults.standard.bool(forKey: "LatestButton") == true  {
                productApi()
                
                print("i am LatestButton")
                UserDefaults.standard.removeObject(forKey: "LatestButton")
                
            } else if UserDefaults.standard.bool(forKey: "HotButton") == true  {
                productApiTwo()
                print("i am HotButton")
                UserDefaults.standard.removeObject(forKey: "HotButton")
            } else if UserDefaults.standard.bool(forKey: "giftButton") == true  {
                productApiThree()
                print("i am giftButton")
                UserDefaults.standard.removeObject(forKey: "giftButton")
            }else{
                productApiForSearch()
            }
            
            
            //
            //            self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            //showNetworkErrorAlert()
        }
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
    func productApiForSearch() {
        print("i am calling")
        let myUrl = URL(string: String(format:"%@api/product_search_by_filter", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        if sort_order_by!.count == 0 {
            
            if discount!.count != 0 {
                sort_order_by = "5"
            }
            else if price_min!.count != 0 {
                sort_order_by = "2"
            }
        }
        // print("discount---->",discount)
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
             postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&page_no=\(page_no!)&main_category_id=\(main_category_id!)&sec_category_id=\(sec_category_id!)&sub_category_id=\(sub_category_id!)&sub_sec_category_id=\(sub_sec_category_id!)&price_min=\(price_min!)&price_max=\(price_max!)&discount=\(discount!)&availability=\(availability!)&sort_order_by=\(sort_order_by!)&title=\(titleString!)&lang=en"
        }else{
             postString = "page_no=\(page_no!)&main_category_id=\(main_category_id!)&sec_category_id=\(sec_category_id!)&sub_category_id=\(sub_category_id!)&sub_sec_category_id=\(sub_sec_category_id!)&price_min=\(price_min!)&price_max=\(price_max!)&discount=\(discount!)&availability=\(availability!)&sort_order_by=\(sort_order_by!)&title=\(titleString!)&lang=en"
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
                    print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["product_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.productsArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Products Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Products Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.productsArray.append(Products(Products: item))
                                    }
                                }
                            }
                        }
                        
                        self.listColeectionView.reloadData()
                        // self.self.listColeectionView.infiniteScrollingView.stopAnimating()
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
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.black
        style.messageAlignment = .center
        style.backgroundColor = UIColor.white
        
        self.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mycartApi()
        let cartButton   = MIBadgeButton()
        cartButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        cartButton.setImage(UIImage(named: "cart-icon"), for: UIControl.State())
        cartButton.addTarget(self, action: #selector(ProductViewController.cartAction(_:)), for: UIControl.Event.touchUpInside)
        cartButton.badgeTextColor = UIColor.white
        
        let rightButton = UIBarButtonItem(customView: cartButton)
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FLatestCollectionViewCell", for: indexPath) as! FLatestCollectionViewCell
        self.setShadowAndRoundedBorder(customCell: cell)
        cell.backgroundColor = UIColor.white
        cell.productTitle.text = productsArray[indexPath.row].product_title
        cell.productCategory.text = productsArray[indexPath.row].merchant_name
        cell.originalPrice.text = "৳" + productsArray[indexPath.row].product_discount_price
        cell.cutOffPrice.attributedText = productsArray[indexPath.row].product_price.strikeThrough()
        cell.offPercentage.text = productsArray[indexPath.row].product_percentage + "% off"
        cell.productImage.kf.setImage(with: (StringToURL(text: productsArray[indexPath.row].product_image)))
        cell.productImage.yy_imageURL = URL(string: productsArray[indexPath.row].product_image)
        return cell
    }
    
    func setShadowAndRoundedBorder(customCell:UICollectionViewCell){
        customCell.layer.cornerRadius = 5
        customCell.layer.borderWidth = 0.9
        
        customCell.layer.borderColor = UIColor.init(named: "appThemeColor")?.cgColor
        customCell.layer.masksToBounds = true
        
        customCell.layer.shadowColor = UIColor.black.cgColor
        customCell.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        customCell.layer.shadowRadius = 3
        customCell.layer.shadowOpacity = 0.3
        customCell.layer.masksToBounds = false
        customCell.layer.shadowPath = UIBezierPath(roundedRect:customCell.bounds, cornerRadius:customCell.contentView.layer.cornerRadius).cgPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "FProductDetailsTableViewController") as! FProductDetailsTableViewController
        objProductDetails.category_name = "Latest Product"
        objProductDetails.product_id = productsArray[indexPath.row].product_id
        UserDefaults.standard.set(productsArray[indexPath.row].product_id, forKey: "temp_pro_id")

        self.navigationController?.pushViewController(objProductDetails, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (listColeectionView.frame.size.width - space) / 2.0
        let widthSet:CGFloat = (listColeectionView.frame.size.width - space) / 2.0
        let heightSet:CGFloat = 195
        return CGSize(width: widthSet, height: heightSet)
    }
    
    @IBAction func btnSortPressed(_ sender: UIButton) {
        sortView.isHidden = false
        UIApplication.shared.keyWindow?.addSubview(sortView)
    }
    
    @IBAction func btnFilterPressed(_ sender: UIButton) {
        filterView.isHidden = false
        UIApplication.shared.keyWindow?.addSubview(filterView)
    }
    
    func productApi() {
        
        let myUrl = URL(string: String(format:"%@api/latest_product_all", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        if sort_order_by!.count == 0 {
            
            if discount!.count != 0 {
                sort_order_by = "5"
            }
            else if price_min!.count != 0 {
                sort_order_by = "2"
            }
        }
        // print("discount---->",discount)
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
             postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&is_approved=1&is_published=1&sort=\(sort_order_by!)"
        }else{
             postString = "is_approved=1&is_published=1&sort=\(sort_order_by!)"
        }
        
        
        //page_no=\(page_no!)&main_category_id=\(main_category_id!)&sec_category_id=\(sec_category_id!)&sub_category_id=\(sub_category_id!)&sub_sec_category_id=\(sub_sec_category_id!)&price_min=\(price_min!)&price_max=\(price_max!)&discount=\(discount!)&availability=\(availability!)&sort_order_by=\(sort_order_by!)&title=\(titleString!)&lang=en&
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
                    print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["product_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.productsArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Products Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Products Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.productsArray.append(Products(Products: item))
                                    }
                                }
                            }
                        }
                        
                        self.listColeectionView.reloadData()
                        // self.self.listColeectionView.infiniteScrollingView.stopAnimating()
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
    
    func productApiTwo() {
        
        let myUrl = URL(string: String(format:"%@api/hot_product_all", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        if sort_order_by!.count == 0 {
            
            if discount!.count != 0 {
                sort_order_by = "5"
            }
            else if price_min!.count != 0 {
                sort_order_by = "2"
            }
        }
        // print("discount---->",discount)
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&is_approved=1&is_published=1&featured=1&sort=\(sort_order_by!)"
        }else{
            postString = "is_approved=1&is_published=1&featured=1&sort=\(sort_order_by!)"
        }
        
        
        //page_no=\(page_no!)&main_category_id=\(main_category_id!)&sec_category_id=\(sec_category_id!)&sub_category_id=\(sub_category_id!)&sub_sec_category_id=\(sub_sec_category_id!)&price_min=\(price_min!)&price_max=\(price_max!)&discount=\(discount!)&availability=\(availability!)&sort_order_by=\(sort_order_by!)&title=\(titleString!)&lang=en&
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
                    print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["product_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.productsArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Products Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Products Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.productsArray.append(Products(Products: item))
                                    }
                                }
                            }
                        }
                        
                        self.listColeectionView.reloadData()
                        //                        self.self.listColeectionView.infiniteScrollingView.stopAnimating()
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
    
    func productApiThree() {
        
        let myUrl = URL(string: String(format:"%@api/gift_product_all", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        if sort_order_by!.count == 0 {
            
            if discount!.count != 0 {
                sort_order_by = "5"
            }
            else if price_min!.count != 0 {
                sort_order_by = "2"
            }
        }
        // print("discount---->",discount)
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
             postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&is_approved=1&is_published=1&gift=1&sort=\(sort_order_by!)"
        }else{
             postString = "is_approved=1&is_published=1&gift=1&sort=\(sort_order_by!)"
        }
        
        //&page_no=\(page_no!)&main_category_id=\(main_category_id!)&sec_category_id=\(sec_category_id!)&sub_category_id=\(sub_category_id!)&sub_sec_category_id=\(sub_sec_category_id!)&price_min=\(price_min!)&price_max=\(price_max!)&discount=\(discount!)&availability=\(availability!)&sort_order_by=\(sort_order_by!)&title=\(titleString!)&lang=en
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
                    print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["product_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.productsArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Products Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Products Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.productsArray.append(Products(Products: item))
                                    }
                                }
                            }
                        }
                        
                        self.listColeectionView.reloadData()
                        //self.self.listColeectionView.infiniteScrollingView.stopAnimating()
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
    
    func productApiFilter() {
        
        let myUrl = URL(string: String(format:"%@api/filter", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        if sort_order_by!.count == 0 {
            
            if discount!.count != 0 {
                sort_order_by = "5"
            }
            else if price_min!.count != 0 {
                sort_order_by = "2"
            }
        }
        // print("discount---->",discount)
        UserDefaults.standard.set("value", forKey: "id")
        
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&page_no=\(page_no!)&main_category_id=\(main_category_id!)&sec_category_id=\(sec_category_id!)&sub_category_id=\(sub_category_id!)&sub_sec_category_id=\(sub_sec_category_id!)&price_min=\(price_min!)&price_max=\(price_max!)&discount=\(discount!)&availability=\(availability!)&title=\(titleString!)&lang=en&is_approved=1&is_published=1&sort=\(sort_order_by!)"
        }else{
            postString = "page_no=\(page_no!)&main_category_id=\(main_category_id!)&sec_category_id=\(sec_category_id!)&sub_category_id=\(sub_category_id!)&sub_sec_category_id=\(sub_sec_category_id!)&price_min=\(price_min!)&price_max=\(price_max!)&discount=\(discount!)&availability=\(availability!)&title=\(titleString!)&lang=en&is_approved=1&is_published=1&sort=\(sort_order_by!)"
        }
        //\
        
        //          let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&page_no=\(page_no!)&main_category_id=\(main_category_id!)&sec_category_id=\(sec_category_id!)&sub_category_id=\(sub_category_id!)&sub_sec_category_id=\(sub_sec_category_id!)&price_min=\(price_min!)&price_max=\(price_max!)&discount=\(discount!)&availability=\(availability!)&title=\(titleString!)&lang=en&is_approved=1&is_published=1&sort=\(sort_order_by!)&category_id =\(value_id!) "
        print("Here i am comming from my modal --\(UserDefaults.standard.object(forKey: "id")!)")
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
                    print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["product_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.productsArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Products Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Products Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.productsArray.append(Products(Products: item))
                                    }
                                }
                            }
                        }
                        
                        self.listColeectionView.reloadData()
                        // self.self.listColeectionView.infiniteScrollingView.stopAnimating()
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
    func mostAction(_ sender: UIButton!) {
        
        sortView.mostButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        sortView.lowButton.setTitleColor(UIColor.black, for: .normal)
        sortView.highButton.setTitleColor(UIColor.black, for: .normal)
        sortView.newestButton.setTitleColor(UIColor.black, for: .normal)
        sortView.resetButton.setTitleColor(UIColor.black, for: .normal)
        sortView.cancelButton.setTitleColor(UIColor.black, for: .normal)
        
        sortView.isHidden = true
        
        self.sort_order_by = "high_low"
        
        self.page_no = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            productApiFilter()
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApiFilter()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    @objc func lowAction(_ sender: UIButton!) {
        
        // sortView.mostButton.setTitleColor(UIColor.black, for: .normal)
        sortView.lowButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        sortView.highButton.setTitleColor(UIColor.black, for: .normal)
        //sortView.newestButton.setTitleColor(UIColor.black, for: .normal)
        sortView.resetButton.setTitleColor(UIColor.black, for: .normal)
        sortView.cancelButton.setTitleColor(UIColor.black, for: .normal)
        
        sortView.isHidden = true
        
        self.sort_order_by = "low_high"
        
        self.page_no = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            // self.productApi()
            productApiFilter()
            //            self.productApiTwo()
            //            self.productApiThree()
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApiFilter()
            //              weakSelf?.productApiFilter()
            ////                weakSelf?.productApiThree()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    @objc func highAction(_ sender: UIButton!) {
        
        // sortView.mostButton.setTitleColor(UIColor.black, for: .normal)
        sortView.lowButton.setTitleColor(UIColor.black, for: .normal)
        sortView.highButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        //  sortView.newestButton.setTitleColor(UIColor.black, for: .normal)
        sortView.resetButton.setTitleColor(UIColor.black, for: .normal)
        sortView.cancelButton.setTitleColor(UIColor.black, for: .normal)
        
        sortView.isHidden = true
        
        self.sort_order_by = "high_low"
        
        self.page_no = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            //            self.productApi()
            //            self.productApiTwo()
            //            self.productApiThree()
            self.productApiFilter()
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApiFilter()
            //                weakSelf?.productApiFilter()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    func newestAction(_ sender: UIButton!) {
        
        // sortView.mostButton.setTitleColor(UIColor.black, for: .normal)
        sortView.lowButton.setTitleColor(UIColor.black, for: .normal)
        sortView.highButton.setTitleColor(UIColor.black, for: .normal)
        // sortView.newestButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        sortView.resetButton.setTitleColor(UIColor.black, for: .normal)
        sortView.cancelButton.setTitleColor(UIColor.black, for: .normal)
        
        sortView.isHidden = true
        
        self.sort_order_by = "4"
        
        self.page_no = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            self.productApi()
            self.productApiTwo()
            self.productApiThree()
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //                weakSelf?.productApiTwo()
            //                weakSelf?.productApiThree()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    @objc func resetAction(_ sender: UIButton!) {
        
        // sortView.mostButton.setTitleColor(UIColor.black, for: .normal)
        sortView.lowButton.setTitleColor(UIColor.black, for: .normal)
        sortView.highButton.setTitleColor(UIColor.black, for: .normal)
        // sortView.newestButton.setTitleColor(UIColor.black, for: .normal)
        sortView.resetButton.setTitleColor(UIColor.black, for: .normal)
        sortView.cancelButton.setTitleColor(UIColor.black, for: .normal)
        
        sortView.isHidden = true
        
        self.sort_order_by = ""
        
        self.page_no = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            self.productApi()
            self.productApiTwo()
            self.productApiThree()
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //                weakSelf?.productApiTwo()
            //                weakSelf?.productApiThree()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    @objc func cancelAction(_ sender: UIButton!) {
        
        sortView.isHidden = true
    }
    
    @objc func underAction(_ sender: UIButton!) {
        
        filterView.underButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        filterView.oneButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twoButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiveButton.setTitleColor(UIColor.black, for: .normal)
        filterView.overButton.setTitleColor(UIColor.black, for: .normal)
        
        filterView.isHidden = true
        
        price_min = "1"
        
        price_max = "1000"
        
        self.page_no = 1
        
        self.value_id = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            // productApiFilter()
            
            if UserDefaults.standard.bool(forKey: "forcategory") == true  {
                productApiFilterOneForHotDeals()
                print("i am HotButton")
                UserDefaults.standard.removeObject(forKey: "forcategory")
            }else {
                productApiFilterOne()
            }
            
            //productApiFilterOneForHotDeals()
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApiFilter()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    //start
    func productApiFilterOne() {
        
        let myUrl = URL(string: String(format:"%@api/filter", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        // print("discount---->",discount)
        UserDefaults.standard.set("value", forKey: "id")
        let postString = "is_approved=1&is_published=1&category_id=1"//&featured=1
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
                    print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["product_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.productsArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Products Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Products Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    for item in reposArray {
                                        self.productsArray.append(Products(Products: item))
                                    }
                                }
                            }
                        }
                        
                        self.self.listColeectionView.reloadData()
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
    
    
    func productApiFilterOneForHotDeals() {
        
        let myUrl = URL(string: String(format:"%@api/filter", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        // print("discount---->",discount)
        // UserDefaults.standard.set("value", forKey: "id")
        let postString = "is_approved=1&is_published=1&featured=1&category_id=1"//&featured=1
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
                    print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["product_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.productsArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Products Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Products Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    for item in reposArray {
                                        self.productsArray.append(Products(Products: item))
                                    }
                                }
                            }
                        }
                        
                        self.self.listColeectionView.reloadData()
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
    
    @objc func oneAction(_ sender: UIButton!) {
        
        filterView.underButton.setTitleColor(UIColor.black, for: .normal)
        filterView.oneButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        filterView.twoButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiveButton.setTitleColor(UIColor.black, for: .normal)
        filterView.overButton.setTitleColor(UIColor.black, for: .normal)
        
        filterView.isHidden = true
        
        price_min = "1000"
        
        price_max = "2500"
        
        self.page_no = 1
        
        self.value_id = 2
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            //            self.productApi()
            //            self.productApiTwo()
            //            self.productApiThree()
            
            productApiFilterTwo()
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //                weakSelf?.productApiTwo()
            //                weakSelf?.productApiThree()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    //Mark: button two
    func productApiFilterTwo() {
        
        let myUrl = URL(string: String(format:"%@api/filter", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        // print("discount---->",discount)
        UserDefaults.standard.set("value", forKey: "id")
        let postString = "is_approved=1&is_published=1&category_id=2"
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
                    print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["product_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.productsArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Products Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Products Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    for item in reposArray {
                                        self.productsArray.append(Products(Products: item))
                                    }
                                }
                            }
                        }
                        
                        self.self.listColeectionView.reloadData()
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
    
    
    @objc func twoAction(_ sender: UIButton!) {
        
        filterView.underButton.setTitleColor(UIColor.black, for: .normal)
        filterView.oneButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twoButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        filterView.fiveButton.setTitleColor(UIColor.black, for: .normal)
        filterView.overButton.setTitleColor(UIColor.black, for: .normal)
        
        filterView.isHidden = true
        
        price_min = "2500"
        
        price_max = "5000"
        
        self.page_no = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            //            self.productApi()
            //            self.productApiTwo()
            //            self.productApiThree()
            productApiFilterThree()
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //                weakSelf?.productApiTwo()
            //                weakSelf?.productApiThree()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    //start
    func productApiFilterThree() {
        
        let myUrl = URL(string: String(format:"%@api/filter", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        // print("discount---->",discount)
        UserDefaults.standard.set("value", forKey: "id")
        let postString = "is_approved=1&is_published=1&category_id=3"
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
                    print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["product_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.productsArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Products Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Products Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    for item in reposArray {
                                        self.productsArray.append(Products(Products: item))
                                    }
                                }
                            }
                        }
                        
                        self.self.listColeectionView.reloadData()
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
    
    @objc func fiveAction(_ sender: UIButton!) {
        
        filterView.underButton.setTitleColor(UIColor.black, for: .normal)
        filterView.oneButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twoButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiveButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        filterView.overButton.setTitleColor(UIColor.black, for: .normal)
        
        filterView.isHidden = true
        
        price_min = "5000"
        
        price_max = "10000"
        
        self.page_no = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            //            self.productApi()
            productApiFilterFour()
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    //start
    func productApiFilterFour() {
        
        let myUrl = URL(string: String(format:"%@api/filter", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        // print("discount---->",discount)
        UserDefaults.standard.set("value", forKey: "id")
        let postString = "is_approved=1&is_published=1&category_id=4"
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
                    print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["product_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.productsArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Products Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Products Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    for item in reposArray {
                                        self.productsArray.append(Products(Products: item))
                                    }
                                }
                            }
                        }
                        
                        self.self.listColeectionView.reloadData()
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
    
    @objc func overAction(_ sender: UIButton!) {
        
        filterView.underButton.setTitleColor(UIColor.black, for: .normal)
        filterView.oneButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twoButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiveButton.setTitleColor(UIColor.black, for: .normal)
        filterView.overButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        
        filterView.isHidden = true
        
        price_min = "10000"
        
        price_max = "100000"
        
        self.page_no = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            //            self.productApi()
            productApiFilterFive()
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    //start
    func productApiFilterFive() {
        
        let myUrl = URL(string: String(format:"%@api/filter", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        // print("discount---->",discount)
        UserDefaults.standard.set("value", forKey: "id")
        let postString = "is_approved=1&is_published=1&category_id=5"
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
                    print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["product_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.productsArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Products Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Products Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    for item in reposArray {
                                        self.productsArray.append(Products(Products: item))
                                    }
                                }
                            }
                        }
                        
                        self.self.listColeectionView.reloadData()
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
    
    @objc func zeroAction(_ sender: UIButton!) {
        
        filterView.zeroButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        filterView.tenButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twentyButton.setTitleColor(UIColor.black, for: .normal)
        //        filterView.thirtyButton.setTitleColor(UIColor.black, for: .normal)
        //        filterView.fourtyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiftyButton.setTitleColor(UIColor.black, for: .normal)
        
        filterView.isHidden = true
        
        self.discount = "1"
        
        self.page_no = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            //self.productApi()
            MessageApi()
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    func MessageApi() {
        
        let myUrl = URL(string: String(format:"%@api/filter", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        // print("discount---->",discount)
        UserDefaults.standard.set("value", forKey: "id")
        let postString = "is_approved=1&is_published=1&category_id=7"
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
                    print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["product_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.productsArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Products Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Products Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    for item in reposArray {
                                        self.productsArray.append(Products(Products: item))
                                    }
                                }
                            }
                        }
                        
                        self.self.listColeectionView.reloadData()
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
    
    
    
    @objc func tenAction(_ sender: UIButton!) {
        
        filterView.zeroButton.setTitleColor(UIColor.black, for: .normal)
        filterView.tenButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        filterView.twentyButton.setTitleColor(UIColor.black, for: .normal)
        //    filterView.thirtyButton.setTitleColor(UIColor.black, for: .normal)
        //       filterView.fourtyButton.setTitleColor(UIColor.black, for: .normal)
        //     filterView.fiftyButton.setTitleColor(UIColor.black, for: .normal)
        
        filterView.isHidden = true
        
        self.discount = "2"
        
        self.page_no = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            //            self.productApi()
            productApiFilterSix()
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    //start
    func productApiFilterSix() {
        
        let myUrl = URL(string: String(format:"%@api/filter", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        // print("discount---->",discount)
        UserDefaults.standard.set("value", forKey: "id")
        let postString = "is_approved=1&is_published=1&category_id=12"
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
                    print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["product_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.productsArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Products Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Products Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    for item in reposArray {
                                        self.productsArray.append(Products(Products: item))
                                    }
                                }
                            }
                        }
                        
                        self.self.listColeectionView.reloadData()
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
    
    @objc func twentyAction(_ sender: UIButton!) {
        
        filterView.zeroButton.setTitleColor(UIColor.black, for: .normal)
        filterView.tenButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twentyButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        //        filterView.thirtyButton.setTitleColor(UIColor.black, for: .normal)
        //        filterView.fourtyButton.setTitleColor(UIColor.black, for: .normal)
        //        filterView.fiftyButton.setTitleColor(UIColor.black, for: .normal)
        
        filterView.isHidden = true
        
        self.discount = "3"
        
        self.page_no = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            //            self.productApi()
            productApiFilterSeven()
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    
    //start
    func productApiFilterSeven() {
        
        let myUrl = URL(string: String(format:"%@api/filter", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        // print("discount---->",discount)
        UserDefaults.standard.set("value", forKey: "id")
        let postString = "is_approved=1&is_published=1&category_id=23"
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
                    print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["product_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.productsArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.showNetworkErrorAlert()
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.showNetworkErrorAlert()
                                    }
                                }
                                else {
                                    for item in reposArray {
                                        self.productsArray.append(Products(Products: item))
                                    }
                                }
                            }
                        }
                        
                        self.self.listColeectionView.reloadData()
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
    
    func thirtyAction(_ sender: UIButton!) {
        
        filterView.zeroButton.setTitleColor(UIColor.black, for: .normal)
        filterView.tenButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twentyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.thirtyButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        filterView.fourtyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiftyButton.setTitleColor(UIColor.black, for: .normal)
        
        filterView.isHidden = true
        
        self.discount = "4"
        
        self.page_no = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            self.productApi()
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    func fourtyAction(_ sender: UIButton!) {
        
        filterView.zeroButton.setTitleColor(UIColor.black, for: .normal)
        filterView.tenButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twentyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.thirtyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fourtyButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        filterView.fiftyButton.setTitleColor(UIColor.black, for: .normal)
        
        filterView.isHidden = true
        
        self.discount = "5"
        
        self.page_no = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            self.productApi()
            
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    @objc func fiftyAction(_ sender: UIButton!) {
        
        filterView.zeroButton.setTitleColor(UIColor.black, for: .normal)
        filterView.tenButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twentyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.thirtyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fourtyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiftyButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        
        filterView.isHidden = true
        
        self.discount = "6"
        
        self.page_no = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            self.productApi()
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    @objc func outAction(_ sender: UIButton!) {
        
        filterView.isHidden = true
        
        if outBool == false {
            
            outBool = true
            self.availability = "1"
            filterView.outButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        }
        else {
            
            outBool = false
            self.availability = ""
            filterView.outButton.setTitleColor(UIColor.black, for: .normal)
        }
        
        self.page_no = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            self.productApi()
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    @objc func resetFilterAction(_ sender: UIButton!) {
        
        filterView.isHidden = true
        filterView.underButton.setTitleColor(UIColor.black, for: .normal)
        filterView.oneButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twoButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiveButton.setTitleColor(UIColor.black, for: .normal)
        
        filterView.overButton.setTitleColor(UIColor.black, for: .normal)
        filterView.zeroButton.setTitleColor(UIColor.black, for: .normal)
        filterView.tenButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twentyButton.setTitleColor(UIColor.black, for: .normal)
        
        //filterView.thirtyButton.setTitleColor(UIColor.black, for: .normal)
        //filterView.fourtyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiftyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.outButton.setTitleColor(UIColor.black, for: .normal)
        
        filterView.resetButton.setTitleColor(UIColor.black, for: .normal)
        //filterView.fourtyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.cancelButton.setTitleColor(UIColor.black, for: .normal)
        self.price_min = ""
        self.price_max = ""
        self.discount = ""
        self.availability = ""
        self.value_id = nil
        
        self.page_no = 1
        
        self.productsArray = [Products]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            self.productApi()
            
            //
            //            self.self.listColeectionView.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    @objc func cancelFilterAction(_ sender: UIButton!) {
        
        filterView.isHidden = true
    }
    
}
extension UIViewController{
    
    func dismissKeyBoardTappedOutside(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
