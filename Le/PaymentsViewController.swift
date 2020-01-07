//
//  PaymentsViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 03/05/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class PaymentsViewController: UIViewController, PayPalPaymentDelegate {

    var environment:String = PayPalEnvironmentSandbox {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var payPalConfig = PayPalConfiguration() // default
    
    @IBOutlet weak var paypalButton : UIButton!
    @IBOutlet weak var codButton : UIButton!
    @IBOutlet weak var payButton : UIButton!
    @IBOutlet weak var itemsLabel : UILabel!
    @IBOutlet weak var priceLabel : UILabel!
    @IBOutlet weak var shippingLabel : UILabel!
    @IBOutlet weak var amountLabel : UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    
    var tax: String!
    var payment_type:Int! = 0
    var no_of_items: String!
    var shipping_charge: String!
    var amount: String!
    var total_amount: String!
    var ship_name: String!
    var ship_address1: String!
    var ship_address2: String!
    var ship_email: String!
    var ship_phone: String!
    var ship_country_id: String!
    var ship_city_id: String!
    var ship_state: String!
    var ship_postalcode: String!
    
    var product_id: String!
    var product_size_id: String!
    var product_color_id: String!
    var product_qty: String!
    
    var deal_id: String!
    var deal_qty: String!
    
    var transaction_id: String! = ""
    
    var screen_value: String!
    
    
    var totalshipping: NSDecimalNumber = NSDecimalNumber(string: "0.0")
    var subtotal: NSDecimalNumber = NSDecimalNumber(string: "0.0")
    var totalTax : NSDecimalNumber = NSDecimalNumber(string: "0.0")
    var totalamount = 0
    var currencySymbol = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Payments"
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(PaymentsViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        self.navigationItem.leftBarButtonItem = LeftButton
        
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "Le"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        // Setting the languageOrLocale property is optional.
        //
        // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
        // its user interface according to the device's current language setting.
        //
        // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
        // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
        // to use that language/locale.
        //
        // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
        
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        
        // Setting the payPalShippingAddressOption property is optional.
        //
        // See PayPalConfiguration.h for details.
        
        //payPalConfig.payPalShippingAddressOption = .payPal;
        
        //print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
        
        //print(amount)
       // print(total_amount)
        
        
        
         if total_amount != nil {
        if let sub_total = Int(amount.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
            totalamount = totalamount + sub_total
            subtotal = NSDecimalNumber(string: "\(sub_total)")
            // print(total_amount)
        }
        }
        
        if shipping_charge != nil {
        if let shipping = Int(shipping_charge.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
            totalamount = totalamount + shipping
            totalshipping = NSDecimalNumber(string: "\(shipping)")
            //  print(shipping)
        }
        }
        if tax != nil {
            // print(taxing)
            let tax1:Double = Double(tax)!
            totalamount = totalamount + Int(tax1)
            totalTax = NSDecimalNumber(string: "\(Int(tax1))")
        }
        
        itemsLabel.text = String(format: "Price(%@ item)", no_of_items)
        
        priceLabel.text = amount
        
        shippingLabel.text = shipping_charge
        
        amountLabel.text =    currencySymbol + " " + "\(totalamount)"
        
        taxLabel.text =   currencySymbol + " " + tax
        
        payButton.setTitle(String(format: "Pay %@", String(totalamount)), for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    @objc func backAction(_ sender: UIButton!) {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func paypalButton(sender:UIButton ) {
        
        payment_type = 1
        paypalButton.isSelected = true
        codButton.isSelected = false
    }
    
    @IBAction func codButton(sender:UIButton ) {
        
        payment_type = 2
        paypalButton.isSelected = false
        codButton.isSelected = true
    }
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.white
        style.messageAlignment = .center
        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        
        self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .center, style: style)
    }
    
    @IBAction func payButton(sender:UIButton ) {
        
        if payment_type == 1 {
            
            // Note: For purposes of illustration, this example shows a payment that includes
            //       both payment details (subtotal, shipping, tax) and multiple items.
            //       You would only specify these if appropriate to your situation.
            //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
            //       and simply set payment.amount to your total charge.
          
            
            
            // Optional: include payment details
            
            let amount = NSDecimalNumber(string: "\(totalamount)")
           
           // print("subtotal",subtotal)
            let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: totalshipping, withTax: totalTax)
            

          
            let payment = PayPalPayment(amount: amount, currencyCode: "USD", shortDescription: "Le", intent: .sale)
            //payment.items = items
            payment.paymentDetails = paymentDetails
            
            if (payment.processable) {
                let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
                present(paymentViewController!, animated: true, completion: nil)
            }
            else {
                // This particular payment will always be processable. If, for
                // example, the amount was negative or the shortDescription was
                // empty, this payment wouldn't be processable, and you'd want
                // to handle that here.
                
                 messageToast(messageStr: "Payment not processalbe")
//               print("Payment not processalbe: \(payment)")
            }
        }
        else if payment_type == 2 {
            
            let reachability = Reachability()!
            
            if reachability.isReachable {
                
                payButton.isEnabled = false
                
                self.view.hideToastActivity()
                self.view.makeToastActivity(.center)
                
                if screen_value == "MyCart" {
                    
                    mycartCODApi()
                }
                else if screen_value == "Product" {
                    
                    productCODApi()
                }
                else if screen_value == "Deal" {
                    
                    dealCODApi()
                }
            }
            else {
                
                self.showNetworkErrorAlert()
            }
        }
        else {
            
            messageToast(messageStr: "Please select payment type")
        }
    }
    
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        //print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        //print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            //print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
            let paymentDict = completedPayment.confirmation as NSDictionary
            //print(completedPayment)
            self.transaction_id = paymentDict.value(forKeyPath: "response.id") as! String
            //print(self.transaction_id!)
            
            let reachability = Reachability()!
            
            if reachability.isReachable {
                
                self.payButton.isEnabled = false
                
                self.view.hideToastActivity()
                self.view.makeToastActivity(.center)
                
                if self.screen_value == "MyCart" {
                    
                    self.mycartPaypalApi()
                }
                else if self.screen_value == "Product" {
                    
                    self.productPaypalApi()
                }
                else if self.screen_value == "Deal" {
                    
                    self.dealPaypalApi()
                }
            }
            else {
                
                self.self.showNetworkErrorAlert()
            }
        })
    }
    
    func mycartPaypalApi() {
        
        let myUrl = URL(string: String(format:"%@api/product_paypal_order_success", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&ship_name=\(ship_name!)&ship_address1=\(ship_address1!)&ship_address2=\(ship_address2!)&ship_email=\(ship_email!)&ship_phone=\(ship_phone!)&ship_country_id=\(ship_country_id!)&ship_city_id=\(ship_city_id!)&ship_state=\(ship_state!)&ship_postalcode=\(ship_postalcode!)&transaction_id=\(transaction_id!)&token_id=&payer_email=&payer_id=&payer_name=&lang=en"
        //print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            UserDefaults.standard.set(0, forKey: "CartCount")
                            UserDefaults.standard.synchronize()
                            
                            let objPlaced = self.storyboard?.instantiateViewController(withIdentifier: "PlacedViewController") as! PlacedViewController
                            objPlaced.total_amount = String(self.totalamount)
                            objPlaced.shipping_details = parseJSON
                            self.navigationController?.pushViewController(objPlaced, animated: true)
                        }
                        else {
                            
                            self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
                        }
                    }
                }
                catch {
                    
                    //print(error)
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                }
            }
        })
        task.resume()
    }
    
    func dealPaypalApi() {
        
        let myUrl = URL(string: String(format:"%@api/deal_paypal_order_success_buy_now", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&deal_id=\(deal_id!)&deal_qty=\(deal_qty!)&ship_name=\(ship_name!)&ship_address1=\(ship_address1!)&ship_address2=\(ship_address2!)&ship_email=\(ship_email!)&ship_phone=\(ship_phone!)&ship_country_id=\(ship_country_id!)&ship_city_id=\(ship_city_id!)&ship_state=\(ship_state!)&ship_postalcode=\(ship_postalcode!)&transaction_id=\(transaction_id!)&token_id=&payer_email=&payer_id=&payer_name=&lang=en"
        //print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            let objPlaced = self.storyboard?.instantiateViewController(withIdentifier: "PlacedViewController") as! PlacedViewController
                            objPlaced.total_amount = String(self.totalamount)
                            objPlaced.shipping_details = parseJSON
                            self.navigationController?.pushViewController(objPlaced, animated: true)
                        }
                        else {
                            
                            self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
                        }
                    }
                }
                catch {
                    
                    //print(error)
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                }
            }
        })
        task.resume()
    }
    
    func productPaypalApi() {
        
        let myUrl = URL(string: String(format:"%@api/product_paypal_order_success_buy_now", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(product_id!)&product_size_id=\(product_size_id!)&product_color_id=\(product_color_id!)&product_qty=\(product_qty!)&ship_name=\(ship_name!)&ship_address1=\(ship_address1!)&ship_address2=\(ship_address2!)&ship_email=\(ship_email!)&ship_phone=\(ship_phone!)&ship_country_id=\(ship_country_id!)&ship_city_id=\(ship_city_id!)&ship_state=\(ship_state!)&ship_postalcode=\(ship_postalcode!)&transaction_id=\(transaction_id!)&token_id=\(transaction_id!)&payer_email=&payer_id=&payer_name=&lang=en"
        //print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            let objPlaced = self.storyboard?.instantiateViewController(withIdentifier: "PlacedViewController") as! PlacedViewController
                            objPlaced.total_amount = String(self.totalamount)
                            objPlaced.shipping_details = parseJSON
                            self.navigationController?.pushViewController(objPlaced, animated: true)
                        }
                        else {
                            
                            self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
                        }
                    }
                }
                catch {
                    
                    //print(error)
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                }
            }
        })
        task.resume()
    }
    
    func mycartCODApi() {
        
        let myUrl = URL(string: String(format:"%@api/product_cod_order", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&ship_name=\(ship_name!)&ship_address1=\(ship_address1!)&ship_address2=\(ship_address2!)&ship_email=\(ship_email!)&ship_phone=\(ship_phone!)&ship_country_id=\(ship_country_id!)&ship_city_id=\(ship_city_id!)&ship_state=\(ship_state!)&ship_postalcode=\(ship_postalcode!)&lang=en"
        //print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            UserDefaults.standard.set(0, forKey: "CartCount")
                            UserDefaults.standard.synchronize()
                            
                            let objPlaced = self.storyboard?.instantiateViewController(withIdentifier: "PlacedViewController") as! PlacedViewController
                            objPlaced.total_amount = String(self.totalamount)
                            objPlaced.shipping_details = parseJSON
                            self.navigationController?.pushViewController(objPlaced, animated: true)
                        }
                        else {
                            
                            self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
                        }
                    }
                }
                catch {
                    
                    //print(error)
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                }
            }
        })
        task.resume()
    }
    
    func productCODApi() {
        
        let myUrl = URL(string: String(format:"%@api/product_cod_order_buy_now", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(product_id!)&product_size_id=\(product_size_id!)&product_color_id=\(product_color_id!)&product_qty=\(product_qty!)&ship_name=\(ship_name!)&ship_address1=\(ship_address1!)&ship_address2=\(ship_address2!)&ship_email=\(ship_email!)&ship_phone=\(ship_phone!)&ship_country_id=\(ship_country_id!)&ship_city_id=\(ship_city_id!)&ship_state=\(ship_state!)&ship_postalcode=\(ship_postalcode!)&lang=en"
        //print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            let objPlaced = self.storyboard?.instantiateViewController(withIdentifier: "PlacedViewController") as! PlacedViewController
                            objPlaced.total_amount = String(self.totalamount)
                            objPlaced.shipping_details = parseJSON
                            self.navigationController?.pushViewController(objPlaced, animated: true)
                        }
                        else {
                            
                            self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
                        }
                    }
                }
                catch {
                    
                    //print(error)
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                }
            }
        })
        task.resume()
    }
    
    func dealCODApi() {
        
        let myUrl = URL(string: String(format:"%@api/deal_order_buy_now", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&deal_id=\(deal_id!)&deal_qty=\(deal_qty!)&ship_name=\(ship_name!)&ship_address1=\(ship_address1!)&ship_address2=\(ship_address2!)&ship_email=\(ship_email!)&ship_phone=\(ship_phone!)&ship_country_id=\(ship_country_id!)&ship_city_id=\(ship_city_id!)&ship_state=\(ship_state!)&ship_postalcode=\(ship_postalcode!)&lang=en"
        //print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            let objPlaced = self.storyboard?.instantiateViewController(withIdentifier: "PlacedViewController") as! PlacedViewController
                            objPlaced.total_amount = String(self.totalamount)
                            objPlaced.shipping_details = parseJSON
                            self.navigationController?.pushViewController(objPlaced, animated: true)
                        }
                        else {
                            
                            self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
                        }
                    }
                }
                catch {
                    
                    //print(error)
                    self.view.hideToastActivity()
                    self.payButton.isEnabled = true
                }
            }
        })
        task.resume()
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
