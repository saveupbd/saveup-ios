//
//  ProductDetailsViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 09/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit
//import Alamofire
//import SwiftyJSON

class ProductDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReviewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
        
    
    @IBOutlet weak var relatedCollectionView: UICollectionView!
    
    
    @IBOutlet weak var imagesTable : UITableView?
    @IBOutlet weak var productImage : UIImageView!
    @IBOutlet weak var producttitleLabel : UILabel!
    @IBOutlet weak var productpriceLabel : UILabel!
    @IBOutlet weak var productdiscountpriceLabel : UILabel!
    @IBOutlet weak var productpercentageLabel : UILabel!
    @IBOutlet weak var footerImage : UIImageView!
    //@IBOutlet weak var relatedTable : UITableView!
    @IBOutlet weak var addcartButton : UIButton!
    @IBOutlet weak var buynowButton : UIButton!
    @IBOutlet weak var colorView : UIView!
    @IBOutlet weak var colorTable : UITableView!
    @IBOutlet weak var sizeTable : UITableView!
    @IBOutlet weak var descriptionView : UIView!
    @IBOutlet weak var descriptionLabel : UILabel!
    
    @IBOutlet weak var dealIncludeLabel: UILabel!
    @IBOutlet weak var reviewView : UIView!
    @IBOutlet weak var headerView : UIView!
    @IBOutlet weak var reviewTable : UITableView!
    @IBOutlet weak var footerView : UIView!
    @IBOutlet weak var specificationView : UIView!
    @IBOutlet weak var specificationLabel : UILabel!
    @IBOutlet weak var deliveryView : UIView!
    
    @IBOutlet weak var conditionView: UIView!
    @IBOutlet weak var conditionsLabel: UILabel!
    
    @IBOutlet weak var redemptionView: UIView!
    @IBOutlet weak var redemptionLabel: UILabel!
    
    @IBOutlet weak var directionView: UIView!
    @IBOutlet weak var directionLabel: UILabel!
    
    @IBOutlet weak var redeemOfferView: UIView!
    //@IBOutlet weak var redeemOfferLabel: UILabel!
    @IBOutlet weak var redeemOfferLabel: UILabel!
    
    @IBOutlet weak var storeDetailsView: UIView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var storeImage: UIImageView!
    
    @IBOutlet weak var deliveryLabel : UILabel!
    @IBOutlet weak var reviewButton : UIButton!
    @IBOutlet weak var soldoutLabel : UILabel!
    
    @IBOutlet weak var selectSize: UILabel!
    @IBOutlet weak var selectColorLabel: UILabel!
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.COLORVIEW_Y_AXIS = self.colorView.frame.minY
        self.canShowColorView()
        //createFloatingButton()
        //setupButton()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard floatingButton?.superview != nil else {  return }
        DispatchQueue.main.async {
            self.floatingButton?.removeFromSuperview()
            self.floatingButton = nil
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.relatedCollectionView.delegate = self
        self.relatedCollectionView.dataSource = self
        self.relatedCollectionView.isScrollEnabled = false
        mycartApi()
        let productId = self.product_id
        print("Here is my product id ---  \(productId)")
        UserDefaults.standard.set("productId", forKey: "productId")
        
        //set border color
        deliveryView.layer.borderColor = UIColor.lightGray.cgColor
        deliveryView.layer.borderWidth = 0.2
        
        conditionView.layer.borderColor = UIColor.lightGray.cgColor
        conditionView.layer.borderWidth = 0.2
        
        redemptionView.layer.borderColor = UIColor.lightGray.cgColor
        redemptionView.layer.borderWidth = 0.2
        
        directionView.layer.borderColor = UIColor.lightGray.cgColor
        directionView.layer.borderWidth = 0.2
        
        redeemOfferView.layer.borderColor = UIColor.lightGray.cgColor
        redeemOfferView.layer.borderWidth = 0.2
        
        storeDetailsView.layer.borderColor = UIColor.lightGray.cgColor
        storeDetailsView.layer.borderWidth = 0.2
        
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = category_name
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(ProductDetailsViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        //self.navigationItem.leftBarButtonItem = LeftButton
        
        //relatedTable.layer.cornerRadius = 5
        
        let rotateTable = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi / 2))
        colorTable.transform = rotateTable
        colorTable.frame = CGRect(x: CGFloat(0), y: CGFloat(30), width: CGFloat(colorTable.frame.size.height), height: CGFloat(colorTable.frame.size.width))
        
        sizeTable.transform = rotateTable
        sizeTable.frame = CGRect(x: CGFloat(0), y: CGFloat(120), width: CGFloat(sizeTable.frame.size.height), height: CGFloat(sizeTable.frame.size.width))
        
        colorView.addSubview(colorTable)
        colorView.addSubview(sizeTable)
        
        addcartButton.isHidden = true
        buynowButton.isHidden = true
        soldoutLabel.isHidden = true
        self.COLORVIEW_Y_AXIS = self.colorView.frame.minY
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
    
    @IBAction func onTapMerchantDirection(_ sender: Any) {
        let storeLat = UserDefaults.standard.value(forKey: "latitude") as! String
        let storeLong = UserDefaults.standard.value(forKey: "longitude") as! String
        
        
        
        if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(storeLat),\(storeLong)&directionsmode=driving") {
            UIApplication.shared.open(url, options: [:])
        }
        
        
//        let dbLat = Double(storeLat)
//        let dbLong = Double(storeLong)
        
