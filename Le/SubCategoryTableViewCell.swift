//
//  SubCategoryTableViewCell.swift
//  Le
//
//  Created by Asif Seraje on 11/24/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit
protocol SubCollectionCellDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, selectedSection:Int)
}
class SubCategoryTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var subCollectionView: UICollectionView!
    var collectionCellDelegate: SubCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subCollectionView.delegate = self
        self.subCollectionView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FLatestCollectionViewCell", for: indexPath) as! FLatestCollectionViewCell
        self.setShadowAndRoundedBorder(customCell: cell)
//        cell.backgroundColor = UIColor.white
//        cell.productTitle.text = topOffersArray[indexPath.row].product_title
//        cell.productCategory.text = topOffersArray[indexPath.row].merchant_name
//        cell.originalPrice.text = "৳" + topOffersArray[indexPath.row].product_discount_price
//        cell.cutOffPrice.attributedText = topOffersArray[indexPath.row].product_price.strikeThrough()
//        cell.offPercentage.text = topOffersArray[indexPath.row].product_percentage + "% off"
//        cell.productImage.kf.setImage(with: (StringToURL(text: topOffersArray[indexPath.row].product_image)))
//        cell.productImage.yy_imageURL = URL(string: topOffersArray[indexPath.row].product_image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let widthSet:CGFloat = (subCollectionView.frame.size.width - space) / 2.0
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
    
    
    

}
