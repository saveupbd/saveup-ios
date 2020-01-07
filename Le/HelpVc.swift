//
//  HelpVc.swift
//  Le
//
//  Created by Akramul Haque on 12/3/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit
import WebKit

class HelpVc: UIViewController {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        let myURL = URL(string:"https://saveupbd.com/faq")
        let myRequest = URLRequest(url: myURL!)
        webView.navigationDelegate = self as? WKNavigationDelegate
        webView.load(myRequest)


        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Help"

        if revealViewController() != nil {

            let rightRevealButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu")!, style: .done, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.navigationItem.leftBarButtonItem = rightRevealButtonItem
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    
        
    }
    
}

extension HelpVc: WKNavigationDelegate {
    func webView(_ webView: WKWebView,didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
