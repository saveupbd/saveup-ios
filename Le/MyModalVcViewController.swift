//
//  MyModalVc.swift
//  categoryFilter
//
//  Created by Akramul Haque on 3/4/19.
//  Copyright © 2019 AABPD. All rights reserved.
//

import UIKit

class MyModalVc: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let myController = ProductViewController()
    @IBOutlet weak var tableView: UITableView!
    
    var listData = [MyCategoryName]()
    
    let Api_Base_URL = "https://saveupbd.com/"
    // var listData = [[String: AnyObject]] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productApiTwo()
        // Do any additional setup after loading the view.
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = self.listData[indexPath.row]
        cell.textLabel?.text = listData[indexPath.row].category_name // item["category_name"] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Filter"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        vc.categoryIdForFilter = listData[indexPath.row].category_id
        let value = vc.categoryIdForFilter
       // UserDefaults.standard.set("TEST", forKey: "Key")
        print(value!)
        UserDefaults.standard.set("value", forKey: "id")
       //  self.navigationController?.pushViewController(vc, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    //Mark: Filter
    
    func productApiTwo() {
        
        let myUrl = URL(string: String(format:"%@api/latest_product_all", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "is_approved=1&is_published=1"
        
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    //   self.view.hideToastActivity()
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    print("Here\(json!)")
                    
                    // self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON["category_details"] as? [NSDictionary] {
                                // self.tableView.reloadData()
                                // 5
                                for item in reposArray {
                                    self.listData.append(MyCategoryName(Products: item))
                                    //   self.listData.append(item["category_name"] as? AnyObject as! [String : AnyObject])
                                    //                                        var rashed = item["category_name"]
                                    //                                     print("All name are here-- \(rashed)")
                                }
                                // print(reposArray)
                                self.tableView.reloadData()
                                if reposArray.count == 0 {
                                    
                                    
                                    
                                    
                                    //       if self.productsArray.count == 0 {
                                    
                                    //                                        var style = ToastStyle()
                                    //                                        style.messageFont = messageFont!
                                    //                                        style.messageColor = UIColor.white
                                    //                                        style.messageAlignment = .center
                                    //                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                    
                                    //                                       self.view.makeToast("No Products Available!", duration: 3.0, position: .center, style: style)
                                    //                          }
                                    //                      else {
                                    
                                    //                                        var style = ToastStyle()
                                    //                                        style.messageFont = messageFont!
                                    //                                        style.messageColor = UIColor.white
                                    //                                        style.messageAlignment = .center
                                    //                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                    //
                                    //                                        self.view.makeToast("No More Products Available!", duration: 3.0, position: .bottom, style: style)
                                    //                        }
                                }
                                else {
                                    
                                    //                                    self.page_no = self.page_no + 1
                                    
                                    
                                }
                            }
                        }
                        
                        //     self.productTable.reloadData()
                        self.tableView.reloadData()
                        
                    }
                }
                catch {
                    
                    //print(error)
                    //     self.view.hideToastActivity()
                }
            }
        })
        task.resume()
    }
    
//end
    
    
    
    
}
