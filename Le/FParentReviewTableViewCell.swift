//
//  FParentReviewTableViewCell.swift
//  Le
//
//  Created by Asif Seraje on 16/5/20.
//  Copyright © 2020 Munesan M. All rights reserved.
//

import UIKit

class FParentReviewTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableReviewF: UITableView!
    var reviewArray = [Review]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableReviewF.delegate = self
        tableReviewF.dataSource = self
        
        hitReviewAPI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "FReviewTableViewCell", for: indexPath) as! FReviewTableViewCell
        tableCell.rvwName.text = self.reviewArray[indexPath.row].user_name
        tableCell.rvwText.text = self.reviewArray[indexPath.row].review_comments
        tableCell.selectionStyle = .none
        if let stars = self.reviewArray[indexPath.row].ratings{
            switch stars {
            case "1":
                tableCell.rvwImgView.image = UIImage(named: "1star")
            case "2":
                tableCell.rvwImgView.image = UIImage(named: "2star")
            case "3":
                tableCell.rvwImgView.image = UIImage(named: "3star")
            case "4":
                tableCell.rvwImgView.image = UIImage(named: "4star")
            case "5":
                tableCell.rvwImgView.image = UIImage(named: "5star")
            default:
                tableCell.rvwImgView.image = nil
            }
        }
        
        return tableCell
    }
    
    func hitReviewAPI() {
        
        let myUrl = URL(string: String(format:"%@api/product_detail_page", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        var postString = ""
        var proId = UserDefaults.standard.value(forKey: "temp_pro_id") as! String
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(proId)&lang=en"//\(product_id!)
        }else{
            postString = "product_id=\(proId)&lang=en"//\(product_id!)
        }
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    print("Here\(json!)")
                    
                    //self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            if let reposArray = parseJSON.value(forKeyPath: "product_details.product_review") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.reviewArray.append(Review(Review: item))
                                    }
                                    self.tableReviewF.reloadData()
                                }
                            }
                        }
                    }
                }catch {
                    print("error from ***FParentReviewTableViewCell")
                }
            }
        })
        task.resume()
        
    }

}
