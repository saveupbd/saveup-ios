//
//  FLatestTableViewCell.swift
//  Le
//
//  Created by Asif Seraje on 11/8/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit
protocol LatestCollectionCellDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, selectedSection:Int)
}

class FLatestTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var collectionCellDelegate: LatestCollectionCellDelegate?
    @IBOutlet weak var latestCollectionView: UICollectionView!
    var topOffersArray = [TopOffers]()//latest deals
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.latestCollectionView.delegate = self
        self.latestCollectionView.dataSource = self
        self.latestCollectionView.isScrollEnabled = false
        self.hitLatestDealsAPI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topOffersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FLatestCollectionViewCell", for: indexPath) as! FLatestCollectionViewCell
        self.setShadowAndRoundedBorder(customCell: cell)
        cell.backgroundColor = UIColor.white
        cell.productTitle.text = topOffersArray[indexPath.row].product_title
        cell.productCategory.text = topOffersArray[indexPath.row].merchant_name
        cell.originalPrice.text = "৳" + topOffersArray[indexPath.row].product_discount_price
        cell.cutOffPrice.attributedText = topOffersArray[indexPath.row].product_price.strikeThrough()
        cell.offPercentage.text = topOffersArray[indexPath.row].product_percentage + "% off"
        cell.productImage.kf.setImage(with: (StringToURL(text: topOffersArray[indexPath.row].product_image)))
        cell.productImage.yy_imageURL = URL(string: topOffersArray[indexPath.row].product_image)
        return cell
    }
    
    
    func StringToURL(text: String) -> URL{
        let url : NSString = text as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        let imageURL : URL = URL(string: urlStr as String)!
        return imageURL
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let widthSet:CGFloat = (latestCollectionView.frame.size.width - space) / 2.0
        let heightSet:CGFloat = 195
        return CGSize(width: widthSet, height: heightSet)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionCellDelegate?.collectionView(collectionView, didSelectItemAt: indexPath, selectedSection:self.tag)
    }
    
    func setShadowAndRoundedBorder(customCell:UICollectionViewCell){
        customCell.layer.cornerRadius = 5
        customCell.layer.borderWidth = 0.9
        
        customCell.layer.borderColor = UIColor.init(named: "appThemeColor")?.cgColor
        customCell.layer.masksToBounds = true
        
        customCell.layer.shadowColor = UIColor.black.cgColor
        customCell.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        customCell.layer.shadowRadius = 3
        customCell.layer.shadowOpacity = 0.3
        customCell.layer.masksToBounds = false
        customCell.layer.shadowPath = UIBezierPath(roundedRect:customCell.bounds, cornerRadius:customCell.contentView.layer.cornerRadius).cgPath
    }
    
    func hitLatestDealsAPI() {
        let reposURL = NSURL(string: String(format:"%@api/home_page", Api_Base_URL))
        
        if let JSONData = NSData(contentsOf: reposURL! as URL) {
            if let json = (try? JSONSerialization.jsonObject(with: JSONData as Data, options: [])) as? NSDictionary {
                print(json)
                
                //Product top offers
                if let reposArray = json["product_top_offer"] as? [NSDictionary] {
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        for item in reposArray {
                            topOffersArray.append(TopOffers(TopOffers: item))
                        }
                    }
                }
                
                self.latestCollectionView.reloadData()
            }
        }
    }
    
}
extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
