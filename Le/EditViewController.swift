//
//  EditViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 27/04/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

protocol EditProfileDelegate {
    
    func myaccountApi()
}

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var eidtScroll : UIScrollView!
    @IBOutlet weak var editView : UIView!
    @IBOutlet weak var editImage : YYAnimatedImageView!
    @IBOutlet weak var nameText : UITextField!
    @IBOutlet weak var emailText : UITextField!
    @IBOutlet weak var phoneText : UITextField!
    @IBOutlet weak var addphotoButton : UIButton!
    @IBOutlet weak var updateButton : UIButton!
    
    var editProfileDelegate : EditProfileDelegate!
    var picker:UIImagePickerController?=UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Edit Profile"
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "back-icon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(EditViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        self.navigationItem.leftBarButtonItem = LeftButton
        
        eidtScroll.contentSize = CGSize(width:UIScreen.main.bounds.size.width, height:500)
        
        let color1 = UIColor(red: 25.0/255.0, green:39.0/255.0, blue: 63.0/255.0, alpha: 1.0).cgColor
        let color2 = UIColor(red: 44.0/255.0, green: 61.0/255.0, blue: 94.0/255.0, alpha: 1.0).cgColor
        let color3 = UIColor(red: 25.0/255.0, green:39.0/255.0, blue: 63.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color1, color2, color3]
        gradientLayer.frame = editView.bounds
        editView.layer.addSublayer(gradientLayer)
        
        editView.addSubview(editImage)
        editView.addSubview(addphotoButton)
     
        nameText.attributedPlaceholder! = NSAttributedString(string: "Name", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font :nameText.font!])
        phoneText.attributedPlaceholder! = NSAttributedString(string: "Mobile", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font :phoneText.font!])
        emailText.attributedPlaceholder! = NSAttributedString(string: "Email ID", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font :emailText.font!])
        
        let scrollGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleTap))
        scrollGesture.delegate = self
        eidtScroll.addGestureRecognizer(scrollGesture)
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
            
            myaccountApi()
        }
        else {
            
            showNetworkErrorAlert()
        }
    }

    @objc func backAction(_ sender: UIButton!) {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        // Resign keypads
        nameText.resignFirstResponder()
        emailText.resignFirstResponder()
        phoneText.resignFirstResponder()
    }
    
    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.black
        style.messageAlignment = .center
        style.backgroundColor = UIColor.white
        
        self.navigationController?.view.makeToast(messageStr, duration: 3.0, position: .center, style: style)
    }
    
    func myaccountApi() {
        
        let myUrl = URL(string: String(format:"%@api/my_account", Api_Base_URL));
        //print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&lang=en"
        //print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    self.view.hideToastActivity()
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //print("Here\(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON.object(forKey: "user_details") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    self.editImage.layer.cornerRadius = self.editImage.frame.size.width / 2
                                    self.editImage.yy_imageURL = URL(string: reposArray[0].object(forKey: "user_image") as! String)
                                    self.nameText.text = reposArray[0].object(forKey: "user_name") as? String
                                    self.phoneText.text = reposArray[0].object(forKey: "user_phone") as? String
                                    self.emailText.text = reposArray[0].object(forKey: "user_email") as? String
                                }
                            }
                        }
                        else {
                            
                            var style = ToastStyle()
                            style.messageFont = messageFont!
                            style.messageColor = UIColor.white
                            style.messageAlignment = .center
                            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                            
                            self.view.makeToast("No Data Available!", duration: 3.0, position: .center, style: style)
                        }
                    }
                }
                catch {
                    
                    //print(error)
                    self.view.hideToastActivity()
                }
            }
        })
        task.resume()
    }
    
    @IBAction func addphotoButton(sender:UIButton ) {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Photo", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            picker!.sourceType = UIImagePickerController.SourceType.camera
            self .present(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    
    func openGallary()
    {
        picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(picker!, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //print("Dismissed")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        let newSize: CGSize = CGSize(width: CGFloat(UIScreen.main.bounds.size.width * 2), height: CGFloat(UIScreen.main.bounds.size.width * 2))
        UIGraphicsBeginImageContext(newSize)
        // Tell the old image to draw in this new context, with the desired
        // new size
        selectedImage.draw(in: CGRect(x:0, y:0, width:newSize.width, height:newSize.height))
        // Get the new image from the context
        let croppedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        // End the context
        UIGraphicsEndImageContext()
        
        editImage.image = croppedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateButton(sender:UIButton ) {
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            
            if nameText.text?.count == 0 {
                
                messageToast(messageStr: Name_Message)
                nameText.becomeFirstResponder()
            }
            else if emailText.text?.count == 0 {
                
                messageToast(messageStr: Email_Message)
                emailText.becomeFirstResponder()
            }
            else if isValidEmail(emailText.text!) == false {
                
                messageToast(messageStr: Valid_Email_Message)
                emailText.becomeFirstResponder()
            }
            else if phoneText.text?.count == 0 {
                
                messageToast(messageStr: Phone_Message)
                phoneText.becomeFirstResponder()
            }
            else {
                
                updateButton.isEnabled = false
                
                self.view.hideToastActivity()
                self.view.makeToastActivity(.center)
                
                updateApi()
            }
        }
        else {
            
            showNetworkErrorAlert()
        }
    }
    
    func updateApi() {
        
        let myUrl = URL(string: String(format:"%@api/update_my_account", Api_Base_URL));
        //print("myurl\(String(describing: myUrl))")
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        let param = [
            "user_id"  : UserDefaults.standard.object(forKey: "UserID")!,
            "user_name"    : nameText.text!,
            "user_email"  : emailText.text!,
            "user_phone"    : phoneText.text!,
            "lang" : "en"
        ]
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = editImage.image!.jpegData(compressionQuality: 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "profile_image", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            DispatchQueue.main.async {
                if error != nil {
                    
                    self.updateButton.isEnabled = true
                    self.view.hideToastActivity()
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    //print("here\(String(describing: json))")
                    self.updateButton.isEnabled = true
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            self.editProfileDelegate.myaccountApi()
                            
                            let alert = UIAlertController(title: "Success", message: "User details updated successfully!", preferredStyle: UIAlertController.Style.alert)
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
                catch
                {
                    self.updateButton.isEnabled = true
                    self.view.hideToastActivity()
                    //print(error)
                }
            }
        }
        
        task.resume()
    }
    
    func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageDataKey as Data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        return body
    }
    
    func generateBoundaryString() -> String {
        // Create and return a unique string.
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        
        let emailRegEx = "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == nameText) {
            
            nameText.resignFirstResponder()
        }
        else if (textField == emailText) {
            
            emailText.resignFirstResponder()
        }
        else if (textField == phoneText) {
            
            phoneText.resignFirstResponder()
        }
        
        return true
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
