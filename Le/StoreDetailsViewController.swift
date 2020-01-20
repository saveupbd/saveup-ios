//
//  StoreDetailsViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 04/05/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class StoreDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReviewDelegate {

    @IBOutlet weak var storeButton : UIButton!
    @IBOutlet weak var dealsButton : UIButton!
    @IBOutlet weak var productsButton : UIButton!
    @IBOutlet weak var lineImage1 : UIImageView!
    @IBOutlet weak var lineImage2 : UIImageView!
    @IBOutlet weak var lineImage3 : UIImageView!
    @IBOutlet weak var productTable : UITableView!
    @IBOutlet weak var dealsTable : UITableView!
    @IBOutlet weak var storeView : UIView!
    @IBOutlet weak var storeImage : YYAnimatedImageView!
    @IBOutlet weak var storenameLabel : UILabel!
    @IBOutlet weak var addressLabel : UILabel!
    @IBOutlet weak var branchesLabel : UILabel!
    @IBOutlet weak var branchesTable : UITableView!
    @IBOutlet weak var reviewView : UIView!
    @IBOutlet weak var headerView : UIView!
    @IBOutlet weak var reviewTable : UITableView!
    @IBOutlet weak var reviewButton : UIButton!
    
    var shop_id: String!
    var merchant_id: String!
    
    var demo : String!
    
    var storesArray = [Stores]()
    var productsArray = [Products]()
    var dealsArray = [Deals]()
    var reviewArray = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mycartApi()
        print("i am giving you the merchant id -- \(shop_id)")
        print("Belloww demo")
        
//        if UserDefaults.standard.string(forKey: "merchant_id") != nil {
//            var shop_id = UserDefaults.standard.string(forKey: "merchant_id")
//            UserDefaults.standard.removeObject(forKey: "merchant_id")
//        }
        

