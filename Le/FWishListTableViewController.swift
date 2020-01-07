//
//  FWishListTableViewController.swift
//  Le
//
//  Created by Asif Seraje on 12/6/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit

class FWishListTableViewController: UITableViewController {

    var mywishArray = [MyWishlist]()
    var page_no: Int! = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        let leftbutton = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(self.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        //self.navigationItem.leftBarButtonItem = LeftButton

        let reachability = Reachability()!
        
        if reachability.isReachable {
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            mywishApi()
        }
        else {
            
            showNetworkErrorAlert()
        }
    }
    
    @objc func backAction(_ sender: UIButton!) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func mywishApi() {
        
        let myUrl = URL(string: String(format:"%@api/my_wishlist", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&page_no=\(page_no!)&lang=en"
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
                            
                            if let reposArray = parseJSON["product_wish_list"] as? [NSDictionary] {
                                // 5
                                //print(reposArray)
                                if reposArray.count == 0 {
                                    
                                    if self.mywishArray.count == 0 {
                                        
                                        //self.lblNoData.isHidden = false
                                    }
                                    else {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                       // self.view.makeToast("No More Wishlist Available!", duration: 3.0, position: .bottom, style: style)
                                        self.view.makeToast(parseJSON.object(forKey: "message") as! String, duration: 3.0, position: .center, style: style)
                                    }
                                }
                                else {
                                    
                                    //self.lblNoData.isHidden = true
                                    
                                    self.page_no = self.page_no + 1
                                    
                                    for item in reposArray {
                                        self.mywishArray.append(MyWishlist(MyWishlist: item))
                                    }
                                }
                            }
                        }
                        else {
                            
                            if self.mywishArray.count == 0 {
                                
                                //self.lblNoData.isHidden = false
                            }
                            else {
                                
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                
                                self.view.makeToast("No More Wishlist Available!", duration: 3.0, position: .bottom, style: style)
                            }
                        }
                        
                        self.tableView.reloadData()
                      //  self.mywishTable.infiniteScrollingView.stopAnimating()
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mywishArray.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objProductDetails = self.storyboard?.instantiateViewController(withIdentifier: "FProductDetailsTableViewController") as! FProductDetailsTableViewController
        objProductDetails.category_name = "My Wishlist"
        objProductDetails.product_id = String(mywishArray[indexPath.row].product_id)
        UserDefaults.standard.set(String(mywishArray[indexPath.row].product_id), forKey: "temp_pro_id")

        self.navigationController?.pushViewController(objProductDetails, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishCell", for: indexPath)
        cell.textLabel?.text = mywishArray[indexPath.row].product_title
        
        cell.detailTextLabel!.numberOfLines = 0
        cell.detailTextLabel!.text = "\("৳" + mywishArray[indexPath.row].product_discount_price!)\n\(mywishArray[indexPath.row].product_discount_percentage + "% off")"
        cell.imageView?.kf.setImage(with: (StringToURL(text: mywishArray[indexPath.row].product_image)))
        cell.imageView?.image = cell.imageView?.image?.resized(toWidth:cell.contentView.bounds.width/3, height: cell.contentView.bounds.height - 2.0)
        
//        if mywishArray[indexPath.row].product_image == "" {
//            cell.imageView?.image = UIImage(named: "no-image-icon")
//        }
//        else {
//            cell.imageView?.yy_imageURL = URL(string: mywishArray[indexPath.row].product_image)
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //mywishArray.remove(at: indexPath.row)
            
            
            let myUrl = URL(string: String(format:"%@api/remove_wishlist", Api_Base_URL));
            //print(myUrl!)
            
            var request = URLRequest(url:myUrl!)
            request.httpMethod = "POST";
            
            let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(mywishArray[indexPath.row].product_id!)&lang=en"
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
                                
                                self.mywishArray.remove(at: indexPath.row)
                                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                                //self.tableView.reloadData()
                            }
                            else {
                                var style = ToastStyle()
                                style.messageFont = messageFont!
                                style.messageColor = UIColor.white
                                style.messageAlignment = .center
                                style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                self.view.makeToast(parseJSON.object(forKey: "message") as! String, duration: 3.0, position: .center, style: style)
                               // self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
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
    }

}
