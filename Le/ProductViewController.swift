//
//  ProductViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 07/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit



class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {
    
    @IBOutlet weak var productTable : UITableView!
    @IBOutlet weak var sortButton : UIButton!
    @IBOutlet weak var filterButton : UIButton!
    
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
    
    //    var one = UserDefaults.standard.string(forKey: "LatestDeals")
    //    //print("rashed value ---\(one)")
    //    var two = UserDefaults.standard.string(forKey: "HotDeals")
    //    //print("rashed value ---\(two)")
    //    var three = UserDefaults.standard.string(forKey: "GiftProducts")
    //    //print("rashed value ---\(three)")
    var three = UserDefaults.standard.bool(forKey: "Key3")
    
    
    override func viewDidLoad() {
        mycartApi()
        //         print("Here i am comming from my modal --\(UserDefaults.standard.object(forKey: "id")!)")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = category_name
        
        if screenString == "Menu" {
            
            if revealViewController() != nil {
                
                let rightRevealButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu")!, style: .done, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
                self.navigationItem.leftBarButtonItem = rightRevealButtonItem
                self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
                view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
            
            productTable.frame = CGRect(x: CGFloat(productTable.frame.origin.x), y: CGFloat(productTable.frame.origin.y), width: CGFloat(productTable.frame.size.width), height: CGFloat(UIScreen.main.bounds.size.height - 50))
        }
        else {
            
            let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
            leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
            leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
            leftbutton.addTarget(self, action: #selector(ProductViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
            
            let LeftButton = UIBarButtonItem(customView: leftbutton)
            //self.navigationItem.leftBarButtonItem = LeftButton
            
            productTable.frame = CGRect(x: CGFloat(productTable.frame.origin.x), y: CGFloat(productTable.frame.origin.y), width: CGFloat(productTable.frame.size.width), height: CGFloat(UIScreen.main.bounds.size.height - 114))
        }
        
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
        
        filterView.underButton.addTarget(self, action: #selector(ProductViewController.underAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.oneButton.addTarget(self, action: #selector(ProductViewController.oneAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.twoButton.addTarget(self, action: #selector(ProductViewController.twoAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.fiveButton.addTarget(self, action: #selector(ProductViewController.fiveAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.overButton.addTarget(self, action: #selector(ProductViewController.overAction(_:)), for: UIControl.Event.touchUpInside)
        
        filterView.zeroButton.addTarget(self, action: #selector(ProductViewController.zeroAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.tenButton.addTarget(self, action: #selector(ProductViewController.tenAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.twentyButton.addTarget(self, action: #selector(ProductViewController.twentyAction(_:)), for: UIControl.Event.touchUpInside)
        // filterView.thirtyButton.addTarget(self, action: #selector(ProductViewController.thirtyAction(_:)), for: UIControlEvents.touchUpInside)
        //filterView.fourtyButton.addTarget(self, action: #selector(ProductViewController.fourtyAction(_:)), for: UIControlEvents.touchUpInside)
        filterView.fiftyButton.addTarget(self, action: #selector(ProductViewController.fiftyAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.outButton.addTarget(self, action: #selector(ProductViewController.outAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.resetButton.addTarget(self, action: #selector(ProductViewController.resetFilterAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.cancelButton.addTarget(self, action: #selector(ProductViewController.cancelFilterAction(_:)), for: UIControl.Event.touchUpInside)
        
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
            }
            
            productApiForSearch()
            weak var weakSelf: ProductViewController? = self
            //            productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.showNetworkErrorAlert()
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
        
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
             postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&page_no=\(page_no!)&main_category_id=\(main_category_id!)&sec_category_id=\(sec_category_id!)&sub_category_id=\(sub_category_id!)&sub_sec_category_id=\(sub_sec_category_id!)&price_min=\(price_min!)&price_max=\(price_max!)&discount=\(discount!)&availability=\(availability!)&sort_order_by=\(sort_order_by!)&title=\(titleString!)&lang=en"
        }else{
            postString = "page_no=\(page_no!)&main_category_id=\(main_category_id!)&sec_category_id=\(sec_category_id!)&sub_category_id=\(sub_category_id!)&sub_sec_category_id=\(sub_sec_category_id!)&price_min=\(price_min!)&price_max=\(price_max!)&discount=\(discount!)&availability=\(availability!)&sort_order_by=\(sort_order_by!)&title=\(titleString!)&lang=en"
        }
        // print("discount---->",discount)
        
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
                        
                        self.productTable.reloadData()
                        // self.productTable.infiniteScrollingView.stopAnimating()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mycartApi()
        let cartButton   = MIBadgeButton()
        cartButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        cartButton.setImage(UIImage(named: "cart-icon"), for: UIControl.State())
        cartButton.addTarget(self, action: #selector(ProductViewController.cartAction(_:)), for: UIControl.Event.touchUpInside)
        //        if UserDefaults.standard.object(forKey: "CartCount") != nil {
        //            print("I am not empty")
        //            cartButton.badgeString = String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
        //            UserDefaults.standard.removeObject(forKey: "CartCount")
        //        } else {
        //            print("Cart is  empty-----")
        //        }
        
        //        if UserDefaults.standard.bool(forKey: "CartCount") == false {
        //            print("Cart is  empty-----")
        //        } else {
        //            print("I am not empty")
        //            cartButton.badgeString = String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
        //            UserDefaults.standard.removeObject(forKey: "CartCount")
        //        }
        //cartButton.badgeString = String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
        cartButton.badgeTextColor = UIColor.white
        
        let rightButton = UIBarButtonItem(customView: cartButton)
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    //for cart count
    func mycartApi() {
        
        let myUrl = URL(string: String(format:"%@api/cart_list", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&lang=en"
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
    
    @objc func backAction(_ sender: UIButton!) {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    @objc func cartAction(_ sender: UIButton!) {
        
        let objMyCart = self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        objMyCart.screen_value = ""
        self.navigationController?.pushViewController(objMyCart, animated: true)
    }
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.black
        style.messageAlignment = .center
        style.backgroundColor = UIColor.white
        
        self.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
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
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&is_approved=1&is_published=1&gift=1&sort=\(sort_order_by!)"
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
                        
                        self.productTable.reloadData()
                        //self.productTable.infiniteScrollingView.stopAnimating()
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
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&is_approved=1&is_published=1&featured=1&sort=\(sort_order_by!)"
        
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
                        
                        self.productTable.reloadData()
                        //                        self.productTable.infiniteScrollingView.stopAnimating()
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
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&is_approved=1&is_published=1&sort=\(sort_order_by!)"
        
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
                        
                        self.productTable.reloadData()
                        // self.productTable.infiniteScrollingView.stopAnimating()
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
    
    //filter
    
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
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&page_no=\(page_no!)&main_category_id=\(main_category_id!)&sec_category_id=\(sec_category_id!)&sub_category_id=\(sub_category_id!)&sub_sec_category_id=\(sub_sec_category_id!)&price_min=\(price_min!)&price_max=\(price_max!)&discount=\(discount!)&availability=\(availability!)&title=\(titleString!)&lang=en&is_approved=1&is_published=1&sort=\(sort_order_by!)"//\
        
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
                        
                        self.productTable.reloadData()
                        // self.productTable.infiniteScrollingView.stopAnimating()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Customize the number of rows in the table view.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var devide: Int = productsArray.count / 2
        if productsArray.count % 2 > 0 {
            devide += 1
        }
        return devide
    }
    // Customize the appearance of table view cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CustomCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
        
        var xyz = Int(indexPath.row)
        xyz = xyz * 2
        
        cell.bgView.layer.borderWidth = 0.5
        cell.bgView.layer.borderColor = UIColor(red: 230.0/255.0, green:230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        
        //cell.topofferImage1.yy_imageURL = URL(string: productsArray[xyz].product_image)
        cell.topTitleLabel1.text = "gvcyvyg"//productsArray[xyz].product_title
        cell.topMerchantNameLabel1.text = "gvcyvyg"//productsArray[xyz].merchant_name
        cell.topPriceLabel1.text = "gvcyvyg"//String(format:"%@%@", productsArray[xyz].currency_symbol, productsArray[xyz].product_discount_price)
        cell.topDiscountPriceLabel1.text = "gvcyvyg"//String(format:"%@%@", productsArray[xyz].currency_symbol, productsArray[xyz].product_price)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.topDiscountPriceLabel1.text!)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        cell.topDiscountPriceLabel1.attributedText = attributeString
        
        cell.topPercentageLabel1.text = "gvcyvyg"////String(format:"%@%% OFF", productsArray[xyz].product_percentage)
        
        if productsArray[xyz].is_wishlist == false {
            
            cell.wishButton1.setImage(UIImage(named: "wish-icon"), for: UIControl.State())
        }
        else {
            
            cell.wishButton1.setImage(UIImage(named: "wish-icon-fill"), for: UIControl.State())
        }
        
        if (xyz + 1) >= productsArray.count {
            
            cell.topOfferView2.isHidden = true
        }
        else {
            
            cell.topOfferView2.isHidden = false
            cell.topofferImage2.yy_imageURL = URL(string: productsArray[xyz+1].product_image)
            cell.topTitleLabel2.text = productsArray[xyz+1].product_title
            cell.topMerchantNameLabel2.text = productsArray[xyz+1].merchant_name
            cell.topPriceLabel2.text = String(format:"%@%@", productsArray[xyz+1].currency_symbol, productsArray[xyz+1].product_discount_price)
            cell.topDiscountPriceLabel2.text = String(format:"%@%@", productsArray[xyz+1].currency_symbol, productsArray[xyz+1].product_price)
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.topDiscountPriceLabel2.text!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.topDiscountPriceLabel2.attributedText = attributeString
            
            cell.topPercentageLabel2.text = String(format:"%@%% OFF", productsArray[xyz+1].product_percentage)
            
            if productsArray[xyz+1].is_wishlist == false {
                
                cell.wishButton2.setImage(UIImage(named: "wish-icon"), for: UIControl.State())
            }
            else {
                
                cell.wishButton2.setImage(UIImage(named: "wish-icon-fill"), for: UIControl.State())
            }
        }
        
        cell.wishButton1.tag = xyz
        cell.wishButton1.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        cell.wishButton2.tag = xyz + 1
        cell.wishButton2.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        
        cell.tapButton1.tag = xyz
        cell.tapButton1.addTarget(self, action: #selector(detailTapped), for: .touchUpInside)
        cell.tapButton2.tag = xyz + 1
        cell.tapButton2.addTarget(self, action: #selector(detailTapped), for: .touchUpInside)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func detailTapped(sender:UIButton ) {
        
        let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "FProductDetailsTableViewController") as! FProductDetailsTableViewController
        objProductDetails.category_name = category_name
        objProductDetails.product_id = productsArray[sender.tag].product_id
        UserDefaults.standard.set(productsArray[sender.tag].product_id, forKey: "temp_pro_id")

        self.navigationController?.pushViewController(objProductDetails, animated: true)
    }
    
    @objc  func btnTapped(sender:UIButton ) {
        
        let myUrl = URL(string: String(format:"%@api/add_to_wishlist", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(productsArray[sender.tag].product_id!)&lang=en"
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
                            
                            if self.productsArray[sender.tag].is_wishlist == false {
                                
                                self.productsArray[sender.tag].is_wishlist = true
                            }
                            else {
                                
                                self.productsArray[sender.tag].is_wishlist = false
                            }
                            self.productTable.reloadData()
                        }
                        else {
                            
                            self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
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
    
    @IBAction func sortButton(sender:UIButton ) {
        
        sortView.isHidden = false
        UIApplication.shared.keyWindow?.addSubview(sortView)
        
        /*let alert=UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.alert);
         //no event handler (just close dialog box)
         alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil));
         //event handler with closure
         alert.addAction(UIAlertAction(title: "Most Popular", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
         
         self.sort_order_by = "1"
         
         self.page_no = 1
         
         self.productsArray = [Products]()
         
         let reachability = Reachability()!
         
         if reachability.isReachable {
         
         self.view.hideToastActivity()
         self.view.makeToastActivity(.center)
         
         self.productApi()
         
         weak var weakSelf: ProductViewController? = self
         self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
         weakSelf?.productApi()
         })
         }
         else {
         
         self.self.showNetworkErrorAlert()
         }
         }));
         alert.addAction(UIAlertAction(title: "Price Low to High", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
         
         self.sort_order_by = "2"
         
         self.page_no = 1
         
         self.productsArray = [Products]()
         
         let reachability = Reachability()!
         
         if reachability.isReachable {
         
         self.view.hideToastActivity()
         self.view.makeToastActivity(.center)
         
         self.productApi()
         
         weak var weakSelf: ProductViewController? = self
         self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
         weakSelf?.productApi()
         })
         }
         else {
         
         self.self.showNetworkErrorAlert()
         }
         }));
         alert.addAction(UIAlertAction(title: "Price High to Low", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
         
         self.sort_order_by = "3"
         
         self.page_no = 1
         
         self.productsArray = [Products]()
         
         let reachability = Reachability()!
         
         if reachability.isReachable {
         
         self.view.hideToastActivity()
         self.view.makeToastActivity(.center)
         
         self.productApi()
         
         weak var weakSelf: ProductViewController? = self
         self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
         weakSelf?.productApi()
         })
         }
         else {
         
         self.self.showNetworkErrorAlert()
         }
         }));
         alert.addAction(UIAlertAction(title: "Newest", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
         
         self.sort_order_by = "4"
         
         self.page_no = 1
         
         self.productsArray = [Products]()
         
         let reachability = Reachability()!
         
         if reachability.isReachable {
         
         self.view.hideToastActivity()
         self.view.makeToastActivity(.center)
         
         self.productApi()
         
         weak var weakSelf: ProductViewController? = self
         self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
         weakSelf?.productApi()
         })
         }
         else {
         
         self.self.showNetworkErrorAlert()
         }
         }));
         alert.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
         
         self.sort_order_by = ""
         
         self.page_no = 1
         
         self.productsArray = [Products]()
         
         let reachability = Reachability()!
         
         if reachability.isReachable {
         
         self.view.hideToastActivity()
         self.view.makeToastActivity(.center)
         
         self.productApi()
         
         weak var weakSelf: ProductViewController? = self
         self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
         weakSelf?.productApi()
         })
         }
         else {
         
         self.self.showNetworkErrorAlert()
         }
         }));
         present(alert, animated: true, completion: nil);*/
    }
    
    @IBAction func filterButton(sender:UIButton ) {
        
        filterView.isHidden = false
        UIApplication.shared.keyWindow?.addSubview(filterView)
        
        
        /*let alert=UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.alert);
         //no event handler (just close dialog box)
         alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil));
         //event handler with closure
         alert.addAction(UIAlertAction(title: "Price Min", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
         
         self.price_min = "1"
         
         self.page_no = 1
         
         self.productsArray = [Products]()
         
         let reachability = Reachability()!
         
         if reachability.isReachable {
         
         self.view.hideToastActivity()
         self.view.makeToastActivity(.center)
         
         self.productApi()
         
         weak var weakSelf: ProductViewController? = self
         self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
         weakSelf?.productApi()
         })
         }
         else {
         
         self.self.showNetworkErrorAlert()
         }
         }));
         alert.addAction(UIAlertAction(title: "Price Max", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
         
         self.price_max = "100"
         
         self.page_no = 1
         
         self.productsArray = [Products]()
         
         let reachability = Reachability()!
         
         if reachability.isReachable {
         
         self.view.hideToastActivity()
         self.view.makeToastActivity(.center)
         
         self.productApi()
         
         weak var weakSelf: ProductViewController? = self
         self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
         weakSelf?.productApi()
         })
         }
         else {
         
         self.self.showNetworkErrorAlert()
         }
         }));
         alert.addAction(UIAlertAction(title: "Discount(0% - 10%)", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
         
         self.discount = "1"
         
         self.page_no = 1
         
         self.productsArray = [Products]()
         
         let reachability = Reachability()!
         
         if reachability.isReachable {
         
         self.view.hideToastActivity()
         self.view.makeToastActivity(.center)
         
         self.productApi()
         
         weak var weakSelf: ProductViewController? = self
         self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
         weakSelf?.productApi()
         })
         }
         else {
         
         self.self.showNetworkErrorAlert()
         }
         }));
         alert.addAction(UIAlertAction(title: "Discount(10% - 20%)", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
         
         self.discount = "2"
         
         self.page_no = 1
         
         self.productsArray = [Products]()
         
         let reachability = Reachability()!
         
         if reachability.isReachable {
         
         self.view.hideToastActivity()
         self.view.makeToastActivity(.center)
         
         self.productApi()
         
         weak var weakSelf: ProductViewController? = self
         self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
         weakSelf?.productApi()
         })
         }
         else {
         
         self.self.showNetworkErrorAlert()
         }
         }));
         alert.addAction(UIAlertAction(title: "Discount(20% - 30%)", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
         
         self.discount = "3"
         
         self.page_no = 1
         
         self.productsArray = [Products]()
         
         let reachability = Reachability()!
         
         if reachability.isReachable {
         
         self.view.hideToastActivity()
         self.view.makeToastActivity(.center)
         
         self.productApi()
         
         weak var weakSelf: ProductViewController? = self
         self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
         weakSelf?.productApi()
         })
         }
         else {
         
         self.self.showNetworkErrorAlert()
         }
         }));
         alert.addAction(UIAlertAction(title: "Discount(30% - 40%)", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
         
         self.discount = "4"
         
         self.page_no = 1
         
         self.productsArray = [Products]()
         
         let reachability = Reachability()!
         
         if reachability.isReachable {
         
         self.view.hideToastActivity()
         self.view.makeToastActivity(.center)
         
         self.productApi()
         
         weak var weakSelf: ProductViewController? = self
         self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
         weakSelf?.productApi()
         })
         }
         else {
         
         self.self.showNetworkErrorAlert()
         }
         }));
         alert.addAction(UIAlertAction(title: "Discount(40% - 50%)", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
         
         self.discount = "5"
         
         self.page_no = 1
         
         self.productsArray = [Products]()
         
         let reachability = Reachability()!
         
         if reachability.isReachable {
         
         self.view.hideToastActivity()
         self.view.makeToastActivity(.center)
         
         self.productApi()
         
         weak var weakSelf: ProductViewController? = self
         self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
         weakSelf?.productApi()
         })
         }
         else {
         
         self.self.showNetworkErrorAlert()
         }
         }));
         alert.addAction(UIAlertAction(title: "Discount(50% - 100%)", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
         
         self.discount = "6"
         
         self.page_no = 1
         
         self.productsArray = [Products]()
         
         let reachability = Reachability()!
         
         if reachability.isReachable {
         
         self.view.hideToastActivity()
         self.view.makeToastActivity(.center)
         
         self.productApi()
         
         weak var weakSelf: ProductViewController? = self
         self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
         weakSelf?.productApi()
         })
         }
         else {
         
         self.self.showNetworkErrorAlert()
         }
         }));
         alert.addAction(UIAlertAction(title: "Out of stock", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
         
         self.availability = "1"
         
         self.page_no = 1
         
         self.productsArray = [Products]()
         
         let reachability = Reachability()!
         
         if reachability.isReachable {
         
         self.view.hideToastActivity()
         self.view.makeToastActivity(.center)
         
         self.productApi()
         
         weak var weakSelf: ProductViewController? = self
         self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
         weakSelf?.productApi()
         })
         }
         else {
         
         self.self.showNetworkErrorAlert()
         }
         }));
         alert.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
         
         self.price_min = ""
         self.price_max = ""
         self.discount = ""
         self.availability = ""
         
         self.page_no = 1
         
         self.productsArray = [Products]()
         
         let reachability = Reachability()!
         
         if reachability.isReachable {
         
         self.view.hideToastActivity()
         self.view.makeToastActivity(.center)
         
         self.productApi()
         
         weak var weakSelf: ProductViewController? = self
         self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
         weakSelf?.productApi()
         })
         }
         else {
         
         self.self.showNetworkErrorAlert()
         }
         }));
         present(alert, animated: true, completion: nil);*/
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApiFilter()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApiFilter()
            //              weakSelf?.productApiFilter()
            ////                weakSelf?.productApiThree()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApiFilter()
            //                weakSelf?.productApiFilter()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //                weakSelf?.productApiTwo()
            //                weakSelf?.productApiThree()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //                weakSelf?.productApiTwo()
            //                weakSelf?.productApiThree()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApiFilter()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
                        
                        self.productTable.reloadData()
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
                        
                        self.productTable.reloadData()
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //                weakSelf?.productApiTwo()
            //                weakSelf?.productApiThree()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
                        
                        self.productTable.reloadData()
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //                weakSelf?.productApiTwo()
            //                weakSelf?.productApiThree()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
                        
                        self.productTable.reloadData()
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
                        
                        self.productTable.reloadData()
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
                        
                        self.productTable.reloadData()
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
                        
                        self.productTable.reloadData()
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
                        
                        self.productTable.reloadData()
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
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
                                        
                                        self.self.showNetworkErrorAlert()
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.self.showNetworkErrorAlert()
                                    }
                                }
                                else {
                                    for item in reposArray {
                                        self.productsArray.append(Products(Products: item))
                                    }
                                }
                            }
                        }
                        
                        self.productTable.reloadData()
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
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
            
            weak var weakSelf: ProductViewController? = self
            //            self.productTable.addInfiniteScrolling(actionHandler: {() -> Void in
            //                weakSelf?.productApi()
            //            })
        }
        else {
            
            self.self.showNetworkErrorAlert()
        }
    }
    
    @objc func cancelFilterAction(_ sender: UIButton!) {
        
        filterView.isHidden = true
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
