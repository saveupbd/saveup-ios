//
//  DealDetailsViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 19/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class DealDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReviewDelegate {

    @IBOutlet weak var imagesTable : UITableView!
    @IBOutlet weak var dealImage : YYAnimatedImageView!
    @IBOutlet weak var dealtitleLabel : UILabel!
    @IBOutlet weak var dealpriceLabel : UILabel!
    @IBOutlet weak var dealdiscountpriceLabel : UILabel!
    @IBOutlet weak var dealpercentageLabel : UILabel!
    @IBOutlet weak var footerImage : UIImageView!
    @IBOutlet weak var relatedTable : UITableView!
    @IBOutlet weak var addcartButton : UIButton!
    @IBOutlet weak var buynowButton : UIButton!
    @IBOutlet weak var descriptionView : UIView!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var reviewView : UIView!
    @IBOutlet weak var headerView : UIView!
    @IBOutlet weak var reviewTable : UITableView!
    @IBOutlet weak var footerView : UIView!
    @IBOutlet weak var dealendsLabel : UILabel!
    @IBOutlet weak var reviewButton : UIButton!
    
    var dealimagesArray = [DealImages]()
    var relatedArray = [RelatedDeals]()
    var reviewArray = [Review]()
    var currencySymbol = String()
    var deal_id: String!
    var shippingAmount = String()
    var tax = String()
    let userCalendar = Calendar.current
    var Amount = String()
    let requestedComponent: Set<Calendar.Component> = [.day,.hour,.minute,.second]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mycartApi()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Deals"
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(DealDetailsViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        //self.navigationItem.leftBarButtonItem = LeftButton
        
        relatedTable.layer.cornerRadius = 5
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            dealDetailsApi()
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
        cartButton.addTarget(self, action: #selector(DealDetailsViewController.cartAction(_:)), for: UIControl.Event.touchUpInside)
//        cartButton.badgeString = String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
        cartButton.badgeTextColor = UIColor.white
        
        let rightButton = UIBarButtonItem(customView: cartButton)
        self.navigationItem.rightBarButtonItem = rightButton
        
       // UserDefaults.standard.removeObject(forKey: "CartCount")
    }
    
    //for cart update
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
        style.messageColor = UIColor.white
        style.messageAlignment = .center
        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        
        self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    
    func dealDetailsApi() {
        
        let myUrl = URL(string: String(format:"%@api/deal_detail", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "dealid=\(deal_id!)&lang=en"
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
                            
                            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.printTime), userInfo: parseJSON.value(forKeyPath: "deal_list.ios_deal_end_date") as? String, repeats: true)
                            timer.fire()
                            
                            if let reposArray = parseJSON.value(forKeyPath: "deal_list.deal_image") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.dealimagesArray.append(DealImages(DealImages: item))
                                    }
                                    if self.dealimagesArray[0].images == "" {
                                        self.dealImage.image = UIImage(named: "no-image-icon")
                                    }
                                    else {
                                        self.dealImage.yy_imageURL = URL(string: self.dealimagesArray[0].images)
                                    }
                                    
                                    self.imagesTable.reloadData()
                                }
                            }
                            //Edited by gugan ****************
                            
                            let deallist = parseJSON.value(forKeyPath: "deal_list") as? NSDictionary
                            print(deallist)
                            self.dealtitleLabel.text = deallist?.value(forKey: "deal_title") as? String
                            self.currencySymbol = (deallist?.value(forKey: "deal_currency_symbol") as? String)!
                            self.dealdiscountpriceLabel.text = (deallist?.value(forKey: "deal_currency_symbol") as? String)! + " " + String((deallist?.value(forKey: "deal_discount_price") as? Int)!)
                            self.Amount = String((deallist?.value(forKey: "deal_discount_price") as? Int)!)
                            self.shippingAmount = String((deallist?.value(forKey: "deal_ship_amt") as? Int)!)
                            self.tax = String((deallist?.value(forKey: "deal_including_tax") as? Int)!)
                            self.dealpriceLabel.text = (deallist?.value(forKey: "deal_currency_symbol") as? String)! + " " + String((deallist?.value(forKey: "deal_original_price") as? Int)!)
                             
                            
                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.dealpriceLabel.text!)
                            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                            self.dealpriceLabel.attributedText = attributeString
                            
                            self.dealpercentageLabel.text = String((deallist?.value(forKey: "deal_discount_percentage") as? Int)!) + "%" + " OFF"
                                
                            
                            self.dealpercentageLabel.layer.borderWidth = 0.5
                            self.dealpercentageLabel.layer.borderColor = UIColor(red: 220.0/255.0, green:220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
                            
                            var Yvalue:CGFloat = 510
                            
                            self.descriptionLabel.numberOfLines = 0
                            self.descriptionLabel.text = parseJSON.value(forKeyPath: "deal_list.deal_description") as? String
                            let expectedLabelSize: CGSize = self.descriptionLabel.text!.boundingRect(with: CGSize(width:UIScreen.main.bounds.size.width - 20, height:9999), options: ([.usesLineFragmentOrigin, .usesFontLeading]), attributes: [
                                NSAttributedString.Key.font : self.descriptionLabel.font], context: nil).size
                            self.descriptionLabel.frame = CGRect(x: CGFloat(10), y: CGFloat(30), width: CGFloat(self.descriptionLabel.frame.size.width), height: CGFloat(expectedLabelSize.height + 10))
                            
                            self.descriptionView.frame = CGRect(x: CGFloat(0), y: CGFloat(Yvalue), width: CGFloat(self.descriptionView.frame.size.width), height: CGFloat(expectedLabelSize.height + 40))
                            
                            Yvalue = Yvalue + expectedLabelSize.height + 40
                            
                            Yvalue = Yvalue + 10
                            
                            self.reviewView.frame = CGRect(x: CGFloat(0), y: CGFloat(Yvalue), width: CGFloat(self.reviewView.frame.size.width), height: CGFloat(self.reviewView.frame.size.height))
                            
                            Yvalue = Yvalue + 50
                            
                            self.headerView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.headerView.frame.size.width), height: CGFloat(Yvalue))
                            
                            self.reviewTable.tableHeaderView = self.headerView
                            
                            if let reposArray = parseJSON.value(forKeyPath: "deal_list.deal_review") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.reviewArray.append(Review(Review: item))
                                    }
                                }
                                self.reviewTable.reloadData()
                            }
                            
                            if let reposArray = parseJSON.value(forKeyPath: "deal_list.related_deals") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    if reposArray.count == 1 || reposArray.count == 2 {
                                        
                                        self.footerView.frame = CGRect(x: CGFloat(self.footerView.frame.origin.x), y: CGFloat(self.footerView.frame.origin.y), width: CGFloat(self.footerView.frame.size.width), height: CGFloat(290))
                                        self.footerImage.frame = CGRect(x: CGFloat(self.footerImage.frame.origin.x), y: CGFloat(self.footerImage.frame.origin.y), width: CGFloat(self.footerImage.frame.size.width), height: CGFloat(260))
                                        self.relatedTable.frame = CGRect(x: CGFloat(self.relatedTable.frame.origin.x), y: CGFloat(self.relatedTable.frame.origin.y), width: CGFloat(self.relatedTable.frame.size.width), height: CGFloat(209))
                                        self.reviewTable.tableFooterView = self.footerView
                                    }
                                    else {
                                        
                                        self.footerView.frame = CGRect(x: CGFloat(self.footerView.frame.origin.x), y: CGFloat(self.footerView.frame.origin.y), width: CGFloat(self.footerView.frame.size.width), height: CGFloat(500))
                                        self.footerImage.frame = CGRect(x: CGFloat(self.footerImage.frame.origin.x), y: CGFloat(self.footerImage.frame.origin.y), width: CGFloat(self.footerImage.frame.size.width), height: CGFloat(470))
                                        self.relatedTable.frame = CGRect(x: CGFloat(self.relatedTable.frame.origin.x), y: CGFloat(self.relatedTable.frame.origin.y), width: CGFloat(self.relatedTable.frame.size.width), height: CGFloat(420))
                                        self.reviewTable.tableFooterView = self.footerView
                                    }
                                    
                                    for item in reposArray {
                                        self.relatedArray.append(RelatedDeals(RelatedDeals: item))
                                    }
                                    self.relatedTable.reloadData()
                                }
                                else {
                                    self.footerView.isHidden = true
                                    self.footerView.frame = CGRect(x: CGFloat(self.footerView.frame.origin.x), y: CGFloat(self.footerView.frame.origin.y), width: CGFloat(self.footerView.frame.size.width), height: CGFloat(0))
                                    self.reviewTable.tableFooterView = self.footerView
                                }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == relatedTable {
            
            if indexPath.row == 1 {
                return 209
            }
            else {
                return 210
            }
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
            
            return 110
        }
    }
    
    // Customize the number of rows in the table view.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == relatedTable {
            
            var devide: Int = relatedArray.count / 2
            if relatedArray.count % 2 > 0 {
                devide += 1
            }
            return devide
        }
        else if tableView == reviewTable {
            
            return reviewArray.count
        }
        else {
            return dealimagesArray.count
        }
    }
    // Customize the appearance of table view cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == relatedTable {
            
            let cellIdentifier = "CustomCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
            
            var xyz = Int(indexPath.row)
            xyz = xyz * 2
            
            if relatedArray[xyz].deal_image == "" {
                cell.popularImage1.image = UIImage(named: "no-image-icon")
            }
            else {
                cell.popularImage1.yy_imageURL = URL(string: relatedArray[xyz].deal_image)
            }
            
            cell.popularTitleLabel1.text = relatedArray[xyz].deal_title
            cell.popularPriceLabel1.text = String(format:"%@%@", relatedArray[xyz].deal_currency_symbol, relatedArray[xyz].deal_discount_price)
            
            if (xyz + 1) >= relatedArray.count {
                
                cell.popularView2.isHidden = true
            }
            else {
                
                cell.popularView2.isHidden = false
                if relatedArray[xyz+1].deal_image == "" {
                    cell.popularImage2.image = UIImage(named: "no-image-icon")
                }
                else {
                    cell.popularImage2.yy_imageURL = URL(string: relatedArray[xyz+1].deal_image)
                }
                
                cell.popularTitleLabel2.text = relatedArray[xyz+1].deal_title
                cell.popularPriceLabel2.text = String(format:"%@%@", relatedArray[xyz+1].deal_currency_symbol, relatedArray[xyz+1].deal_discount_price)
            }
            
            cell.tapButton1.tag = xyz
            cell.tapButton1.addTarget(self, action: #selector(relatedTapped), for: .touchUpInside)
            cell.tapButton2.tag = xyz + 1
            cell.tapButton2.addTarget(self, action: #selector(relatedTapped), for: .touchUpInside)
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
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
            
            
            cell.bgView.layer.borderWidth = 0.5
            cell.bgView.layer.borderColor = UIColor(red: 220.0/255.0, green:220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
            
            if dealimagesArray[indexPath.row].images == "" {
                cell.productImage.image = UIImage(named: "no-image-icon")
            }
            else {
                cell.productImage.yy_imageURL = URL(string: dealimagesArray[indexPath.row].images)
            }
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == imagesTable {
            
            if dealimagesArray[indexPath.row].images == "" {
                dealImage.image = UIImage(named: "no-image-icon")
            }
            else {
                dealImage.yy_imageURL = URL(string: dealimagesArray[indexPath.row].images)
            }
        }
    }
    
     @objc func relatedTapped(sender:UIButton ) {
        
        let objDealDetails = self.storyboard?.instantiateViewController(withIdentifier: "DealDetailsViewController") as! DealDetailsViewController
        objDealDetails.deal_id = relatedArray[sender.tag].deal_id
        self.navigationController?.pushViewController(objDealDetails, animated: true)
    }
    
    @IBAction func addcartButton(sender:UIButton ) {
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            addcartApi()
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    func addcartApi() {
        
        let myUrl = URL(string: String(format:"%@api/add_to_dealcart", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&dealid=\(deal_id!)&quantity=\("1")&lang=en"
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
                            
                            var style = ToastStyle()
                            style.messageFont = messageFont!
                            style.messageColor = UIColor.white
                            style.messageAlignment = .center
                            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                            
                            self.view.makeToast(parseJSON.object(forKey: "message") as! String, duration: 3.0, position: .center, style: style)
                        }
                        else {
                            
                            var style = ToastStyle()
                            style.messageFont = messageFont!
                            style.messageColor = UIColor.white
                            style.messageAlignment = .center
                            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                            
                            self.view.makeToast(parseJSON.object(forKey: "message") as! String, duration: 3.0, position: .center, style: style)
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
    
    @IBAction func buynowButton(sender:UIButton ) {
        
        let objShipping = self.storyboard?.instantiateViewController(withIdentifier: "ShippingViewController") as! ShippingViewController
        objShipping.no_of_items = "1"
        objShipping.shipping_charge = currencySymbol + self.shippingAmount
        objShipping.tax = String(calulateTax(total: self.Amount, tax: self.tax))
        objShipping.total_amount = dealdiscountpriceLabel.text!
        objShipping.deal_id = deal_id!
        objShipping.amount = self.currencySymbol + self.Amount
        objShipping.currencySymbol = currencySymbol
        objShipping.deal_qty = "1"
        objShipping.screen_value = "Deal"
        self.navigationController?.pushViewController(objShipping, animated: true)
    }
    
    
    
    @objc func printTime(toDate: Timer) {
        
        //print(toDate.userInfo as! String)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
        let startTime = Date()
        let endTime = dateFormatter.date(from: toDate.userInfo as! String)
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: startTime, to: endTime!)
        
        var dayString = "";
        if String(format:"%d", timeDifference.day!).count == 1 {
            
            dayString = String(format:"0%d", timeDifference.day!)
        }
        else {
            dayString = String(format:"%d", timeDifference.day!)
        }
        
        var hourString = "";
        if String(format:"%d", timeDifference.hour!).count == 1 {
            
            hourString = String(format:"0%d", timeDifference.hour!)
        }
        else {
            hourString = String(format:"%d", timeDifference.hour!)
        }
        
        var minuteString = "";
        if String(format:"%d", timeDifference.minute!).count == 1 {
            
            minuteString = String(format:"0%d", timeDifference.minute!)
        }
        else {
            minuteString = String(format:"%d", timeDifference.minute!)
        }
        
        var secondString = "";
        if String(format:"%d", timeDifference.second!).count == 1 {
            
            secondString = String(format:"0%d", timeDifference.second!)
        }
        else {
            secondString = String(format:"%d", timeDifference.second!)
        }
        
        dealendsLabel.text = String(format:"Deal ends within %@days %@hrs %@min %@sec", dayString, hourString, minuteString, secondString)
    }
    
    @IBAction func reviewButton(sender:UIButton ) {
        
        let objPostReview = self.storyboard?.instantiateViewController(withIdentifier: "PostReviewViewController") as! PostReviewViewController
        objPostReview.review_id = deal_id
        objPostReview.screen_value = "Deals"
        objPostReview.reviewDelegate = self
        self.navigationController?.pushViewController(objPostReview, animated: true)
    }
    
    func updateReview(json: NSDictionary) {
        
        if let reposArray = json["deal_review"] as? [NSDictionary] {
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

func calulateTax(total: String ,tax: String) -> Double {
    let totalAmount = Double(total)
    let totalPercentage = Double(tax)
    return (totalAmount! * totalPercentage!) / 100
}
