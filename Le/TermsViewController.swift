//
//  TermsViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 14/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Terms"
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(TermsViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        self.navigationItem.leftBarButtonItem = LeftButton
    }

    @objc func backAction(_ sender: UIButton!) {
        
        self.navigationController!.popViewController(animated: true)
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
