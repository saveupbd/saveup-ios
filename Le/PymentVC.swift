//
//  PymentVC.swift
//  Le
//
//  Created by Akramul Haque on 12/3/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit
import WebKit
//import SSLCommerz

class PymentVC: UIViewController/*,SSLCommerzDelegate*/ {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backBtn.layer.cornerRadius = 5
        activityIndicator.startAnimating()
        
        let userDefault = UserDefaults.standard
        let userId="\(UserDefaults.standard.object(forKey: "UserID")!)"
        
        let userName = userDefault.string(forKey: "name")!.removeWhitespace()
        let email = userDefault.string(forKey: "email")!
        let address = userDefault.string(forKey: "address")!.removeWhitespace()
        let city = userDefault.string(forKey: "city")!.removeWhitespace()
        let state = userDefault.string(forKey: "state")!.removeWhitespace()
        let zip = userDefault.string(forKey: "zip")!.removeWhitespace()
        let phoneNumber = userDefault.string(forKey: "phoneNumber")!.removeWhitespace()
        
        let myURL = URL(string: "https://saveupbd.com/app-pay?user_id=\(userId)&email=\(email)&name=\(userName)&address=\(address)&city=\(city)&province=\(state)&postalcode=\(zip)&phone=\(phoneNumber)&coupon_code=null")
        
        let myRequest = URLRequest(url: myURL!)
        webView.navigationDelegate = self
        webView.load(myRequest)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    //MARK:- SSLCommerz
//    var sslPay:SSLCommerz?
//    
//    func transactionCompleted(withTransactionData transactionData: TransactionDetails?) {
//        print("\(transactionData!)")
//    }
//    func configureSSLCommerz() {
//        sslPay = SSLCommerz.init(integrationInformation: .init(storeID: "saveu5dc66da586ca7", storePassword: "saveu5dc66da586ca7@ssl", totalAmount: 10.00, currency: "BDT", transactionId: "2343", productCategory: "asd"), emiInformation: nil, customerInformation: .init(customerName: "doe", customerEmail: "ss@ss.com", customerAddressOne: "one", customerCity: "two", customerPostCode: "111", customerCountry: "BD", customerPhone: "00000"), shipmentInformation: nil, productInformation: nil, additionalInformation: nil)
//        sslPay?.delegate = self
//        sslPay?.start(in: self, shouldRunInTestMode: false)
//    }
    
}

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}

extension PymentVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView,didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
