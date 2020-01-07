//
//  StoresViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 26/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class StoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var storesTable : UITableView!
    
    var page_no: Int! = 1
    var storesArray = [Stores]()
    var filterView:FilterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storesTable.dataSource = self
        storesTable.delegate = self

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Merchants"
        
        if revealViewController() != nil {
            
            let rightRevealButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu")!, style: .done, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.navigationItem.leftBarButtonItem = rightRevealButtonItem
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            storesApi()

        }
        else {
            
            self.showNetworkErrorAlert()
        }
        
        //filter
        filterView =  FilterView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(filterView)
        filterView.isHidden = true
        filterView.backView.layer.cornerRadius = 10
        
        filterView.underButton.addTarget(self, action: #selector(StoresViewController.underAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.oneButton.addTarget(self, action: #selector(StoresViewController.oneAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.twoButton.addTarget(self, action: #selector(StoresViewController.twoAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.fiveButton.addTarget(self, action: #selector(StoresViewController.fiveAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.overButton.addTarget(self, action: #selector(StoresViewController.overAction(_:)), for: UIControl.Event.touchUpInside)

        filterView.zeroButton.addTarget(self, action: #selector(StoresViewController.zeroAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.tenButton.addTarget(self, action: #selector(StoresViewController.tenAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.twentyButton.addTarget(self, action: #selector(StoresViewController.twentyAction(_:)), for: UIControl.Event.touchUpInside)
        
        //Not using
//        filterView.thirtyButton.addTarget(self, action: #selector(ProductViewController.thirtyAction(_:)), for: UIControlEvents.touchUpInside)
//        filterView.fourtyButton.addTarget(self, action: #selector(ProductViewController.fourtyAction(_:)), for: UIControlEvents.touchUpInside)
        //end
        
        filterView.fiftyButton.addTarget(self, action: #selector(StoresViewController.fiftyAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.outButton.addTarget(self, action: #selector(StoresViewController.outAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.resetButton.addTarget(self, action: #selector(StoresViewController.resetFilterAction(_:)), for: UIControl.Event.touchUpInside)
        filterView.cancelButton.addTarget(self, action: #selector(StoresViewController.cancelFilterAction(_:)), for: UIControl.Event.touchUpInside)
        
        //filter end
        
        filterView.cancelButton.addTarget(self, action: #selector(StoresViewController.cancelFilterAction(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func resetFilterAction(_ sender: UIButton!) {
        
        filterView.isHidden = true
                
        filterView.underButton.setTitleColor(UIColor.black, for: .normal)
        filterView.oneButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twoButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiveButton.setTitleColor(UIColor.black, for: .normal)
        
        filterView.overButton.setTitleColor(UIColor.black, for: .normal)
        filterView.zeroButton.setTitleColor(UIColor.black, for: .normal)
        filterView.tenButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twentyButton.setTitleColor(UIColor.black, for: .normal)
        
        //filterView.thirtyButton.setTitleColor(UIColor.black, for: .normal)
        //filterView.fourtyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiftyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.outButton.setTitleColor(UIColor.black, for: .normal)
        
        filterView.resetButton.setTitleColor(UIColor.black, for: .normal)
        //filterView.fourtyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.cancelButton.setTitleColor(UIColor.black, for: .normal)
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
           storesApiforreset()
        }
        else {
            self.self.showNetworkErrorAlert()
        }
    }
    
    func storesApiforreset() {
         storesArray.removeAll()
        let myUrl = URL(string: String(format:"%@api/shop_list", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "pageno=\(page_no!)&lang=en"
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
                            
                            if let reposArray = parseJSON["store_details"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.storesArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.storesArray.append(Stores(Stores: item))
                                    }
                                }
                            }
                        }
                        else {
                            
                            if self.storesArray.count == 0 {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                
                                self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                            }
                            else {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                            }
                        }
                        
                        self.storesTable.reloadData()
                        //                        self.storesTable.infiniteScrollingView.stopAnimating()
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
    
    
    func storesApi() {
       // storesArray.removeAll()
        let myUrl = URL(string: String(format:"%@api/shop_list", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "pageno=\(page_no!)&lang=en"
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
                            
                            if let reposArray = parseJSON["store_details"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.storesArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.storesArray.append(Stores(Stores: item))
                                    }
                                }
                            }
                        }
                        else {
                            
                            if self.storesArray.count == 0 {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                
                                self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                            }
                            else {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                            }
                        }
                        
                        self.storesTable.reloadData()
                        //                        self.storesTable.infiniteScrollingView.stopAnimating()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.storesTable.reloadData()
    }
    
    //MARK: Filter action
     @objc func cancelFilterAction(_ sender: UIButton!) {
        filterView.isHidden = true
    }

    
    @IBAction func filterButton(_ sender: UIButton) {
        filterView.isHidden = false
        UIApplication.shared.keyWindow?.addSubview(filterView)
    }
    
    @objc func underAction(_ sender: UIButton!) {
        
        filterView.underButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        filterView.oneButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twoButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiveButton.setTitleColor(UIColor.black, for: .normal)
        filterView.overButton.setTitleColor(UIColor.black, for: .normal)
        
        filterView.isHidden = true

        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            merchantFilterStoresApi()
            
        }
        else {
            self.self.showNetworkErrorAlert()
        }
    }
    

    @objc func oneAction(_ sender: UIButton!) {

        filterView.underButton.setTitleColor(UIColor.black, for: .normal)
        filterView.oneButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        filterView.twoButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiveButton.setTitleColor(UIColor.black, for: .normal)
        filterView.overButton.setTitleColor(UIColor.black, for: .normal)

        filterView.isHidden = true

        let reachability = Reachability()!

        if reachability.isReachable {

            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)


            oneAction()

        }
        else {

            self.self.showNetworkErrorAlert()
        }
    }

    @objc func twoAction(_ sender: UIButton!) {

        filterView.underButton.setTitleColor(UIColor.black, for: .normal)
        filterView.oneButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twoButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        filterView.fiveButton.setTitleColor(UIColor.black, for: .normal)
        filterView.overButton.setTitleColor(UIColor.black, for: .normal)

        filterView.isHidden = true


        let reachability = Reachability()!

        if reachability.isReachable {

            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)

            twoAction()
        }
        else {

            self.self.showNetworkErrorAlert()
        }
    }

    @objc func fiveAction(_ sender: UIButton!) {

        filterView.underButton.setTitleColor(UIColor.black, for: .normal)
        filterView.oneButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twoButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiveButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        filterView.overButton.setTitleColor(UIColor.black, for: .normal)

        filterView.isHidden = true

 

        self.page_no = 1

       

        let reachability = Reachability()!

        if reachability.isReachable {

            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)

            //            self.productApi()
          fourthAction()
        }
        else {

            self.self.showNetworkErrorAlert()
        }
    }

    @objc func overAction(_ sender: UIButton!) {

        filterView.underButton.setTitleColor(UIColor.black, for: .normal)
        filterView.oneButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twoButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiveButton.setTitleColor(UIColor.black, for: .normal)
        filterView.overButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)

        filterView.isHidden = true

   

       

        let reachability = Reachability()!

        if reachability.isReachable {

            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)

            fifthAction()

        }
        else {

            self.self.showNetworkErrorAlert()
        }
    }

    @objc func zeroAction(_ sender: UIButton!) {

        filterView.zeroButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        filterView.tenButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twentyButton.setTitleColor(UIColor.black, for: .normal)
//                filterView.thirtyButton.setTitleColor(UIColor.black, for: .normal)
//                filterView.fourtyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiftyButton.setTitleColor(UIColor.black, for: .normal)

        filterView.isHidden = true

       

        let reachability = Reachability()!

        if reachability.isReachable {

            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)

            //self.productApi()
            sixthAction()

            
        }
        else {

            self.self.showNetworkErrorAlert()
        }
    }

    @objc func tenAction(_ sender: UIButton!) {

        filterView.zeroButton.setTitleColor(UIColor.black, for: .normal)
        filterView.tenButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
        filterView.twentyButton.setTitleColor(UIColor.black, for: .normal)
//            filterView.thirtyButton.setTitleColor(UIColor.black, for: .normal)
//               filterView.fourtyButton.setTitleColor(UIColor.black, for: .normal)
             filterView.fiftyButton.setTitleColor(UIColor.black, for: .normal)

        filterView.isHidden = true


        let reachability = Reachability()!

        if reachability.isReachable {

            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)

            //            self.productApi()
           seventhAction()

        }
        else {

            self.self.showNetworkErrorAlert()
        }
    }

    @objc func twentyAction(_ sender: UIButton!) {

        filterView.zeroButton.setTitleColor(UIColor.black, for: .normal)
        filterView.tenButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twentyButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
//        filterView.thirtyButton.setTitleColor(UIColor.black, for: .normal)
//        filterView.fourtyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiftyButton.setTitleColor(UIColor.black, for: .normal)

        filterView.isHidden = true

       

        let reachability = Reachability()!

        if reachability.isReachable {

            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)

            eightAction()
        }
        else {

            self.self.showNetworkErrorAlert()
        }
    }

    @objc func fiftyAction(_ sender: UIButton!) {

        filterView.zeroButton.setTitleColor(UIColor.black, for: .normal)
        filterView.tenButton.setTitleColor(UIColor.black, for: .normal)
        filterView.twentyButton.setTitleColor(UIColor.black, for: .normal)
//        filterView.thirtyButton.setTitleColor(UIColor.black, for: .normal)
//        filterView.fourtyButton.setTitleColor(UIColor.black, for: .normal)
        filterView.fiftyButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)

        filterView.isHidden = true

        
        let reachability = Reachability()!

        if reachability.isReachable {

            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)

           eightAction()
        }
        else {

            self.self.showNetworkErrorAlert()
        }
    }

    @objc func outAction(_ sender: UIButton!) {

        filterView.isHidden = true

//        if outBool == false {
//
//            outBool = true
//            self.availability = "1"
//            filterView.outButton.setTitleColor(UIColor(red: 255.0/255.0, green:35.0/255.0, blue: 83.0/255.0, alpha: 1.0), for: .normal)
//        }
//        else {
//
//            outBool = false
//            self.availability = ""
//            filterView.outButton.setTitleColor(UIColor.black, for: .normal)
//        }

        self.page_no = 1

//        self.productsArray = [Products]()

        let reachability = Reachability()!

        if reachability.isReachable {

            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)

            storesApi()

            
        }
        else {

            self.self.showNetworkErrorAlert()
        }
    }
    
    func merchantFilterStoresApi() {
        storesArray.removeAll()
        let myUrl = URL(string: String(format:"%@api/categoy_merchant", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
            let postString = "category_id=1&lang=en"
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
                            
                            if let reposArray = parseJSON["store_details"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.storesArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.storesArray.append(Stores(Stores: item))
                                    }
                                }
                            }
                        }
                        else {
                            
                            if self.storesArray.count == 0 {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                
                                self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                            }
                            else {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                            }
                        }
                        
                        self.storesTable.reloadData()
                        //                        self.storesTable.infiniteScrollingView.stopAnimating()
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
    
    func oneAction() {
        storesArray.removeAll()
        let myUrl = URL(string: String(format:"%@api/categoy_merchant", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "category_id=2&lang=en"
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
                            
                            if let reposArray = parseJSON["store_details"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.storesArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.storesArray.append(Stores(Stores: item))
                                    }
                                }
                            }
                        }
                        else {
                            
                            if self.storesArray.count == 0 {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                
                                self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                            }
                            else {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                            }
                        }
                        
                        self.storesTable.reloadData()
                        //                        self.storesTable.infiniteScrollingView.stopAnimating()
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
    
    
    func twoAction() {
        storesArray.removeAll()
        let myUrl = URL(string: String(format:"%@api/categoy_merchant", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "category_id=3&lang=en"
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
                            
                            if let reposArray = parseJSON["store_details"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.storesArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.storesArray.append(Stores(Stores: item))
                                    }
                                }
                            }
                        }
                        else {
                            
                            if self.storesArray.count == 0 {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                
                                self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                            }
                            else {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                            }
                        }
                        
                        self.storesTable.reloadData()
                        //                        self.storesTable.infiniteScrollingView.stopAnimating()
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
    
  
    func fourthAction() {
        storesArray.removeAll()
        let myUrl = URL(string: String(format:"%@api/categoy_merchant", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "category_id=4&lang=en"
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
                            
                            if let reposArray = parseJSON["store_details"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.storesArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.storesArray.append(Stores(Stores: item))
                                    }
                                }
                            }
                        }
                        else {
                            
                            if self.storesArray.count == 0 {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                
                                self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                            }
                            else {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                            }
                        }
                        
                        self.storesTable.reloadData()
                        //                        self.storesTable.infiniteScrollingView.stopAnimating()
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
    
    
    func fifthAction() {
        storesArray.removeAll()
        let myUrl = URL(string: String(format:"%@api/categoy_merchant", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "category_id=5&lang=en"
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
                            
                            if let reposArray = parseJSON["store_details"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.storesArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.storesArray.append(Stores(Stores: item))
                                    }
                                }
                            }
                        }
                        else {
                            
                            if self.storesArray.count == 0 {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                
                                self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                            }
                            else {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                            }
                        }
                        
                        self.storesTable.reloadData()
                        //                        self.storesTable.infiniteScrollingView.stopAnimating()
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
    
    
    func sixthAction() {
        storesArray.removeAll()
        let myUrl = URL(string: String(format:"%@api/categoy_merchant", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "category_id=7&lang=en"
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
                            
                            if let reposArray = parseJSON["store_details"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.storesArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.storesArray.append(Stores(Stores: item))
                                    }
                                }
                            }
                        }
                        else {
                            
                            if self.storesArray.count == 0 {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                
                                self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                            }
                            else {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                            }
                        }
                        
                        self.storesTable.reloadData()
                        //                        self.storesTable.infiniteScrollingView.stopAnimating()
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
    
    
    func seventhAction() {
        storesArray.removeAll()
        let myUrl = URL(string: String(format:"%@api/categoy_merchant", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "category_id=12&lang=en"
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
                            
                            if let reposArray = parseJSON["store_details"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.storesArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.storesArray.append(Stores(Stores: item))
                                    }
                                }
                            }
                        }
                        else {
                            
                            if self.storesArray.count == 0 {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                
                                self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                            }
                            else {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                            }
                        }
                        
                        self.storesTable.reloadData()
                        //                        self.storesTable.infiniteScrollingView.stopAnimating()
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
    
    func eightAction() {
        storesArray.removeAll()
        let myUrl = URL(string: String(format:"%@api/categoy_merchant", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "category_id=23&lang=en"
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
                            
                            if let reposArray = parseJSON["store_details"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.storesArray.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                                    }
                                }
                                else {
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.storesArray.append(Stores(Stores: item))
                                    }
                                }
                            }
                        }
                        else {
                            
                            if self.storesArray.count == 0 {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                
                                self.view.makeToast("No Merchants Available!", duration: 3.0, position: .center, style: style)
                            }
                            else {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                self.view.makeToast("No More Merchants Available!", duration: 3.0, position: .bottom, style: style)
                            }
                        }
                        
                        self.storesTable.reloadData()
                        //                        self.storesTable.infiniteScrollingView.stopAnimating()
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
    
    
    
    //End filter action
    
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.black
        style.messageAlignment = .center
        style.backgroundColor = UIColor.white
        
        self.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Customize the number of rows in the table view.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storesArray.count
    }
    // Customize the appearance of table view cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CustomCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
        
        if storesArray[indexPath.row].store_img == "" {
            cell.storeImage.image = UIImage(named: "no-image-icon")
        }
        else {
            cell.storeImage.yy_imageURL = URL(string: storesArray[indexPath.row].store_img)
        }
        
        cell.storenameLabel.text = storesArray[indexPath.row].store_name
        
