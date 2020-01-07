//
//  FCategoriesTableViewCell.swift
//  Le
//
//  Created by Asif Seraje on 11/8/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit

protocol CategorySelectDelegate {
    func btnFoodPressed(_ sender: UIButton)
    func btnTravelPressed(_ sender: UIButton)
    func btnServicePressed(_ sender: UIButton)
    func btnBeautyPressed(_ sender: UIButton)
    func btnFitnessPressed(_ sender: UIButton)
}

class FCategoriesTableViewCell: UITableViewCell {
    
    var categoryHomeArray = [CategoryHome]()
    var catDel:CategorySelectDelegate?
    @IBOutlet weak var btnService: UIButton!
    @IBOutlet weak var btnBeauty: UIButton!
    @IBOutlet weak var btnFitness: UIButton!
    @IBOutlet weak var btnTravel: UIButton!
    @IBOutlet weak var btnFood: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hitCategoryAPI()
//        setShadowAndRoundedBorder(buttonToChange: btnFood)
//        setShadowAndRoundedBorder(buttonToChange: btnBeauty)
//        setShadowAndRoundedBorder(buttonToChange: btnTravel)
//        setShadowAndRoundedBorder(buttonToChange: btnFitness)
//        setShadowAndRoundedBorder(buttonToChange: btnService)
        //btnFood.kf.setBackgroundImage(with: StringToURL(text: categoryHomeArray[0].category_image), for: .normal)
        
        //btnFood.setImage(UIImage(named: "foodIc"), for: .normal)
        //btnFood.centerImageAndButton(0.0, imageOnTop: true)
        
        //btnTravel.setImage(UIImage(named: "travelIc"), for: .normal)
        //btnTravel.centerImageAndButton(0.0, imageOnTop: true)
        
        //btnFitness.setImage(UIImage(named: "fitnessIc"), for: .normal)
        //btnFitness.centerImageAndButton(0.0, imageOnTop: true)
        
        //btnBeauty.setImage(UIImage(named: "beautyIc"), for: .normal)
        //btnBeauty.centerImageAndButton(0.0, imageOnTop: true)
        
        //btnService.setImage(UIImage(named: "serviceIc"), for: .normal)
        //btnService.centerImageAndButton(0.0, imageOnTop: true)
        
    }
    
    func StringToURL(text: String) -> URL{
        let url : NSString = text as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        let imageURL : URL = URL(string: urlStr as String)!
        return imageURL
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnFoodPressed(_ sender: UIButton) {
        catDel?.btnFoodPressed(sender)
    }
    
    @IBAction func btnTravelPressed(_ sender: UIButton) {
        catDel?.btnTravelPressed(sender)
    }
    
    @IBAction func btnServicePressed(_ sender: UIButton) {
        catDel?.btnServicePressed(sender)
    }
    
    @IBAction func btnBeautyPressed(_ sender: UIButton) {
        catDel?.btnBeautyPressed(sender)
    }
    
    @IBAction func btnFitnessPressed(_ sender: UIButton) {
        catDel?.btnFitnessPressed(sender)
    }
    
    func setShadowAndRoundedBorder(buttonToChange:UIButton){
        //customCell.contentView.layer.cornerRadius = 10
        //buttonToChange.layer.borderWidth = 1.0
        buttonToChange.layer.cornerRadius = buttonToChange.bounds.width/8
        //buttonToChange.layer.borderColor = UIColor.white.cgColor
        //buttonToChange.layer.masksToBounds = true
        
        //buttonToChange.layer.shadowColor = UIColor.white.cgColor
        //buttonToChange.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        //customCell.layer.shadowRadius = 2.0
        //buttonToChange.layer.shadowOpacity = 1.0
        //buttonToChange.layer.masksToBounds = false
        //buttonToChange.layer.shadowPath = UIBezierPath(roundedRect:buttonToChange.bounds, cornerRadius:buttonToChange.layer.cornerRadius).cgPath
    }
    func hitCategoryAPI() {
        let reposURL = NSURL(string: String(format:"%@api/home_page", Api_Base_URL))
        
        if let JSONData = NSData(contentsOf: reposURL! as URL) {
            if let json = (try? JSONSerialization.jsonObject(with: JSONData as Data, options: [])) as? NSDictionary {
                print(json)
                
                //Category Details
                if let reposArray = json["category_details"] as? [NSDictionary]{
                    print(reposArray)
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        for item in reposArray {
                            categoryHomeArray.append(CategoryHome(CategoryHome: item))
                        }
                    }
                }
            }
        }
    }
}
extension UIButton {
    
    func centerImageAndButton(_ gap: CGFloat, imageOnTop: Bool) {
        
        guard let imageView = self.currentImage,
            let titleLabel = self.titleLabel?.text else { return }
        
        let sign: CGFloat = imageOnTop ? 1 : -1
        self.titleEdgeInsets = UIEdgeInsets(top: (imageView.size.height + gap) * sign, left: -imageView.size.width, bottom: 0, right: 0);
        
        let titleSize = titleLabel.size(withAttributes:[NSAttributedString.Key.font: self.titleLabel!.font!])
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + gap) * sign, left: 0, bottom: 0, right: -titleSize.width)
    }
}

