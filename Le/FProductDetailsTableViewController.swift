//
//  FProductDetailsTableViewController.swift
//  Le
//
//  Created by Asif Seraje on 12/21/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit

class FProductDetailsTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,RelatedCollectionCellDelegate {

    @IBOutlet weak var btnWishList: UIButton!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var productTableView: UITableView!
    //@IBOutlet weak var imagesTable : UITableView?
    var productImage : UIImageView?
    var producttitleText = ""
    var productpriceText = ""
    var productdiscountpriceText = ""
    var productpercentageText = ""
    var productType = ""
    var productOff = 0
    var footerImage : UIImageView?
    //@IBOutlet weak var relatedTable : UITableView!
    var addcartButton : UIButton?
    var buynowButton : UIButton?
    var colorView : UIView?
    var colorTable : UITableView?
    var sizeTable : UITableView?
    var descriptionView : UIView?
    var descriptionLabel : UILabel?
    var descriptionText = ""
    var dealIncludeLabel: UILabel?
    var dealIncludeText = ""
    var reviewView : UIView?
    var headerView : UIView?
    var reviewTable : UITableView?
    var footerView : UIView?
    var specificationView : UIView?
    var specificationLabel : UILabel?
    var deliveryView : UIView?
    
    var conditionView: UIView?
    var conditionsLabel: UILabel?
    var conditionsText = ""
    var redemptionView: UIView?
    var redemptionLabel: UILabel?
    var redemptionText = ""
    var directionView: UIView?
    var directionLabel: UILabel?
    var directionText = ""
    var redeemOfferView: UIView?
    //@IBOutlet weak var redeemOfferLabel: UILabel!
    var redeemOfferLabel: UILabel?
    var redeemOfferText = ""
    var storeDetailsView: UIView?
    var storeName: UILabel?
    var storeAddress: UILabel?
    var storeImage: UIImage?
    
    var storeNameText = ""
    var storeAddressText = ""
    
    var deliveryLabel : UILabel?
    var reviewButton : UIButton?
    var soldoutLabel : UILabel?
    
    var selectSize: UILabel?
    var selectColorLabel: UILabel?
    
    var productimagesArray = [ProductImages]()
    var relatedArray = [RelatedProducts]()
    var colorsArray = [Colors]()
    var sizeArray = [Sizes]()
    var reviewArray = [Review]()
    var spec_string = String()
    var LatLongArray = [storeDetails]()
    
    var category_name: String!
    var product_id: String!
    var product_size_id: String! = ""
    var product_color_id: String! = ""
    var tax = ""
    var product_ship_amt: String!
    var currencySymbol = String()
    var Amount = String()
    var storeId:Int?
    
    var COLORVIEW_Y_AXIS = CGFloat()
    
