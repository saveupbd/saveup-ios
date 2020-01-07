//
//  ViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 02/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            categoryApi()
        }
        var rootVC : UIViewController?
        
        if UserDefaults.standard.string(forKey: "AppStatus") == "AppInside"{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RootTabBarController")
        }else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        
//        if UserDefaults.standard.string(forKey: "AppStatus") == "AppInside" {
//
//            let gotoLogin = self.storyboard!.instantiateViewController(withIdentifier: "HomeViewController")
//            self.navigationController!.pushViewController(gotoLogin, animated: false)
//        }
//        else {
//
//            let gotoLogin = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
//            self.navigationController!.pushViewController(gotoLogin, animated: false)
//        }
    }
    
    func categoryApi() {
        
        // 1
        let reposURL = NSURL(string: String(format:"%@api/category_list?lang=en", Api_Base_URL))
        // 2
        if let JSONData = NSData(contentsOf: reposURL! as URL) {
            // 3
            if let json = (try? JSONSerialization.jsonObject(with: JSONData as Data, options: [])) as? NSDictionary {
                //print(json)
                // 4
                if let reposArray = json["categories_list"] as? [NSDictionary] {
                    // 5
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        UserDefaults.standard.set(reposArray, forKey: "Categories")
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

