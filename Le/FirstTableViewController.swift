//
//  FirstTableViewController.swift
//  Le
//
//  Created by Asif Seraje on 11/8/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit

class FirstTableViewController: UITableViewController,LatestCollectionCellDelegate,CategorySelectDelegate,BannersSelectDelegate,UISearchBarDelegate,TopPicksCollectionViewDelegate {
    
    
    var categoryHomeArray = [CategoryHome]()//food travel
    var bannersArray = [BannersHome]()//banner images
    var topOffersArray = [TopOffers]()//latest deals
    var fiftyPercentArray = [FiftyPercent]()//hot deals
    var popularArray = [Popular]()
    var dealsArray = [DealsHome]()
    
    @IBOutlet weak var masterSearchBar: UISearchBar!
    let reachability = Reachability()!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.masterSearchBar.delegate = self
        
        //self.dismissKeyBoardTappedOutside()
        
        
        let cartButton  = MIBadgeButton()
        cartButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        cartButton.setImage(UIImage(named: "cart-icon"), for: UIControl.State())
        cartButton.addTarget(self, action: #selector(self.cartAction(_:)), for: UIControl.Event.touchUpInside)
//        cartButton.layer.borderColor = UIColor.white.cgColor
//        cartButton.layer.borderWidth = 0.5
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        if let userName = UserDefaults.standard.object(forKey: "UserName"){
            nameLabel.text = String(format: "Hi %@!", userName as! String)
        }else{
            nameLabel.text = String(format: "Hi Guest!")
        }
        
        nameLabel.textAlignment = .right
        nameLabel.font = UIFont(name: "SanFranciscoText-Regular", size: 15)
        nameLabel.textColor = UIColor.white
        
        //let rightButton = UIBarButtonItem(customView: cartButton)
        let rightButton1 = UIBarButtonItem(customView: nameLabel)
        self.navigationItem.rightBarButtonItems = [/*rightButton,*/ rightButton1]
        
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            self.hitHomeAPI()
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    

    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.white
        style.messageAlignment = .center
        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        
        self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.masterSearchBar.showsCancelButton = false
        self.masterSearchBar.text = ""
        //self.view.endEditing(true)
        //self.createFloatingButton()
        //self.setupFloatingButton()
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.endEditing(true)
        self.masterSearchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.masterSearchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.masterSearchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            let objProduct = self.storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
            objProduct.main_category_id = ""
            objProduct.sec_category_id = ""
            objProduct.sub_category_id = ""
            objProduct.sub_sec_category_id = ""
            objProduct.category_name = searchBar.text
            objProduct.titleString = searchBar.text
            objProduct.screenString = ""
            self.navigationController?.pushViewController(objProduct, animated: true)
        }else{
            self.view.endEditing(true)
        }
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0://Category
            return 1
        case 1://Banner
            return 1
        case 2://Latest Deals Title
            return 1
        case 3://Latest Deals CollectionView
            return 1
        case 4://Hot Deals Title
            return 1
        case 5://Hot Deals Content
            if fiftyPercentArray.count != 0 {
                return fiftyPercentArray.count
            }else{
                return 1
            }
        case 6://Gift Items Title
            return 1
        case 7://Gift Items Content
//            if popularArray.count != 0 {
//                return popularArray.count
//            }else{
                return 1
            //}
        default:
            return 0
        }
    }
    
    func StringToURL(text: String) -> URL{
        let url : NSString = text as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        let imageURL : URL = URL(string: urlStr as String)!
        return imageURL
    }
    
    func setShadowAndRoundedBorder(customCell:UITableViewCell){
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableCell = UITableViewCell()
        switch indexPath.section {
        case 0://Category
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FCategoriesTableViewCell", for: indexPath) as? FCategoriesTableViewCell{
                cell.catDel = self
                cell.selectionStyle = .none
                return cell
            }
            return tableCell
        case 1://Banner
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FBannerTableViewCell", for: indexPath) as? FBannerTableViewCell{
                //cell.hitHomeBanner = true
                cell.bannerDel = self
                return cell
            }
            return tableCell
        case 2://Latest Deal Title
            tableCell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
            tableCell.textLabel?.text = "Latest Deals"
            tableCell.detailTextLabel?.text = "See All"
            return tableCell
        case 3://Latest Deals
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FLatestTableViewCell", for: indexPath) as? FLatestTableViewCell{
                cell.tag = indexPath.section
                cell.collectionCellDelegate = self
                return cell
            }
            return tableCell
        case 4://Hot Deals Title
            tableCell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
            tableCell.textLabel?.text = "Hot Deals"
            tableCell.detailTextLabel?.text = "See All"
            return tableCell
        case 5://Hot Deals
            tableCell = tableView.dequeueReusableCell(withIdentifier: "FHotDealsTableViewCell", for: indexPath) as! FHotDealsTableViewCell
            if fiftyPercentArray.count != 0 {
                self.setShadowAndRoundedBorder(customCell: tableCell)
                tableCell.textLabel?.numberOfLines = 2
                tableCell.textLabel?.text = fiftyPercentArray[indexPath.row].product_title
                tableCell.detailTextLabel!.numberOfLines = 0
                if fiftyPercentArray[indexPath.row].product_type != "all_item"{
                    tableCell.detailTextLabel!.text = "\(fiftyPercentArray[indexPath.row].merchant_name!)\n\("৳" + fiftyPercentArray[indexPath.row].product_discount_price!)\n\(fiftyPercentArray[indexPath.row].product_percentage! + "% off")"
                }else{
                    tableCell.detailTextLabel!.text = "\(fiftyPercentArray[indexPath.row].merchant_name!)\n\(fiftyPercentArray[indexPath.row].product_off! + "% off")"
                }
                
                tableCell.imageView?.kf.setImage(with: (StringToURL(text: fiftyPercentArray[indexPath.row].product_image)))
                tableCell.imageView?.image = tableCell.imageView?.image?.resized(toWidth:tableCell.contentView.bounds.width/3, height: tableCell.contentView.bounds.height - 2.0)
            }else{
                tableCell.textLabel?.text = "No items available currently"
                tableCell.textLabel?.textAlignment = .center
            }
            
            return tableCell
        case 6://Top Picks Title
            tableCell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
            tableCell.textLabel?.text = "Top Picks"
            tableCell.detailTextLabel?.text = "See All"
            return tableCell
        case 7://Top Picks
