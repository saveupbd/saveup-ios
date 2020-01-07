//
//  PostReviewViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 06/05/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

protocol ReviewDelegate {
    
    func updateReview(json: NSDictionary)
}

class PostReviewViewController: UIViewController, FloatRatingViewDelegate {

    @IBOutlet weak var titleImage : UIImageView!
    @IBOutlet weak var commentsImage : UIImageView!
    @IBOutlet weak var titleText : UITextField!
    @IBOutlet weak var commentsText : UITextView!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet weak var postButton : UIButton!
    
    var reviewDelegate : ReviewDelegate!
    
    var rate_value: String! = "0"
    var review_id: String!
    var screen_value: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Post Review"
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(PostReviewViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        self.navigationItem.leftBarButtonItem = LeftButton
        
        titleImage.layer.cornerRadius = 5
        commentsImage.layer.cornerRadius = 5
        titleImage.layer.borderWidth = 0.5
        commentsImage.layer.borderWidth = 0.5
        titleImage.layer.borderColor = UIColor(red: 220.0/255.0, green:220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
        commentsImage.layer.borderColor = UIColor(red: 220.0/255.0, green:220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
        
        commentsText.text = "Comments"
        commentsText.textColor = UIColor.lightGray
        
        // Required float rating view params
        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.rating = 0
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = false
        self.floatRatingView.floatRatings = false
    }

    @objc func backAction(_ sender: UIButton!) {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        rate_value = NSString(format: "%.0f", self.floatRatingView.rating) as String
        //print(rate_value)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        rate_value = NSString(format: "%.0f", self.floatRatingView.rating) as String
        //print(rate_value)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comments"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.white
        style.messageAlignment = .center
        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        
        self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .top, style: style)
    }
    
    @IBAction func postButton(sender:UIButton ) {
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            if titleText.text?.count == 0 {
                
                messageToast(messageStr: "Please enter your title")
                titleText.becomeFirstResponder()
            }
            else if commentsText.text?.count == 0 {
                
                messageToast(messageStr: "Please enter your comments")
                commentsText.becomeFirstResponder()
            }
            else if (commentsText.text == "Comments"){
                
                messageToast(messageStr: "Please enter your comments")
                commentsText.becomeFirstResponder()
            }
            else {
                
                postButton.isEnabled = false
                
                self.view.hideToastActivity()
                self.view.makeToastActivity(.center)
                
                if screen_value == "Shop" {
                    
                    reviewShopApi()
                }
                else if screen_value == "Deals" {
                    
                    reviewDealApi()
                }
                else {
                    
                    reviewProductApi()
                }
            }
        }
        else {
            
            self.showNetworkErrorAlert()
        }
    }
    
    func reviewShopApi() {
        
        let myUrl = URL(string: String(format:"%@api/store_write_review", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
              postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&store_id=\(review_id!)&title=\(titleText.text!)&comments=\(commentsText.text!)&ratings=\(rate_value!)&lang=en"
        }else{
             postString = "store_id=\(review_id!)&title=\(titleText.text!)&comments=\(commentsText.text!)&ratings=\(rate_value!)&lang=en"
        }
        
        
        
        //print(postString)
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    self.view.hideToastActivity()
                    self.postButton.isEnabled = true
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    self.postButton.isEnabled = true
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            self.reviewDelegate.updateReview(json: parseJSON)
                            
                            let alert = UIAlertController(title: "Success", message: parseJSON.object(forKey: "message") as? String, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ (ACTION :UIAlertAction!)in
                                
                                self.navigationController!.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else {
                            
                            self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
                        }
                    }
                }
                catch {
                    
                    //print(error)
                    self.view.hideToastActivity()
                    self.postButton.isEnabled = true
                }
            }
        })
        task.resume()
    }
    
    func reviewDealApi() {
        
        let myUrl = URL(string: String(format:"%@api/deal_write_review", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
               postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&deal_id=\(review_id!)&title=\(titleText.text!)&comments=\(commentsText.text!)&ratings=\(rate_value!)&lang=en"
        }else{
              postString = "deal_id=\(review_id!)&title=\(titleText.text!)&comments=\(commentsText.text!)&ratings=\(rate_value!)&lang=en"
        }
        
        
        
        //print(postString)
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    self.view.hideToastActivity()
                    self.postButton.isEnabled = true
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    self.postButton.isEnabled = true
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            self.reviewDelegate.updateReview(json: parseJSON)
                            
                            let alert = UIAlertController(title: "Success", message: parseJSON.object(forKey: "message") as? String, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ (ACTION :UIAlertAction!)in
                                
                                self.navigationController!.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else {
                            
                            self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
                        }
                    }
                }
                catch {
                    
                    //print(error)
                    self.view.hideToastActivity()
                    self.postButton.isEnabled = true
                }
            }
        })
        task.resume()
    }
    
    func reviewProductApi() {
        
        let myUrl = URL(string: String(format:"%@api/product_write_review", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
                postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(review_id!)&title=\(titleText.text!)&comments=\(commentsText.text!)&ratings=\(rate_value!)&lang=en"
        }else{
               postString = "product_id=\(review_id!)&title=\(titleText.text!)&comments=\(commentsText.text!)&ratings=\(rate_value!)&lang=en"
        }
        
        
        
        //print(postString)
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    self.view.hideToastActivity()
                    self.postButton.isEnabled = true
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    self.postButton.isEnabled = true
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            self.reviewDelegate.updateReview(json: parseJSON)
                            
                            let alert = UIAlertController(title: "Success", message: parseJSON.object(forKey: "message") as? String, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ (ACTION :UIAlertAction!)in
                                
                                self.navigationController!.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else {
                            
                            self.messageToast(messageStr: parseJSON.object(forKey: "message") as! String)
                        }
                    }
                }
                catch {
                    
                    //print(error)
                    self.view.hideToastActivity()
                    self.postButton.isEnabled = true
                }
            }
        })
        task.resume()
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
