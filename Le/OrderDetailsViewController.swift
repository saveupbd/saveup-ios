//
//  OrderDetailsViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 18/05/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var orderTable : UITableView!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var itemsLabel : UILabel!
    @IBOutlet weak var totalLabel : UILabel!
    
    var total_amount: String!
    var shipping_details: NSDictionary!
    
    var cartArray = [CartDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Order Details"
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(OrderDetailsViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        //self.navigationItem.leftBarButtonItem = LeftButton
        
        if let reposArray = shipping_details["cart_details"] as? [NSDictionary] {
            // 5
            //print(reposArray)
            if reposArray.count != 0 {
                
                for item in reposArray {
                    cartArray.append(CartDetails(CartDetails: item))
                }
                
                dateLabel.text = cartArray[0].cart_order_date
                itemsLabel.text = String(format: "%d", cartArray.count)
                totalLabel.text = total_amount!
            }
        }
    }

    @objc func backAction(_ sender: UIButton!) {
        
        let objHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(objHome, animated: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Customize the number of rows in the table view.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cartArray.count
    }
    // Customize the appearance of table view cells.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CustomCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomCell
        
//        if cartArray[indexPath.row].cart_image == "" {
//            cell.productImage.image = UIImage(named: "no-image-icon")
//        }
//        else {
//            cell.productImage.yy_imageURL = URL(string: cartArray[indexPath.row].cart_image)
//        }
        
       // cell.producttitleLabel.text = cartArray[indexPath.row].cart_title
        
       // cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
