//
//  PlacedViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 09/05/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class PlacedViewController: UIViewController {

    @IBOutlet weak var orderView : UIView!
    @IBOutlet weak var thankLabel : UILabel!
    @IBOutlet weak var placedLabel : UILabel!
    @IBOutlet weak var amountLabel : UILabel!
    @IBOutlet weak var deliverLabel : UILabel!
    @IBOutlet weak var orderButton : UIButton!
    @IBOutlet weak var lineImage : UIImageView!
    @IBOutlet weak var shipView : UIView!
    @IBOutlet weak var addressLabel : UILabel!
    
    var total_amount: String!
    var shipping_details: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(PlacedViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        self.navigationItem.leftBarButtonItem = LeftButton
        
        let color1 = UIColor(red: 25.0/255.0, green:39.0/255.0, blue: 63.0/255.0, alpha: 1.0).cgColor
        let color2 = UIColor(red: 44.0/255.0, green: 61.0/255.0, blue: 94.0/255.0, alpha: 1.0).cgColor
        let color3 = UIColor(red: 25.0/255.0, green:39.0/255.0, blue: 63.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color1, color2, color3]
        gradientLayer.frame = orderView.bounds
        orderView.layer.addSublayer(gradientLayer)
        
        orderView.addSubview(thankLabel)
        orderView.addSubview(placedLabel)
        orderView.addSubview(lineImage)
        orderView.addSubview(amountLabel)
        orderView.addSubview(orderButton)
        orderView.addSubview(deliverLabel)
        
        amountLabel.text = String(format: "Total Amount %@", total_amount!)
        
        if let reposArray = shipping_details["cart_details"] as? [NSDictionary] {
            // 5
            if reposArray.count != 0 {
                let cart_deliery_days = String((reposArray[0].object(forKey: "cart_delivery") as? Int)!)
                self.deliverLabel.text = String(format: "Your Product will deliver on %@ working days",cart_deliery_days)
            }
        }
        
        if let reposArray = shipping_details["shipping_details"] as? [NSDictionary] {
            // 5
            if reposArray.count != 0 {
                
                var Yvalue:CGFloat = 40
                
                var addressStr = ""
                
                if reposArray[0].object(forKey: "ship_name") as? String != "" {
                    
                    addressStr += (reposArray[0].object(forKey: "ship_name") as? String)!
                }
                if reposArray[0].object(forKey: "ship_address1") as? String != "" {
                    
                    addressStr += String(format: "\n%@", (reposArray[0].object(forKey: "ship_address1") as? String)!)
                }
                if reposArray[0].object(forKey: "ship_address2") as? String != "" {
                    
                    addressStr += String(format: "\n%@", (reposArray[0].object(forKey: "ship_address2") as? String)!)
                }
                if reposArray[0].object(forKey: "ship_city_name") as? String != "" {
                    
                    addressStr += String(format: "\n%@", (reposArray[0].object(forKey: "ship_city_name") as? String)!)
                }
                if reposArray[0].object(forKey: "ship_state") as? String != "" {
                    
                    addressStr += String(format: "\n%@", (reposArray[0].object(forKey: "ship_state") as? String)!)
                }
                if reposArray[0].object(forKey: "ship_country_name") as? String != "" {
                    
                    addressStr += String(format: "\n%@", (reposArray[0].object(forKey: "ship_country_name") as? String)!)
                }
                if reposArray[0].object(forKey: "ship_postalcode") as? String != "" {
                    
                    addressStr += String(format: "\n%@", (reposArray[0].object(forKey: "ship_postalcode") as? String)!)
                }
                if reposArray[0].object(forKey: "ship_phone") as? String != "" {
                    
                    addressStr += String(format: "\nMobile: %@", (reposArray[0].object(forKey: "ship_phone") as? String)!)
                }
                
                self.addressLabel.numberOfLines = 0
                self.addressLabel.text = addressStr
                let expectedLabelSize1: CGSize = self.addressLabel.text!.boundingRect(with: CGSize(width:UIScreen.main.bounds.size.width - 20, height:9999), options: ([.usesLineFragmentOrigin, .usesFontLeading]), attributes: [
                    NSAttributedString.Key.font : self.addressLabel.font], context: nil).size
                self.addressLabel.frame = CGRect(x: CGFloat(self.addressLabel.frame.origin.x), y: CGFloat(Yvalue), width: CGFloat(self.addressLabel.frame.size.width), height: CGFloat(expectedLabelSize1.height + 10))
                
                Yvalue = Yvalue + expectedLabelSize1.height + 10
                
                Yvalue = Yvalue + 10
                
                self.shipView.frame = CGRect(x: CGFloat(self.shipView.frame.origin.x), y: CGFloat(self.shipView.frame.origin.y), width: CGFloat(self.shipView.frame.size.width), height: CGFloat(Yvalue))
                
                
            }
        }
    }

    @objc func backAction(_ sender: UIButton!) {
        
        let objHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(objHome, animated: false)
    }
    
    @IBAction func orderButton(sender:UIButton ) {
        
        let objOrderDetails = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        objOrderDetails.total_amount = self.total_amount!
        objOrderDetails.shipping_details = shipping_details
        self.navigationController?.pushViewController(objOrderDetails, animated: true)
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
