//
//  RedemptionViewController.swift
//  Le
//
//  Created by Asif Seraje on 21/3/20.
//  Copyright © 2020 Munesan M. All rights reserved.
//

import UIKit

class RedemptionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var redempTableView: UITableView!
    
    var remdemTableArray = [""]
    var remdemTableImgArray = [""]
    
    override func viewDidLoad() {
        redempTableView.delegate = self
        redempTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        remdemTableArray = ["Redeem by Mobile Recharge","Redeem by bKash"]
        remdemTableImgArray = ["recharge","bkash"]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remdemTableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "RedemptionTableViewCell", for: indexPath) as! RedemptionTableViewCell
        tableCell.redemImgView.image = UIImage(named: remdemTableImgArray[indexPath.row])
        tableCell.redemLabel.text = remdemTableArray[indexPath.row]
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedemOptionsViewController" ) as! RedemOptionsViewController
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    

}
