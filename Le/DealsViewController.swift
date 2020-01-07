//
//  DealsViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 19/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class DealsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dealsTable : UITableView!
    @IBOutlet weak var searchView : UIView!
    @IBOutlet weak var searchImage : UIImageView!
    @IBOutlet weak var searchText : UITextField!
    @IBOutlet weak var searchIcon : UIImageView!
    
    var page_no: Int! = 1
    var dealsArray = [Deals]()
    var searchBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Deals"
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(DealsViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        //self.navigationItem.leftBarButtonItem = LeftButton
        
        searchView.frame = CGRect(x: CGFloat(searchView.frame.origin.x), y: CGFloat(searchView.frame.origin.y), width: CGFloat(searchView.frame.size.width), height: CGFloat(0))
        searchImage.layer.cornerRadius = 5.0
        searchView.addSubview(searchImage)
        searchView.addSubview(searchText)
        searchView.addSubview(searchIcon)
        searchView.isHidden = true
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            dealsApi()
            
            weak var weakSelf: DealsViewController? = self
            dealsTable.addInfiniteScrolling(actionHandler: {() -> Void in
                weakSelf?.dealsApi()
            })
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let image1 = UIImage(named: "cart-icon")
        let button1 = MIBadgeButton()
        button1.bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(30), height: CGFloat(30))
        button1.setImage(image1, for: .normal)
        button1.addTarget(self, action: #selector(DealsViewController.cartAction(_:)), for: .touchUpInside)
        button1.badgeString = String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
        button1.badgeTextColor = UIColor.white
        
        let image2 = UIImage(named: "search-icon")
        let button2 = UIButton(type: .custom)
        button2.bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(30), height: CGFloat(30))
        button2.setImage(image2, for: .normal)
        button2.addTarget(self, action: #selector(DealsViewController.searchAction(_:)), for: .touchUpInside)
        let barButtonItem1 = UIBarButtonItem(customView: button1)
        let barButtonItem2 = UIBarButtonItem(customView: button2)
        self.navigationItem.rightBarButtonItems = [barButtonItem1, barButtonItem2]
        
        //UserDefaults.standard.removeObject(forKey: "CartCount")
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
    
    @objc func searchAction(_ sender: UIButton!) {
        
        if searchBool == false {
            
            searchView.isHidden = false
            searchBool = true
            searchView.frame = CGRect(x: CGFloat(searchView.frame.origin.x), y: CGFloat(searchView.frame.origin.y), width: CGFloat(searchView.frame.size.width), height: CGFloat(60))
            dealsTable.tableHeaderView = searchView
        }
        else {
            
            searchView.isHidden = true
            searchBool = false
            searchView.frame = CGRect(x: CGFloat(searchView.frame.origin.x), y: CGFloat(searchView.frame.origin.y), width: CGFloat(searchView.frame.size.width), height: CGFloat(0))
            dealsTable.tableHeaderView = searchView
            
            searchText.text = ""
            
            page_no = 1
            
            dealsArray = [Deals]()
            
            let reachability = Reachability()!
            
            if reachability.isReachable {
                
                self.view.hideToastActivity()
                self.view.makeToastActivity(.center)
                
                dealsApi()
                
                weak var weakSelf: DealsViewController? = self
                dealsTable.addInfiniteScrolling(actionHandler: {() -> Void in
                    weakSelf?.dealsApi()
                })
            }
            else {
                
                self.showNetworkErrorAlert()
            }
        }
    }
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.white
        style.messageAlignment = .center
        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        
        self.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    
    func dealsApi() {
        
        let myUrl = URL(string: String(format:"%@api/deals_list", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "page_no=\(page_no!)&title=\(searchText.text!)&lang=en"
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
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["deal_list"] as? [NSDictionary] {
                                // 5
                               // print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.dealsArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Deals Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Deals Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.dealsArray.append(Deals(Deals: item))
                                    }
                                }
                            }
                        }
                        else {
                            
                            if self.dealsArray.count == 0 {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                
                                self.view.makeToast("No Deals Available!", duration: 3.0, position: .center, style: style)
                            }
                            else {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                
                                self.view.makeToast("No More Deals Available!", duration: 3.0, position: .bottom, style: style)
                            }
                        }
                        
                        self.dealsTable.reloadData()
                        self.dealsTable.infiniteScrollingView.stopAnimating()
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
    
    // Customize the number of rows in the table view.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var devide: Int = dealsArray.count / 2
        if dealsArray.count % 2 > 0 {
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
        cell.topofferImage1.kf.setImage(with: StringToURL(text: dealsArray[xyz].deal_image))
        
       // cell.topofferImage1.yy_imageURL = URL(string: dealsArray[xyz].deal_image)
        cell.topTitleLabel1.text = dealsArray[xyz].deal_title
        cell.topPriceLabel1.text = String(format:"%@%@", dealsArray[xyz].deal_currency_symbol, dealsArray[xyz].deal_discount_price)
       // print( dealsArray[xyz].deal_currency_symbol)
      //  print(dealsArray[xyz].deal_original_price)
        
        cell.topDiscountPriceLabel1.text = String(format:"%@%@", dealsArray[xyz].deal_currency_symbol, dealsArray[xyz].deal_original_price)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.topDiscountPriceLabel1.text!)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        cell.topDiscountPriceLabel1.attributedText = attributeString
        
        
        
        
        
//        cell.topDiscountPriceLabel1.text = ""
//        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.topDiscountPriceLabel1.text!)
//        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
//        cell.topDiscountPriceLabel1.attributedText = attributeString
//
        cell.topPercentageLabel1.text = String(format:"%@%% OFF", dealsArray[xyz].deal_discount_percentage)
        
        cell.showTimer1(toDate: dealsArray[xyz].ios_deal_end_date)
        
        if (xyz + 1) >= dealsArray.count {
            
            cell.topOfferView2.isHidden = true
        }
        else {
            
            cell.topOfferView2.isHidden = false
            cell.topofferImage2.kf.setImage(with: StringToURL(text: dealsArray[xyz+1].deal_image))
           // cell.topofferImage2.yy_imageURL = URL(string: dealsArray[xyz+1].deal_image)
            cell.topTitleLabel2.text = dealsArray[xyz+1].deal_title
            cell.topPriceLabel2.text = String(format:"%@%@", dealsArray[xyz+1].deal_currency_symbol, dealsArray[xyz+1].deal_discount_price)
            cell.topDiscountPriceLabel2.text = String(format:"%@%@", dealsArray[xyz+1].deal_currency_symbol, dealsArray[xyz+1].deal_original_price)
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.topDiscountPriceLabel2.text!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.topDiscountPriceLabel2.attributedText = attributeString
            
            cell.topPercentageLabel2.text = String(format:"%@%% OFF", dealsArray[xyz+1].deal_discount_percentage)
            
            cell.showTimer2(toDate: dealsArray[xyz+1].ios_deal_end_date)
        }
        
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
        
        let objDealDetails = self.storyboard?.instantiateViewController(withIdentifier: "DealDetailsViewController") as! DealDetailsViewController
        objDealDetails.deal_id = dealsArray[sender.tag].deal_id
        self.navigationController?.pushViewController(objDealDetails, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        searchText.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == searchText) {
            
            searchText.resignFirstResponder()
            
            page_no = 1
            
            dealsArray = [Deals]()
            
            let reachability = Reachability()!
            
            if reachability.isReachable {
                
                self.view.hideToastActivity()
                self.view.makeToastActivity(.center)
                
                dealsApi()
                
                weak var weakSelf: DealsViewController? = self
                dealsTable.addInfiniteScrolling(actionHandler: {() -> Void in
                    weakSelf?.dealsApi()
                })
            }
            else {
                
                self.showNetworkErrorAlert()
            }
        }
        
        return true
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
