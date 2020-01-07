//
//  MyWishlistViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 27/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class MyWishlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mywishTable : UITableView!
    @IBOutlet weak var lblNoData : UILabel!
    
    let forProductId = FProductDetailsTableViewController()
    var page_no: Int! = 1
    var mywishArray = [MyWishlist]()
    
     var relatedArray = [RelatedProducts]()
     var product_id: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "My Wishlist"
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(MyWishlistViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        //self.navigationItem.leftBarButtonItem = LeftButton
        
        lblNoData.isHidden = true
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            mywishApi()
            
//            weak var weakSelf: MyWishlistViewController? = self
//            mywishTable.addInfiniteScrolling(actionHandler: {() -> Void in
//                weakSelf?.mywishApi()
//            })
        }
        else {
            
            showNetworkErrorAlert()
        }
    }

    @objc func backAction(_ sender: UIButton!) {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.black
        style.messageAlignment = .center
        style.backgroundColor = UIColor.white
        
        self.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    
    func mywishApi() {
        
        let myUrl = URL(string: String(format:"%@api/my_wishlist", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&page_no=\(page_no!)&lang=en"
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
                            
                            if let reposArray = parseJSON["product_wish_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.mywishArray.count == 0 {
                                        
                                        self.lblNoData.isHidden = false
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                       // self.view.makeToast("No More Wishlist Available!", duration: 3.0, position: .bottom, style: style)
                                        self.view.makeToast(parseJSON.object(forKey: "message") as! String, duration: 3.0, position: .center, style: style)
                                    }
                                }
                                else {
                                    
                                    self.lblNoData.isHidden = true
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.mywishArray.append(MyWishlist(MyWishlist: item))
                                    }
                                }
                            }
                        }
                        else {
                            
                            if self.mywishArray.count == 0 {
                                
                                self.lblNoData.isHidden = false
                            }
                            else {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                
                                self.view.makeToast("No More Wishlist Available!", duration: 3.0, position: .bottom, style: style)
                            }
                        }
                        
                        self.mywishTable.reloadData()
                      //  self.mywishTable.infiniteScrollingView.stopAnimating()
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
        
        return mywishArray.count
    }
    // Customize the appearance of table view cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CustomCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
        
        if mywishArray[indexPath.row].product_image == "" {
            cell.productImage.image = UIImage(named: "no-image-icon")
        }
        else {
            cell.productImage.yy_imageURL = URL(string: mywishArray[indexPath.row].product_image)
        }
        
        cell.producttitleLabel.text = mywishArray[indexPath.row].product_title
        
        cell.topPriceLabel1.text = String(format:"%@%@", mywishArray[indexPath.row].product_currency_symbol, mywishArray[indexPath.row].product_original_price)
        cell.topDiscountPriceLabel1.text = String(format:"%@%@", mywishArray[indexPath.row].product_currency_symbol, mywishArray[indexPath.row].product_discount_price)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.topPriceLabel1.text!)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        cell.topPriceLabel1.attributedText = attributeString
        
        cell.topPercentageLabel1.text = String(format:"%@%% OFF", mywishArray[indexPath.row].product_discount_percentage)
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "FProductDetailsTableViewController") as! FProductDetailsTableViewController
        objProductDetails.category_name = "My Wishlist"
        UserDefaults.standard.set(String(mywishArray[indexPath.row].product_id), forKey: "temp_pro_id")

        objProductDetails.product_id = String(mywishArray[indexPath.row].product_id)
        self.navigationController?.pushViewController(objProductDetails, animated: true)
    }
    
    @objc func deleteTapped(sender:UIButton ) {
        
        let myUrl = URL(string: String(format:"%@api/remove_wishlist", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(mywishArray[sender.tag].product_id!)&lang=en"
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
                            
                            self.mywishArray.remove(at: sender.tag)
                            self.mywishTable.reloadData()
                        }
                        else {
                            var style = ToastStyle()
                            style.messageFont = messageFont!
                            style.messageColor = UIColor.white
                            style.messageAlignment = .center
                            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                            self.view.makeToast(parseJSON.object(forKey: "message") as! String, duration: 3.0, position: .center, style: style)
                           // self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func deleteWishlistBtn(_ sender: Any) {
     //   deleteWishlish()
    }
    
    func deleteWishlish(){
        let myUrl = URL(string: String(format:"%@api/remove_wishlist", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(UserDefaults.standard.string(forKey: "productId")!)&lang=en"//\(product_id!)
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
                            
                            //UserDefaults.standard.set(parseJSON.object(forKey: "cart_count") as! NSInteger, forKey: "CartCount")
                            UserDefaults.standard.synchronize()

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
                    print("Item deleted successfully")
                }
                catch {
                    
                    //print(error)
                    self.view.hideToastActivity()
                }
            }
        })
        task.resume()
        
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
