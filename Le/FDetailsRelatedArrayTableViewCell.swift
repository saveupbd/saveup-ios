//
//  FDetailsRelatedArrayTableViewCell.swift
//  Le
//
//  Created by Asif Seraje on 12/23/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit
protocol RelatedCollectionCellDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, selectedSection:Int)
}
class FDetailsRelatedArrayTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var relatedCollectionCellDelegate: RelatedCollectionCellDelegate?
    var product_id = ""
    var relatedArray = [RelatedProducts]()
    @IBOutlet weak var relatedCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.relatedCollectionView.delegate = self
        self.relatedCollectionView.dataSource = self
        self.relatedCollectionView.isScrollEnabled = false
        relatedDealsApi()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (relatedCollectionView.frame.size.width - space) / 2.0
        let widthSet:CGFloat = (relatedCollectionView.frame.size.width - space) / 2.0
        let heightSet:CGFloat = 195
        return CGSize(width: widthSet, height: heightSet)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        relatedCollectionCellDelegate?.collectionView(collectionView, didSelectItemAt: indexPath, selectedSection: indexPath.section)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedArray.count
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FLatestCollectionViewCell", for: indexPath) as! FLatestCollectionViewCell
        self.setShadowAndRoundedBorder(customCell: cell)
        cell.backgroundColor = UIColor.white
        if relatedArray[indexPath.row].product_image == "" {
            cell.productImage.image = UIImage(named: "no-image-icon")
        }
        else {
            cell.productImage.kf.setImage(with:StringToURL(text: relatedArray[indexPath.row].product_image))
            //  cell.popularImage1.yy_imageURL = URL(string: relatedArray[xyz].product_image)
        }
        //cell.productTitle.numberOfLines = 5
        cell.productTitle.text = relatedArray[indexPath.row].product_title!
        //cell.productTitle.text = relatedArray[indexPath.row].product_title
        cell.productCategory.numberOfLines = 2
        cell.productCategory.text = relatedArray[indexPath.row].merchant_name!
//        cell.cutOffPrice.text = "৳" + relatedArray[indexPath.row].product_price!
        
        if relatedArray[indexPath.row].product_type != "all_item"{
            cell.originalPrice.text = "৳" + relatedArray[indexPath.row].product_discount_price
            cell.cutOffPrice.attributedText = relatedArray[indexPath.row].product_price.strikeThrough()
            cell.offPercentage.text = relatedArray[indexPath.row].product_percentage + "% off"
        }else{
            cell.cutOffPrice.text = relatedArray[indexPath.row].product_off + "% off"
            cell.cutOffPrice.textColor = UIColor(named: "appThemeColor")
        }
        
        return cell
    }
    
    func relatedDealsApi() {
        
        let myUrl = URL(string: String(format:"%@api/product_detail_page", Api_Base_URL));
        print(myUrl!)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        var postString = ""
        var proId = UserDefaults.standard.value(forKey: "temp_pro_id") as! String
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&product_id=\(proId)&lang=en"//\(product_id!)
        }else{
            postString = "product_id=\(proId)&lang=en"//\(product_id!)
        }
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            //Got response from server
            DispatchQueue.main.async {
                
                if (error != nil) {
                    
                    //self.view.hideToastActivity()
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    print("Here\(json!)")
                    
                    //self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON.value(forKeyPath: "product_details.related_products") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    for item in reposArray {
                                        self.relatedArray.append(RelatedProducts(RelatedProducts: item))
                                    }
                                    self.relatedCollectionView.reloadData()
                                }
                            }
                        }
                    }
                }catch {
                    
                    //print(error)
                    //self.view.hideToastActivity()
                }
            }
        })
        task.resume()
    }

}
