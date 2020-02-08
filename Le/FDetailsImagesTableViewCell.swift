//
//  FDetailsImagesTableViewCell.swift
//  Le
//
//  Created by Asif Seraje on 2/8/20.
//  Copyright © 2020 Munesan M. All rights reserved.
//

import UIKit
protocol DetailsImagesTableViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}
class FDetailsImagesTableViewCell: UITableViewCell {
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    var productImagesArr = [ProductImages]()
    var imagesDel:DetailsImagesTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.dataSource = self
        self.productDetailsApi()
        self.imagesCollectionView.collectionViewLayout = ZoomAndSnapFlowLayout()
        startTimerForShowScrollIndicator()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var timerForShowScrollIndicator: Timer?
    @objc func showScrollIndicatorsInContacts() {
        self.imagesCollectionView.flashScrollIndicators()
        timerForShowScrollIndicator?.invalidate()
    }
    
    func startTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.showScrollIndicatorsInContacts), userInfo: nil, repeats: false)
    }

}

extension FDetailsImagesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImagesArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FDetailsImagesCollectionViewCell", for: indexPath) as! FDetailsImagesCollectionViewCell
        
        if let url = URL(string: productImagesArr[indexPath.item].images) {
            cell.productImage.kf.setImage(with: url, placeholder: nil)
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
        imagesDel?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    func productDetailsApi() {
        
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
            DispatchQueue.main.async {
                
                if (error != nil) {
                    return
                }
                do {
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    print("Here\(json!)")
                    
                    //self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            
                            if let reposArray = parseJSON.value(forKeyPath: "product_details.product_image") as? [NSDictionary] {
                                // 5
                                if reposArray.count != 0 {
                                    
                                    for item in reposArray {
                                        self.productImagesArr.append(ProductImages(ProductImages: item))
                                    }
                                    if self.productImagesArr[0].images == "" {
                                        
                                    }
                                    else {
                                        
                                    }
                                }
                            }
                            self.imagesCollectionView.reloadData()
                        }
                    }
                }
                catch {
                    
                }
            }
        })
        task.resume()
    }
    
}