//        let coordinate = CLLocationCoordinate2DMake(dbLat!,dbLong!)
//        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
//        mapItem.name = "Target location"
//        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
//        let vc = storyboard?.instantiateViewController(withIdentifier: "MerchantLocationVC") as! MerchantLocationVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onTapStoreDetails(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "StoreDetailsViewController") as! StoreDetailsViewController
        vc.shop_id = String(Int(10))
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "MainToTimer") {
//            let vc = segue.destination as! StoreDetailsViewController
//            //vc.shop_id = ("\(storeId!)")
////            var myid = self.storeId
////            let id = UserDefaults.standard.object(forKey: "merchant_id")
////            print("i am id under userdefault")
////            print(id!)
//            vc.shop_id = "\(UserDefaults.standard.object(forKey: "merchant_id")!)"
//
//          //  self.navigationController?.pushViewController(vc, animated: true)
//
//        }
//    }
    
    
    @IBAction func onTapStore(_ sender: Any) {
        print("I am tapped")
        let vc = storyboard?.instantiateViewController(withIdentifier: "StoreDetailsViewController") as! StoreDetailsViewController
         //   UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "locationProfile") as! LocationTableViewController
         vc.shop_id = "\(UserDefaults.standard.object(forKey: "merchant_id")!)"
//        let navigationController = UINavigationController(rootViewController: locationTableVC)
        //self.present(vc, animated: true, completion: nil)
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mycartApi()
        let cartButton   = MIBadgeButton()
        cartButton.frame = CGRect(x: 0, y: 30, width: 30, height: 44)
        cartButton.setImage(UIImage(named: "cart-icon"), for: UIControl.State())
        cartButton.addTarget(self, action: #selector(ProductDetailsViewController.cartAction(_:)), for: UIControl.Event.touchUpInside)
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
        self.COLORVIEW_Y_AXIS = self.colorView.frame.minY
        let rightButton = UIBarButtonItem(customView: cartButton)
        self.navigationItem.rightBarButtonItem = rightButton
        
        // UserDefaults.standard.removeObject(forKey: "CartCount")
        
    }
    
    //for cart count
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

                                cartButton.badgeString = "\(cartValue)"
                                cartButton.badgeTextColor = UIColor.white
                                let rightButton = UIBarButtonItem(customView: cartButton)
                                self.navigationItem.rightBarButtonItems = [rightButton]
                                
                                
                                
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
        
        let objMyCart = self.storyboard?.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        objMyCart.screen_value = ""
        self.navigationController?.pushViewController(objMyCart, animated: true)
    }
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.black
        style.messageAlignment = .center
        style.backgroundColor = UIColor.white
        
        self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    
    func productDetailsApi() {
        
        let myUrl = URL(string: String(format:"%@api/product_detail_page", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(product_id!)&lang=en"//\(product_id!)
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
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON.value(forKeyPath: "product_details.product_image") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.productimagesArray.append(ProductImages(ProductImages: item))
                                    }
                                    if self.productimagesArray[0].images == "" {
                                        self.productImage.image = UIImage(named: "no-image-icon")
                                    }
                                    else {
                                        self.productImage.kf.setImage(with: StringToURL(text: self.productimagesArray[0].images))
                                         self.productImage.yy_imageURL = URL(string: self.productimagesArray[0].images)
                                    }
                                    
                                    self.imagesTable?.reloadData()
                                }
                            }
                            
                            self.producttitleLabel.text = parseJSON.value(forKeyPath: "product_details.product_title") as? String
                            self.currencySymbol = (parseJSON.value(forKeyPath: "product_details.currency_symbol") as? String)!
                            self.productdiscountpriceLabel.text = String(format:"%@%d", (parseJSON.value(forKeyPath: "product_details.currency_symbol") as? String)!, (parseJSON.value(forKeyPath: "product_details.product_discount_price") as? NSInteger)!)
                            self.tax = String((parseJSON.value(forKeyPath: "product_details.product_including_tax") as? NSInteger)!)
                            self.productpriceLabel.text = String(format:"%@%d", (parseJSON.value(forKeyPath: "product_details.currency_symbol") as? String)!, (parseJSON.value(forKeyPath: "product_details.product_original_price") as? NSInteger)!)
                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.productpriceLabel.text!)
                            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                            self.productpriceLabel.attributedText = attributeString
                            self.Amount = String((parseJSON.value(forKeyPath: "product_details.product_discount_price") as? NSInteger)!)
                            self.productpercentageLabel.text = String(format:"%d%% OFF", (parseJSON.value(forKeyPath: "product_details.product_discount_percentage") as? NSInteger)!)
                            self.productpercentageLabel.layer.borderWidth = 0.5
                            self.productpercentageLabel.layer.borderColor = UIColor(red: 220.0/255.0, green:220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
                            
                            self.product_ship_amt = String(format: "%@%d", (parseJSON.value(forKeyPath: "product_details.currency_symbol") as? String)!, (parseJSON.value(forKeyPath: "product_details.product_ship_amt") as? NSInteger)!)
                            
                            if parseJSON.value(forKeyPath: "product_details.product_status") as? String == "sold" {
                                
                                self.addcartButton.isHidden = true
                                self.buynowButton.isHidden = true
                                self.soldoutLabel.isHidden = false
                            }
                            else {
                                
                                self.addcartButton.isHidden = false
                                self.buynowButton.isHidden = false
                                self.soldoutLabel.isHidden = true
                            }
                            
                            if let reposArray = parseJSON.value(forKeyPath: "product_details.product_color_details") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.colorsArray.append(Colors(Colors: item))
                                    }
                                    
                                    self.colorsArray[0].color_status = "1"
                                    self.colorTable.reloadData()
                                    
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
                                    self.sizeTable.reloadData()
                                    
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
                                    self.specificationLabel.numberOfLines = 3
                                    self.specificationLabel.text = self.spec_string
                                    let expectedLabelSize: CGSize = self.specificationLabel.text!.boundingRect(with: CGSize(width:UIScreen.main.bounds.size.width - 20, height:9999), options: ([.usesLineFragmentOrigin, .usesFontLeading]), attributes: [
                                        NSAttributedString.Key.font : self.specificationLabel.font], context: nil).size
                                    self.specificationLabel.frame = CGRect(x: CGFloat(10), y: CGFloat(10), width: CGFloat(self.specificationLabel.frame.size.width), height: CGFloat(expectedLabelSize.height))
                                    
                                    self.specificationView.frame = CGRect(x: CGFloat(0), y: CGFloat(Yvalue), width: CGFloat(self.specificationView.frame.size.width), height: CGFloat(expectedLabelSize.height + 10))
                                    
                                    Yvalue = Yvalue + expectedLabelSize.height + 10
                                    Yvalue = Yvalue + 10
                                }
                            }
                            
                            self.descriptionLabel.numberOfLines = 10
                            var tempDescription = parseJSON.value(forKeyPath: "product_details.product_description") as? String
                            //self.descriptionLabel.text = parseJSON.value(forKeyPath: "product_details.product_description") as? String
                            //DispatchQueue.main.async {
                            self.descriptionLabel.attributedText = tempDescription?.convertHtml()
                            //}
                            
                            
                            let expectedLabelSize: CGSize = self.descriptionLabel.text!.boundingRect(with: CGSize(width:UIScreen.main.bounds.size.width - 20, height:9999), options: ([.usesLineFragmentOrigin, .usesFontLeading]), attributes: [
                                NSAttributedString.Key.font : self.descriptionLabel.font!], context: nil).size
                            self.descriptionLabel.frame = CGRect(x: CGFloat(10), y: CGFloat(30), width: CGFloat(self.descriptionLabel.frame.size.width), height: CGFloat(expectedLabelSize.height + 40))
                            
                            self.descriptionView.frame = CGRect(x: CGFloat(0), y: CGFloat(Yvalue), width: CGFloat(self.descriptionView.frame.size.width), height: CGFloat(expectedLabelSize.height + 40))
                            
                            Yvalue = Yvalue + expectedLabelSize.height + 40
                            
                            Yvalue = Yvalue + 10
                            
                            //MARK:for deal include
                            
                            self.dealIncludeLabel.numberOfLines = 10
                            self.dealIncludeLabel.text = parseJSON.value(forKeyPath: "product_details.deal_include") as? String
                            
                            self.dealIncludeLabel.attributedText = self.dealIncludeLabel.text!.convertHtml()
                            
                            let expectedLabelSizeForDealInclude: CGSize = self.dealIncludeLabel.text!.boundingRect(with: CGSize(width:UIScreen.main.bounds.size.width - 20, height:9999), options: ([.usesLineFragmentOrigin, .usesFontLeading]), attributes: [
                                NSAttributedString.Key.font : self.dealIncludeLabel.font], context: nil).size
                            self.dealIncludeLabel.frame = CGRect(x: CGFloat(10), y: CGFloat(30), width: CGFloat(self.dealIncludeLabel.frame.size.width), height: CGFloat(expectedLabelSizeForDealInclude.height + 40))
                            
                            self.deliveryView.frame = CGRect(x: CGFloat(0), y: CGFloat(Yvalue), width: CGFloat(self.deliveryView.frame.size.width), height: CGFloat(expectedLabelSizeForDealInclude.height + 40))
                            
                            Yvalue = Yvalue + expectedLabelSizeForDealInclude.height + 40
                            
                            Yvalue = Yvalue + 10
                            //MARK:end
                            
                            
                            //MARK:for Condition
                            self.conditionsLabel.numberOfLines = 3
                            self.conditionsLabel.text = parseJSON.value(forKeyPath: "product_details.conditions") as? String
                            
                            self.conditionsLabel.attributedText = self.conditionsLabel.text!.convertHtml()
                            
                            let expectedLabelSizeForConditions: CGSize = self.conditionsLabel.text!.boundingRect(with: CGSize(width:UIScreen.main.bounds.size.width - 20, height:10999), options: ([.usesLineFragmentOrigin, .usesFontLeading]), attributes: [
                                NSAttributedString.Key.font : self.conditionsLabel.font!], context: nil).size
                            self.conditionsLabel.frame = CGRect(x: CGFloat(10), y: CGFloat(30), width: CGFloat(self.conditionsLabel.frame.size.width), height: CGFloat(expectedLabelSizeForConditions.height + 40))
                            
                            self.conditionView.frame = CGRect(x: CGFloat(0), y: CGFloat(Yvalue), width: CGFloat(self.conditionView.frame.size.width), height: CGFloat(expectedLabelSizeForConditions.height + 40))
                            
                            Yvalue = Yvalue + expectedLabelSizeForConditions.height + 40
                            
                            Yvalue = Yvalue + 10
                            
                            
                            //end
                            
                            
                            //MARK:for Redemption
                            
                            self.redemptionLabel.numberOfLines = 10
                            self.redemptionLabel.text = parseJSON.value(forKeyPath: "product_details.redemption") as? String
                            
                            self.redemptionLabel.attributedText = self.redemptionLabel.text!.convertHtml()
                            
                            let expectedLabelSizeForRedemption: CGSize = self.redemptionLabel.text!.boundingRect(with: CGSize(width:UIScreen.main.bounds.size.width - 20, height:9999), options: ([.usesLineFragmentOrigin, .usesFontLeading]), attributes: [
                                NSAttributedString.Key.font : self.redemptionLabel.font], context: nil).size
                            self.redemptionLabel.frame = CGRect(x: CGFloat(10), y: CGFloat(30), width: CGFloat(self.redemptionLabel.frame.size.width), height: CGFloat(expectedLabelSizeForRedemption.height + 40))
                            
                            self.redemptionView.frame = CGRect(x: CGFloat(0), y: CGFloat(Yvalue), width: CGFloat(self.redemptionView.frame.size.width), height: CGFloat(expectedLabelSizeForRedemption.height + 40))
                            
                            Yvalue = Yvalue + expectedLabelSizeForRedemption.height + 40
                            
                            Yvalue = Yvalue + 10
                            //end
                            
                            //direction label for lat long
                            
                            self.directionLabel.numberOfLines = 3
                            //self.directionLabel.text
                            let store_latitude  = parseJSON.value(forKeyPath: "product_details.store_details.store_latitude") as? String
                            let userDefaultStore = UserDefaults.standard //userDefault object
                            userDefaultStore.set(store_latitude, forKey: "latitude")
                            print( "lat -- \(self.directionLabel.text )")
                            let store_longitude  = parseJSON.value(forKeyPath: "product_details.store_details.store_longitude") as? String
                            userDefaultStore.set(store_longitude, forKey: "longitude")
                            print(store_longitude)
                            
                            
                            
                            //end
                            
                            //Redemtion offer date //Do later
                            
                            self.redeemOfferLabel.numberOfLines = 2
                            let name = parseJSON.value(forKeyPath: "product_details.day") as? Int
                            print(name)
                            let date = Calendar.current.date(byAdding: .day, value: name!, to: Date())
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy' at 'h:mm a."
                            let todaysDate = dateFormatter.string(from: date!)
                            self.redeemOfferLabel.text = "Redeem offer from today  untill \(todaysDate)"
                            print("---------------------------\(todaysDate)")
                            
