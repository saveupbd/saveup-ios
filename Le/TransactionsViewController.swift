//
//  TransactionsViewController.swift
//  Le
//
//  Created by Asif Seraje on 2/29/20.
//  Copyright © 2020 Munesan M. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var transactionTable: UITableView!
    var transactionsArray = [LoyalityModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transactionTable.delegate =  self
        transactionTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hitLoyalityApi()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        cell.merchantNameLabel.text = transactionsArray[indexPath.row].merchant_name
        cell.originalPriceLabel.text = transactionsArray[indexPath.row].order_total
        cell.discountedPriceLabel.text = transactionsArray[indexPath.row].user_payable_amount
        cell.savingLabel.text = transactionsArray[indexPath.row].user_savings
        cell.timeLabel.text = transactionsArray[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func hitLoyalityApi() {
        let myUrl = URL(string: String(format:"%@api/my_orders", Api_Base_URL));
        
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)"
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
        
        print("my orders value --\(postString)")
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
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        //if self.cameFromMyAcc{
                            if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                                
                                if let reposArray = parseJSON["order_list"] as? [NSDictionary] {
                                    print("my orders value ----\(reposArray)")
                                    if reposArray.count != 0 {
                                        
                                        for item in reposArray {
                                            self.transactionsArray.append(LoyalityModel(LoyalityModel: item))
                                        }
                                    }
                                }
                                
                            }
                            else {
                                
                            }
                        //}
//
//                        self.totelPoinLabel.text = String(parseJSON["total_loyality_point"] as! NSInteger)
//                        let tempSave = parseJSON["total_savings"] as! Double
//                        self.totalSavedLabel.text = "You've saved total \(String(tempSave.truncate(places: 2))) BDT!"
//                        self.totalLoyality = String(parseJSON["total_loyality_point"] as! NSInteger)
                    }
                    self.transactionTable.reloadData()
                }
                catch {
                    self.view.hideToastActivity()
                }
            }
        })
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    

}
