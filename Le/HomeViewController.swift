
//  HomeViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 15/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var searchView : UIView!
    @IBOutlet weak var searchImage : UIImageView!
    @IBOutlet weak var searchIcon : UIImageView!
    @IBOutlet weak var searchText : UITextField!
    @IBOutlet weak var categoryTable : UITableView!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var bannerImage : UIImageView!
    @IBOutlet weak var homeTable : UITableView!
    @IBOutlet weak var topoffersTable : UITableView!
    @IBOutlet weak var bottomImage : UIImageView!
    @IBOutlet weak var popularTable : UITableView!
    @IBOutlet weak var popularAllButton : UIButton!
    @IBOutlet weak var fiftyAllButton : UIButton!
    @IBOutlet weak var topAllButton : UIButton!
    @IBOutlet weak var fiftyView : UIView!
    @IBOutlet weak var dealsTable : UITableView!
    @IBOutlet weak var timeleftLabel : UILabel!
    @IBOutlet weak var dealsLabel : UILabel!
    @IBOutlet weak var hrsLabel : UILabel!
    @IBOutlet weak var grabButton : UIButton!
    @IBOutlet weak var dealsButton : UIButton!
    @IBOutlet weak var dealsTimeView: UIView!
    @IBOutlet weak var dealsTabelView: UITableView!
    @IBOutlet weak var topOffersView: UIView!
    @IBOutlet weak var uptoOfferView: UIView!
    
    @IBOutlet weak var subView1: UIView!
    @IBOutlet var pageControl: UIPageControl!
    
    var DEALVIEW_Y_AXIS = CGFloat()
    
    var isFirstStarted: Bool = false
    var totalFirstCount: Int = 0
    var currentFirst: Int = 0
    
    var categoryHomeArray = [CategoryHome]()
    var bannersArray = [BannersHome]()
    var topOffersArray = [TopOffers]()
    var fiftyPercentArray = [FiftyPercent]()
    var popularArray = [Popular]()
    var dealsArray = [DealsHome]()
    var timerStarts = false
    var currentDate = Date()
    var dateFormatter = DateFormatter()
    var userCalendar = Calendar.current
    var requestedComponent: Set<Calendar.Component> = [.day,.hour,.minute,.second]
    var lastDealTime = String()
    
    
    
    let images = [
        UIImage(named: "StarEmpty"),
        UIImage(named: "StarEmpty"),
        UIImage(named: "StarEmpty"),
        UIImage(named: "StarEmpty")
    ]
    
    var currentIndex = 0
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mycartApi()
        //page controll
        pageControl.numberOfPages = images.count
        startTimer()
        //        let cartButton  = MIBadgeButton()
        //        cartButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //        cartButton.setImage(UIImage(named: "cart-icon"), for: UIControlState())
        //        cartButton.addTarget(self, action: #selector(HomeViewController.cartAction(_:)), for: UIControlEvents.touchUpInside)
        //
        ////        if UserDefaults.standard.object(forKey: "CartCount") != nil {
        ////            print("I am not empty")
        ////            cartButton.badgeString = String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
        ////            UserDefaults.standard.removeObject(forKey: "CartCount")
        ////        } else {
        ////            print("Cart is  empty-----")
        ////        }
        //   //     cartButton.badgeString = String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
        //
        //       // print("this is the code--\(cartButton.badgeString)")
        //        cartButton.badgeTextColor = UIColor.white
        
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        //        let img = UIImageView(image: UIImage(named: "header-logo"))
        //        self.navigationItem.titleView = img
        
        if revealViewController() != nil {
            
            let rightRevealButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu")!, style: .done, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            //self.navigationItem.leftBarButtonItem = rightRevealButtonItem
            //self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
            let image2 = UIImage(named:"header-logo")
            let button2 = UIButton(type: .custom)
            button2.bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(40), height: CGFloat(40))
            //button2.setImage(image2, for: .normal)
            let barButtonItem2 = UIBarButtonItem(customView: button2)
            self.navigationItem.leftBarButtonItems = [rightRevealButtonItem, barButtonItem2]
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        }
        
        //        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(printTime), userInfo: nil, repeats: true)
        //        timer.fire()
        
        //        let color1 = UIColor(red: 25.0/255.0, green:39.0/255.0, blue: 63.0/255.0, alpha: 1.0).cgColor
        //        let color2 = UIColor(red: 44.0/255.0, green: 61.0/255.0, blue: 94.0/255.0, alpha: 1.0).cgColor
        //        let color3 = UIColor(red: 25.0/255.0, green:39.0/255.0, blue: 63.0/255.0, alpha: 1.0).cgColor
        
        let color1 = UIColor(red: 0.0/255.0, green:170.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor
        let color2 = UIColor(red: 0.0/255.0, green: 170.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor
        let color3 = UIColor(red: 0.0/255.0, green:170.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color1, color2, color3]
        gradientLayer.frame = searchView.bounds
        searchView.layer.addSublayer(gradientLayer)
        
        searchImage.layer.cornerRadius = 5.0
        searchView.addSubview(searchImage)
        searchView.addSubview(searchText)
        searchView.addSubview(searchIcon)
        
        let rotateTable = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi / 2))
        categoryTable.transform = rotateTable
        categoryTable.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(categoryTable.frame.size.height), height: CGFloat(categoryTable.frame.size.width))
        
        let rotateTable1 = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi / 2))
        dealsTable.transform = rotateTable1
        dealsTable.frame = CGRect(x: CGFloat(150), y: CGFloat(290), width: CGFloat(dealsTable.frame.size.height), height: CGFloat(dealsTable.frame.size.width))
        
        _ = CGAffineTransform(rotationAngle: (CGFloat)(Double.pi / 2))
        // dealsButton.transform = rotateTable2
        //        dealsButton.frame = CGRect(x: CGFloat(dealsButton.frame.origin.x), y: CGFloat(dealsButton.frame.origin.y), width: CGFloat(dealsButton.frame.size.width), height: CGFloat(dealsButton.frame.size.height))
        //   dealsButton.layer.cornerRadius = dealsButton.frame.size.width / 2
        
        //        dealsLabel.transform = rotateTable2
        //        dealsLabel.frame = CGRect(x: CGFloat(dealsLabel.frame.origin.x), y: CGFloat(dealsLabel.frame.origin.y), width: CGFloat(dealsLabel.frame.size.width), height: CGFloat(dealsLabel.frame.size.height))
        //
        //        timeleftLabel.transform = rotateTable2
        //        timeleftLabel.frame = CGRect(x: CGFloat(110), y: CGFloat(10), width: CGFloat(30), height: CGFloat(130))
        //
        //        hrsLabel.transform = rotateTable2
        //        hrsLabel.frame = CGRect(x: CGFloat(80), y: CGFloat(10), width: CGFloat(30), height: CGFloat(130))
        //
        //        grabButton.transform = rotateTable2
        //        grabButton.frame = CGRect(x: CGFloat(30), y: CGFloat(10), width: CGFloat(40), height: CGFloat(130))
        
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.colors = [color1, color2, color3]
        //gradientLayer1.frame = bottomImage.bounds
        //bottomImage.layer.addSublayer(gradientLayer1)
        
        topoffersTable.layer.cornerRadius = 5
        popularTable.layer.cornerRadius = 5
        DEALVIEW_Y_AXIS = self.dealsTimeView.frame.minY
        let path = UIBezierPath(roundedRect:fiftyView.bounds, byRoundingCorners:[.topRight, .topLeft],cornerRadii: CGSize(width: 5, height:  5))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        fiftyView.layer.mask = maskLayer
        
        homeTable.frame = CGRect(x: CGFloat(homeTable.frame.origin.x), y: CGFloat(homeTable.frame.origin.y), width: CGFloat(homeTable.frame.size.width), height: CGFloat(UIScreen.main.bounds.size.height - 124))
        
        let reachability = Reachability()!
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            homeApi()
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction(){
        let desiredScrollPosition = (currentIndex < images.count - 1) ? currentIndex + 1 : 0
        collectionView.scrollToItem(at: IndexPath(item: desiredScrollPosition, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    //    @IBAction func onTapGetBannerId(_ sender: Any) {
    //        print("I am tapped")
    //        //  var bannersArray = [BannersHome]()
    //        for items in bannersArray {
    //            print(items.banner_id)
    //        }
    //        // print(bannersArray[0].banner_id)
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mycartApi()
        
        let cartButton  = MIBadgeButton()
        cartButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        cartButton.setImage(UIImage(named: "cart-icon"), for: UIControl.State())
        cartButton.addTarget(self, action: #selector(HomeViewController.cartAction(_:)), for: UIControl.Event.touchUpInside)
        //       cartButton.badgeString =  String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
        //        cartButton.badgeTextColor = UIColor.white
        
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        nameLabel.text = String(format: "Hi %@!", UserDefaults.standard.object(forKey: "UserName") as! String)
        nameLabel.textAlignment = .right
        nameLabel.font = UIFont(name: "SanFranciscoText-Regular", size: 15)
        nameLabel.textColor = UIColor.white
        //
        let rightButton = UIBarButtonItem(customView: cartButton)
        let rightButton1 = UIBarButtonItem(customView: nameLabel)
        self.navigationItem.rightBarButtonItems = [rightButton, rightButton1]
    }
    
    
    
    //for cart issue
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
                                let nameLabel = UILabel()
                                nameLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
                                nameLabel.text = String(format: "Hi %@!", UserDefaults.standard.object(forKey: "UserName") as! String)
                                nameLabel.textAlignment = .right
                                nameLabel.font = UIFont(name: "SanFranciscoText-Regular", size: 15)
                                nameLabel.textColor = UIColor.white
                                
                                let rightButton = UIBarButtonItem(customView: cartButton)
                                let rightButton1 = UIBarButtonItem(customView: nameLabel)
                                self.navigationItem.rightBarButtonItems = [rightButton, rightButton1]
                                
                                
                                
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
    
    
    
    //End
    
    
    func canShowDeal() {
        if self.dealsArray.count == 0 {
            self.dealsTimeView.isHidden = true
            self.dealsTabelView.isHidden = true
            self.topOffersView.frame = CGRect(x: 0, y: self.DEALVIEW_Y_AXIS, width: self.topOffersView.frame.width, height: self.topOffersView.frame.height)
            self.uptoOfferView.frame = CGRect(x: 0, y: DEALVIEW_Y_AXIS+self.topOffersView.frame.height, width: self.uptoOfferView.frame.width, height: self.uptoOfferView.frame.height)
            self.subView1.frame = CGRect(x: 0, y: 0, width: self.subView1.frame.width, height: self.uptoOfferView.frame.maxY)
            
        } else {
            self.dealsTimeView.isHidden = false
            self.dealsTabelView.isHidden = false
            self.topOffersView.frame = CGRect(x: 0, y: self.DEALVIEW_Y_AXIS + self.dealsTimeView.frame.height, width: self.topOffersView.frame.width, height: self.topOffersView.frame.height)
            self.uptoOfferView.frame = CGRect(x: 0, y: self.DEALVIEW_Y_AXIS + self.dealsTimeView.frame.height + self.topOffersView.frame.height, width: self.uptoOfferView.frame.width, height: self.uptoOfferView.frame.height)
            self.subView1.frame = CGRect(x: 0, y: 0, width: self.subView1.frame.width, height: self.uptoOfferView.frame.maxY)
        }
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
    
    func printTime()
    {
        if self.lastDealTime != "" || timerStarts == true {
            timerStarts = true
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter1.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            
            let date = dateFormatter1.date(from:self.lastDealTime )!
            
            let hour = Calendar.current.component(.hour, from: date)
            _ = Calendar.current.component(.second, from: date)
            _ = Calendar.current.component(.minute, from: date)
            
            let currentHour = Calendar.current.component(.hour, from: Date())
            let currentminute = Calendar.current.component(.minute, from: Date())
            let currentSecond = Calendar.current.component(.second, from: Date())
            
            var hourString = "";
            if String(format:"%d", hour-currentHour).count == 1 {
                
                hourString = String(format:"0%d", hour-currentHour)
            }
            else {
                hourString = String(format:"%d", hour-currentHour)
            }
            
            var minuteString = "";
            if String(format:"%d", 60-currentminute).count == 1 {
                
                minuteString = String(format:"0%d", 60-currentminute)
            }
            else {
                minuteString = String(format:"%d", 60-currentminute)
            }
            
            var secondString = "";
            if String(format:"%d", 60-currentSecond).count == 1 {
                
                secondString = String(format:"0%d", 60-currentSecond)
            }
            else {
                secondString = String(format:"%d", 60-currentSecond)
            }
            
            let Stringhere = String(format:"%@  :  %@  :  %@", hourString, minuteString, secondString);
            timeleftLabel.text = Stringhere
        } else {
            
        }
    }
    
    func homeApi() {
        
        // 1
        let reposURL = NSURL(string: String(format:"%@api/home_page", Api_Base_URL))
        // 2
        print(reposURL)
        if let JSONData = NSData(contentsOf: reposURL! as URL) {
            // 3
            if let json = (try? JSONSerialization.jsonObject(with: JSONData as Data, options: [])) as? NSDictionary {
                print(json)
                // 4
                if let reposArray = json["category_details"] as? [NSDictionary] {
                    // 5
                    print(reposArray)
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        for item in reposArray {
                            categoryHomeArray.append(CategoryHome(CategoryHome: item))
                        }
                    }
                }
                
                if let reposArray = json["banner_details"] as? [NSDictionary] {
                    // 5
                    //print(reposArray)
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        for item in reposArray {
                            bannersArray.append(BannersHome(BannersHome: item))
                        }
                    }
                }
                
                if let reposArray = json["deals_of_day_details"] as? [NSDictionary] {
                    // 5
                    print(reposArray)
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        for item in reposArray {
                            dealsArray.append(DealsHome(DealsHome: item))
                        }
                    }
                }
                
                if let reposArray = json["product_top_offer"] as? [NSDictionary] {
                    // 5
                    //print(reposArray)
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        for item in reposArray {
                            topOffersArray.append(TopOffers(TopOffers: item))
                        }
                    }
                }
                
                if let reposArray = json["product_fifty_percent"] as? [NSDictionary] {
                    // 5
                    //print(reposArray)
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        for item in reposArray {
                            fiftyPercentArray.append(FiftyPercent(FiftyPercent: item))
                        }
                    }
                }
                
                if let reposArray = json["most_popular_product"] as? [NSDictionary] {
                    // 5
                    //print(reposArray)
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        for item in reposArray {
                            popularArray.append(Popular(Popular: item))
                        }
                    }
                }
                
                self.lastDealTime =   json["Total_deal_end_time"] as? String ?? "0"
                
                categoryTable.reloadData()
                
                //setBannerImages(bannersArray)
                
                dealsTable.reloadData()
                
                topoffersTable.reloadData()
                
                homeTable.reloadData()
                
                popularTable.reloadData()
                
                self.canShowDeal()
                
                self.view.hideToastActivity()
            }
        }
    }
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.white
        style.messageAlignment = .center
        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        
        self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    
    //    func setBannerImages(_ bannerArray: [BannersHome]) {
    //
    //        totalFirstCount = bannerArray.count
    //        if totalFirstCount == 1 {
    //            bannerImage.yy_imageURL = URL(string: bannerArray[0].banner_image)
    //
    //            bannerImage.kf.setImage(with: URL(string: bannerArray[0].banner_image))
    //            print("banner id------------\(bannerArray[0].banner_id)")
    //        }
    //                    else if !isFirstStarted && (totalFirstCount > 1) {
    //                        isFirstStarted = true
    //                        totalFirstCount = 0
    //                        self.perform(#selector(self.setImage), with: bannerArray, afterDelay: 0.3)
    //                    }
    //    }
    
    //        func setImage(_ thumbArray: [BannersHome]) {
    //
    //            if currentFirst == thumbArray.count {
    //                currentFirst = 0
    //            }
    //            let transition = CATransition()
    //            transition.duration = 0.4
    //            transition.type = kCATransitionFade
    //bannerImage.layer.add(transition, forKey: kCATransition)
    //bannerImage.kf.setImage(with: URL(string: thumbArray[currentFirst].banner_image))
    // bannerImage.yy_imageURL = URL(string: thumbArray[currentFirst].banner_image)
    //            currentFirst += 1
    //            self.perform(#selector(self.setImage), with: thumbArray, afterDelay: 2.0)
    //        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == categoryTable {
            return 65
        }
        else if tableView == dealsTable {
            return 130
        }
        else if tableView == topoffersTable {
            return 220
        }
        else if tableView == popularTable {
            
            if indexPath.row == 1 {
                return 217
            }
            else {
                return 210
            }
        }
        else {
            
            if indexPath.row == 1 {
                return 99
            }
            else {
                return 100
            }
        }
    }
    // Customize the number of rows in the table view.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == categoryTable {
            
            return categoryHomeArray.count
        }
        else if tableView == dealsTable {
            // print(dealsArray.count)
            if dealsArray.count == 0 {
                
            }
            return dealsArray.count
        }
        else if tableView == topoffersTable {
            
            return 1
        }
        else if tableView == popularTable {
            
            return 2
        }
        else {
            
            return 2
        }
    }
    // Customize the appearance of table view cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == categoryTable {
            
            let CellIdentifier: String = "CategoryCell"
            var cell: CategoryCell? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? CategoryCell)
            if cell == nil {
                var topLevelObjects: [Any] = Bundle.main.loadNibNamed("CategoryCell", owner: self, options: nil)!
                cell = (topLevelObjects[0] as? CategoryCell)
            }
            
            cell!.categoryImage.layer.cornerRadius = cell!.categoryImage.frame.size.width / 2
            cell!.categoryImage.layer.borderWidth = 0.5
            cell!.categoryImage.layer.borderColor = UIColor(red: 230.0/255.0, green:230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
            
            if categoryHomeArray[indexPath.row].category_image == "" {
                cell!.categoryImage.image = UIImage(named: "no-image-icon")
            }
            else {
                cell!.categoryImage.yy_imageURL = URL(string: categoryHomeArray[indexPath.row].category_image)
                cell!.categoryImage.kf.setImage(with: (StringToURL(text: categoryHomeArray[indexPath.row].category_image)))
            }
            
            cell!.categorynameLabel.text = categoryHomeArray[indexPath.row].category_name
            
            let rotateImage = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            cell!.transform = rotateImage
            cell!.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if tableView == self.dealsTable {
            
            let CellIdentifier: String = "DealsCell"
            var cell: DealsCell? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? DealsCell)
            if cell == nil {
                var topLevelObjects: [Any] = Bundle.main.loadNibNamed("DealsCell", owner: self, options: nil)!
                cell = (topLevelObjects[0] as? DealsCell)
            }
            //print("dealsArray--------->",dealsArray)
            //cell!.dealsImage.yy_imageURL = URL(string: dealsArray[indexPath.row].deal_image)
            cell!.dealsImage.kf.setImage(with: (StringToURL(text: dealsArray[indexPath.row].deal_image)))
            cell?.dealpercentageLabel.text = String(format:"%@%% OFF", dealsArray[indexPath.row].deal_percentage)
            cell?.dealpriceLabel.text = String(format:"%@%@", dealsArray[indexPath.row].currency_symbol, dealsArray[indexPath.row].deal_price)
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (cell?.dealpriceLabel.text)!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell?.dealpriceLabel.attributedText = attributeString
            
            cell?.dealdiscountpriceLabel.text = String(format:"%@%@", dealsArray[indexPath.row].currency_symbol, dealsArray[indexPath.row].deal_discount_price)
            
            let rotateImage = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            cell!.transform = rotateImage
            cell!.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if tableView == topoffersTable {
            
            let cellIdentifier = "CustomCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
            
            var xyz = Int(indexPath.row)
            xyz = xyz * 2
            
            cell.topofferImage1.kf.setImage(with: (StringToURL(text: topOffersArray[xyz].product_image)))
            
            cell.topofferImage1.yy_imageURL = URL(string: topOffersArray[xyz].product_image)
            
            cell.topTitleLabel1.text = topOffersArray[xyz].product_title
            //cell.topMerchantNameLabel1.text = topOffersArray[xyz].merchant_name
            //cell.topMerchantNameLabel1.text = topOffersArray[xyz].merchant_name
            cell.TopTitleMerchantNmae.text = topOffersArray[xyz].merchant_name
            cell.topPriceLabel1.text = String(format:"%@%@", topOffersArray[xyz].currency_symbol, topOffersArray[xyz].product_discount_price)
            cell.topDiscountPriceLabel1.text = String(format:"%@%@", topOffersArray[xyz].currency_symbol, topOffersArray[xyz].product_price)
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.topDiscountPriceLabel1.text!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.topDiscountPriceLabel1.attributedText = attributeString
            
            cell.topPercentageLabel1.text = String(format:"%@%% OFF", topOffersArray[xyz].product_percentage)
            
            if (xyz + 1) >= topOffersArray.count {
                
                cell.topOfferView2.isHidden = true
            }
            else {
                
                cell.topOfferView2.isHidden = false
                //cell.topofferImage2.yy_imageURL = URL(string: topOffersArray[xyz+1].product_image)
                cell.topofferImage2.kf.setImage(with: (StringToURL(text: topOffersArray[xyz+1].product_image)))
                cell.topTitleLabel2.text = topOffersArray[xyz+1].product_title
                //cell.topMerchantNameLabel2.text = topOffersArray[xyz+1].merchant_name
                //cell.topMerchantNameLabel2.text = topOffersArray[xyz+1].merchant_name
                cell.topTitleLBL2MerchantName.text = topOffersArray[xyz+1].merchant_name
                cell.topPriceLabel2.text = String(format:"%@%@", topOffersArray[xyz+1].currency_symbol, topOffersArray[xyz+1].product_discount_price)
                cell.topDiscountPriceLabel2.text = String(format:"%@%@", topOffersArray[xyz+1].currency_symbol, topOffersArray[xyz+1].product_price)
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.topDiscountPriceLabel2.text!)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.topDiscountPriceLabel2.attributedText = attributeString
                
                cell.topPercentageLabel2.text = String(format:"%@%% OFF", topOffersArray[xyz+1].product_percentage)
            }
            
            cell.tapButton1.tag = xyz
            cell.tapButton1.addTarget(self, action: #selector(detailTapped), for: .touchUpInside)
            cell.tapButton2.tag = xyz + 1
            cell.tapButton2.addTarget(self, action: #selector(detailTapped), for: .touchUpInside)
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        else if tableView == popularTable {
            
            
            let cellIdentifier = "CustomCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
            
            var xyz = Int(indexPath.row)
            xyz = xyz * 2
            if popularArray.count > 0{
                cell.popularImage1.yy_imageURL = URL(string: popularArray[xyz].product_image)
                
                //            cell.popularImage1.kf.setImage(with: (StringToURL(text: popularArray[xyz].product_image)))
                cell.popularTitleLabel1.text = popularArray[xyz].product_title
                cell.giftMerchantNameLbl1.text = popularArray[xyz].merchant_name
                //      cell.titleMerchantName.text = popularArray[xyz].merchant_name
                cell.popularPriceLabel1.text = String(format:"%@%@", popularArray[xyz].currency_symbol, popularArray[xyz].product_discount_price)
            }else{
                //cell.popularImage1.yy_imageURL = URL(string: popularArray[xyz].product_image)
                
                //            cell.popularImage1.kf.setImage(with: (StringToURL(text: popularArray[xyz].product_image)))
                cell.popularTitleLabel1.text = "gatis"
                cell.giftMerchantNameLbl1.text = "gatis"
                //      cell.titleMerchantName.text = popularArray[xyz].merchant_name
                cell.popularPriceLabel1.text = "gatis"
            }
            
            
            
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.popularpercentageLabel1.text!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.popularpercentageLabel1.attributedText = attributeString
            
            cell.popularpercentageLabel1.text = String(format:"%@%% OFF", topOffersArray[xyz+1].product_percentage)
            
            
            
            if (xyz + 1) >= popularArray.count {
                
                cell.popularView2.isHidden = true
            }
            else {
                
                cell.popularView2.isHidden = false
                //cell.popularImage2.yy_imageURL = URL(string: popularArray[xyz+1].product_image)
                cell.popularImage2.kf.setImage(with: (StringToURL(text: popularArray[xyz+1].product_image)))
                cell.popularTitleLabel2.text = popularArray[xyz+1].product_title
                cell.giftMerchantNameLbl2.text = popularArray[xyz].merchant_name
                cell.popularPriceLabel2.text = String(format:"%@%@", popularArray[xyz+1].currency_symbol, popularArray[xyz+1].product_discount_price)
                
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.popularPercentageLabel2.text!)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.popularPercentageLabel2.attributedText = attributeString
                
                cell.popularPercentageLabel2.text = String(format:"%@%% OFF", topOffersArray[xyz+1].product_percentage)
            }
            
            cell.tapButton1.tag = xyz
            cell.tapButton1.addTarget(self, action: #selector(popularTapped), for: .touchUpInside)
            cell.tapButton2.tag = xyz + 1
            cell.tapButton2.addTarget(self, action: #selector(popularTapped), for: .touchUpInside)
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        else {
            
            let cellIdentifier = "CustomCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
            
            // cell.productImage.yy_imageURL = URL(string: fiftyPercentArray[indexPath.row].product_image)
            cell.productImage.kf.setImage(with: (StringToURL(text: fiftyPercentArray[indexPath.row].product_image)))
            cell.titleLabel.text = fiftyPercentArray[indexPath.row].product_title
            
            cell.titleMerchantName.text = fiftyPercentArray[indexPath.row].merchant_name
            
            cell.priceLabel.text = String(format:"%@%@", fiftyPercentArray[indexPath.row].currency_symbol, fiftyPercentArray[indexPath.row].product_discount_price)
            
            
            
            cell.percentageLabel.text = String(format:"%@%% OFF", fiftyPercentArray[indexPath.row].product_percentage)
            
            if indexPath.row == 1 {
                
                let path = UIBezierPath(roundedRect:cell.homeView.bounds, byRoundingCorners:[.bottomLeft, .bottomRight],cornerRadii: CGSize(width: 5, height:  5))
                
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                cell.homeView.layer.mask = maskLayer
            }
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == categoryTable {
            
            if categoryHomeArray[indexPath.row].sub_category_list.count == 0 {
                
                let objProduct = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                objProduct.main_category_id = categoryHomeArray[indexPath.row].category_id
                objProduct.sec_category_id = ""
                objProduct.sub_category_id = ""
                objProduct.sub_sec_category_id = ""
                objProduct.category_name = categoryHomeArray[indexPath.row].category_name
                objProduct.sort_order_by = ""
                objProduct.screenString = ""
                self.navigationController?.pushViewController(objProduct, animated: true)
            }
            else {
                
                let objSub = self.storyboard?.instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
                objSub.parent_category_id = categoryHomeArray[indexPath.row].category_id
                objSub.parent_category_name = categoryHomeArray[indexPath.row].category_name
                
                let reposArray = categoryHomeArray[indexPath.row].sub_category_list
                objSub.sec_category_id = String(reposArray[0].object(forKey: "category_id") as! NSInteger)
                self.navigationController?.pushViewController(objSub, animated: true)
            }
        }
        else if tableView == homeTable {
            
            let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            objProductDetails.category_name = "Hot Deals"
            objProductDetails.product_id = fiftyPercentArray[indexPath.row].product_id
            self.navigationController?.pushViewController(objProductDetails, animated: true)
        }
        else if tableView == dealsTable {
            
            let objDealDetails = self.storyboard?.instantiateViewController(withIdentifier: "DealDetailsViewController") as! DealDetailsViewController
            objDealDetails.deal_id = dealsArray[indexPath.row].deal_id
            self.navigationController?.pushViewController(objDealDetails, animated: true)
        }
    }
    
     @objc func detailTapped(sender:UIButton ) {
        
        let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        objProductDetails.category_name = "Latest Product"
        objProductDetails.product_id = topOffersArray[sender.tag].product_id
        self.navigationController?.pushViewController(objProductDetails, animated: true)
    }
    
     @objc func popularTapped(sender:UIButton ) {
        
        let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        objProductDetails.category_name = "Gift Products"
        objProductDetails.product_id = popularArray[sender.tag].product_id
        self.navigationController?.pushViewController(objProductDetails, animated: true)
    }
    
    
    
    @IBAction func popularAllButton(sender:UIButton ) {
        
        let objProduct = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        objProduct.main_category_id = ""
        objProduct.sec_category_id = ""
        objProduct.sub_category_id = ""
        objProduct.sub_sec_category_id = ""
        objProduct.category_name = "Gift Products"
        objProduct.sort_order_by = "1"
        objProduct.screenString = ""
        self.navigationController?.pushViewController(objProduct, animated: true)
        //        var GiftProducts = 3
        //        UserDefaults.standard.set("GiftProducts", forKey: "GiftProducts")
        //  UserDefaults.standard.set(true, forKey: "Key3")
        let three = sender.tag
        
        if sender.tag == 3 {
            UserDefaults.standard.set(true, forKey: "giftButton")
            print(three)
        }
        // UserDefaults.standard.set("\(three)", forKey: "three")
        //       UserDefaults.standard.set(3, forKey: "Key")
        
    }
    
    @IBAction func fiftyAllButton(sender:UIButton ) {
        
        let objProduct = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        objProduct.main_category_id = ""
        objProduct.sec_category_id = ""
        objProduct.sub_category_id = ""
        objProduct.sub_sec_category_id = ""
        objProduct.category_name = "Hot Deals"
        objProduct.discount = ""
        objProduct.screenString = ""
        objProduct.is_approved = 1
        objProduct.is_published = 1
        objProduct.featured = 1
        self.navigationController?.pushViewController(objProduct, animated: true)
        //        var HotDeals = 2
        //        UserDefaults.standard.set("HotDeals", forKey: "HotDeals")
        //        UserDefaults.standard.set("Hot Deals", forKey: "Key2")
        //       var two = sender.tag
        //        print(two)
        
        let two = sender.tag
        
        if sender.tag == 2 {
            UserDefaults.standard.set(true, forKey: "HotButton")
            UserDefaults.standard.set(true, forKey: "forcategory")
            print(two)
        }
        
    }
    
    @IBAction func topAllButton(sender:UIButton ) {
        
        let objProduct = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        objProduct.main_category_id = ""
        objProduct.sec_category_id = ""
        objProduct.sub_category_id = ""
        objProduct.sub_sec_category_id = ""
        objProduct.category_name = "Latest Deals"//Latest Product
        objProduct.discount = ""
        objProduct.screenString = ""
        self.navigationController?.pushViewController(objProduct, animated: true)
        //         var LatestDeals = 2
        //        UserDefaults.standard.set("LatestDeals", forKey: "LatestDeals")
        // UserDefaults.standard.set(true, forKey: "Key1")
        
        
        
        let one = sender.tag
        if sender.tag == 1 {
            UserDefaults.standard.set(true, forKey: "LatestButton")
            print(one)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       currentIndex = Int(scrollView.contentOffset.x / 5 + collectionView.frame.size.width)
        pageControl.currentPage = currentIndex
        searchText.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == searchText) {
            
            searchText.resignFirstResponder()
            
            let objProduct = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            objProduct.main_category_id = ""
            objProduct.sec_category_id = ""
            objProduct.sub_category_id = ""
            objProduct.sub_sec_category_id = ""
            objProduct.category_name = searchText.text
            objProduct.titleString = searchText.text
            objProduct.screenString = ""
            self.navigationController?.pushViewController(objProduct, animated: true)
        }
        
        return true
    }
    
    @IBAction func grabButton(sender:UIButton ) {
        
        let objDeals = self.storyboard?.instantiateViewController(withIdentifier: "DealsViewController") as! DealsViewController
        self.navigationController?.pushViewController(objDeals, animated: true)
    }
    
    @IBAction func dealsButton(sender:UIButton ) {
        
        let objDeals = self.storyboard?.instantiateViewController(withIdentifier: "DealsViewController") as! DealsViewController
        self.navigationController?.pushViewController(objDeals, animated: true)
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

func StringToURL(text: String) -> URL{
    let url : NSString = text as NSString
    let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
    let imageURL : URL = URL(string: urlStr as String)!
    return imageURL
}



extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return bannersArray.count
        //return images.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
        
       // cell.image = images[indexPath.item]
        
        //  cell.imageView = UIImage(named: bannersArray[indexPath.item])//bannersArray[indexPath.item].banner_image.toImage()
        
        //cell.image =  bannersArray[indexPath.item]
        //cell.image = UIImage(named: bannersArray[indexPath.item])
        // cell.image = bannersArray[indexPath.item].banner_image.toImage()
        //        cell.imageView.image = UIImage(data: Data(contentsOf: bannersArray[indexPath.item].banner_image.toImage()))
        
        
        if let url = URL(string: bannersArray[indexPath.item].banner_image) {
            DispatchQueue.main.async {
                cell.imageView.kf.setImage(with: url, placeholder: nil)
            }
            //            do {
            //                let data = try Data(contentsOf: url)
            //                cell.image = UIImage(data:data)
            //              //  cell.imageView.kf.setImage(with: url, placeholder: nil)
            //
            //            } catch let err {
            //                print("Error  : \(err.localizedDescription)")
            //            }
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        currentIndex = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
//        pageControl.currentPage = currentIndex
//        searchText.resignFirstResponder()
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.product_id = bannersArray[indexPath.item].banner_id
        self.navigationController?.pushViewController(vc, animated: true)
        print("i am tapped manu")
    }
    
}



extension String {
    
    func toImage() -> UIImage? {
        
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            
            return UIImage(data: data)
            
        }
        
        return nil
        
    }
    
}