//                            let date = Calendar.current.date(byAdding: .day, value: name!, to: Date())
//
//                            self.redeemOfferLabel.text = "Redeem offer from today  untill \(date!)"
                            
                 
                            
                            
                            //End
                            
                            //MARK: Store name
                            self.storeName.numberOfLines = 2
                            self.storeName.text = parseJSON.value(forKeyPath: "product_details.store_details.merchant_name") as? String
                           // print(self.storeName.text!)
                            
                            self.storeAddress.numberOfLines = 3
                            self.storeAddress.text = parseJSON.value(forKeyPath: "product_details.store_details.store_name") as? String
                            //print(self.storeAddress.text!)
                            
                            //store id
                            let storeId = parseJSON.value(forKeyPath: "product_details.store_details.merchant_id") as? Int
                            UserDefaults.standard.set("\(storeId!)", forKey: "merchant_id")
                            print("here is the sore id \(storeId!)")
                            
                            
                            
                            
                            if (parseJSON.value(forKeyPath: "product_details.store_details.merchant_img") as? String) != nil {
                                let url = (parseJSON.value(forKeyPath: "product_details.store_details.merchant_img") as? String)
  //                              print("Crashing url  --\(url)")
                                
                                if let url = URL(string: url!) {
                                    do {
                                        let data = try Data(contentsOf: url)
                                        self.storeImage.image = UIImage(data:data)
                                    } catch let err {
                                        print("Error  : \(err.localizedDescription)")
                                    }
                                }
                            }

                           
                            
                            //end
                            
                            //MARK: For whishlist button
                            self.storeName.numberOfLines = 2
                            let showWishlist = parseJSON.value(forKeyPath: "product_details.showWishlist") as? Bool
                            print("here is--- \(showWishlist!)")
                            
                            //buynowButton
                            if showWishlist == false {
                                //  buynowButton.titleLabel = "join"
                                self.buynowButton.setTitle("Add To Wishlist", for: UIControl.State.normal)
                            } else {
                                self.buynowButton.setTitle("Wishlisted", for: UIControl.State.normal)
                                self.buynowButton.isUserInteractionEnabled = false
                            }
                            
                            //END
                            
                            //MARK: Show review button
                             //storeImage
                            //self.storeImage.numberOfLines = 0
                            let showReviewForm = parseJSON.value(forKeyPath: "product_details.showReviewForm") as? Bool
                            print("here is--- \(showReviewForm!)")
                            
                            //buynowButton
                            if showWishlist == false {
                                //  buynowButton.titleLabel = "join"
                                self.reviewButton.isHidden = true
                                 self.reviewButton.isUserInteractionEnabled = true
                            } else {
                                self.reviewButton.isHidden = false
                                self.reviewButton.isUserInteractionEnabled = false
                            }
                            
                            //END
                            
                            //self.deliveryView.frame = CGRect(x: CGFloat(0), y: CGFloat(Yvalue), width: CGFloat(self.deliveryView.frame.size.width), height: CGFloat(self.deliveryView.frame.size.height))
                            //  let product_details = parseJSON.value(forKey: "product_details") as! NSDictionary
                            // let delivery = String(product_details.value(forKey: "product_delivery") as! Int)
                            // self.deliveryLabel.text = String(format:"Product will deliver in %@ Days", delivery)
                            
                            Yvalue = Yvalue + 50
                            
                            self.reviewView.frame = CGRect(x: CGFloat(0), y: CGFloat(Yvalue), width: CGFloat(self.reviewView.frame.size.width), height: CGFloat(self.reviewView.frame.size.height))
                            
                            Yvalue = Yvalue + 30
                            
                            self.headerView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.headerView.frame.size.width), height: CGFloat(Yvalue))
                            
                            self.reviewTable.tableHeaderView = self.headerView
                            
                            if let reposArray = parseJSON.value(forKeyPath: "product_details.product_review") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.reviewArray.append(Review(Review: item))
                                    }
                                }
                                self.canShowColorView()
                                self.reviewTable.reloadData()
                            }
                            
                            if let reposArray = parseJSON.value(forKeyPath: "product_details.related_products") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    if reposArray.count == 1 || reposArray.count == 2 {
                                        
                                        self.footerView.frame = CGRect(x: CGFloat(self.footerView.frame.origin.x), y: CGFloat(self.footerView.frame.origin.y), width: CGFloat(self.footerView.frame.size.width), height: CGFloat(290))
                                        self.footerImage.frame = CGRect(x: CGFloat(self.footerImage.frame.origin.x), y: CGFloat(self.footerImage.frame.origin.y), width: CGFloat(self.footerImage.frame.size.width), height: CGFloat(260))
                                        self.relatedCollectionView.frame = CGRect(x: CGFloat(self.relatedCollectionView.frame.origin.x), y: CGFloat(self.relatedCollectionView.frame.origin.y), width: CGFloat(self.relatedCollectionView.frame.size.width), height: CGFloat(209))
                                        self.reviewTable.tableFooterView = self.footerView
                                    }
                                    else {
                                        
                                        self.footerView.frame = CGRect(x: CGFloat(self.footerView.frame.origin.x), y: CGFloat(self.footerView.frame.origin.y), width: CGFloat(self.footerView.frame.size.width), height: CGFloat(500))
                                        self.footerImage.frame = CGRect(x: CGFloat(self.footerImage.frame.origin.x), y: CGFloat(self.footerImage.frame.origin.y), width: CGFloat(self.footerImage.frame.size.width), height: CGFloat(470))
                                        self.relatedCollectionView.frame = CGRect(x: CGFloat(self.relatedCollectionView.frame.origin.x), y: CGFloat(self.relatedCollectionView.frame.origin.y), width: CGFloat(self.relatedCollectionView.frame.size.width), height: CGFloat(420))
                                        self.reviewTable.tableFooterView = self.footerView
                                    }
                                    
                                    for item in reposArray {
                                        self.relatedArray.append(RelatedProducts(RelatedProducts: item))
                                    }
                                    self.relatedCollectionView.reloadData()
                                    
                                }
                                else {
                                    
                                    self.footerView.isHidden = true
                                    self.footerView.frame = CGRect(x: CGFloat(self.footerView.frame.origin.x), y: CGFloat(self.footerView.frame.origin.y), width: CGFloat(self.footerView.frame.size.width), height: CGFloat(0))
                                    self.reviewTable.tableFooterView = self.footerView
                                }
                            }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        /*if tableView == relatedTable {
            
            if indexPath.row == 1 {
                return 209
            }
            else {
                return 210
            }
        }
        else */if tableView == colorTable {
            
            return 50
        }
        else if tableView == sizeTable {
            
            return 50
        }
        else if tableView == reviewTable {
            
            var Yvalue:CGFloat = 80
            
            let lbl1 = UILabel()
            lbl1.numberOfLines = 3
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
        
       /* if tableView == relatedTable {
            
            var devide: Int = relatedArray.count / 2
            if relatedArray.count % 2 > 0 {
                devide += 1
            }
            return devide
        }
        else*/ if tableView == colorTable {
            
            return colorsArray.count
        }
        else if tableView == sizeTable {
            
            return sizeArray.count
        }
        else if tableView == reviewTable {
            
            return reviewArray.count
        }
        else {
            return productimagesArray.count
        }
    }
    // Customize the appearance of table view cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       /* if tableView == relatedTable {
            
            let cellIdentifier = "CustomCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
            
            var xyz = Int(indexPath.row)
            xyz = xyz * 2
            
            if relatedArray[xyz].product_image == "" {
                cell.popularImage1.image = UIImage(named: "no-image-icon")
            }
            else {
                cell.popularImage1.kf.setImage(with:StringToURL(text: relatedArray[xyz].product_image))
                //  cell.popularImage1.yy_imageURL = URL(string: relatedArray[xyz].product_image)
            }
            
            cell.popularTitleLabel1.text = relatedArray[xyz].product_title
            cell.popularPriceLabel1.text = String(format:"%@%@", relatedArray[xyz].currency_symbol, relatedArray[xyz].product_price)
            
            if (xyz + 1) >= relatedArray.count {
                
                cell.popularView2.isHidden = true
            }
            else {
                
                cell.popularView2.isHidden = false
                if relatedArray[xyz+1].product_image == "" {
                    cell.popularImage2.image = UIImage(named: "no-image-icon")
                }
                else {
                    cell.popularImage2.kf.setImage(with:StringToURL(text:  relatedArray[xyz+1].product_image))
                    // cell.popularImage2.yy_imageURL = URL(string: relatedArray[xyz+1].product_image)
                }
                
                cell.popularTitleLabel2.text = relatedArray[xyz+1].product_title
                cell.popularPriceLabel2.text = String(format:"%@%@", relatedArray[xyz+1].currency_symbol, relatedArray[xyz+1].product_price)
            }
            
            cell.tapButton1.tag = xyz
            cell.tapButton1.addTarget(self, action: #selector(relatedTapped), for: .touchUpInside)
            cell.tapButton2.tag = xyz + 1
            cell.tapButton2.addTarget(self, action: #selector(relatedTapped), for: .touchUpInside)
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        else */if tableView == colorTable {
            
            let CellIdentifier: String = "ColorCell"
            var cell: ColorCell? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? ColorCell)
            if cell == nil {
                var topLevelObjects: [Any] = Bundle.main.loadNibNamed("ColorCell", owner: self, options: nil)!
                cell = (topLevelObjects[0] as? ColorCell)
            }
            
            cell!.colorLabel.layer.cornerRadius = cell!.colorLabel.frame.size.width / 2
            cell!.colorLabel.layer.borderWidth = 2
            cell!.colorLabel.backgroundColor = hexStringToUIColor(hex: colorsArray[indexPath.row].color_code)
            if colorsArray[indexPath.row].color_status == "1" {
                
                cell!.colorLabel.layer.borderColor = UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0).cgColor
            }
            else {
                
                cell!.colorLabel.layer.borderColor = UIColor.clear.cgColor
            }
            
            let rotateImage = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            cell!.transform = rotateImage
            cell!.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if tableView == sizeTable {
            
            let CellIdentifier: String = "ColorCell"
            var cell: ColorCell? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? ColorCell)
            if cell == nil {
                var topLevelObjects: [Any] = Bundle.main.loadNibNamed("ColorCell", owner: self, options: nil)!
                cell = (topLevelObjects[0] as? ColorCell)
            }
            
            cell!.colorLabel.layer.cornerRadius = cell!.colorLabel.frame.size.width / 2
            cell!.colorLabel.layer.borderWidth = 2
            cell!.colorLabel.backgroundColor = UIColor(red: 230.0/255.0, green:230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            
            if sizeArray[indexPath.row].size_status == "1" {
                
                cell!.colorLabel.layer.borderColor = UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0).cgColor
            }
            else {
                
                cell!.colorLabel.layer.borderColor = UIColor.clear.cgColor
            }
            
            cell!.colorLabel.text = sizeArray[indexPath.row].size_name
            
            let rotateImage = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            cell!.transform = rotateImage
            cell!.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if tableView == reviewTable {
            
            let cellIdentifier = "CustomCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
            
            cell.usernameLabel.text = reviewArray[indexPath.row].user_name
            
            cell.reviewtitleLabel.text = reviewArray[indexPath.row].review_title
            
            if colorsArray.count == 0 && sizeArray.count == 0 {
                cell.frame = CGRect(x: 0, y: self.reviewView.frame.maxY, width: cell.frame.size.width, height: cell.frame.size.height)
            }
            
            
            var Yvalue:CGFloat = 80
            
            cell.reviewcommentLabel.numberOfLines = 2
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
            
            if productimagesArray[indexPath.row].images == "" {
                cell.productImage.image = UIImage(named: "no-image-icon")
            }
            else {
                cell.productImage.kf.setImage(with: StringToURL(text: productimagesArray[indexPath.row].images))
                cell.productImage.yy_imageURL = URL(string: productimagesArray[indexPath.row].images)
            }
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == imagesTable {
            
            if productimagesArray[indexPath.row].images == nil {
                productImage.image = UIImage(named: "no-image-icon")
            }
            else {
                productImage.kf.setImage(with: StringToURL(text: self.productimagesArray[indexPath.row].images))
                productImage.yy_imageURL = URL(string: self.productimagesArray[indexPath.row].images)
            }
        }
        else if tableView == sizeTable {
            
            product_size_id = sizeArray[indexPath.row].product_size_id
            
            for i in 0..<sizeArray.count {
                
                if indexPath.row == i {
                    sizeArray[i].size_status = "1"
                }
                else {
                    sizeArray[i].size_status = "0"
                }
            }
            sizeTable.reloadData()
        }
        else if tableView == colorTable {
            
            product_color_id = colorsArray[indexPath.row].product_color_id
            
            for i in 0..<colorsArray.count {
                
                if indexPath.row == i {
                    colorsArray[i].color_status = "1"
                }
                else {
                    colorsArray[i].color_status = "0"
                }
            }
            colorTable.reloadData()
        }
    }
    
    
    func canShowColorView() {
        
        if colorsArray.count == 0 && sizeArray.count != 0 {
            includeColorsView()
            self.colorView.isHidden = false
            self.colorTable.isHidden = true
            self.selectColorLabel.isHidden = true
            self.selectSize.isHidden = false
            self.sizeTable.isHidden = false
            self.selectColorLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            self.colorTable.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            self.selectSize.frame = CGRect(x: 10, y: 0, width: 300, height: 30)
            self.sizeTable.frame = CGRect(x: 0, y: 30, width: 300, height: 60)
            self.colorView.frame.size.height =  self.colorView.frame.size.height/2
            if spec_string.count == 0 {
                self.specificationView.frame = CGRect(x: 0, y: self.COLORVIEW_Y_AXIS, width: self.specificationView.frame.width, height: 0)
            } else {
                self.specificationView.frame = CGRect(x: 0, y: self.colorView.frame.maxY + 10 , width: self.specificationView.frame.width, height: self.specificationView.frame.height)
            }
            includeColorsView()
        } else if colorsArray.count != 0 && sizeArray.count == 0 {
            
            self.colorView.isHidden = false
            self.colorTable.isHidden = false
            self.selectColorLabel.isHidden = false
            self.selectSize.isHidden = true
            self.sizeTable.isHidden = true
            self.selectColorLabel.frame = CGRect(x: 10, y: 0, width: 300, height: 30)
            self.colorTable.frame = CGRect(x: 0, y: 30, width: 300, height: 60)
            self.selectSize.frame = CGRect(x: 0, y: 0, width:0, height: 0)
            self.sizeTable.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            self.colorView.frame = CGRect(x: 0, y: self.COLORVIEW_Y_AXIS, width: self.colorView.frame.width, height: 90)
            if spec_string.count == 0 {
                self.specificationView.frame = CGRect(x: 0, y: self.COLORVIEW_Y_AXIS, width: self.specificationView.frame.width, height: 0)
            } else {
                self.specificationView.frame = CGRect(x: 0, y: self.colorView.frame.maxY + 10 , width: self.specificationView.frame.width, height: self.specificationView.frame.height)
            }
            includeColorsView()
            
        } else if colorsArray.count == 0 && sizeArray.count == 0 {
            self.colorView.isHidden = true
            if spec_string.count == 0 {
                self.specificationView.frame = CGRect(x: 0, y: self.COLORVIEW_Y_AXIS, width: self.specificationView.frame.width, height: 0)
            } else {
                self.specificationView.frame = CGRect(x: 0, y: self.COLORVIEW_Y_AXIS, width: self.specificationView.frame.width, height: self.specificationView.frame.height)
            }
            self.descriptionView.frame = CGRect(x: 0, y: self.specificationView.frame.maxY, width: self.descriptionView.frame.width, height: self.descriptionView.frame.height)
            
            self.deliveryView.frame = CGRect(x: 0, y: self.descriptionView.frame.maxY, width: self.deliveryView.frame.width, height: self.deliveryView.frame.height)
            
            self.conditionView.frame = CGRect(x:0, y:self.deliveryView.frame.maxY, width:self.conditionView.frame.width, height: self.conditionView.frame.height)
            
            self.redemptionView.frame = CGRect(x:0, y:self.conditionView.frame.maxY, width:self.redemptionView.frame.width, height: self.redemptionView.frame.height)
            
            self.directionView.frame = CGRect(x:0, y:self.redemptionView.frame.maxY, width:self.directionView.frame.width, height: self.directionView.frame.height)
            
            self.redeemOfferView.frame = CGRect(x:0, y:self.directionView.frame.maxY, width:self.redeemOfferView.frame.width, height: self.redeemOfferView.frame.height)
            
            self.storeDetailsView.frame = CGRect(x:0, y:self.redeemOfferView.frame.maxY, width:self.storeDetailsView.frame.width, height: self.storeDetailsView.frame.height)
            
            self.reviewView.frame = CGRect(x: 0, y: self.storeDetailsView.frame.maxY, width: self.reviewView.frame.width, height: self.reviewView.frame.height)
            
            self.headerView.frame = CGRect(x: 0, y: 0, width: self.headerView.frame.width, height: self.reviewView.frame.maxY)
            
        } else {
            self.colorView.isHidden = false
            self.colorView.frame = CGRect(x: 0, y: self.COLORVIEW_Y_AXIS, width: self.colorView.frame.width, height: self.colorView.frame.height)
            if spec_string.count == 0 {
                self.specificationView.frame = CGRect(x: 0, y: self.colorView.frame.maxY + 10, width: self.specificationView.frame.width, height: 0)
            } else {
                self.specificationView.frame = CGRect(x: 0, y: self.colorView.frame.maxY + 10 , width: self.specificationView.frame.width, height: self.specificationView.frame.height)
            }
            includeColorsView()
        }
    }
    
    func includeColorsView(){
        
        self.descriptionView.frame = CGRect(x: 0, y: self.specificationView.frame.maxY + 10, width: self.descriptionView.frame.width, height: self.descriptionView.frame.height)
        
        self.deliveryView.frame = CGRect(x: 0, y: self.descriptionView.frame.maxY + 10, width: self.deliveryView.frame.width, height: self.deliveryView.frame.height)
        
        self.conditionView.frame = CGRect(x: 0, y: self.deliveryView.frame.maxY + 10, width: self.conditionView.frame.width, height: self.conditionView.frame.height)
        
        self.redemptionView.frame = CGRect(x: 0, y: self.conditionView.frame.maxY + 10, width: self.redemptionView.frame.width, height: self.redemptionView.frame.height)
        
        self.directionView.frame = CGRect(x: 0, y: self.redemptionView.frame.maxY + 10, width: self.directionView.frame.width, height: self.directionView.frame.height)
        
        self.redeemOfferView.frame = CGRect(x: 0, y: self.directionView.frame.maxY + 10, width: self.redeemOfferView.frame.width, height: self.redeemOfferView.frame.height)
        
        self.storeDetailsView.frame = CGRect(x: 0, y: self.redeemOfferView.frame.maxY + 10, width: self.storeDetailsView.frame.width, height: self.storeDetailsView.frame.height)
        
        self.reviewView.frame = CGRect(x: 0, y: self.storeDetailsView.frame.maxY + 10, width: self.reviewView.frame.width, height: self.reviewView.frame.height)
        
        self.headerView.frame = CGRect(x: 0, y: 0, width: self.headerView.frame.width, height: self.reviewView.frame.maxY)
        
    }
    
    
     @objc func relatedTapped(sender:UIButton ) {
        let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        objProductDetails.category_name = "Related Deals"
        objProductDetails.product_id = relatedArray[sender.tag].product_id
        self.navigationController?.pushViewController(objProductDetails, animated: true)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    @IBAction func addcartButton(sender:UIButton ) {
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            DispatchQueue.main.async {
                self.addcartApi()
               
            }
            
        }
        else {
            self.showNetworkErrorAlert()
        }
    }
    
    func addcartApi() {
        
        let myUrl = URL(string: String(format:"%@api/add_to_cart", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(product_id!)&product_size_id=\(product_size_id!)&product_color_id=\(product_color_id!)&quantity=\("1")&lang=en"
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
                            cartButton.addTarget(self, action: #selector(ProductDetailsViewController.cartAction(_:)), for: UIControl.Event.touchUpInside)
                         //   cartButton.badgeString = String(format: "%d", UserDefaults.standard.object(forKey: "CartCount") as! NSInteger)
                            cartButton.badgeTextColor = UIColor.white
                            
                            let rightButton = UIBarButtonItem(customView: cartButton)
                            self.navigationItem.rightBarButtonItem = rightButton
                            
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
    
    @IBAction func buynowButton(sender:UIButton ) {
        AddtoWishlish()
        //        let objShipping = self.storyboard?.instantiateViewController(withIdentifier: "ShippingViewController") as! ShippingViewController
        //        objShipping.no_of_items = "1"
        //        objShipping.shipping_charge = product_ship_amt!
        //        objShipping.amount = self.currencySymbol + self.Amount
        //        objShipping.total_amount = productdiscountpriceLabel.text!
        //        objShipping.tax = String(calulateTax(total: self.Amount, tax: self.tax))
        //        objShipping.currencySymbol = self.currencySymbol
        //        objShipping.product_id = product_id!
        //        objShipping.product_size_id = product_size_id!
        //        objShipping.product_color_id = product_color_id!
        //        objShipping.product_qty = "1"
        //        objShipping.screen_value = "Product"
        //        self.navigationController?.pushViewController(objShipping, animated: true)
    }
    
    func AddtoWishlish(){
        let myUrl = URL(string: String(format:"%@api/add_to_wishlist", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        // let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(product_id!)&lang=en"
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(product_id!)&lang=en"//\(product_id!)
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
                            self.buynowButton.setTitle("Wishlisted", for: UIControl.State.normal)
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
    
    
    
    @IBAction func reviewButton(sender:UIButton ) {
        
        let objPostReview = self.storyboard?.instantiateViewController(withIdentifier: "PostReviewViewController") as! PostReviewViewController
        objPostReview.review_id = product_id
        objPostReview.screen_value = "Products"
        objPostReview.reviewDelegate = self
        self.navigationController?.pushViewController(objPostReview, animated: true)
    }
    
    func updateReview(json: NSDictionary) {
        
        if let reposArray = json["product_review"] as? [NSDictionary] {
            // 5
            if reposArray.count != 0 {
                
                for item in reposArray {
                    self.reviewArray.append(Review(Review: item))
                }
            }
            self.canShowColorView()
            self.reviewTable.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (relatedCollectionView.frame.size.width - space) / 2.0
        let widthSet:CGFloat = (relatedCollectionView.frame.size.width - space) / 2.0
        let heightSet:CGFloat = 195
        return CGSize(width: widthSet, height: heightSet)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        objProductDetails.category_name = "Latest Product"
        objProductDetails.product_id = relatedArray[indexPath.row].product_id
        self.navigationController?.pushViewController(objProductDetails, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedArray.count
    }
    
    func setShadowAndRoundedBorder(customCell:UICollectionViewCell){
        customCell.layer.cornerRadius = 5
        customCell.layer.borderWidth = 0.9
        
        customCell.layer.borderColor = UIColor.init(named: "appThemeColor")?.cgColor
        customCell.layer.masksToBounds = true
        
        customCell.layer.shadowColor = UIColor.black.cgColor
        customCell.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        customCell.layer.shadowRadius = 3
        customCell.layer.shadowOpacity = 0.3
        customCell.layer.masksToBounds = false
        customCell.layer.shadowPath = UIBezierPath(roundedRect:customCell.bounds, cornerRadius:customCell.contentView.layer.cornerRadius).cgPath
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FLatestCollectionViewCell", for: indexPath) as! FLatestCollectionViewCell
        self.setShadowAndRoundedBorder(customCell: cell)
        cell.backgroundColor = UIColor.white
        if relatedArray[indexPath.row].product_image == "" {
            cell.productImage.image = UIImage(named: "no-image-icon")
        }
        else {
            cell.productImage.kf.setImage(with:StringToURL(text: relatedArray[indexPath.row].product_image))
            //  cell.popularImage1.yy_imageURL = URL(string: relatedArray[xyz].product_image)
        }
        //cell.productTitle.numberOfLines = 5
        cell.productTitle.text = relatedArray[indexPath.row].product_title!
        //cell.productTitle.text = relatedArray[indexPath.row].product_title
        //cell.productCategory.numberOfLines = 2
        cell.productCategory.text = relatedArray[indexPath.row].merchant_name!
        cell.cutOffPrice.text = "৳" + relatedArray[indexPath.row].product_price!
        return cell
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

extension String{
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data,
                                          options: [.documentType : NSAttributedString.DocumentType.html],
                                          documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
}
