//
//  MyCartViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 18/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class MyCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var mycartTable : UITableView!
    @IBOutlet weak var continueButton : UIButton!
    @IBOutlet weak var totalLabel : UILabel!
    @IBOutlet weak var noofitemsLabel : UILabel!
    @IBOutlet weak var shippingLabel : UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var couponCodeText: UITextField!
    @IBOutlet weak var promoCodeApplyText: UILabel!
    
    var mycartArray = [MyCart]()
    var screen_value:String!
    var cart_sub_total: String!
    var cart_Tax: String!
    var currencySymbol = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        applyBtn.layer.cornerRadius = 5
        
        promoCodeApplyText.isHidden = true
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Cart"
        
        if screen_value == "Menu" {
            
            if revealViewController() != nil {
                
                let rightRevealButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu")!, style: .done, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
                self.navigationItem.leftBarButtonItem = rightRevealButtonItem
                self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
                view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
        }
        else {
            
            let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
            leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
            leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
            leftbutton.addTarget(self, action: #selector(MyCartViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
            
            let LeftButton = UIBarButtonItem(customView: leftbutton)
            //self.navigationItem.leftBarButtonItem = LeftButton
        }
        
        continueButton.isHidden = true
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            mycartApi()
            //            addCouponCode()
            //            productDetailsApi()
        }
        else {
            
            self.showNetworkErrorAlert()
        }
        
        couponCodeText.tag = 1 //AnyValue
        couponCodeText.delegate = self
    }
    //start
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
    }
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    //end
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1{
            print("I am touched")
            applyBtn.backgroundColor = UIColor(red:0.00, green:0.67, blue:0.89, alpha:1.0)
        }
        return true
    }
    
    @objc func backAction(_ sender: UIButton!) {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.black
        style.messageAlignment = .center
        style.backgroundColor = UIColor(red:0.00, green:0.67, blue:0.89, alpha:1.0)
        
        self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .center, style: style)
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
            let postString = "lang=en"
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
                                if reposArray.count == 0 {
                                    
                                    self.mycartTable.isHidden = true
                                    
                                    var style = ToastStyle()
                                    style.messageFont = messageFont!
                                    style.messageColor = UIColor.white
                                    style.messageAlignment = .center
                                    style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                    
                                    self.view.makeToast("No Data Available!", duration: 3.0, position: .center, style: style)
                                }
                                else {
                                    
                                    for item in reposArray {
                                        self.mycartArray.append(MyCart(MyCart: item))
                                    }
                                    
                                    UserDefaults.standard.set(parseJSON.object(forKey: "cart_count") as? NSInteger, forKey: "CartCount")

                                    
                                    self.currencySymbol =  (parseJSON.object(forKey: "cart_currency_symbol") as? String)!
                                   // self.navigationItem.title = String(format:"Cart (%d)", (parseJSON.object(forKey: "cart_count") as? NSInteger)!)
                                     self.navigationItem.title = String(format:"Cart", (parseJSON.object(forKey: "cart_count") as? NSInteger)!)
                                    self.noofitemsLabel.text = String(format:"%d", (parseJSON.object(forKey: "cart_count") as? NSInteger)!)
                                    self.shippingLabel.text = String(format: "%@ %@", (parseJSON.object(forKey: "cart_currency_symbol") as? String)!, (parseJSON.object(forKey: "cart_grand_shipping") as? NSNumber)!)
                                    self.totalLabel.text = String(format: "%@ %@", (parseJSON.object(forKey: "cart_currency_symbol") as? String)!, (parseJSON.object(forKey: "cart_grand_total") as? NSNumber)!)
                                    //self.totalLabel.text
                                    // var TotalAmount = String(format: "%@ %@", (parseJSON.object(forKey: "cart_currency_symbol") as? String)!, (parseJSON.object(forKey: "cart_grand_total") as? NSNumber)!)
                                    //                                    self.totalLabel.text = String(format:"%d", (parseJSON.object(forKey: "cart_grand_total") as? NSInteger)!)
                                    let TotalAmount = String(format:"%d", (parseJSON.object(forKey: "cart_grand_total") as? NSInteger)!)
                                    
                                    UserDefaults.standard.set("\(TotalAmount)", forKey: "TotalAmount")
                                    
                                    
                                    //                                    if totalAmount != nil {
                                    ////                                        self.totalLabel.text = "\(format: "%@ %@", (parseJSON.object(forKey: "cart_currency_symbol") as? String)!, (parseJSON.object(forKey: "cart_grand_total") as? NSNumber)!)"  -  "\(UserDefaults.standard.set("\(value)", forKey: "CodeAmount"))"
                                    //                                        var discountAmount =  UserDefaults.standard.string(forKey: "Key")
                                    //                                        var finalAmount =   "\((Int(totalAmount ?? "") ?? 0) - (Int(totalAmount ?? "") ?? 0))" //Int(totalAmount) - Int(discountAmount!)
                                    //
                                    //                                        self.totalLabel.text = finalAmount
                                    //                                    }else {
                                    //                                        self.totalLabel.text = String(format: "%@ %@", (parseJSON.object(forKey: "cart_currency_symbol") as? String)!, (parseJSON.object(forKey: "cart_grand_total") as? NSNumber)!)
                                    //                                    }
                                    
                                    self.cart_sub_total = String(format: "%@%@", (parseJSON.object(forKey: "cart_currency_symbol") as? String)!, (parseJSON.object(forKey: "cart_sub_total") as? NSNumber)!)
                                    self.cart_Tax = String((parseJSON.object(forKey: "cart_grand_tax") as? Double)!)
                                    self.taxLabel.text = self.currencySymbol + self.cart_Tax
                                }
                                self.mycartTable.reloadData()
                                self.continueButton.isHidden = false
                                self.mycartTable.isHidden = false
                            }
                        }
                        else {
                            
                            self.mycartTable.isHidden = true
                            var style = ToastStyle()
                            style.messageFont = messageFont!
                            style.messageColor = UIColor.white
                            style.messageAlignment = .center
                            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                            self.view.makeToast("No Data Available!", duration: 3.0, position: .center, style: style)
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
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mycartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CustomCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
        
        if mycartArray[indexPath.row].cart_image == "" {
            cell.productImage.image = UIImage(named: "no-image-icon")
        }
        else {
            cell.productImage.yy_imageURL = URL(string: mycartArray[indexPath.row].cart_image)
        }
        
        cell.producttitleLabel.text = mycartArray[indexPath.row].cart_title
        
        let priceLabelString = NSMutableAttributedString(string: String(format:"Price : %@%@", mycartArray[indexPath.row].cart_currency_symbol, mycartArray[indexPath.row].cart_price))
        priceLabelString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 5))
        cell.priceLabel.attributedText = priceLabelString
        
        if mycartArray[indexPath.row].cart_color_details.count == 0 {
            let colorLabelString = NSMutableAttributedString(string: String(format:"Color : "))
            colorLabelString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 5))
            cell.colorLabel.attributedText = colorLabelString
            cell.colorLabel.isHidden = true
        }
        else {
            let colorLabelString = NSMutableAttributedString(string: String(format:"Color : %@", mycartArray[indexPath.row].cart_color_details[0].object(forKey: "color_name") as! String))
            colorLabelString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 5))
            cell.colorLabel.attributedText = colorLabelString
            cell.colorLabel.isHidden = false
        }
        
        if mycartArray[indexPath.row].cart_size_details.count == 0 {
            let sizeLabelString = NSMutableAttributedString(string: String(format:"Size : "))
            sizeLabelString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 5))
            cell.sizeLabel.attributedText = sizeLabelString
            cell.sizeLabel.isHidden = true
        }
        else {
            let sizeLabelString = NSMutableAttributedString(string: String(format:"Size : %@", mycartArray[indexPath.row].cart_size_details[0].object(forKey: "size_name") as! String))
            sizeLabelString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 5))
            cell.sizeLabel.attributedText = sizeLabelString
            cell.sizeLabel.isHidden = false
        }
        
        cell.quantityLabel.text = String(format: "%d", mycartArray[indexPath.row].cart_quantity)
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButton), for: .touchUpInside)
        
        cell.plusButton.tag = indexPath.row
        cell.plusButton.addTarget(self, action: #selector(plusButton), for: .touchUpInside)
        cell.plusButton.isEnabled = true
        
        cell.minusButton.tag = indexPath.row
        cell.minusButton.addTarget(self, action: #selector(minusButton), for: .touchUpInside)
        cell.minusButton.isEnabled = true
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func plusButton(sender:UIButton ) {
        //  print("Plus button tapped")
        let alertController = UIAlertController(title: "Purchasing multiple vouchers?", message: "Remember, You can only redeem all these vouchers at once.To redeem vouchers separately, simply purchase them in separate transaction.", preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            if self.mycartArray[sender.tag].cart_quantity < self.mycartArray[sender.tag].product_available_qty {
                
                sender.isEnabled = false
                self.addCart(tag_value: sender)
            }
            
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        self.view.hideToastActivity()
        self.view.makeToastActivity(.center)
        
    }
    
    func addCart(tag_value: UIButton) {
        
        let myUrl = URL(string: String(format:"%@api/update_product_cart", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        var product_size_id = ""
        if mycartArray[tag_value.tag].cart_size_details.count != 0 {
            
            product_size_id = String(format:"%d", mycartArray[tag_value.tag].cart_size_details[0].object(forKey: "product_size_id") as! NSInteger)
        }
        
        var product_color_id = ""
        if mycartArray[tag_value.tag].cart_color_details.count != 0 {
            
            product_color_id = String(format:"%d", mycartArray[tag_value.tag].cart_color_details[0].object(forKey: "product_color_id") as! NSInteger)
        }
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&cart_id=\(mycartArray[tag_value.tag].cart_id!)&product_id=\(mycartArray[tag_value.tag].cart_product_id!)&product_size_id=\(product_size_id)&product_color_id=\(product_color_id)&quantity=\(String(format:"%d", mycartArray[tag_value.tag].cart_quantity + 1))&lang=en"
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
                            
                            self.mycartArray = [MyCart]()
                            
                            self.mycartApi()
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
    
    @objc func minusButton(sender:UIButton ) {
        
        if mycartArray[sender.tag].cart_quantity > 1 {
            
            sender.isEnabled = false
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            removeCart(tag_value: sender)
        }
    }
    
    func removeCart(tag_value: UIButton) {
        
        let myUrl = URL(string: String(format:"%@api/update_product_cart", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        var product_size_id = ""
        if mycartArray[tag_value.tag].cart_size_details.count != 0 {
            
            product_size_id = String(format:"%d", mycartArray[tag_value.tag].cart_size_details[0].object(forKey: "product_size_id") as! NSInteger)
        }
        
        var product_color_id = ""
        if mycartArray[tag_value.tag].cart_color_details.count != 0 {
            
            product_color_id = String(format:"%d", mycartArray[tag_value.tag].cart_color_details[0].object(forKey: "product_color_id") as! NSInteger)
        }
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&cart_id=\(mycartArray[tag_value.tag].cart_id!)&product_id=\(mycartArray[tag_value.tag].cart_product_id!)&product_size_id=\(product_size_id)&product_color_id=\(product_color_id)&quantity=\(String(format:"%d", mycartArray[tag_value.tag].cart_quantity - 1))&lang=en"
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
                            
                            self.mycartArray = [MyCart]()
                            
                            self.mycartApi()
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
    
    @objc func deleteButton(sender:UIButton ) {
        
        let myUrl = URL(string: String(format:"%@api/remove_productcart", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "cart_id=\(mycartArray[sender.tag].cart_id!)&lang=en"
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
                            
                            self.mycartArray = [MyCart]()
                            
                            self.mycartApi()
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
    
    @IBAction func continueButton(sender:UIButton ) {
        
        let objShipping = self.storyboard?.instantiateViewController(withIdentifier: "ShippingViewController") as! ShippingViewController
        objShipping.no_of_items = noofitemsLabel.text!
        objShipping.shipping_charge = shippingLabel.text!
        objShipping.amount = cart_sub_total!
        objShipping.total_amount = totalLabel.text!
        objShipping.screen_value = "MyCart"
        objShipping.tax = self.cart_Tax
        objShipping.currencySymbol = self.currencySymbol
        self.navigationController?.pushViewController(objShipping, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func applyPromoCode(_ sender: UIButton) {
        
        if couponCodeText.text?.isEmpty ?? true {
            let myAlert = UIAlertView(title: "Attention!",
                                      message: "Promo Code Field is required",
                                      delegate: nil, cancelButtonTitle: "OK")
            myAlert.show()
        } else {
            _ = UserDefaults.standard.string(forKey: "TotalAmount")
            _ =  UserDefaults.standard.string(forKey: "CodeAmount")
            productDetailsApi()
            //            print("textField has some text")
            //
            //            print("From VC i am printing --\(PromoCodeAmount)")
            //            print("From VC i am printing --\(TotalAmount)")
            //            print("\(PromoCodeAmount)")
            //
            //            let finalValue = "\((Int(TotalAmount ?? "") ?? 0) - (Int(PromoCodeAmount ?? "") ?? 0))"
            //            print(finalValue)
            //
            //            self.totalLabel.text = finalValue
            //            self.shippingLabel.text = PromoCodeAmount
            
        }
        let tagNumber  = sender.tag
        if sender.tag == 1 {
            //                     UserDefaults.standard.removeObject(forKey: "CodeAmount")
            //                    UserDefaults.standard.removeObject(forKey: "TotalAmount")
            //self.applyBtn.isUserInteractionEnabled = false           
            print(tagNumber)
            promoCodeApplyText.isHidden = false
        }
        
    }
    
    ////Start
    func productDetailsApi() {
        
        let myUrl = URL(string: String(format:"%@api/product_promo", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        //  let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(product_id!)&lang=en"//\(product_id!)
        let postString = "coupon_code=\(couponCodeText.text!)&user_id=\(UserDefaults.standard.object(forKey: "UserID")!)"//
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
                            
                            
                            //   self.shippingLabel.text = parseJSON.value(forKeyPath: "coupon_details.coupon_amount") as? String
                            let value =  String(parseJSON.value(forKeyPath: "coupon_details.coupon_amount") as! NSInteger)
                            // let value = self.shippingLabel.text
                            UserDefaults.standard.set("\(value)", forKey: "CodeAmount")
                            UserDefaults.standard.synchronize()
                            let TotalAmount = UserDefaults.standard.string(forKey: "TotalAmount")
                            let finalValue = "\((Int(TotalAmount ?? "") ?? 0) - (Int(value ) ?? 0))"
                            
                            self.totalLabel.text = finalValue
                            self.shippingLabel.text = value
                            
                            //  self.shippingLabel.text = value
                            //                            print("O vai ----- \(value)")
                            
                            
                            
                        }
                        //Show toast message
                        self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
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
    
    
    ////End
    
}


extension MyCartViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
