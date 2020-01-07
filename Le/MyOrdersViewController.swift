//
//  MyOrdersViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 26/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class MyOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myordersTable : UITableView!
    @IBOutlet weak var btnCOD : UIButton!
    @IBOutlet weak var btnPaypal : UIButton!
    //@IBOutlet weak var imgCOD : UIImageView!
    //@IBOutlet weak var imgPaypal : UIImageView!
    
    var page_no: Int! = 1
    var btn_value: Int! = 0
    var myordersCODArray = [OrdersCOD]()
    var myordersPaypalArray = [OrdersPaypal]()
    var orderProductListArray = [orderProductList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.removeObject(forKey: "btn_value1")
        self.navigationItem.title = "My Vouchers"
        // var f = UserDefaults.standard.string(forKey: "Key")
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        //self.navigationItem.title = "myOrder".localized(loc: f!)
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "reloadIc"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(self.reloadAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem = LeftButton
        
        //        imgCOD.isHidden = false
        //        imgPaypal.isHidden = true
        
        btn_value = 0
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            myordersApi()
            //  myordersApiForReload()
//
//            weak var weakSelf: MyOrdersViewController? = self
//            myordersTable.addInfiniteScrolling(actionHandler: {() -> Void in
//                weakSelf?.myordersApi()
//            })
        }
        else {
            showNetworkErrorAlert()
        }
        myordersTable.tableFooterView = UIView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if  UserDefaults.standard.bool(forKey: "OkPressed") == true {
            print("Yesss from me")
            myordersApiForReload()
            UserDefaults.standard.removeObject(forKey: "OkPressed")
        } else {
            
        }
        myordersTable.reloadData()
    }
    
    @objc func reloadAction(_ sender: UIButton!) {
        self.view.hideToastActivity()
        self.view.makeToastActivity(.center)
        myordersApiForReload()
    }
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.black
        style.messageAlignment = .center
        style.backgroundColor = UIColor.white
        
        self.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    
    func myordersApi() {
        myordersCODArray.removeAll()
        myordersPaypalArray.removeAll()
        orderProductListArray.removeAll()
        let myUrl = URL(string: String(format:"%@api/my_orders", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&page_no=\(page_no!)&lang=en"
        }else{
            postString = "page_no=\(page_no!)&lang=en"
        }
        // let postString = "user_id=44&page_no=\(page_no!)&lang=en"
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
                            
                            if let reposArray = parseJSON["product_order_list"] as? [NSDictionary] {
                                // 5
                                print("my orders value ----\(reposArray)")
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.myordersPaypalArray.append(OrdersPaypal(OrdersPaypal: item))
                                        //print(<#T##items: Any...##Any#>)
                                        let dayNumber = item["day"]
                                        print("dayNumber Id ---\(dayNumber!)")
                                        
                                    }
                                }
                                self.page_no = self.page_no + 1
                            }
                            
                            if let reposArray = parseJSON["order_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.myordersCODArray.append(OrdersCOD(OrdersCOD: item))
                                        let order_id = item["day"]
                                        print("Order Id ---\(order_id!)")
                                        // self.myordersCODArray.last?.payment_status = "1"
                                    }
                                }
                            }
                            
                            //                            if let reposArray = parseJSON["deal_order_list"] as? [NSDictionary] {
                            //                                // 5
                            //                                //print(reposArray)
                            //                                if reposArray.count != 0 {
                            //
                            //                                    for item in reposArray {
                            //                                        self.myordersPaypalArray.append(OrdersPaypal(OrdersPaypal: item))
                            //                                    }
                            //                                }
                            //                            }
                            
                            //                            if let reposArray = parseJSON["deal_order_cod_list"] as? [NSDictionary] {
                            //                                // 5
                            //                                //print(reposArray)
                            //                                if reposArray.count != 0 {
                            //
                            //                                    for item in reposArray {
                            //                                        self.myordersCODArray.append(OrdersCOD(OrdersCOD: item))
                            //                                        self.myordersCODArray.last?.payment_status = "1"
                            //                                    }
                            //                                }
                            //                            }
                            self.myordersCODArray.sort { $0.orderDate > $1.orderDate }
                        }
                        else {
                            
                            if self.btn_value == 1 {
                                
                                if self.myordersPaypalArray.count == 0 {
                                    
                                    var style = ToastStyle()
                                    style.messageFont = messageFont!
                                    style.messageColor = UIColor.white
                                    style.messageAlignment = .center
                                    style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                    
                                    //self.view.makeToast("No Orders Available!", duration: 3.0, position: .center, style: style)
                                }
                                else {
                                    
                                    var style = ToastStyle()
                                    style.messageFont = messageFont!
                                    style.messageColor = UIColor.white
                                    style.messageAlignment = .center
                                    style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                    
                                    self.view.makeToast("No More Orders Available!", duration: 3.0, position: .bottom, style: style)
                                }
                            }
                            else {
                                
                                if self.myordersCODArray.count == 0 {
                                    
                                    var style = ToastStyle()
                                    style.messageFont = messageFont!
                                    style.messageColor = UIColor.white
                                    style.messageAlignment = .center
                                    style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                    
                                    //self.view.makeToast("No Orders Available!", duration: 3.0, position: .center, style: style)
                                }
                                else {
                                    
                                    var style = ToastStyle()
                                    style.messageFont = messageFont!
                                    style.messageColor = UIColor.white
                                    style.messageAlignment = .center
                                    style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                    
                                    self.view.makeToast("No More Orders Available!", duration: 3.0, position: .bottom, style: style)
                                }
                            }
                        }
                        
                        self.myordersTable.reloadData()
                        // self.myordersTable.infiniteScrollingView.stopAnimating()
                    }
                    DispatchQueue.main.async {
                        self.myordersTable.reloadData()
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
        
        if btn_value == 1 {
            return myordersPaypalArray.count
        }
        else {
            return myordersCODArray.count
        }
    }
    // Customize the appearance of table view cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if btn_value == 1 {
            let cellIdentifier = "CustomCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
            
            //cell.ordertitleLabel.text = myordersPaypalArray[indexPath.row].order_title
            //cell.orderOwnerLabel.text = myordersPaypalArray[indexPath.row].shipping_name
            
            if myordersPaypalArray[indexPath.row].order_status == "success" {
                
                cell.orderstatusLabel.text = myordersPaypalArray[indexPath.row].order_status
                cell.orderstatusLabel.textColor = UIColor(red: 73.0/255.0, green:178.0/255.0, blue: 4.0/255.0, alpha: 1.0)
                cell.deliveryImage.backgroundColor = UIColor(red: 73.0/255.0, green:178.0/255.0, blue: 4.0/255.0, alpha: 1.0)
            }
            else if myordersPaypalArray[indexPath.row].order_status == "completed" {
                
                cell.orderstatusLabel.text = myordersPaypalArray[indexPath.row].order_status
                cell.orderstatusLabel.textColor = UIColor(red: 73.0/255.0, green:178.0/255.0, blue: 4.0/255.0, alpha: 1.0)
                cell.deliveryImage.backgroundColor = UIColor(red: 73.0/255.0, green:178.0/255.0, blue: 4.0/255.0, alpha: 1.0)
            }
            else if myordersPaypalArray[indexPath.row].order_status == "Hold" {
                
                cell.orderstatusLabel.text = myordersPaypalArray[indexPath.row].order_status
                cell.orderstatusLabel.textColor = UIColor(red: 252.0/255.0, green:185.0/255.0, blue: 48.0/255.0, alpha: 1.0)
                cell.deliveryImage.backgroundColor = UIColor(red: 252.0/255.0, green:185.0/255.0, blue: 48.0/255.0, alpha: 1.0)
            }
            else if myordersPaypalArray[indexPath.row].order_status == "cancelled" {
                
                cell.orderstatusLabel.text = myordersPaypalArray[indexPath.row].order_status
                cell.orderstatusLabel.textColor = UIColor.darkGray
                cell.deliveryImage.backgroundColor = UIColor.darkGray
            }
            
            cell.orderdateLabel.text = myordersPaypalArray[indexPath.row].order_date
            cell.orderOwnerLabel.text = myordersPaypalArray[indexPath.row].shipping_name
            //cell.merchantNameLabel.text = myordersPaypalArray[indexPath.row].merchant_name
            cell.orderTotal.text = myordersPaypalArray[indexPath.row].order_total
            
            if myordersPaypalArray[indexPath.row].payment_status == "1" {
                
                //cell.paymentLabel.text = " "  //"Cash on delivery"
            }
            else {
                //cell.paymentLabel.text = " " //"PayPal"
            }
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        else {
            let cellIdentifier = "CustomCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
            
            //cell.ordertitleLabel.text = myordersCODArray[indexPath.row].order_title
            
            if myordersCODArray[indexPath.row].order_status == "success" {
                
                cell.orderstatusLabel.text = myordersCODArray[indexPath.row].order_status
                cell.orderstatusLabel.textColor = UIColor(red: 73.0/255.0, green:178.0/255.0, blue: 4.0/255.0, alpha: 1.0)
                cell.deliveryImage.backgroundColor = UIColor(red: 73.0/255.0, green:178.0/255.0, blue: 4.0/255.0, alpha: 1.0)
            }
            else if myordersCODArray[indexPath.row].order_status == "completed" {
                
                cell.orderstatusLabel.text = myordersCODArray[indexPath.row].order_status
                cell.orderstatusLabel.textColor = UIColor(red: 73.0/255.0, green:178.0/255.0, blue: 4.0/255.0, alpha: 1.0)
                cell.deliveryImage.backgroundColor = UIColor(red: 73.0/255.0, green:178.0/255.0, blue: 4.0/255.0, alpha: 1.0)
            }
            else if myordersCODArray[indexPath.row].order_status == "Hold" {
                
                cell.orderstatusLabel.text = myordersCODArray[indexPath.row].order_status
                cell.orderstatusLabel.textColor = UIColor(red: 252.0/255.0, green:185.0/255.0, blue: 48.0/255.0, alpha: 1.0)
                cell.deliveryImage.backgroundColor = UIColor(red: 252.0/255.0, green:185.0/255.0, blue: 48.0/255.0, alpha: 1.0)
            }
            else if myordersCODArray[indexPath.row].order_status == "cancelled" {
                
                cell.orderstatusLabel.text = myordersCODArray[indexPath.row].order_status
                cell.orderstatusLabel.textColor = UIColor.darkGray
                cell.deliveryImage.backgroundColor = UIColor.darkGray
            }
            
            cell.orderdateLabel.text = myordersCODArray[indexPath.row].order_date
            cell.orderOwnerLabel.text = myordersCODArray[indexPath.row].shipping_name
            //cell.merchantNameLabel.text = myordersCODArray[indexPath.row].merchant_name
            cell.orderTotal.text = myordersCODArray[indexPath.row].order_total
            
            if myordersCODArray[indexPath.row].payment_status == "1" {
                
                //cell.paymentLabel.text = " "//"Cash on delivery"
            }
            else {
                //cell.paymentLabel.text = " " //"PayPal"
            }
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if btn_value == 1 {
            let objDetails = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            objDetails.orderdate = myordersPaypalArray[indexPath.row].order_date
            objDetails.amount = String(format: "%@%@", myordersPaypalArray[indexPath.row].currency_symbol, myordersPaypalArray[indexPath.row].order_total)
            objDetails.orderId = myordersPaypalArray[indexPath.row].order_id
            objDetails.day = myordersPaypalArray[indexPath.row].day
            objDetails.order_image = myordersPaypalArray[indexPath.row].image
            objDetails.titleString = myordersPaypalArray[indexPath.row].order_title
            objDetails.statusString = myordersPaypalArray[indexPath.row].order_status
            objDetails.merchantName = myordersPaypalArray[indexPath.row].merchant_name
            objDetails.couponCode = myordersPaypalArray[indexPath.row].coupon_code
            objDetails.redeemValue = myordersPaypalArray[indexPath.row].is_redeem
            //            objDetails.productTitle = orderProductListArray[indexPath.row].product_title
            //            objDetails.productPrice = orderProductListArray[indexPath.row].product_price
            //            objDetails.quantity = orderProductListArray[indexPath.row].order_qty
            //            objDetails.imageOfProduct = orderProductListArray[indexPath.row].image
            
            
            self.navigationController?.pushViewController(objDetails, animated: true)
        }
        else {
            let objDetails = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            objDetails.orderId = myordersCODArray[indexPath.row].order_id
            objDetails.orderdate = myordersCODArray[indexPath.row].order_date
            // objDetails.day = myordersCODArray[indexPath.row].day
            objDetails.day = myordersCODArray[indexPath.row].day
            // objDetails.amount = myordersCODArray[indexPath.row].order_total
            objDetails.amount = String(format: "%@%@", myordersCODArray[indexPath.row].currency_symbol, myordersCODArray[indexPath.row].order_total)
            objDetails.order_image = myordersCODArray[indexPath.row].image
            objDetails.titleString = myordersCODArray[indexPath.row].order_title
            objDetails.statusString = myordersCODArray[indexPath.row].order_status
            objDetails.merchantName = myordersCODArray[indexPath.row].merchant_name
            objDetails.couponCode = myordersCODArray[indexPath.row].coupon_code
            objDetails.redeemValue = myordersCODArray[indexPath.row].is_redeem
            
            
            //            objDetails.productTitle = orderProductListArray[indexPath.row].product_title
            //            objDetails.productPrice = orderProductListArray[indexPath.row].product_price
            //            objDetails.quantity = orderProductListArray[indexPath.row].order_qty
            //            objDetails.imageOfProduct = orderProductListArray[indexPath.row].image
            
            self.navigationController?.pushViewController(objDetails, animated: true)
            
        }
    }
    
    @IBAction func btnCOD(sender:UIButton ) {
        loadView()
        btn_value = 0
        UserDefaults.standard.set(0, forKey: "btn_value0")
        //        imgCOD.isHidden = false
        //        imgPaypal.isHidden = true
        
        DispatchQueue.main.async {
            if self.btn_value == 0 {
                print("I am  in btn value Unredeem")
                self.myordersApiForReload()
                self.myordersTable.reloadData()
            }
        }
        UserDefaults.standard.removeObject(forKey: "btn_value1")
        
        if self.myordersCODArray.count == 0 {
            
            var style = ToastStyle()
            style.messageFont = messageFont!
            style.messageColor = UIColor.white
            style.messageAlignment = .center
            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
            //self.view.makeToast("No Orders Available!", duration: 3.0, position: .center, style: style)
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //myordersTable.reloadData()
    }
    
    @IBAction func btnPaypal(sender:UIButton ) {
        loadView()
        btn_value = 1
        UserDefaults.standard.set(1, forKey: "btn_value1")
        
        //        imgCOD.isHidden = true
        //        imgPaypal.isHidden = false
        //  myordersTable.reloadData()
        
        DispatchQueue.main.async {
            if self.btn_value == 1 {
                print("I am  in btn value Unredeem")
                self.myordersApiForReloadRedeem()
                self.myordersTable.reloadData()
            }
        }
        UserDefaults.standard.removeObject(forKey: "btn_value0")
        
        if self.myordersPaypalArray.count == 0 {
            
            var style = ToastStyle()
            style.messageFont = messageFont!
            style.messageColor = UIColor.white
            style.messageAlignment = .center
            style.backgroundColor = UIColor(red: 28.0/255.0,green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
            
            //self.view.makeToast("No Orders Available!", duration: 3.0, position: .center, style: style)
        }
        print("I am redeem")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func myordersApiForReload() {
        myordersCODArray.removeAll()
        myordersPaypalArray.removeAll()
        orderProductListArray.removeAll()
        let myUrl = URL(string: String(format:"%@api/my_orders", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
              postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&page_no=\(page_no!)&lang=en"
        }else{
              postString = "page_no=\(page_no!)&lang=en"
        }
        
        
        // let postString = "user_id=44&page_no=\(page_no!)&lang=en"
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
                            
                            if let reposArray = parseJSON["product_order_list"] as? [NSDictionary] {
                                // 5
                                print("my orders value ----\(reposArray)")
                                //                                if reposArray.count != 0 {
                                //
                                //                                    for item in reposArray {
                                //                                        self.myordersPaypalArray.append(OrdersPaypal(OrdersPaypal: item))
                                //                                        //print(<#T##items: Any...##Any#>)
                                //                                        var dayNumber = item["day"]
                                //                                        print("dayNumber Id ---\(dayNumber!)")
                                //
                                //                                    }
                                //                                }
                                //         self.page_no = self.page_no + 1
                            }
                            
                            if let reposArray = parseJSON["order_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.myordersCODArray.append(OrdersCOD(OrdersCOD: item))
                                        let order_id = item["day"]
                                        print("Order Id ---\(order_id!)")
                                        // self.myordersCODArray.last?.payment_status = "1"
                                    }
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.myordersTable.reloadData()
                            }
                        }
                        else {
                            
                            if self.btn_value == 1 {
                                
                                if self.myordersPaypalArray.count == 0 {
                                    
                                    var style = ToastStyle()
                                    style.messageFont = messageFont!
                                    style.messageColor = UIColor.white
                                    style.messageAlignment = .center
                                    style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                    
                                    //    self.view.makeToast("No Orders Available!", duration: 3.0, position: .center, style: style)
                                }
                                else {
                                    
                                    var style = ToastStyle()
                                    style.messageFont = messageFont!
                                    style.messageColor = UIColor.white
                                    style.messageAlignment = .center
                                    style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                    
                                    //   self.view.makeToast("No More Orders Available!", duration: 3.0, position: .bottom, style: style)
                                }
                            }
                            else {
                                
                                if self.myordersCODArray.count == 0 {
                                    
                                    var style = ToastStyle()
                                    style.messageFont = messageFont!
                                    style.messageColor = UIColor.white
                                    style.messageAlignment = .center
                                    style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                    
                                    //     self.view.makeToast("No Orders Available!", duration: 3.0, position: .center, style: style)
                                }
                                else {
                                    
                                    var style = ToastStyle()
                                    style.messageFont = messageFont!
                                    style.messageColor = UIColor.white
                                    style.messageAlignment = .center
                                    style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                    
                                    //       self.view.makeToast("No More Orders Available!", duration: 3.0, position: .bottom, style: style)
                                }
                            }
                        }
                        
                        self.myordersTable.reloadData()
                        // self.myordersTable.infiniteScrollingView.stopAnimating()
                    }
                    DispatchQueue.main.async {
                        self.myordersTable.reloadData()
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
    
    
    
    func myordersApiForReloadRedeem() {
        myordersCODArray.removeAll()
        myordersPaypalArray.removeAll()
        orderProductListArray.removeAll()
        let myUrl = URL(string: String(format:"%@api/my_orders", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
             postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&page_no=\(page_no!)&lang=en"
        }else{
             postString = "page_no=\(page_no!)&lang=en"
        }
        
        
        // let postString = "user_id=44&page_no=\(page_no!)&lang=en"
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
                            
                            if let reposArray = parseJSON["product_order_list"] as? [NSDictionary] {
                                // 5
                                print("my orders value ----\(reposArray)")
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.myordersPaypalArray.append(OrdersPaypal(OrdersPaypal: item))
                                        //print(<#T##items: Any...##Any#>)
                                        let dayNumber = item["day"]
                                        print("dayNumber Id ---\(dayNumber!)")
                                        
                                    }
                                }
                                self.page_no = self.page_no + 1
                            }
                            
                            if let reposArray = parseJSON["order_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.myordersCODArray.append(OrdersCOD(OrdersCOD: item))
                                        let order_id = item["day"]
                                        print("Order Id ---\(order_id!)")
                                        // self.myordersCODArray.last?.payment_status = "1"
                                    }
                                }
                            }
                            
                            //                            if let reposArray = parseJSON["deal_order_list"] as? [NSDictionary] {
                            //                                // 5
                            //                                //print(reposArray)
                            //                                if reposArray.count != 0 {
                            //
                            //                                    for item in reposArray {
                            //                                        self.myordersPaypalArray.append(OrdersPaypal(OrdersPaypal: item))
                            //                                    }
                            //                                }
                            //                            }
                            
                            //                            if let reposArray = parseJSON["deal_order_cod_list"] as? [NSDictionary] {
                            //                                // 5
                            //                                //print(reposArray)
                            //                                if reposArray.count != 0 {
                            //
                            //                                    for item in reposArray {
                            //                                        self.myordersCODArray.append(OrdersCOD(OrdersCOD: item))
                            //                                        self.myordersCODArray.last?.payment_status = "1"
                            //                                    }
                            //                                }
                            //                            }
                            self.myordersCODArray.sort { $0.orderDate > $1.orderDate }
                        }
                        else {
                            
                            if self.btn_value == 1 {
                                
                                if self.myordersPaypalArray.count == 0 {
                                    
                                    var style = ToastStyle()
                                    style.messageFont = messageFont!
                                    style.messageColor = UIColor.white
                                    style.messageAlignment = .center
                                    style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                    
                                    //self.view.makeToast("No Orders Available!", duration: 3.0, position: .center, style: style)
                                }
                                else {
                                    
                                    var style = ToastStyle()
                                    style.messageFont = messageFont!
                                    style.messageColor = UIColor.white
                                    style.messageAlignment = .center
                                    style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                    
                                    self.view.makeToast("No More Orders Available!", duration: 3.0, position: .bottom, style: style)
                                }
                            }
                            else {
                                
                                if self.myordersCODArray.count == 0 {
                                    
                                    var style = ToastStyle()
                                    style.messageFont = messageFont!
                                    style.messageColor = UIColor.white
                                    style.messageAlignment = .center
                                    style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                    
                                    //self.view.makeToast("No Orders Available!", duration: 3.0, position: .center, style: style)
                                }
                                else {
                                    
                                    var style = ToastStyle()
                                    style.messageFont = messageFont!
                                    style.messageColor = UIColor.white
                                    style.messageAlignment = .center
                                    style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                    
                                    self.view.makeToast("No More Orders Available!", duration: 3.0, position: .bottom, style: style)
                                }
                            }
                        }
                        
                        self.myordersTable.reloadData()
                        // self.myordersTable.infiniteScrollingView.stopAnimating()
                    }
                    DispatchQueue.main.async {
                        self.myordersTable.reloadData()
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