//        if storesArray[indexPath.row].deal_count == "0" {
//            
//            let dealLabelString = NSMutableAttributedString(string: String(format:"Deals N/A"))
//            dealLabelString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSRange(location: 0, length: 5))
//            cell.dealcountLabel.attributedText = dealLabelString
//        }
//        else {
//            
//            let dealLabelString = NSMutableAttributedString(string: String(format:"Deals %@", storesArray[indexPath.row].deal_count))
//            dealLabelString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSRange(location: 0, length: 5))
//            cell.dealcountLabel.attributedText = dealLabelString
//        }
        
        if storesArray[indexPath.row].product_count == "0" {
            
            let productLabelString = NSMutableAttributedString(string: String(format:"Deals N/A"))
            productLabelString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 5))
            cell.productcountLabel.attributedText = productLabelString
        }
        else {
           
            let productLabelString = NSMutableAttributedString(string: String(format:"Deals %@", storesArray[indexPath.row].product_count))
            productLabelString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 5))
            cell.productcountLabel.attributedText = productLabelString
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objStoreDetails = self.storyboard?.instantiateViewController(withIdentifier: "StoreDetailsViewController") as! StoreDetailsViewController
        objStoreDetails.shop_id = storesArray[indexPath.row].store_id
        self.navigationController?.pushViewController(objStoreDetails, animated: true)
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
