//
//  FTopPicksTableViewCell.swift
//  Le
//
//  Created by Asif Seraje on 2/15/20.
//  Copyright © 2020 Munesan M. All rights reserved.
//

import UIKit

protocol TopPicksCollectionViewDelegate {
    func topCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, selectedSection:Int)
}

class FTopPicksTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    @IBOutlet weak var topPicksCollectionView: UICollectionView!
    var popularArray = [Popular]()
    var topPicksDelegate: TopPicksCollectionViewDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.topPicksCollectionView.delegate = self
        self.topPicksCollectionView.dataSource = self
        self.topPicksCollectionView.isScrollEnabled = false
        self.hitTopPicksAPI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FTopPicksCollectionViewCell", for: indexPath) as! FTopPicksCollectionViewCell
        self.setShadowAndRoundedBorder(customCell: cell)
        cell.backgroundColor = UIColor.white
        cell.productTitle.text = popularArray[indexPath.row].product_title
        cell.productCategory.text = popularArray[indexPath.row].merchant_name
        
        if popularArray[indexPath.row].product_type != "all_item"{
            cell.originalPrice.text = "৳" + popularArray[indexPath.row].product_discount_price
            cell.cutOffPrice.attributedText = popularArray[indexPath.row].product_price.strikeThrough()
            cell.offPercentage.text = popularArray[indexPath.row].product_percentage + "% off"
        }else{
            cell.cutOffPrice.text = popularArray[indexPath.row].product_off + "% off"
            cell.cutOffPrice.textColor = UIColor(named: "appThemeColor")
        }
        cell.productImage.kf.setImage(with: (StringToURL(text: popularArray[indexPath.row].product_image)))
        cell.productImage.yy_imageURL = URL(string: popularArray[indexPath.row].product_image)
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
        let widthSet:CGFloat = (topPicksCollectionView.frame.size.width - space) / 2.0
        let heightSet:CGFloat = 195
        return CGSize(width: widthSet, height: heightSet)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        topPicksDelegate?.topCollectionView(collectionView, didSelectItemAt: indexPath, selectedSection:self.tag)
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
    
    func hitTopPicksAPI() {
        let reposURL = NSURL(string: String(format:"%@api/home_page", Api_Base_URL))
        
        if let JSONData = NSData(contentsOf: reposURL! as URL) {
            if let json = (try? JSONSerialization.jsonObject(with: JSONData as Data, options: [])) as? NSDictionary {
                print(json)
                
                //Product top offers
                if let reposArray = json["most_popular_product"] as? [NSDictionary] {
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        for item in reposArray {
                            popularArray.append(Popular(Popular: item))
                        }
                    }
                }
                
                self.topPicksCollectionView.reloadData()
            }
        }
    }

}
