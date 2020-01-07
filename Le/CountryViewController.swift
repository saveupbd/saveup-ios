//
//  CountryViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 14/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

protocol CountryDelegate {
    
    func updateCountry(countryName: String, countryId:String)
}

class CountryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var countryTable : UITableView!
    
    var countryArray = [Country]()
    var countryDelegate : CountryDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Country"
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(CountryViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        self.navigationItem.leftBarButtonItem = LeftButton
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            countryApi()
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }

    func countryApi() {
        
        // 1
        let reposURL = NSURL(string: String(format:"%@api/country_city_list?lang=en", Api_Base_URL))
        // 2
        if let JSONData = NSData(contentsOf: reposURL! as URL) {
            // 3
            if let json = (try? JSONSerialization.jsonObject(with: JSONData as Data, options: [])) as? NSDictionary {
                // 4
                if let reposArray = json["country_details"] as? [NSDictionary] {
                    // 5
                    if reposArray.count == 0 {
                        
                        var style = ToastStyle()
                        style.messageFont = messageFont!
                        style.messageColor = UIColor.white
                        style.messageAlignment = .center
                        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                        
                        self.navigationController?.view.makeToast("No Country Available!", duration: 3.0, position: .center, style: style)
                    }
                    else {
                        for item in reposArray {
                            countryArray.append(Country(Country: item))
                        }
                    }
                    countryTable!.reloadData()
                    self.view.hideToastActivity()
                }
            }
        }
    }
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return countryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CustomCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
        
        cell.countryLabel.text = countryArray[indexPath.row].country_name
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        countryDelegate.updateCountry(countryName: countryArray[indexPath.row].country_name, countryId: String(countryArray[indexPath.row].country_id))
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
