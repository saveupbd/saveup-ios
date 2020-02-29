//
//  CategoryProductListViewController.swift
//  Le
//
//  Created by Asif Seraje on 11/25/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit

class CategoryProductListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var catCollectionView: UICollectionView!
    @IBOutlet weak var upperSegment: UISegmentedControl!
    
    @IBOutlet weak var subCatCollectionView: UICollectionView!
    var topOffersArray = [TopOffers]()
    var popularArray = [Popular]()
    var secondaryArray = [SecondayCategory]()
    var submoduleArray = [SubModule]()
    var bannersArray = [BannersHome]()
    var adimagesArray = [AdImages]()
    
    var parent_category_id: String!
    var parent_category_name: String!
    var sec_category_id: String!
    
    var isFirstStarted: Bool = false
    var totalFirstCount: Int = 0
    var currentFirst: Int = 0
    
    var BANNER_Y_AXIX = CGFloat()
    
    var flag: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.catCollectionView.delegate = self
        self.catCollectionView.dataSource = self
        
        self.subCatCollectionView.delegate = self
        self.subCatCollectionView.dataSource = self
        
        
        //upperSegment.apportionsSegmentWidthsByContent = true
        print(parent_category_id!)
        print(parent_category_name!)
        sec_category_id = parent_category_id
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(SubViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        //self.navigationItem.leftBarButtonItem = LeftButton
        //upperSegment.isHidden = true
        //setScrollSegment()
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            subcategoryApi()
            //upperSegment.isHidden = false
            print()
        }
        else {
            showNetworkErrorAlert()
        }
    }
    
    func setScrollSegment() {
//        upperSegment.items = ["Weekly", "Fornightly", "Monthly"]
//        upperSegment.borderColor = .clear
//        upperSegment.selectedLabelColor = .white
//        upperSegment.unselectedLabelColor = .red
//        upperSegment.backgroundColor = .lightGray
//        upperSegment.thumbColor = .black
//        upperSegment.selectedIndex = 1
        //upperSegment.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
//        self.upperSegment.segmentStyle = .textOnly
//        upperSegment.insertSegment(withTitle: "Segment 1", image: nil, at: 0)
//        upperSegment.insertSegment(withTitle: "Segment 2", image: nil, at: 1)
//        upperSegment.insertSegment(withTitle: "Segment 3", image: nil, at: 2)
//        upperSegment.insertSegment(withTitle: "Segment 4", image: nil, at: 3)
//        upperSegment.insertSegment(withTitle: "Segment 5", image: nil, at: 4)
//        upperSegment.insertSegment(withTitle: "Segment 6", image: nil, at: 5)
//
//        upperSegment.underlineSelected = true
//
//        upperSegment.addTarget(self, action: #selector(upperSegmentPressed), for: .valueChanged)
//
//        // change some colors
//        upperSegment.segmentContentColor = UIColor.white
//        upperSegment.selectedSegmentContentColor = UIColor.yellow
//        upperSegment.backgroundColor = UIColor.black
//
//        // Turn off all segments been fixed/equal width.
//        // The width of each segment would be based on the text length and font size.
//        upperSegment.fixedSegmentWidth = false
    }
    
    @IBAction func upperSegmentPressed(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            sec_category_id = parent_category_id
        }else{
            sec_category_id = submoduleArray[sender.selectedSegmentIndex].sec_category_id
        }
        
        
        
        topOffersArray = [TopOffers]()
        popularArray = [Popular]()
        secondaryArray = [SecondayCategory]()
        //  submoduleArray = [SubModule]()
        bannersArray = [BannersHome]()
        adimagesArray = [AdImages]()
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            subcategoryApi()
            //   subcategoryApiOne()
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
        
        self.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.catCollectionView{
            return topOffersArray.count
        }else{
            return submoduleArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.catCollectionView{

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FLatestCollectionViewCell", for: indexPath) as! FLatestCollectionViewCell
            self.setShadowAndRoundedBorder(customCell: cell)
            cell.backgroundColor = UIColor.white
            cell.productTitle.text = topOffersArray[indexPath.row].product_title
            cell.productCategory.text = topOffersArray[indexPath.row].merchant_name
            
            if topOffersArray[indexPath.row].product_type != "all_item"  {
                cell.originalPrice.text = "৳" + topOffersArray[indexPath.row].product_discount_price
                cell.cutOffPrice.attributedText = topOffersArray[indexPath.row].product_price.strikeThrough()
                cell.offPercentage.text = topOffersArray[indexPath.row].product_percentage + "% off"
            }else{
                cell.cutOffPrice.text = topOffersArray[indexPath.row].product_off + "% off"
                cell.cutOffPrice.textColor = UIColor(named: "appThemeColor")
            }
            cell.productImage.kf.setImage(with: (StringToURL(text: topOffersArray[indexPath.row].product_image)))
            cell.productImage.yy_imageURL = URL(string: topOffersArray[indexPath.row].product_image)
            return cell
        }else{

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCatCollectionViewCell", for: indexPath) as! SubCatCollectionViewCell
            self.setShadowAndRoundedBorder(customCell: cell)
            cell.subCatLabel.text = submoduleArray[indexPath.row].sec_category_name
            return cell
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.catCollectionView{
            let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "FProductDetailsTableViewController") as! FProductDetailsTableViewController
            objProductDetails.category_name = "Latest Product"
            objProductDetails.product_id = topOffersArray[indexPath.row].product_id
            UserDefaults.standard.set(topOffersArray[indexPath.row].product_id, forKey: "temp_pro_id")

            self.navigationController?.pushViewController(objProductDetails, animated: true)
            return
        }else{
            if indexPath.row == 0 {
                sec_category_id = parent_category_id
            }else{
                sec_category_id = submoduleArray[indexPath.row].sec_category_id
            }
            
            
            
            topOffersArray = [TopOffers]()
            popularArray = [Popular]()
            secondaryArray = [SecondayCategory]()
            //  submoduleArray = [SubModule]()
            bannersArray = [BannersHome]()
            adimagesArray = [AdImages]()
            
            let reachability = Reachability()!
            
            if reachability.isReachable {
                
                self.view.hideToastActivity()
                self.view.makeToastActivity(.center)
                
                subcategoryApi()
                //   subcategoryApiOne()
            }
            else {
                
                showNetworkErrorAlert()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.catCollectionView{
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let widthSet:CGFloat = (catCollectionView.frame.size.width - space) / 2.0
            let heightSet:CGFloat = 195
            return CGSize(width: widthSet, height: heightSet)
        }else{
            return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height)
        }
        
        
    }
    
    func subcategoryApi() {
        
        let myUrl = URL(string: String(format:"%@api/product_list_by_category", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "main_category_id=\(sec_category_id!)"  //&main_category_id=\(sec_category_id!)//&sec_category_id=\(sec_category_id!)&lang=en
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
                    //self.topoffersTable.isHidden = false
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            
                            
                            
                            if let reposArray = parseJSON["categories_list"] as? [NSDictionary] {
                                
                                
                                
                                //                    "main_category_id": 1,
                                //                    "main_category_name": "FOOD",
                                //                    "main_category_image": "https://saveupbd.com/storage/category/March2019/XGdbamXsxC1UlgIV2bYm.png",
                                //                    "main_category_status": 1,
                                
                                
                                
                                if self.flag {
                                    let localObject = SubModule()
                                    localObject.pushData(sec_category_id:"\(String(describing: self.parent_category_id))", sec_category_name: self.parent_category_name)
                                    
                                    print("after inserting \(localObject.sec_category_name)")
                                    
                                    self.submoduleArray.append(localObject)
                                    
                                    
                                    
                                    
                                    // 5
                                    if reposArray.count != 0 {
                                        
                                        for item in reposArray {
                                            
                                            if let reposArray1 = item["sec_maincategory_list"] as? [NSDictionary] {
                                                
                                                if reposArray1.count != 0 {
                                                    print(reposArray1.count)
                                                    for item1 in reposArray1 {
                                                        
                                                        self.submoduleArray.append(SubModule(SubModule: item1))
                                                        
                                                        
                                                        //print(self.sec_category_id)
                                                        
                                                        if String((item1["sec_category_id"] as? Int)!) == self.sec_category_id {
                                                            
                                                            if let reposArray2 = item1["sub_category_list"] as? [NSDictionary] {
                                                                
                                                                if reposArray2.count != 0 {
                                                                    
                                                                    for item2 in reposArray2 {
                                                                        
                                                                        self.secondaryArray.append(SecondayCategory(SecondayCategory: item2))
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    self.flag = false
                                }
                                
                                self.toggleStatus()
                                print("here is the submodule array after array--\(self.submoduleArray.count)")
                                
                                //
                                if self.secondaryArray.count == 0 {
                                    
                                    //                                    self.secondaryTable.isHidden = true
                                    //                                    self.headerView.frame = CGRect(x: CGFloat(self.headerView.frame.origin.x), y: CGFloat(self.headerView.frame.origin.y), width: CGFloat(self.headerView.frame.size.width), height: CGFloat(50))
                                    //                                    self.topoffersTable.tableHeaderView = self.headerView
                                }
                                else {
                                    //                                    self.secondaryTable.isHidden = false
                                    //                                    self.headerView.frame = CGRect(x: CGFloat(self.headerView.frame.origin.x), y: CGFloat(self.headerView.frame.origin.y), width: CGFloat(self.headerView.frame.size.width), height: CGFloat(50))
                                    //                                    self.topoffersTable.tableHeaderView = self.headerView
                                }
                                
                                //self.subTable.reloadData()
                                self.subCatCollectionView.reloadData()
                                self.catCollectionView.reloadData()
                            }
                            
                            
                            
                            if let reposArray = parseJSON["product_top_offer"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    //  self.messageToast(messageStr: "No deals available")
                                    
                                    
                                }
                                else {
                                    for item in reposArray {
                                        self.topOffersArray.append(TopOffers(TopOffers: item))
                                    }
                                }
//                                if self.submoduleArray.count == 2{
//                                    self.upperSegment.removeSegment(at: 2, animated: true)
//                                }
                                /*self.upperSegment.removeAllSegments()
                                
                                for index in 0..<self.submoduleArray.count {
                                    
                                    print("cameg\(index)");
                                    self.upperSegment.insertSegment(withTitle: self.submoduleArray[index].sec_category_name, at: index, animated: false)
                                }*/
                                
                                
                                
                                self.catCollectionView.reloadData()
                            }
                            
                            
                        }
                        else{
                            
                            self.toggleStatus()
                            
                            //                            self.subTable.reloadData()
                            //                            self.secondaryTable.reloadData()
                            self.catCollectionView.reloadData()
                            
                            var style = ToastStyle()
                            style.messageFont = messageFont!
                            style.messageColor = UIColor.white
                            style.messageAlignment = .center
                            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                            
                            self.view.makeToast("No Data Available!", duration: 3.0, position: .center, style: style)
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
    
    func toggleStatus(){
        print("here is the submodule array--\(self.submoduleArray.count)")
        
        //
        if self.submoduleArray.count != 0 {
            
            for i in 0..<self.submoduleArray.count {
                
                if self.submoduleArray[i].sec_category_id == self.sec_category_id {
                    self.submoduleArray[i].selected_value = "1"
                }
                else {
                    self.submoduleArray[i].selected_value = "0"
                }
            }
        }
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

}
