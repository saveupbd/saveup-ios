//
//  FDetailsVideoTableViewCell.swift
//  Le
//
//  Created by Asif Seraje on 22/4/20.
//  Copyright © 2020 Munesan M. All rights reserved.
//

import UIKit
import WebKit

class FDetailsVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var videoWebView: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        videoWebView.uiDelegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
extension FDetailsVideoTableViewCell: WKUIDelegate {

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        return WKWebView(frame: self.frame, configuration: configuration)
    }
}