    private var floatingButton: UIButton?
    // TODO: Replace image name with your own image:
    private var floatingButtonImageName = "NAME OF YOUR IMAGE"
    private var buttonHeight: CGFloat = 36.0
    private var buttonWidth: CGFloat = 75.0
    //private let roundValue = FloatingButtonViewController.buttonHeight/2
    private var trailingValue: CGFloat = 15.0
    private var leadingValue: CGFloat = 49.0
    private var shadowRadius: CGFloat = 2.0
    private var shadowOpacity: Float = 0.5
    private var shadowOffset = CGSize(width: 0.0, height: 5.0)
    private var scaleKeyPath = "scale"
    private var animationKeyPath = "transform.scale"
    private var animationDuration: CFTimeInterval = 0.4
    private var animateFromValue: CGFloat = 1.00
    private var animateToValue: CGFloat = 1.05
    
    
    private func createFloatingButton() {
        floatingButton = UIButton(type: .custom)
        floatingButton?.translatesAutoresizingMaskIntoConstraints = false
        floatingButton?.backgroundColor = UIColor(named: "appThemeColor")
        //floatingButton?.setImage(UIImage(named: floatingButtonImageName), for: .normal)
        floatingButton?.setTitle("Add to Cart", for: .normal)
        floatingButton?.addTarget(self, action: #selector(doThisWhenButtonIsTapped(_:)), for: .touchUpInside)
        constrainFloatingButtonToWindow()
        addShadowToFloatingButton()
        //addScaleAnimationToFloatingButton()
    }
    
    // TODO: Add some logic for when the button is tapped.
    @IBAction private func doThisWhenButtonIsTapped(_ sender: Any) {
        print("Button Tapped")
    }
    
    private func constrainFloatingButtonToWindow() {
        DispatchQueue.main.async {
            self.leadingValue = self.view.safeAreaInsets.bottom + 10.0
            self.buttonWidth = self.view.bounds.width/2
            print(self.leadingValue)
            guard let keyWindow = UIApplication.shared.keyWindow,
                let floatingButton = self.floatingButton else { return }
            keyWindow.addSubview(floatingButton)
            keyWindow.trailingAnchor.constraint(equalTo: floatingButton.trailingAnchor,
                                                constant: self.trailingValue).isActive = true
            keyWindow.bottomAnchor.constraint(equalTo: floatingButton.bottomAnchor,
                                              constant: self.leadingValue).isActive = true
            floatingButton.widthAnchor.constraint(equalToConstant:
                self.buttonWidth).isActive = true
            floatingButton.heightAnchor.constraint(equalToConstant:
                self.buttonHeight).isActive = true
        }
    }
    
    private func addShadowToFloatingButton() {
        floatingButton?.layer.shadowColor = UIColor.black.cgColor
        floatingButton?.layer.shadowOffset = shadowOffset
        floatingButton?.layer.masksToBounds = false
        floatingButton?.layer.shadowRadius = shadowRadius
        floatingButton?.layer.shadowOpacity = shadowOpacity
    }
    
    //    private func addScaleAnimationToFloatingButton() {
    //        // Add a pulsing animation to draw attention to button:
    //        DispatchQueue.main.async {
    //            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: self.animationKeyPath)
    //            scaleAnimation.duration = self.animationDuration
    //            scaleAnimation.repeatCount = .greatestFiniteMagnitude
    //            scaleAnimation.autoreverses = true
    //            scaleAnimation.fromValue = self.animateFromValue
    //            scaleAnimation.toValue = self.animateToValue
    //            self.floatingButton?.layer.add(scaleAnimation, forKey: self.scaleKeyPath)
    //        }
    //    }
    
    lazy var faButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    func setupButton() {
        NSLayoutConstraint.activate([
            faButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            faButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            faButton.heightAnchor.constraint(equalToConstant: 80),
            faButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        faButton.layer.cornerRadius = 40
        faButton.layer.masksToBounds = true
        faButton.layer.borderColor = UIColor.lightGray.cgColor
        faButton.layer.borderWidth = 4
    }
    
    @objc func fabTapped(_ button: UIButton) {
        print("button tapped")
    }
    
    var btnFloating:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.COLORVIEW_Y_AXIS = self.colorView.frame.minY
        //self.canShowColorView()
//        createFloatingButton()
//        setupButton()
        let productId = self.product_id
        UserDefaults.standard.set("productId", forKey: "productId")
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            productDetailsApi()
        }
        else {
            self.showNetworkErrorAlert()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 9{
            return 410
        }
        return UITableView.automaticDimension
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.productTableView.estimatedRowHeight = 400
//        self.productTableView.rowHeight = UITableView.automaticDimension
        
        
        
        mycartApi()
        let cartButton   = MIBadgeButton()
        cartButton.frame = CGRect(x: 0, y: 30, width: 30, height: 44)
        cartButton.setImage(UIImage(named: "cart-icon"), for: UIControl.State())
        cartButton.addTarget(self, action: #selector(self.cartAction(_:)), for: UIControl.Event.touchUpInside)
        //        if UserDefaults.standard.object(forKey: "CartCount") != nil {
        //            print("I am not empty")
        //            cartButton.badgeString = String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
        //            UserDefaults.standard.removeObject(forKey: "CartCount")
        //        } else {
        //            print("Cart is  empty-----")
        //            //cartButton.badgeString = String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
        //        }
        //  cartButton.badgeString = String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
        cartButton.badgeTextColor = UIColor.white
        //self.COLORVIEW_Y_AXIS = self.colorView.frame.minY
        let rightButton = UIBarButtonItem(customView: cartButton)
        //self.navigationItem.rightBarButtonItem = rightButton
        //createFloatingButton()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard floatingButton?.superview != nil else {  return }
        DispatchQueue.main.async {
            self.floatingButton?.removeFromSuperview()
            self.floatingButton = nil
        }
        
    }
    
    
    func verifyOtp() {
        let myUrl = URL(string: String(format:"%@api/order_otp_verified", Api_Base_URL));
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"
        
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            postString = "otp_code=\(self.otpCode!)&user_id=\(tempUserID)&merchant_id=\(self.otpMerchantId!)"
        }else{
            postString = "otp_code=\(self.otpCode!)&merchant_id=37"
        }
        
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
                            
                            //         {"status":200,"message":"OTP Code Successfully Verified. Your payable amount TK 46","loyality_point":465,"total_loyality_point":1843}
                            
                            let mess = parseJSON.object(forKey: "message") as? String
                            let point = parseJSON.object(forKey: "loyality_point") as? NSInteger
                            UserDefaults.standard.set(point, forKey: "loyality_point")
                            let total_point = parseJSON.object(forKey: "total_loyality_point") as? NSInteger
                            UserDefaults.standard.set(total_point, forKey: "total_loyality_point")
                            let pointmessage = "You have got \(point!) points. Your total loyality point is \(total_point!)."
                            
                            let alert = UIAlertController(title: "OTP Code", message: mess! + ". " + pointmessage, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler:{ (ACTION :UIAlertAction!)in
                                self.dismiss(animated: true, completion: nil)
                                
                            }))
                            
                            DispatchQueue.main.async {
                                self.view.hideToastActivity()
                                self.present(alert, animated: true, completion: nil)
                            }
                            
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
    
    var otpMessage:String?
    var otpCode:NSInteger?
    var otpMerchantId:NSInteger?
    var otpAmount:NSInteger?
    var otpTextField: UITextField?
    
    func payNowPressed() {
        let myUrl = URL(string: String(format:"%@api/order_by_otp", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        var postString = ""
        let merID = UserDefaults.standard.object(forKey: "merchant_id") as! String
        let finalMerchantId = Int(merID)
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            postString = "amount=\(self.otpAmount!)&user_id=\(tempUserID)&merchant_id=\(finalMerchantId!)&product_id=\(product_id!)"
        }else{
            postString = "product_id=\(product_id!)&amount=\(product_size_id!)&merchantId=\(product_color_id!)"
        }
        
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
                            DispatchQueue.main.async {
                                self.otpMessage = parseJSON.object(forKey: "message") as? String
                                //self.otpCode = parseJSON.object(forKey: "code") as? NSInteger
                                self.otpMerchantId = parseJSON.object(forKey: "merchant_id") as? NSInteger
                                let alert = UIAlertController(title: "OTP Code", message: self.otpMessage, preferredStyle: UIAlertController.Style.alert)
                                
                                alert.addTextField(configurationHandler: { (textField) in
                                    //self.otpTextField = textField
                                    textField.placeholder = "Enter OTP Here"
                                    textField.keyboardType = .numberPad
                                    if #available(iOS 12.0, *) {
                                        textField.textContentType = .oneTimeCode
                                    } else {
                                        // Fallback on earlier versions
                                    }
                                })
                                
                                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler:{ (ACTION :UIAlertAction!)in
                                    self.dismiss(animated: true, completion: nil)
                                    
                                }))
                                alert.addAction(UIAlertAction(title: "Proceed", style: UIAlertAction.Style.default, handler:{ (ACTION :UIAlertAction!)in
                                    if let textField = alert.textFields?.first{
                                        self.otpCode = Int(textField.text!)
                                    }
                                    //print(self.otpCode)
                                    self.verifyOtp()
                                }))
                                
                                self.view.hideToastActivity()
                                self.present(alert, animated: true, completion: nil)
                            }
                            
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
    
    @IBAction func btnAddToCartPressed(_ sender: UIButton) {
        let reachability = Reachability()!
        
        if reachability.isReachable {
            self.view.hideToastActivity()
            //self.view.makeToastActivity(.center)
            DispatchQueue.main.async {
                if (UserDefaults.standard.object(forKey: "UserID") == nil){
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
                    //self.view.hideToastActivity()
                    return
                }else{
                    //self.addcartApi()
                    
                    let alert = UIAlertController(title: "Payment", message: "Please enter amount to pay", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addTextField(configurationHandler: { (textField) in
                        //self.otpTextField = textField
                        textField.placeholder = "Enter amount Here"
                        textField.keyboardType = .decimalPad
                        
                    })
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler:{ (ACTION :UIAlertAction!)in
                        self.dismiss(animated: true, completion: nil)
                        
                    }))
                    alert.addAction(UIAlertAction(title: "Proceed", style: UIAlertAction.Style.default, handler:{ (ACTION :UIAlertAction!)in
                        if let textField = alert.textFields?.first{
                            self.otpAmount = Int(textField.text!)
                        }
                        self.payNowPressed()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else {
            self.showNetworkErrorAlert()
        }
    }
    
    func addcartApi() {
        
        let myUrl = URL(string: String(format:"%@api/add_to_cart", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            postString = "user_id=\(tempUserID)!)&product_id=\(product_id!)&product_size_id=\(product_size_id!)&product_color_id=\(product_color_id!)&quantity=\("1")&lang=en"
        }else{
            postString = "product_id=\(product_id!)&product_size_id=\(product_size_id!)&product_color_id=\(product_color_id!)&quantity=\("1")&lang=en"
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
                            
                            //UserDefaults.standard.set(parseJSON.object(forKey: "cart_count") as! NSInteger, forKey: "CartCount")
                            UserDefaults.standard.synchronize()
                            
                            let cartButton   = MIBadgeButton()
                            cartButton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
                            cartButton.setImage(UIImage(named: "cart-icon"), for: UIControl.State())
                            cartButton.addTarget(self, action: #selector(self.cartAction(_:)), for: UIControl.Event.touchUpInside)
                         //   cartButton.badgeString = String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
                            cartButton.badgeTextColor = UIColor.white
                            
                            let rightButton = UIBarButtonItem(customView: cartButton)
                            //self.navigationItem.rightBarButtonItem = rightButton
                            
                            var style = ToastStyle()
                            style.messageFont = messageFont!
                            style.messageColor = UIColor.white
                            style.messageAlignment = .center
                            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                            
                            self.view.makeToast(parseJSON.object(forKey: "message") as! String, duration: 3.0, position: .center, style: style)
                            self.mycartApi()
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
    
    func AddtoWishlish(){
        let myUrl = URL(string: String(format:"%@api/add_to_wishlist", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        // let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(product_id!)&lang=en"
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(product_id!)&lang=en"//\(product_id!)
        }else{
            postString = "product_id=\(product_id!)&lang=en"//\(product_id!)
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
                            
                            //UserDefaults.standard.set(parseJSON.object(forKey: "cart_count") as! NSInteger, forKey: "CartCount")
                            UserDefaults.standard.synchronize()
                            
                            //                            let cartButton   = MIBadgeButton()
                            //                            cartButton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
                            //                            cartButton.setImage(UIImage(named: "cart-icon"), for: UIControlState())
                            //                            cartButton.addTarget(self, action: #selector(ProductDetailsViewController.cartAction(_:)), for: UIControlEvents.touchUpInside)
                            //                            cartButton.badgeString = String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
                            //                            cartButton.badgeTextColor = UIColor.white
                            //
                            //                            let rightButton = UIBarButtonItem(customView: cartButton)
                            //                            self.navigationItem.rightBarButtonItem = rightButton
                            //
                            var style = ToastStyle()
                            style.messageFont = messageFont!
                            style.messageColor = UIColor.white
                            style.messageAlignment = .center
                            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                            
                            self.view.makeToast(parseJSON.object(forKey: "message") as! String, duration: 3.0, position: .center, style: style)
                            self.btnWishList.setTitle("Wishlisted", for: UIControl.State.normal)
                            //self.buynowButton.isUserInteractionEnabled = false
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
    
    @IBAction func btnAddToWishlistPressed(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "UserID") == nil){
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
        }else{
            AddtoWishlish()
        }
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 9{
//            return 400
//        }
//        return 200
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0://image
            let tableCell = tableView.dequeueReusableCell(withIdentifier: "FDetailsImageTableViewCell", for: indexPath) as! FDetailsImageTableViewCell
            if self.productimagesArray.count == 0 {
                tableCell.proImageView.image = UIImage(named: "no-image-icon")
            }
            else {
                tableCell.proImageView.kf.setImage(with: StringToURL(text: self.productimagesArray[0].images))
                tableCell.proImageView.yy_imageURL = URL(string: self.productimagesArray[0].images)
            }
            tableCell.selectionStyle = .none
            return tableCell
        case 1://name and price
            let tableCell = tableView.dequeueReusableCell(withIdentifier: "FDetailsProductNamePriceTableViewCell", for: indexPath) as! FDetailsProductNamePriceTableViewCell
            if self.productType != "all_item"  {
                tableCell.proNameLabel.text = self.producttitleText
                tableCell.proNameLabel.numberOfLines = 4
                tableCell.proLeftLabel.text = self.productdiscountpriceText
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.productpriceText)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                tableCell.proMiddleLable.attributedText = attributeString
                tableCell.proRightLabel.text = self.productpercentageText
            }else{
                tableCell.proMiddleLable.text = String(self.productOff) + "% Off"
                tableCell.proMiddleLable.textColor = UIColor.black
            }
            
            tableCell.selectionStyle = .none
            return tableCell
        case 2://description
            let tableCell = tableView.dequeueReusableCell(withIdentifier: "FDetailsProductDescriptionTableViewCell", for: indexPath) as! FDetailsProductDescriptionTableViewCell
            tableCell.proHeaderLabel.text = "Description"
            tableCell.proDescriptionDetailsTextView.attributedText = descriptionText.htmlToAttributedString
            tableCell.selectionStyle = .none
            return tableCell
        case 3://what is included
            let tableCell = tableView.dequeueReusableCell(withIdentifier: "FDetailsProductDescriptionTableViewCell", for: indexPath) as! FDetailsProductDescriptionTableViewCell
            tableCell.proHeaderLabel.text = "What is included in the deal?"
            tableCell.proDescriptionDetailsTextView.attributedText = dealIncludeText.htmlToAttributedString
            tableCell.selectionStyle = .none
            return tableCell
        case 4://fineprint
            let tableCell = tableView.dequeueReusableCell(withIdentifier: "FDetailsProductDescriptionTableViewCell", for: indexPath) as! FDetailsProductDescriptionTableViewCell
            tableCell.proHeaderLabel.text = "Fine print (Conditions)"
            tableCell.proDescriptionDetailsTextView.attributedText = conditionsText.htmlToAttributedString
            tableCell.selectionStyle = .none
            return tableCell
        case 5://redemption instruction
            let tableCell = tableView.dequeueReusableCell(withIdentifier: "FDetailsProductDescriptionTableViewCell", for: indexPath) as! FDetailsProductDescriptionTableViewCell
            tableCell.proHeaderLabel.text = "Redemption Instruction"
            tableCell.proDescriptionDetailsTextView.attributedText = redemptionText.htmlToAttributedString
            tableCell.selectionStyle = .none
            return tableCell
        case 6://direction
            let tableCell = tableView.dequeueReusableCell(withIdentifier: "singleTitleCell", for: indexPath)
            tableCell.textLabel?.text = "Direction to the Merchant Store"
            tableCell.imageView?.image = UIImage(named: "location-icon")
            tableCell.selectionStyle = .none
            return tableCell
        case 7://redeem offer time
            let tableCell = tableView.dequeueReusableCell(withIdentifier: "simpleCell", for: indexPath)
            tableCell.textLabel?.numberOfLines = 2
            tableCell.textLabel?.text = redeemOfferText
            tableCell.imageView?.image = UIImage(named: "redeem")
            tableCell.selectionStyle = .none
            return tableCell
        case 8://store details
            let tableCell = tableView.dequeueReusableCell(withIdentifier: "ProStoreDetailsCell", for: indexPath)
            tableCell.textLabel?.text = self.storeNameText
            tableCell.detailTextLabel?.text = self.storeAddressText
            
            tableCell.imageView?.image = self.storeImage
            tableCell.selectionStyle = .none
            return tableCell
        case 9://related
            let tableCell = tableView.dequeueReusableCell(withIdentifier: "FDetailsRelatedArrayTableViewCell", for: indexPath) as! FDetailsRelatedArrayTableViewCell
            tableCell.product_id = self.product_id
            tableCell.relatedCollectionCellDelegate = self
            tableCell.selectionStyle = .none
            return tableCell
        default:
            return UITableViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, selectedSection: Int) {
        let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "FProductDetailsTableViewController") as! FProductDetailsTableViewController
        objProductDetails.category_name = "Latest Product"
        objProductDetails.product_id = relatedArray[indexPath.row].product_id
        self.navigationController?.pushViewController(objProductDetails, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0://image
            
            return
        case 1://name and price
            
            return
        case 2://description
            
            return
        case 3://what is included
            
            return
        case 4://fineprint
            
            return
        case 5://redemption instruction
            
            return
        case 6://direction
            let storeLat = UserDefaults.standard.value(forKey: "latitude") as! Double
            let storeLong = UserDefaults.standard.value(forKey: "longitude") as! Double
            if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(storeLat),\(storeLong)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }
            return
        case 7://redeem offer time
            
            return
        case 8://store details
            let objStoreDetails = self.storyboard?.instantiateViewController(withIdentifier: "StoreDetailsViewController") as! StoreDetailsViewController
            objStoreDetails.shop_id = UserDefaults.standard.value(forKey:"merchant_id") as? String
            self.navigationController?.pushViewController(objStoreDetails, animated: true)
            
            return
        case 9://related
            
            return
        default:
            return
        }
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
                                cartButton.addTarget(self, action: #selector(self.cartAction(_:)), for: UIControl.Event.touchUpInside)
                                
                                cartButton.badgeString = "\(cartValue)"
                                cartButton.badgeTextColor = UIColor.white
                                let rightButton = UIBarButtonItem(customView: cartButton)
                                //self.navigationItem.rightBarButtonItems = [rightButton]
                                
                                
                                
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
    
    func productDetailsApi() {
        
        let myUrl = URL(string: String(format:"%@api/product_detail_page", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(product_id!)&lang=en"//\(product_id!)
        }else{
            postString = "product_id=\(product_id!)&lang=en"//\(product_id!)
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
                    print("Here\(json!)")
                    
                    //self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON.value(forKeyPath: "product_details.product_image") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.productimagesArray.append(ProductImages(ProductImages: item))
                                    }
                                    if self.productimagesArray[0].images == "" {
                                        self.productImage?.image = UIImage(named: "no-image-icon")
                                    }
                                    else {
                                        self.productImage?.kf.setImage(with: StringToURL(text: self.productimagesArray[0].images))
                                        self.productImage?.yy_imageURL = URL(string: self.productimagesArray[0].images)
                                    }
                                    //self.productTableView.reloadData()
                                    
                                }
                            }
                            
                            self.producttitleText = parseJSON.value(forKeyPath: "product_details.product_title") as! String
                            self.productType = parseJSON.value(forKeyPath: "product_details.product_type") as! String
                            if self.productType == "all_item"{
                                self.productOff = parseJSON.value(forKeyPath: "product_details.product_discount") as! NSInteger
                            }
                            self.currencySymbol = (parseJSON.value(forKeyPath: "product_details.currency_symbol") as? String)!
                            self.productdiscountpriceText = String(format:"%@%d", (parseJSON.value(forKeyPath: "product_details.currency_symbol") as? String)!, (parseJSON.value(forKeyPath: "product_details.product_discount_price") as? NSInteger)!)
                            self.tax = String((parseJSON.value(forKeyPath: "product_details.product_including_tax") as? NSInteger)!)
                            self.productpriceText = String(format:"%@%d", (parseJSON.value(forKeyPath: "product_details.currency_symbol") as? String)!, (parseJSON.value(forKeyPath: "product_details.product_original_price") as? NSInteger)!)
//                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.productpriceLabel!.text!)
//                            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//                            self.productpriceLabel?.attributedText = attributeString
                            self.Amount = String((parseJSON.value(forKeyPath: "product_details.product_discount_price") as? NSInteger)!)
                            self.productpercentageText = String(format:"%d%% off", (parseJSON.value(forKeyPath: "product_details.product_discount_percentage") as? NSInteger)!)
                            //self.productpercentageLabel?.layer.borderWidth = 0.5
                           // self.productpercentageLabel?.layer.borderColor = UIColor(red: 220.0/255.0, green:220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
                            
                            self.product_ship_amt = String(format: "%@%d", (parseJSON.value(forKeyPath: "product_details.currency_symbol") as? String)!, (parseJSON.value(forKeyPath: "product_details.product_ship_amt") as? NSInteger)!)
                           // self.productTableView.reloadData()
                            if parseJSON.value(forKeyPath: "product_details.product_status") as? String == "sold" {
                                
                                self.addcartButton?.isHidden = true
                                self.buynowButton?.isHidden = true
                                //self.soldoutLabel.isHidden = false
                            }
                            else {
                                
                                self.addcartButton?.isHidden = false
                                self.buynowButton?.isHidden = false
                                //self.soldoutLabel.isHidden = true
                            }
                            
                            if let reposArray = parseJSON.value(forKeyPath: "product_details.product_color_details") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.colorsArray.append(Colors(Colors: item))
                                    }
                                    
                                    self.colorsArray[0].color_status = "1"
                                    //self.colorTable.reloadData()
                                    
                                    self.product_color_id = self.colorsArray[0].product_color_id
                                }
                            }
                            
                            if let reposArray = parseJSON.value(forKeyPath: "product_details.product_size_details") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.sizeArray.append(Sizes(Sizes: item))
                                    }
                                    self.sizeArray[0].size_status = "1"
                                    //self.sizeTable.reloadData()
                                    
                                    self.product_size_id = self.sizeArray[0].product_size_id
                                }
                            }
                            
                            
                            var Yvalue:CGFloat = 650
                            
                            if let reposArray = parseJSON.value(forKeyPath: "product_details.product_specification_details") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    for item in reposArray {
                                        self.spec_string += "\(item["spec_name"]!)\n"
                                    }
                                    self.specificationLabel?.numberOfLines = 3
                                    self.specificationLabel?.text = self.spec_string
                                    let expectedLabelSize: CGSize = (self.specificationLabel?.text!.boundingRect(with: CGSize(width:UIScreen.main.bounds.size.width - 20, height:9999), options: ([.usesLineFragmentOrigin, .usesFontLeading]), attributes: [
                                        NSAttributedString.Key.font : self.specificationLabel?.font], context: nil).size)!
                                    self.specificationLabel?.frame = CGRect(x: CGFloat(10), y: CGFloat(10), width: CGFloat((self.specificationLabel?.frame.size.width)!), height: CGFloat(expectedLabelSize.height))
                                    
                                    self.specificationView?.frame = CGRect(x: CGFloat(0), y: CGFloat(Yvalue), width: CGFloat((self.specificationView?.frame.size.width)!), height: CGFloat(expectedLabelSize.height + 10))
                                    
                                    Yvalue = Yvalue + expectedLabelSize.height + 10
                                    Yvalue = Yvalue + 10
                                }
                            }
                            
                            self.descriptionText = parseJSON.value(forKeyPath: "product_details.product_description") as! String
                            self.dealIncludeText = parseJSON.value(forKeyPath: "product_details.deal_include") as! String
                            self.conditionsText = parseJSON.value(forKeyPath: "product_details.conditions") as! String
                            self.redemptionText = parseJSON.value(forKeyPath: "product_details.redemption") as! String
                            
                            
                            let store_latitude  = parseJSON.value(forKeyPath: "product_details.store_details.store_latitude") as? Double
                            let userDefaultStore = UserDefaults.standard //userDefault object
                            userDefaultStore.set(store_latitude, forKey: "latitude")
                            print( "lat -- \(self.directionLabel?.text )")
                            let store_longitude  = parseJSON.value(forKeyPath: "product_details.store_details.store_longitude") as? Double
                            userDefaultStore.set(store_longitude, forKey: "longitude")
                            print(store_longitude)
                            
                            
                            let name = parseJSON.value(forKeyPath: "product_details.day") as? Int
                            let date = Calendar.current.date(byAdding: .day, value: name!, to: Date())
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy' at 'h:mm a."
                            let todaysDate = dateFormatter.string(from: date!)
                            self.redeemOfferText = "Redeem offer from today  untill \(todaysDate)"
                            
                            
                            self.storeNameText = parseJSON.value(forKeyPath: "product_details.store_details.merchant_name") as! String
                            
                            self.storeAddressText = parseJSON.value(forKeyPath: "product_details.store_details.store_name") as! String
                            
                            let storeId = parseJSON.value(forKeyPath: "product_details.store_details.merchant_id") as? Int
                            UserDefaults.standard.set("\(storeId!)", forKey: "merchant_id")
                            print("here is the sore id \(storeId!)")
                            
                            
                            
                            
                            if (parseJSON.value(forKeyPath: "product_details.store_details.merchant_img") as? String) != nil {
                                let url = (parseJSON.value(forKeyPath: "product_details.store_details.merchant_img") as? String)
                                //                              print("Crashing url  --\(url)")
                                
                                if let url = URL(string: url!) {
                                    do {
                                        let data = try Data(contentsOf: url)
                                        self.storeImage = UIImage(data:data)
                                    } catch let err {
                                        print("Error  : \(err.localizedDescription)")
                                    }
                                }
                            }
                            
                            if let reposArray = parseJSON.value(forKeyPath: "product_details.related_products") as? [NSDictionary] {
                                if reposArray.count != 0 {
                                    for item in reposArray {
                                        self.relatedArray.append(RelatedProducts(RelatedProducts: item))
                                    }
                                }else{
                                    print("related_products is 0")
                                }
                            }else{
                                print("related_products not found")
                            }
                            
                            self.productTableView.reloadData()
                            
                            
                            
                            //end
                            
                            //MARK: For whishlist button
                            self.storeName?.numberOfLines = 2
                            /*seraje
                            let showWishlist = parseJSON.value(forKeyPath: "product_details.showWishlist") as? Bool
                            print("here is--- \(showWishlist!)")
                            
                            //buynowButton
                            if showWishlist == false {
                                //  buynowButton.titleLabel = "join"
                                self.buynowButton?.setTitle("Add To Wishlist", for: UIControl.State.normal)
                            } else {
                                self.buynowButton?.setTitle("Wishlisted", for: UIControl.State.normal)
                                self.buynowButton?.isUserInteractionEnabled = false
                            }
                            */
                            //END
                            
                            //MARK: Show review button
                            //storeImage
                            //self.storeImage.numberOfLines = 0
                            /*seraje
                            let showReviewForm = parseJSON.value(forKeyPath: "product_details.showReviewForm") as? Bool
                            print("here is--- \(showReviewForm!)")
                            
                            //buynowButton
                            if showWishlist == false {
                                //  buynowButton.titleLabel = "join"
                                self.reviewButton?.isHidden = true
                                self.reviewButton?.isUserInteractionEnabled = true
                            } else {
                                self.reviewButton?.isHidden = false
                                self.reviewButton?.isUserInteractionEnabled = false
                            }
                            */
                            //END
                            
                            //self.deliveryView.frame = CGRect(x: CGFloat(0), y: CGFloat(Yvalue), width: CGFloat(self.deliveryView.frame.size.width), height: CGFloat(self.deliveryView.frame.size.height))
                            //  let product_details = parseJSON.value(forKey: "product_details") as! NSDictionary
                            // let delivery = String(product_details.value(forKey: "product_delivery") as! Int)
                            // self.deliveryLabel.text = String(format:"Product will deliver in %@ Days", delivery)
                            
//                            Yvalue = Yvalue + 50
//
//                            self.reviewView.frame = CGRect(x: CGFloat(0), y: CGFloat(Yvalue), width: CGFloat(self.reviewView.frame.size.width), height: CGFloat(self.reviewView.frame.size.height))
//
//                            Yvalue = Yvalue + 30
//
//                            self.headerView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.headerView.frame.size.width), height: CGFloat(Yvalue))
//
//                            self.reviewTable.tableHeaderView = self.headerView
                            /*seraje
                            if let reposArray = parseJSON.value(forKeyPath: "product_details.product_review") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.reviewArray.append(Review(Review: item))
                                    }
                                }
                                //self.canShowColorView()
                                //self.reviewTable.reloadData()
                            }
                            
                            if let reposArray = parseJSON.value(forKeyPath: "product_details.related_products") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    if reposArray.count == 1 || reposArray.count == 2 {
                                    }
                                    else {
                                    
                                    }
                                    
                                    for item in reposArray {
                                        self.relatedArray.append(RelatedProducts(RelatedProducts: item))
                                    }
                                    //self.relatedCollectionView.reloadData()
                                    
                                }
                                else {
                                    
//                                    self.footerView.isHidden = true
//                                    self.footerView.frame = CGRect(x: CGFloat(self.footerView.frame.origin.x), y: CGFloat(self.footerView.frame.origin.y), width: CGFloat(self.footerView.frame.size.width), height: CGFloat(0))
//                                    self.reviewTable.tableFooterView = self.footerView
                                }
 
                            }*/
                        }
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
}
extension String{
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
