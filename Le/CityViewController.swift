//
//  CityViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 14/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

protocol CityDelegate {
    
    func updateCity(cityName: String, cityId:String)
}

class CityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cityTable : UITableView!
    
    var cityArray = [City]()
    var cityDelegate : CityDelegate!
    var countryId:NSInteger!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "City"
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(CityViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        self.navigationItem.leftBarButtonItem = LeftButton
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            cityApi()
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }

    func cityApi() {
        
        // 1
        let reposURL = NSURL(string: String(format:"%@api/country_city_list?lang=en", Api_Base_URL))
        // 2
        if let JSONData = NSData(contentsOf: reposURL! as URL) {
            // 3
            if let json = (try? JSONSerialization.jsonObject(with: JSONData as Data, options: [])) as? NSDictionary {
                //print(json)
                // 4
                if let reposArray = json["country_details"] as? [NSDictionary] {
                    // 5
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        
                        for item in reposArray {
                            
                            if item["country_id"] as! NSInteger == countryId {
                                
                                if let reposArray1 = item["city_details"] as? [NSDictionary] {
                                    
                                    if reposArray1.count == 0 {
                                        
                                        var style = ToastStyle()
                                        style.messageFont = messageFont!
                                        style.messageColor = UIColor.white
                                        style.messageAlignment = .center
                                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                        
                                        self.navigationController?.view.makeToast("No City Available!", duration: 3.0, position: .center, style: style)
                                    }
                                    else {
                                        for item1 in reposArray1 {
                                            
                                            cityArray.append(City(City: item1))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    cityTable!.reloadData()
                    self.view.hideToastActivity()
                }
            }
        }
    }
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CustomCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
        
        cell.countryLabel.text = cityArray[indexPath.row].city_name
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cityDelegate.updateCity(cityName: cityArray[indexPath.row].city_name, cityId: String(cityArray[indexPath.row].city_id))
        self.navigationController!.popViewController(animated: true)
    }
    
    @objc func backAction(_ sender: UIButton!) {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.white
        style.messageAlignment = .center
        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        
        self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .center, style: style)
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
