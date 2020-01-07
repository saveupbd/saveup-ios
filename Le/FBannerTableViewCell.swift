//
//  FBannerTableViewCell.swift
//  Le
//
//  Created by Asif Seraje on 11/8/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit
protocol BannersSelectDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}
class FBannerTableViewCell: UITableViewCell {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    var bannersArray = [BannersHome]()
    var bannerDel:BannersSelectDelegate?
    @IBOutlet weak var pageControlBanner: UIPageControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hitBannersAPI()
        self.bannerCollectionView.delegate = self
        self.bannerCollectionView.dataSource = self
        self.bannerCollectionView.collectionViewLayout = ZoomAndSnapFlowLayout()
        startTimerForShowScrollIndicator()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func hitBannersAPI() {
        let reposURL = NSURL(string: String(format:"%@api/home_page", Api_Base_URL))
        
        if let JSONData = NSData(contentsOf: reposURL! as URL) {
            if let json = (try? JSONSerialization.jsonObject(with: JSONData as Data, options: [])) as? NSDictionary {
                print(json)
                
                //Product top offers
                if let reposArray = json["banner_details"] as? [NSDictionary] {
                    if reposArray.count == 0 {
                        
                    }
                    else {
                        for item in reposArray {
                            bannersArray.append(BannersHome(BannersHome: item))
                        }
                    }
                }
                
                self.bannerCollectionView.reloadData()
            }
        }
    }
    
    var timerForShowScrollIndicator: Timer?
    @objc func showScrollIndicatorsInContacts() {
        self.bannerCollectionView.flashScrollIndicators()
        timerForShowScrollIndicator?.invalidate()
    }
    
    func startTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.showScrollIndicatorsInContacts), userInfo: nil, repeats: false)
    }
    

}
extension FBannerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannersArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
        
        if let url = URL(string: bannersArray[indexPath.item].banner_image) {
            cell.imageView.kf.setImage(with: url, placeholder: nil)
        }
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        currentIndex = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
//        pageControl.currentPage = currentIndex
//        searchText.resignFirstResponder()
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        bannerDel?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
}
