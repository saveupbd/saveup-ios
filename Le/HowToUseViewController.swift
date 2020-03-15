//
//  HowToUseViewController.swift
//  Le
//
//  Created by Asif Seraje on 15/3/20.
//  Copyright © 2020 Munesan M. All rights reserved.
//

import UIKit

class HowToUseViewController: UIViewController {

    var imageList:[String] = ["firstImg", "secondImg", "thirdImg","fourthImg", "fifthImg","sixthImg"]
    let maxImages = 5
    var imageIndex: NSInteger = 0
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(getSwipedUp(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)

        var swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(getSwipedUp(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)

        imgView.image = UIImage(named:"firstImg")
    }
    
    @objc func getSwipedUp(gesture: UISwipeGestureRecognizer){

        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizer.Direction.right :
                print("User swiped right")
                
                // decrease index first
                
                imageIndex = imageIndex - 1
                
                // check if index is in range
                
                if imageIndex < 0 {
                    
                    imageIndex = maxImages
                    
                }
                
                imgView.image = UIImage(named: imageList[imageIndex])
                
            case UISwipeGestureRecognizer.Direction.left:
                print("User swiped Left")
                
                // increase index first
                
                imageIndex = imageIndex + 1
                
                // check if index is in range
                
                if imageIndex > maxImages {
                    
                    imageIndex = 0
                    
                }
                
                imgView.image = UIImage(named: imageList[imageIndex])
                
                
                
                
            default:
                break //stops the code/codes nothing.
                
                
            }
            
        }
    }

}