//          let merchant_id = UserDefaults.standard.string(forKey: "merchant_id")
//        print("Store merchant id --\(merchant_id!)")
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        let img = UIImageView(image: UIImage(named: "header-logo"))
        //self.navigationItem.titleView = img
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(StoreDetailsViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        //self.navigationItem.leftBarButtonItem = LeftButton
        
        lineImage1.isHidden = false
        lineImage2.isHidden = true
        lineImage3.isHidden = true
        
        productTable.isHidden = true
        dealsTable.isHidden = true
        reviewTable.isHidden = false
        
        storeView.layer.cornerRadius = 5.0
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            storedetailsApi()
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
        cartButton.addTarget(self, action: #selector(StoreDetailsViewController.cartAction(_:)), for: UIControl.Event.touchUpInside)
//        cartButton.badgeString = String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
        cartButton.badgeTextColor = UIColor.white
        
        let rightButton = UIBarButtonItem(customView: cartButton)
        //self.navigationItem.rightBarButtonItem = rightButton
        
        //UserDefaults.standard.removeObject(forKey: "CartCount")
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
                                //self.navigationItem.rightBarButtonItem = rightButton
                                
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
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.black
        style.messageAlignment = .center
        style.backgroundColor = UIColor.white
        
        self.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    
    func storedetailsApi() {
        
        let myUrl = URL(string: String(format:"%@api/shop_detail_by_id", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
//        if UserDefaults.standard.string(forKey: "merchant_id") != nil {
//             var shop_id = UserDefaults.standard.string(forKey: "merchant_id")
//           UserDefaults.standard.removeObject(forKey: "merchant_id")
//        }
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            postString = "shopid=\(shop_id!)&user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&lang=en"
        }else{
            postString = "shopid=\(shop_id!)&lang=en"
        }
        
        
        print(postString)//&shopid=\(merchant_id!)//\(shop_id!)
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
                            
                            if let reposArray = parseJSON["store_details"] as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    if reposArray[0].object(forKey: "store_img") as! String == "" {
                                        self.storeImage.image = UIImage(named: "no-image-icon")
                                    }
                                    else {
                                        self.storeImage.yy_imageURL = URL(string: reposArray[0].object(forKey: "store_img") as! String)
                                    }
                                    
                                    var Yvalue:CGFloat = 310
                                    
                                    self.storenameLabel.numberOfLines = 0
                                    self.storenameLabel.text = reposArray[0].object(forKey: "store_name") as? String
                                    let expectedLabelSize: CGSize = self.storenameLabel.text!.boundingRect(with: CGSize(width:UIScreen.main.bounds.size.width - 30, height:9999), options: ([.usesLineFragmentOrigin, .usesFontLeading]), attributes: [
                                        NSAttributedString.Key.font : self.storenameLabel.font], context: nil).size
                                    self.storenameLabel.frame = CGRect(x: CGFloat(self.storenameLabel.frame.origin.x), y: CGFloat(Yvalue), width: CGFloat(self.storenameLabel.frame.size.width), height: CGFloat(expectedLabelSize.height + 10))
                                    
                                    Yvalue = Yvalue + expectedLabelSize.height + 10
                                    
                                    var tempDescription = ""
                                    
                                    if reposArray[0].object(forKey: "description") as? String != nil {
                                        
                                        tempDescription = (reposArray[0].object(forKey: "description") as? String)!
                                    }
//                                    if reposArray[0].object(forKey: "store_address2") as? String != nil {
//
//                                        addressStr += String(format: "\n%@", (reposArray[0].object(forKey: "store_address2") as? String)!)
//                                    }
//                                    if reposArray[0].object(forKey: "store_city_name") as? String != nil {
//
//                                        addressStr += String(format: "\n%@", (reposArray[0].object(forKey: "store_city_name") as? String)!)
//                                    }
//                                    if reposArray[0].object(forKey: "store_country_name") as? String != nil {
//
//                                        addressStr += String(format: "\n%@", (reposArray[0].object(forKey: "store_country_name") as? String)!)
//                                    }
//                                    if reposArray[0].object(forKey: "store_zipcode") as? String != nil {
//
//                                        addressStr += String(format: "\n%@", (reposArray[0].object(forKey: "store_zipcode") as? String)!)
//                                    }
//                                    if reposArray[0].object(forKey: "store_phone") as? String != nil {
//                                        
//                                        addressStr += String(format: "\nMobile: %@", (reposArray[0].object(forKey: "store_phone") as? String)!)
//                                    }
                                    
                                    self.addressLabel.numberOfLines = 0
                                    self.addressLabel.attributedText = tempDescription.convertHtml()
                                    let expectedLabelSize1: CGSize = self.addressLabel.text!.boundingRect(with: CGSize(width:UIScreen.main.bounds.size.width - 30, height:9999), options: ([.usesLineFragmentOrigin, .usesFontLeading]), attributes: [
                                        NSAttributedString.Key.font : self.addressLabel.font], context: nil).size
                                    self.addressLabel.frame = CGRect(x: CGFloat(self.addressLabel.frame.origin.x), y: CGFloat(Yvalue), width: CGFloat(self.addressLabel.frame.size.width), height: CGFloat(expectedLabelSize1.height + 10))
                                    
                                    Yvalue = Yvalue + expectedLabelSize1.height + 10
                                    
                                    Yvalue = Yvalue + 10
                                    
                                    self.storeView.frame = CGRect(x: CGFloat(self.storeView.frame.origin.x), y: CGFloat(self.storeView.frame.origin.y), width: CGFloat(self.storeView.frame.size.width), height: CGFloat(Yvalue))
                                    
                                    if let reposArray = parseJSON["branch_list"] as? [NSDictionary] {
                                        // 5
                                        if reposArray.count == 0 {
                                            
                                            self.branchesLabel.isHidden = true
                                            self.branchesTable.isHidden = true
                                            
                                            Yvalue = Yvalue + 15
                                            
                                            self.reviewView.frame = CGRect(x: CGFloat(self.reviewView.frame.origin.x), y: CGFloat(Yvalue), width: CGFloat(self.reviewView.frame.size.width), height: CGFloat(self.reviewView.frame.size.height))
                                            
                                            Yvalue = Yvalue + 50
                                            
                                            self.headerView.frame = CGRect(x: CGFloat(self.headerView.frame.origin.x), y: CGFloat(self.headerView.frame.origin.y), width: CGFloat(self.headerView.frame.size.width), height: CGFloat(Yvalue))
                                            
                                            self.reviewTable.tableHeaderView = self.headerView
                                        }
                                        else {
                                           
                                            for item in reposArray {
                                                self.storesArray.append(Stores(Stores: item))
                                            }
                                            
                                            self.branchesTable.reloadData()
                                            
                                            Yvalue = Yvalue + 15
                                            
                                            self.branchesLabel.frame = CGRect(x: CGFloat(self.branchesLabel.frame.origin.x), y: CGFloat(Yvalue), width: CGFloat(self.branchesLabel.frame.size.width), height: CGFloat(self.branchesLabel.frame.size.height))
                                            
                                            Yvalue = Yvalue + 40
                                            
                                            self.branchesTable.frame = CGRect(x: CGFloat(self.branchesTable.frame.origin.x), y: CGFloat(Yvalue), width: CGFloat(self.branchesTable.frame.size.width), height: CGFloat(self.branchesTable.contentSize.height))
                                            
                                            Yvalue = Yvalue + self.branchesTable.contentSize.height
                                            
                                            self.reviewView.frame = CGRect(x: CGFloat(self.reviewView.frame.origin.x), y: CGFloat(Yvalue), width: CGFloat(self.reviewView.frame.size.width), height: CGFloat(self.reviewView.frame.size.height))
                                            
                                            Yvalue = Yvalue + 50
                                            
                                            self.headerView.frame = CGRect(x: CGFloat(self.headerView.frame.origin.x), y: CGFloat(self.headerView.frame.origin.y), width: CGFloat(self.headerView.frame.size.width), height: CGFloat(Yvalue))
                                            
                                            self.reviewTable.tableHeaderView = self.headerView
                                        }
                                    }
                                }
                            }
                            
                            if let reposArray = parseJSON["store_review"] as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.reviewArray.append(Review(Review: item))
                                    }
                                }
                                self.reviewTable.reloadData()
                            }
                            
                            if let reposArray = parseJSON["product_list_by_shop"] as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.productsArray.append(Products(Products: item))
                                    }
                                }
                                self.productTable.reloadData()
                            }
                            
                            if let reposArray = parseJSON["deal_list_by_shop"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.dealsArray.append(Deals(Deals: item))
                                    }
                                }
                                self.dealsTable.reloadData()
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
    
    @IBAction func storeButton(sender:UIButton ) {
        
        lineImage1.isHidden = false
        lineImage2.isHidden = true
        lineImage3.isHidden = true
        
        reviewTable.isHidden = false
        productTable.isHidden = true
        dealsTable.isHidden = true
    }
    
    @IBAction func dealsButton(sender:UIButton ) {
        
        lineImage1.isHidden = true
        lineImage2.isHidden = false
        lineImage3.isHidden = true
        
        reviewTable.isHidden = true
        productTable.isHidden = true
        dealsTable.isHidden = false
        
        if dealsArray.count == 0 {
            
            var style = ToastStyle()
            style.messageFont = messageFont!
            style.messageColor = UIColor.white
            style.messageAlignment = .center
            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
            
            self.view.makeToast("No Deals Available!", duration: 1.0, position: .center, style: style)
        }
    }
    
    @IBAction func productsButton(sender:UIButton ) {

        lineImage1.isHidden = true
        lineImage2.isHidden = true
        lineImage3.isHidden = false

        reviewTable.isHidden = true
        productTable.isHidden = false
        dealsTable.isHidden = true
        //self.productTable.reloadData()
//        if productsArray.count == 0 {
//
//            var style = ToastStyle()
//            style.messageFont = messageFont!
//            style.messageColor = UIColor.white
//            style.messageAlignment = .center
//            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
//
//            self.view.makeToast("No Products Available!", duration: 1.0, position: .center, style: style)
//        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == productTable {
            
            return 120
        }
        else if tableView == dealsTable {
            
            return 270
        }
        else if tableView == reviewTable {
            
            var Yvalue:CGFloat = 80
            
            let lbl1 = UILabel()
            lbl1.numberOfLines = 0
            lbl1.text = reviewArray[indexPath.row].review_comments
            lbl1.font = UIFont(name: "SanFranciscoText-Light", size: CGFloat(14))
            let expectedLabelSize1 = lbl1.text?.boundingRect(with: CGSize(width: CGFloat(UIScreen.main.bounds.size.width - 20), height: CGFloat(9999)), options: ([.usesLineFragmentOrigin, .usesFontLeading]), attributes: [ NSAttributedString.Key.font : lbl1.font], context: nil).size
            
            Yvalue = Yvalue + (expectedLabelSize1?.height)! + 10
            
            return Yvalue
        }
        else {
             return 95
        }
    }
    // Customize the number of rows in the table view.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == productTable {
            return productsArray.count
            /*var devide: Int = productsArray.count / 2
            if productsArray.count % 2 > 0 {
                devide += 1
            }
            return devide*/
        }
        else if tableView == dealsTable {
            
            var devide: Int = dealsArray.count / 2
            if dealsArray.count % 2 > 0 {
                devide += 1
            }
            return devide
        }
        else if tableView == reviewTable {
            
            return reviewArray.count
        }
        else {
            
            return storesArray.count
        }
    }
    // Customize the appearance of table view cells.
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    func StringToURL(text: String) -> UIImage{
        var downloadedImage:UIImage?
        let url : NSString = text as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        let imageURL : URL = URL(string: urlStr as String)!
        //let url = URL(string: "http://i.imgur.com/w5rkSIj.jpg")
        let data = try? Data(contentsOf: imageURL)

        if let imageData = data {
            let image = UIImage(data: imageData)
            downloadedImage = self.resizeImage(image: image!, targetSize: CGSize(width: 80, height: 80))
            print(downloadedImage?.size)
            return downloadedImage!
        }
        return downloadedImage!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == productTable {
            
            let cellIdentifier = "FdealsCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            cell.imageView?.image = self.StringToURL(text: productsArray[indexPath.row].product_image)
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.text = productsArray[indexPath.row].product_title
            cell.detailTextLabel!.numberOfLines = 0
            cell.detailTextLabel!.text = "\(productsArray[indexPath.row].merchant_name!)\n\("৳" + productsArray[indexPath.row].product_discount_price!)\n\(productsArray[indexPath.row].product_percentage! + "% off")"
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            //cell.detailTextLabel?.text = productsArray[indexPath.row].merchant_name
            
            
            /*var xyz = Int(indexPath.row)
            xyz = xyz * 2
            
            cell.bgView.layer.borderWidth = 0.5
            cell.bgView.layer.borderColor = UIColor(red: 230.0/255.0, green:230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
            
            cell.topofferImage1.yy_imageURL = URL(string: productsArray[xyz].product_image)
            cell.topTitleLabel1.text = productsArray[xyz].product_title
            cell.topMerchentNameLabel.text = productsArray[xyz].merchant_name
            cell.topPriceLabel1.text = String(format:"%@%@", productsArray[xyz].currency_symbol, productsArray[xyz].product_discount_price)
            cell.topDiscountPriceLabel1.text = String(format:"%@%@", productsArray[xyz].currency_symbol, productsArray[xyz].product_price)
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.topDiscountPriceLabel1.text!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.topDiscountPriceLabel1.attributedText = attributeString
            
            cell.topPercentageLabel1.text = String(format:"%@%% OFF", productsArray[xyz].product_percentage)
            
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
                cell.topMerchantNameLbl.text = productsArray[xyz+1].merchant_name
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
            cell.tapButton1.addTarget(self, action: #selector(detailproductTapped), for: .touchUpInside)
            cell.tapButton2.tag = xyz + 1
            cell.tapButton2.addTarget(self, action: #selector(detailproductTapped), for: .touchUpInside)
            */
            //cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        else if tableView == dealsTable {
            
            let cellIdentifier = "CustomCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
            
            var xyz = Int(indexPath.row)
            xyz = xyz * 2
            
            cell.bgView.layer.borderWidth = 0.5
            cell.bgView.layer.borderColor = UIColor(red: 230.0/255.0, green:230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
            
            cell.topofferImage1.yy_imageURL = URL(string: dealsArray[xyz].deal_image)
            cell.topTitleLabel1.text = dealsArray[xyz].deal_title
            cell.topMerchentNameLabel.text = productsArray[xyz].merchant_name
            cell.topPriceLabel1.text = String(format:"%@%@", dealsArray[xyz].deal_currency_symbol, dealsArray[xyz].deal_discount_price)
            cell.topDiscountPriceLabel1.text = String(format:"%@%@", dealsArray[xyz].deal_currency_symbol, dealsArray[xyz].deal_original_price)
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.topDiscountPriceLabel1.text!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.topDiscountPriceLabel1.attributedText = attributeString
            
            cell.topPercentageLabel1.text = String(format:"%@%% OFF", dealsArray[xyz].deal_discount_percentage)
            
            cell.showTimer1(toDate: dealsArray[xyz].ios_deal_end_date)
            
            if (xyz + 1) >= dealsArray.count {
                
                cell.topOfferView2.isHidden = true
            }
            else {
                
                cell.topOfferView2.isHidden = false
                cell.topofferImage2.yy_imageURL = URL(string: dealsArray[xyz+1].deal_image)
                cell.topTitleLabel2.text = dealsArray[xyz+1].deal_title
                cell.topMerchantNameLbl.text = productsArray[xyz+1].merchant_name
                cell.topPriceLabel2.text = String(format:"%@%@", dealsArray[xyz+1].deal_currency_symbol, dealsArray[xyz+1].deal_discount_price)
                cell.topDiscountPriceLabel2.text = String(format:"%@%@", dealsArray[xyz+1].deal_currency_symbol, dealsArray[xyz+1].deal_original_price)
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.topDiscountPriceLabel2.text!)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.topDiscountPriceLabel2.attributedText = attributeString
                
                cell.topPercentageLabel2.text = String(format:"%@%% OFF", dealsArray[xyz+1].deal_discount_percentage)
                
                cell.showTimer2(toDate: dealsArray[xyz+1].ios_deal_end_date)
            }
            
            cell.tapButton1.tag = xyz
            cell.tapButton1.addTarget(self, action: #selector(detaildealTapped), for: .touchUpInside)
            cell.tapButton2.tag = xyz + 1
            cell.tapButton2.addTarget(self, action: #selector(detaildealTapped), for: .touchUpInside)
            
            //cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        else if tableView == reviewTable {
            
            let cellIdentifier = "CustomCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
            
            cell.usernameLabel.text = reviewArray[indexPath.row].user_name
            
            cell.reviewtitleLabel.text = reviewArray[indexPath.row].review_title
            
            var Yvalue:CGFloat = 80
            
            cell.reviewcommentLabel.numberOfLines = 0
            cell.reviewcommentLabel.text = reviewArray[indexPath.row].review_comments
            let expectedLabelSize1 = cell.reviewcommentLabel.text?.boundingRect(with: CGSize(width: CGFloat(UIScreen.main.bounds.size.width - 20), height: CGFloat(9999)), options: ([.usesLineFragmentOrigin, .usesFontLeading]), attributes: [ NSAttributedString.Key.font : cell.reviewcommentLabel.font], context: nil).size
            cell.reviewcommentLabel.frame = CGRect(x: CGFloat(cell.reviewcommentLabel.frame.origin.x), y: CGFloat(cell.reviewcommentLabel.frame.origin.y), width: CGFloat(cell.reviewcommentLabel.frame.size.width), height: CGFloat((expectedLabelSize1?.height)! + 10))
            
            Yvalue = Yvalue + (expectedLabelSize1?.height)! + 10
            
            cell.lineImage.frame = CGRect(x: CGFloat(cell.lineImage.frame.origin.x), y: CGFloat(Yvalue - 0.5), width: CGFloat(cell.lineImage.frame.size.width), height: CGFloat(cell.lineImage.frame.size.height))
            
            // Required float rating view params
            cell.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
            cell.floatRatingView.fullImage = UIImage(named: "StarFull")
            cell.floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
            cell.floatRatingView.maxRating = 5
            cell.floatRatingView.minRating = 0
            cell.floatRatingView.rating = Float(reviewArray[indexPath.row].ratings)!
            cell.floatRatingView.editable = false
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        else {
            
            let cellIdentifier = "CustomCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
            
            if storesArray[indexPath.row].store_img == "" {
                cell.storeImage.image = UIImage(named: "no-image-icon")
            }
            else {
                cell.storeImage.yy_imageURL = URL(string: storesArray[indexPath.row].store_img)
            }
            
            cell.storenameLabel.text = storesArray[indexPath.row].store_name
            
//            if storesArray[indexPath.row].deal_count == "0" {
//
//                let dealLabelString = NSMutableAttributedString(string: String(format:"Deals N/A"))
//                dealLabelString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSRange(location: 0, length: 5))
//                cell.dealcountLabel.attributedText = dealLabelString
//            }
//            else {
//
//                let dealLabelString = NSMutableAttributedString(string: String(format:"Deals %@", storesArray[indexPath.row].deal_count))
//                dealLabelString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSRange(location: 0, length: 5))
//                cell.dealcountLabel.attributedText = dealLabelString
//            }
            
            if storesArray[indexPath.row].product_count == "0" {
                
                let productLabelString = NSMutableAttributedString(string: String(format:"Deals N/A"))
                productLabelString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 5))
                cell.productcountLabel.attributedText = productLabelString
            }
            else {
                
                let productLabelString = NSMutableAttributedString(string: String(format:"Deals %@", storesArray[indexPath.row].product_count))
                productLabelString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 5))
                cell.productcountLabel.attributedText = productLabelString
            }
            
            //cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == branchesTable {
            
            let objStoreDetails = self.storyboard?.instantiateViewController(withIdentifier: "StoreDetailsViewController") as! StoreDetailsViewController
            objStoreDetails.shop_id = storesArray[indexPath.row].store_id
            self.navigationController?.pushViewController(objStoreDetails, animated: true)
        }
        if tableView == productTable {
            let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "FProductDetailsTableViewController") as! FProductDetailsTableViewController
            objProductDetails.category_name = "Hot Deals"
            UserDefaults.standard.set(productsArray[indexPath.row].product_id, forKey: "temp_pro_id")

            objProductDetails.product_id = productsArray[indexPath.row].product_id
            self.navigationController?.pushViewController(objProductDetails, animated: true)
        }
    }
    
     @objc func detailproductTapped(sender:UIButton ) {
        
        let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "FProductDetailsTableViewController") as! FProductDetailsTableViewController
        objProductDetails.category_name = "Stores"
        UserDefaults.standard.set(productsArray[sender.tag].product_id, forKey: "temp_pro_id")

        objProductDetails.product_id = productsArray[sender.tag].product_id
        self.navigationController?.pushViewController(objProductDetails, animated: true)
    }
    
     @objc func btnTapped(sender:UIButton ) {
        
        let myUrl = URL(string: String(format:"%@api/add_to_wishlist", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(productsArray[sender.tag].product_id!)&lang=en"
        }else{
            postString = "product_id=\(productsArray[sender.tag].product_id!)&lang=en"
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
    
     @objc func detaildealTapped(sender:UIButton ) {
        
        let objDealDetails = self.storyboard?.instantiateViewController(withIdentifier: "DealDetailsViewController") as! DealDetailsViewController
        objDealDetails.deal_id = dealsArray[sender.tag].deal_id
        self.navigationController?.pushViewController(objDealDetails, animated: true)
    }
    
    @IBAction func reviewButton(sender:UIButton ) {
        
        let objPostReview = self.storyboard?.instantiateViewController(withIdentifier: "PostReviewViewController") as! PostReviewViewController
        objPostReview.review_id = shop_id
        objPostReview.screen_value = "Shop"
        objPostReview.reviewDelegate = self
        self.navigationController?.pushViewController(objPostReview, animated: true)
    }
    
    func updateReview(json: NSDictionary) {
        
        if let reposArray = json["store_review"] as? [NSDictionary] {
            // 5
            if reposArray.count != 0 {
                
                for item in reposArray {
                    self.reviewArray.append(Review(Review: item))
                }
            }
            self.reviewTable.reloadData()
        }
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

extension String {
    func convertHtml() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [.documentType : NSAttributedString.DocumentType.html],
            documentAttributes: nil) else { return nil }
        return html
    }
}
