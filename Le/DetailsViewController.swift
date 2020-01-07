//
//  DetailsViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 20/05/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var itemsLabel : UILabel!
    @IBOutlet weak var totalLabel : UILabel!
    
    @IBOutlet weak var productImage : YYAnimatedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantiyLabel: UILabel!
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var statusLabel : UILabel!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var redeemInfoView: UIView!
    @IBOutlet weak var orderIdLabel: UILabel!
    
    //For redeemInfoView
    
    @IBOutlet weak var CouponLabel: UILabel!
    @IBOutlet weak var RedeemAtLabel: UILabel!
    @IBOutlet weak var NameOfMerchantLabel: UILabel!
    @IBOutlet weak var expireDateView: UILabel!
    
    
    var orderId: String!
    var orderdate: String!
    var day: String!
    var amount: String!
    var order_image: String!
    var titleString: String!
    var statusString: String!
    var merchantName: String!
    var couponCode: String!
    var redeemValue: String!
    
    var productTitle: String!
    var productPrice: String!
    var quantity: String!
    var imageOfProduct: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        _ = couponCode
        let order_id = orderId
        print("My order id --\(order_id!)")
        let  isRedeem =  UserDefaults.standard.integer(forKey: "btn_value1")
        //let isRedeem1 = UserDefaults.standard.integer(forKey: "btn_value0")
        print("here is redeem value - \(isRedeem)")
      //  print("here is redeem value - \(isRedeem1)")
        print(day)
        
 
        if isRedeem == 1 {
            redeemInfoView.isHidden = false
            expireDateView.isHidden = true
            self.CouponLabel.text = "Coupon Code - " + self.couponCode!
            self.RedeemAtLabel.text = "Redeem At - " + self.orderdate!
            self.NameOfMerchantLabel.text = "Merchant Name - " + self.merchantName!
          // UserDefaults.standard.removeObject(forKey: "btn_value1")
           // UserDefaults.standard.removeObject(forKey: "btn_value0")
        } else  {//if isRedeem == 0
            UserDefaults.standard.removeObject(forKey: "btn_value1")
//            UserDefaults.standard.removeObject(forKey: "btn_value0")

            redeemInfoView.isHidden = true
            expireDateView.isHidden = false
            
            //to show the expire date
            let dateString = orderdate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "EEEE, MMM d, yyyy"
            let myInt = (day as NSString).integerValue
            let dateFromString = dateFormatter.date(from: dateString!)
            let myExpireDate = Calendar.current.date(byAdding: .day, value: myInt, to: dateFromString!)
            let todaysDate = dateFormatterPrint.string(from: myExpireDate!)
            print("------------------------\(todaysDate)")

            self.expireDateView.text = "Expires At :  " + todaysDate
            

            let currentDate:Date = Date()
            let result: ComparisonResult = myExpireDate!.compare(currentDate)

            if result == .orderedAscending {
                redeemInfoView.isHidden = true
                print("true if \(myExpireDate) is earlier than \(currentDate)")
            } else if result == .orderedSame {
                print("true if the dates are the same")
            } else if result == .orderedDescending {
                print("true if \(currentDate) is later than \(myExpireDate)")

            }else{
                print("nothing to compare with Date")
            }
            UserDefaults.standard.removeObject(forKey: "btn_value0")
        } 
 
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Order Details"
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(DetailsViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        //self.navigationItem.leftBarButtonItem = LeftButton
        
        dateLabel.text = orderdate!
        totalLabel.text = amount!
        merchantNameLabel.text = "Make sure to redeem only when you are at  " + merchantName!
        
        if order_image == "" {
            productImage.image = UIImage(named: "no-image-icon")
        }
        else {
            //    productImage.yy_imageURL = URL(string: order_image)
        }
        
        //  titleLabel.text = titleString!
        
        if statusString == "success" {
            
            statusLabel.text = statusString
            statusLabel.textColor = UIColor(red: 73.0/255.0, green:178.0/255.0, blue: 4.0/255.0, alpha: 1.0)
        }
        else if statusString == "completed" {
            
            statusLabel.text = statusString
            statusLabel.textColor = UIColor(red: 73.0/255.0, green:178.0/255.0, blue: 4.0/255.0, alpha: 1.0)
        }
        else if statusString == "Hold" {
            
            statusLabel.text = statusString
            statusLabel.textColor = UIColor(red: 252.0/255.0, green:185.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        }
        else if statusString == "cancelled" {
            
            statusLabel.text = statusString
            statusLabel.textColor = UIColor.darkGray
        }
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            self.view.makeToastActivity(.center)
           productListByOrderId()
        }
        else {
            showNetworkErrorAlert()
        }

    }
    
    
    
    func messageToast(messageStr:String) {
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.black
        style.messageAlignment = .center
        style.backgroundColor = UIColor.white
        
        self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    
    @objc func backAction(_ sender: UIButton!) {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapRedeemCoupon(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Redeem Coupon", message: "Are you sure you want to redeem coupon?", preferredStyle: UIAlertController.Style.alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("YES Pressed")
            self.addCouponCode()
            self.redeemInfoView.isHidden = false

            
            self.CouponLabel.text = "Coupon Code - " + self.couponCode!
            self.RedeemAtLabel.text = "Redeem At - " + self.orderdate!
            self.NameOfMerchantLabel.text = "Merchant Name - " + self.merchantName!

            UserDefaults.standard.set(true, forKey: "OkPressed")
        }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("NO Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //Mark:Order Product list by user id
    func productListByOrderId() {
        let myUrl = URL(string: String(format:"%@api/orders_product_list", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        //let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&page_no=\(page_no!)&lang=en"
        let postString = "order_id=\(orderId!)&lang=en"
        print("my orders value --\(postString)")
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
                    // print("my orders value-- \(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["order_product"] as? [NSDictionary] {
                                // 5
                                print("Order product list --\(reposArray)")
                                if reposArray.count != 0 {

                                    for item in reposArray {
                                       let url = item["product_image"] as? String
                                       // print(pic!)
                                       // var url = (parseJSON.value(forKeyPath: "order_product.product_image") as? String)
                                        print("Crashing url  --\(url!)")
    
                                        if let url = URL(string: url!) {
                                            do {
                                                let data = try Data(contentsOf: url)
                                                self.productImage.image = UIImage(data:data)
                                            } catch let err {
                                                print("Error  : \(err.localizedDescription)")
                                            }
                                        }
                                        
                                       self.nameLabel.text = item["product_title"] as? String
                                        self.priceLabel.text =  "Price : " + String(item["product_price"] as! String)
                                       self.quantiyLabel.text = "Quantity : " +  String(item["order_qty"] as! NSInteger)
                                        self.orderIdLabel.text = "Order Id : " + String(item["order_id"] as! NSInteger)
                                        // print(title)

                                    }
                                }
                            }
                        }
                        else {
                            
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
    
    
    
    
    
    
    //MARK: Add coupon code
    func addCouponCode(){
        let myUrl = URL(string: String(format:"%@api/redeem_by_user", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        // let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(product_id!)&lang=en"
        let postString = "coupon_code=\(couponCode!)&lang=en"//\(product_id!)
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
                            
                            //
                            var style = ToastStyle()
                            style.messageFont = messageFont!
                            style.messageColor = UIColor.white
                            style.messageAlignment = .center
                            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                            
                            self.view.makeToast(parseJSON.object(forKey: "message") as! String, duration: 3.0, position: .center, style: style)
                            //     self.buynowButton.setTitle("Wishlisted", for: UIControlState.normal)
                            
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
                    print("Item added successfully")
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