//            tableCell = tableView.dequeueReusableCell(withIdentifier: "FGiftDealsTableViewCell", for: indexPath) as! FGiftDealsTableViewCell
//            if popularArray.count != 0 {
//                tableCell.textLabel?.numberOfLines = 2
//                tableCell.textLabel?.text = popularArray[indexPath.row].product_title
//                tableCell.detailTextLabel!.numberOfLines = 0
//                tableCell.detailTextLabel!.text = "\(popularArray[indexPath.row].merchant_name!)\n\("৳" + popularArray[indexPath.row].product_discount_price!)\n\(popularArray[indexPath.row].product_percentage! + "% off")"
//                tableCell.imageView?.kf.setImage(with: (StringToURL(text: popularArray[indexPath.row].product_image)))
//                tableCell.imageView?.image = tableCell.imageView?.image?.resized(toWidth:tableCell.contentView.bounds.width/3, height: tableCell.contentView.bounds.height - 2.0)
//            }else{
//                tableCell.textLabel?.text = "No items available currently"
//                tableCell.textLabel?.textAlignment = .center
//            }
//
//            return tableCell
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FTopPicksTableViewCell", for: indexPath) as? FTopPicksTableViewCell{
                cell.tag = indexPath.section
                cell.topPicksDelegate = self
                return cell
            }
            return tableCell
        default:
            return tableCell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 125
        case 1:
            return 300
        case 2,4,6:
            return 25
        case 3,7:
            return 625
        default:
            return 100
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !reachability.isReachable{
            self.showNetworkErrorAlert()
            return
        }
        switch indexPath.section {
        case 2:
            let objProduct = self.storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
            objProduct.main_category_id = ""
            objProduct.sec_category_id = ""
            objProduct.sub_category_id = ""
            objProduct.sub_sec_category_id = ""
            objProduct.category_name = "Latest Deals"//Latest Product
            objProduct.discount = ""
            objProduct.screenString = ""
            self.navigationController?.pushViewController(objProduct, animated: true)
            UserDefaults.standard.set(true, forKey: "LatestButton")
            return
        case 4:
            let objProduct = self.storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
            objProduct.main_category_id = ""
            objProduct.sec_category_id = ""
            objProduct.sub_category_id = ""
            objProduct.sub_sec_category_id = ""
            objProduct.category_name = "Hot Deals"
            objProduct.discount = ""
            objProduct.screenString = ""
            objProduct.is_approved = 1
            objProduct.is_published = 1
            objProduct.featured = 1
            self.navigationController?.pushViewController(objProduct, animated: true)
            UserDefaults.standard.set(true, forKey: "HotButton")
            UserDefaults.standard.set(true, forKey: "forcategory")
            return
        case 5:
            let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "FProductDetailsTableViewController") as! FProductDetailsTableViewController
            objProductDetails.category_name = "Hot Deals"
            UserDefaults.standard.set(fiftyPercentArray[indexPath.row].product_id, forKey: "temp_pro_id")
            objProductDetails.product_id = fiftyPercentArray[indexPath.row].product_id
            self.navigationController?.pushViewController(objProductDetails, animated: true)
            return
        case 6:
            let objProduct = self.storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
            objProduct.main_category_id = ""
            objProduct.sec_category_id = ""
            objProduct.sub_category_id = ""
            objProduct.sub_sec_category_id = ""
            objProduct.category_name = "Gift Products"
            objProduct.sort_order_by = "1"
            objProduct.screenString = ""
            self.navigationController?.pushViewController(objProduct, animated: true)
            UserDefaults.standard.set(true, forKey: "giftButton")
            return
        case 7:
        let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "FProductDetailsTableViewController") as! FProductDetailsTableViewController
        objProductDetails.category_name = "Hot Deals"
        UserDefaults.standard.set(popularArray[indexPath.row].product_id, forKey: "temp_pro_id")
        objProductDetails.product_id = popularArray[indexPath.row].product_id
        self.navigationController?.pushViewController(objProductDetails, animated: true)
        return
        default:
            return
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, selectedSection: Int) {
        let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "FProductDetailsTableViewController") as! FProductDetailsTableViewController
        UserDefaults.standard.set(topOffersArray[indexPath.row].product_id, forKey: "temp_pro_id")
        objProductDetails.category_name = "Latest Product"
        objProductDetails.product_id = topOffersArray[indexPath.row].product_id
        self.navigationController?.pushViewController(objProductDetails, animated: true)
    }
    
    func topCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, selectedSection: Int) {
        let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "FProductDetailsTableViewController") as! FProductDetailsTableViewController
        UserDefaults.standard.set(popularArray[indexPath.row].product_id, forKey: "temp_pro_id")
        objProductDetails.category_name = "Top Picks"
        objProductDetails.product_id = popularArray[indexPath.row].product_id
        self.navigationController?.pushViewController(objProductDetails, animated: true)
    }
    
    func hitHomeAPI() {
        let reposURL = NSURL(string: String(format:"%@api/home_page", Api_Base_URL))
        
        if let JSONData = NSData(contentsOf: reposURL! as URL) {
            if let json = (try? JSONSerialization.jsonObject(with: JSONData as Data, options: [])) as? NSDictionary {
                print(json)
                
                //Category Details
                if let reposArray = json["category_details"] as? [NSDictionary]{
                    print(reposArray)
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        for item in reposArray {
                            categoryHomeArray.append(CategoryHome(CategoryHome: item))
                        }
                    }
                }
                
                //Banner Details
                if let reposArray = json["banner_details"] as? [NSDictionary]{
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        for item in reposArray {
                            bannersArray.append(BannersHome(BannersHome: item))
                        }
                    }
                }
                
                //Deal of the day Details
                if let reposArray = json["deals_of_day_details"] as? [NSDictionary] {
                    print(reposArray)
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        for item in reposArray {
                            dealsArray.append(DealsHome(DealsHome: item))
                        }
                    }
                }
                
                //Product top offers
                if let reposArray = json["product_top_offer"] as? [NSDictionary] {
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        for item in reposArray {
                            topOffersArray.append(TopOffers(TopOffers: item))
                        }
                    }
                }
                
                //Product fifty percent offers
                if let reposArray = json["product_fifty_percent"] as? [NSDictionary] {
                    
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        for item in reposArray {
                            fiftyPercentArray.append(FiftyPercent(FiftyPercent: item))
                        }
                    }
                }
                
                //Most popular offers
                if let reposArray = json["most_popular_product"] as? [NSDictionary] {
                    
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        for item in reposArray {
                            popularArray.append(Popular(Popular: item))
                        }
                    }
                }
                self.tableView.reloadData()
                self.view.hideToastActivity()
            }
        }
    }
    
    func btnFoodPressed(_ sender: UIButton) {
        if reachability.isReachable {
            let objSub = self.storyboard?.instantiateViewController(withIdentifier: "CategoryProductListViewController") as! CategoryProductListViewController
            objSub.parent_category_id = categoryHomeArray[0].category_id
            objSub.parent_category_name = categoryHomeArray[0].category_name
            
            let reposArray = categoryHomeArray[0].sub_category_list
            objSub.sec_category_id = String(reposArray[0].object(forKey: "category_id") as! NSInteger)
            self.navigationController?.pushViewController(objSub, animated: true)
        }
        else {
            self.showNetworkErrorAlert()
        }
        
    }
    
    func btnTravelPressed(_ sender: UIButton) {
        if reachability.isReachable {
            let objSub = self.storyboard?.instantiateViewController(withIdentifier: "CategoryProductListViewController") as! CategoryProductListViewController
            objSub.parent_category_id = categoryHomeArray[1].category_id
            objSub.parent_category_name = categoryHomeArray[1].category_name
            
            let reposArray = categoryHomeArray[1].sub_category_list
            objSub.sec_category_id = String(reposArray[0].object(forKey: "category_id") as! NSInteger)
            self.navigationController?.pushViewController(objSub, animated: true)
        }
        else {
            self.showNetworkErrorAlert()
        }
        
    }
    
    func btnServicePressed(_ sender: UIButton) {
        if reachability.isReachable {
            let objSub = self.storyboard?.instantiateViewController(withIdentifier: "CategoryProductListViewController") as! CategoryProductListViewController
            objSub.parent_category_id = categoryHomeArray[4].category_id
            objSub.parent_category_name = categoryHomeArray[4].category_name
            
            let reposArray = categoryHomeArray[4].sub_category_list
            objSub.sec_category_id = String(reposArray[0].object(forKey: "category_id") as! NSInteger)
            self.navigationController?.pushViewController(objSub, animated: true)
        }
        else {
            self.showNetworkErrorAlert()
        }
        
    }
    
    func btnBeautyPressed(_ sender: UIButton) {
        if reachability.isReachable {
            let objSub = self.storyboard?.instantiateViewController(withIdentifier: "CategoryProductListViewController") as! CategoryProductListViewController
            objSub.parent_category_id = categoryHomeArray[3].category_id
            objSub.parent_category_name = categoryHomeArray[3].category_name
            
            let reposArray = categoryHomeArray[3].sub_category_list
            objSub.sec_category_id = String(reposArray[0].object(forKey: "category_id") as! NSInteger)
            self.navigationController?.pushViewController(objSub, animated: true)
        }
        else {
            self.showNetworkErrorAlert()
        }
        
    }
    
    func btnFitnessPressed(_ sender: UIButton) {
        if reachability.isReachable {
            let objSub = self.storyboard?.instantiateViewController(withIdentifier: "CategoryProductListViewController") as! CategoryProductListViewController
            objSub.parent_category_id = categoryHomeArray[2].category_id
            objSub.parent_category_name = categoryHomeArray[2].category_name
            
            let reposArray = categoryHomeArray[2].sub_category_list
            objSub.sec_category_id = String(reposArray[0].object(forKey: "category_id") as! NSInteger)
            self.navigationController?.pushViewController(objSub, animated: true)
        }
        else {
            self.showNetworkErrorAlert()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FProductDetailsTableViewController") as! FProductDetailsTableViewController
        UserDefaults.standard.set(bannersArray[indexPath.item].banner_id, forKey: "temp_pro_id")
        vc.product_id = bannersArray[indexPath.item].banner_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Create the floating Button
    
    var floatButton = UIButton(type: .custom)
    func setupFloatingButton(){
        floatButton.frame = CGRect(x: 0, y: (tabBarController?.tabBar.frame.minY)! - 60 , width: self.view.frame.width/2.0, height: 50)
        floatButton.setTitle("Get Discounts", for: .normal)
        floatButton.backgroundColor = UIColor(named: "appThemeColor")
        floatButton.setImage(UIImage(named: "tick-icon"), for: .normal)
        floatButton.layer.shadowColor = UIColor.black.cgColor
        floatButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        floatButton.layer.masksToBounds = false
        floatButton.layer.shadowRadius = 2.0
        floatButton.layer.shadowOpacity = 0.5
        floatButton.layer.cornerRadius = 5
        floatButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        floatButton.layer.borderWidth = 0.8
        floatButton.center.x = self.view.center.x
        floatButton.addTarget(self,action: #selector(doThisWhenButtonIsTapped(_:)), for: .touchUpInside)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(floatButton)
        }
    }
    
    @IBAction private func doThisWhenButtonIsTapped(_ sender: Any) {
        print("Button Tapped")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard floatButton.superview != nil else {  return }
        DispatchQueue.main.async {
            self.floatButton.removeFromSuperview()
        }
        
    }
    
}
extension UIImage {
    func resized(toWidth width: CGFloat,height:CGFloat) -> UIImage? {
        //let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let canvasSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIViewController{
    func showNetworkErrorAlert() {
        let alert = UIAlertController(title: "Internet isn't reachable.", message: "Please make sure you are connected to WiFi/Cellular data.",preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UIViewController{
    func setTopLogo() {
        let topImage = UIImageView(image: UIImage(named: "header-logo"))
        self.navigationItem.titleView = topImage
    }
    
    func setNavBarButton(ofRightSide:Bool,imageName:String){
        if ofRightSide{
            let barButton = UIButton()
            let barButtonImage = UIImage(named: imageName)
            barButton.setImage(barButtonImage, for: .normal)
            let realBarButton = UIBarButtonItem(customView: barButton)
            self.navigationItem.rightBarButtonItem = realBarButton
        }else{
            let barButton = UIButton()
            let barButtonImage = UIImage(named: imageName)
            barButton.setImage(barButtonImage, for: .normal)
            let realBarButton = UIBarButtonItem(customView: barButton)
            self.navigationItem.leftBarButtonItem = realBarButton
        }
    }
}


