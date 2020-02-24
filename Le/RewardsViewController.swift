//
//  RewardsViewController.swift
//  Le
//
//  Created by Asif Seraje on 2/1/20.
//  Copyright © 2020 Munesan M. All rights reserved.
//

import UIKit

class RewardsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var btnRedeem: UIButton!
    @IBOutlet weak var totelPoinLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var pointView: UIView!
    @IBOutlet weak var totalSavedLabel: UILabel!
    @IBOutlet weak var listTableHeaderLabel: UILabel!
    
    var totalLoyality:String?
    var transactionsArray = [LoyalityModel]()
    var cameFromMyAcc = false
    var offersArray:[String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        setShadowAndRoundedBorder(ofView: pointView)
        
        btnRedeem.layer.cornerRadius = 5
        btnRedeem.layer.borderWidth = 0.9
        btnRedeem.layer.borderColor = UIColor.white.cgColor
        
        listTableView.layer.cornerRadius = 5
        listTableView.layer.borderWidth = 0.9
        listTableView.layer.borderColor = UIColor(named: "appThemeColor")?.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !cameFromMyAcc {
            offersArray = ["50 BDT Phone Recharge","100 BDT Phone Recharge","100 BDT bKash"]
            listTableHeaderLabel.text = "Loyality Offers"
        }else{
            listTableHeaderLabel.text = "History"
        }
        hitLoyalityApi()
        
//        if totalLoyality != nil{
//            totelPoinLabel.text = totalLoyality
//            btnRedeem.isEnabled = true
//            btnRedeem.alpha = 1.0
//        }else{
//            totelPoinLabel.text = "----"
//            btnRedeem.isEnabled = false
//            btnRedeem.alpha = 0.5
//        }
        
    }
    
    
    func setShadowAndRoundedBorder(ofView:UIView){
        ofView.layer.cornerRadius = 5
        ofView.layer.borderWidth = 0.9
        
        ofView.layer.borderColor = UIColor.init(named: "appThemeColor")?.cgColor
        ofView.layer.masksToBounds = true
        
        ofView.layer.shadowColor = UIColor.black.cgColor
        ofView.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        ofView.layer.shadowRadius = 3
        ofView.layer.shadowOpacity = 0.9
        ofView.layer.masksToBounds = false
        ofView.layer.shadowPath = UIBezierPath(roundedRect:ofView.bounds, cornerRadius:ofView.layer.cornerRadius).cgPath
    }
    
    @IBAction func btnRedeemPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoresViewController" ) as! StoresViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !cameFromMyAcc{
            return offersArray!.count
        }
        return transactionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rewardCell", for: indexPath)
        if !cameFromMyAcc{
            cell.textLabel?.text = offersArray?[indexPath.row]
            cell.detailTextLabel?.text = ""
        }else{
            cell.textLabel?.text = transactionsArray[indexPath.row].merchant_name
            cell.detailTextLabel?.text = transactionsArray[indexPath.row].order_total! + " BDT"
        }
        return cell
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
                        if self.cameFromMyAcc{
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
                        }
                        
                        self.totelPoinLabel.text = String(parseJSON["total_loyality_point"] as! NSInteger)
                        let tempSave = parseJSON["total_savings"] as! Double
                        self.totalSavedLabel.text = "You've saved total \(String(tempSave.truncate(places: 2))) BDT!"
                        self.totalLoyality = String(parseJSON["total_loyality_point"] as! NSInteger)
                    }
                    self.listTableView.reloadData()
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
extension Double{
    func truncate(places : Int)-> Double{
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
    
}
