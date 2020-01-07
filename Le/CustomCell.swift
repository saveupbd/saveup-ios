//
//  CustomCell.swift
//  Le
//
//  Created by 2Base MacBook Pro on 14/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var countryLabel : UILabel!
    @IBOutlet weak var menuLabel : UILabel!
    @IBOutlet weak var homeView : UIView!
    @IBOutlet weak var productImage : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var titleMerchantName: UILabel!
    
    @IBOutlet weak var priceLabel : UILabel!
    @IBOutlet weak var percentageLabel : UILabel!
    @IBOutlet weak var topOfferView1 : UIView!
    @IBOutlet weak var topOfferView2 : UIView!
    @IBOutlet weak var topofferImage1 : UIImageView!
    @IBOutlet weak var topofferImage2 : UIImageView!
    @IBOutlet weak var topTitleLabel1 : UILabel!
    @IBOutlet weak var subCatMerchantName1: UILabel!
    
    @IBOutlet weak var topMerchentNameLabel: UILabel!
    
    @IBOutlet weak var topMerchantNameLabel1: UILabel!
    @IBOutlet weak var topMerchantNameLabel2: UILabel!
    
    
    @IBOutlet weak var TopTitleMerchantNmae: UILabel!
    @IBOutlet weak var topTitleLabel2 : UILabel!
    @IBOutlet weak var subCatMerchantName2: UILabel!
    
    @IBOutlet weak var topMerchantNameLbl: UILabel!
    
    
    @IBOutlet weak var topTitleLBL2MerchantName: UILabel!
    @IBOutlet weak var topPriceLabel1 : UILabel!
    @IBOutlet weak var topPriceLabel2 : UILabel!
    @IBOutlet weak var topDiscountPriceLabel1 : UILabel!
    @IBOutlet weak var topDiscountPriceLabel2 : UILabel!
    @IBOutlet weak var topPercentageLabel1 : UILabel!
    @IBOutlet weak var topPercentageLabel2 : UILabel!
    //gift tabel
    @IBOutlet weak var popularView1 : UIView!
    @IBOutlet weak var popularView2 : UIView!
    @IBOutlet weak var popularImage1 : UIImageView!
    @IBOutlet weak var popularImage2 : UIImageView!
    @IBOutlet weak var popularTitleLabel1 : UILabel!
    @IBOutlet weak var popularTitleLabel2 : UILabel!
    @IBOutlet weak var popularPriceLabel1 : UILabel!
    @IBOutlet weak var popularpercentageLabel1: UILabel!
    @IBOutlet weak var popularPercentageLabel2: UILabel!
    
    @IBOutlet weak var giftMerchantNameLbl1: UILabel!
    @IBOutlet weak var giftMerchantNameLbl2: UILabel!
    
    
    @IBOutlet weak var popularPriceLabel2 : UILabel!
    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var wishButton1 : UIButton!
    @IBOutlet weak var wishButton2 : UIButton!
    @IBOutlet weak var tapButton1 : UIButton!
    @IBOutlet weak var tapButton2 : UIButton!
    @IBOutlet weak var topallButton : UIButton!
    @IBOutlet weak var usernameLabel : UILabel!
    @IBOutlet weak var reviewtitleLabel : UILabel!
    @IBOutlet weak var reviewcommentLabel : UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet weak var lineImage : UIImageView!
    @IBOutlet weak var producttitleLabel : UILabel!
    @IBOutlet weak var colorLabel : UILabel!
    @IBOutlet weak var sizeLabel : UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var timeleftLabel1 : UILabel!
    @IBOutlet weak var timeleftLabel2 : UILabel!
    
    @IBOutlet weak var storeImage : UIImageView!
    @IBOutlet weak var storenameLabel : UILabel!
    @IBOutlet weak var dealcountLabel : UILabel!
    @IBOutlet weak var productcountLabel : UILabel!
    @IBOutlet weak var quantityLabel : UILabel!
    @IBOutlet weak var plusButton : UIButton!
    @IBOutlet weak var minusButton : UIButton!
    
    @IBOutlet weak var ordertitleLabel : UILabel!
    @IBOutlet weak var orderstatusLabel : UILabel!
    //@IBOutlet weak var orderTotalLabel: UILabel!
    @IBOutlet weak var orderTotal: UILabel!
    
    @IBOutlet var orderOwnerLabel: UILabel!
    //@IBOutlet var merchantNameLabel: UILabel!
    
    @IBOutlet weak var orderDate: UILabel!
    
    @IBOutlet weak var orderdateLabel : UILabel!
    //@IBOutlet weak var paymentLabel : UILabel!
    @IBOutlet weak var deliveryImage : UIImageView!
    @IBOutlet weak var tableImage : UIImageView!
    
    let userCalendar = Calendar.current
    
    let requestedComponent: Set<Calendar.Component> = [.day,.hour,.minute,.second]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showTimer1(toDate:String) {
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(printTime1), userInfo: toDate, repeats: true)
        timer.fire()
    }
    
    @objc func printTime1(toDate: Timer) {
        
        //print(toDate.userInfo as! String)
        
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
        let startTime = Date()
        let endTime = dateFormatter.date(from: toDate.userInfo as! String)
        //let endTime = dateFormatter.date(from: "21/04/2017 00:00:00")
        //print(startTime)
        //print(endTime!)
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: startTime, to: endTime!)
        
        var dayString = "";
        if String(format:"%d", timeDifference.day!).count == 1 {
            
            dayString = String(format:"0%d", timeDifference.day!)
        }
        else {
            dayString = String(format:"%d", timeDifference.day!)
        }
        
        var hourString = "";
        if String(format:"%d", timeDifference.hour!).count == 1 {
            
            hourString = String(format:"0%d", timeDifference.hour!)
        }
        else {
            hourString = String(format:"%d", timeDifference.hour!)
        }
        
        var minuteString = "";
        if String(format:"%d", timeDifference.minute!).count == 1 {
            
            minuteString = String(format:"0%d", timeDifference.minute!)
        }
        else {
            minuteString = String(format:"%d", timeDifference.minute!)
        }
        
        var secondString = "";
        if String(format:"%d", timeDifference.second!).count == 1 {
            
            secondString = String(format:"0%d", timeDifference.second!)
        }
        else {
            secondString = String(format:"%d", timeDifference.second!)
        }
        
        self.timeleftLabel1.text = String(format:"%@  :  %@  :  %@  :  %@", dayString, hourString, minuteString, secondString)
    }
    
    func showTimer2(toDate:String) {
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(printTime2), userInfo: toDate, repeats: true)
        timer.fire()
    }
    
    @objc func printTime2(toDate: Timer) {
                
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
        let startTime = Date()
        let endTime = dateFormatter.date(from: toDate.userInfo as! String)
        //let endTime = dateFormatter.date(from: "21/04/2017 00:00:00")
        //print(startTime)
        //print(endTime!)
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: startTime, to: endTime!)
        
        var dayString = "";
        if String(format:"%d", timeDifference.day!).count == 1 {
            
            dayString = String(format:"0%d", timeDifference.day!)
        }
        else {
            dayString = String(format:"%d", timeDifference.day!)
        }
        
        var hourString = "";
        if String(format:"%d", timeDifference.hour!).count == 1 {
            
            hourString = String(format:"0%d", timeDifference.hour!)
        }
        else {
            hourString = String(format:"%d", timeDifference.hour!)
        }
        
        var minuteString = "";
        if String(format:"%d", timeDifference.minute!).count == 1 {
            
            minuteString = String(format:"0%d", timeDifference.minute!)
        }
        else {
            minuteString = String(format:"%d", timeDifference.minute!)
        }
        
        var secondString = "";
        if String(format:"%d", timeDifference.second!).count == 1 {
            
            secondString = String(format:"0%d", timeDifference.second!)
        }
        else {
            secondString = String(format:"%d", timeDifference.second!)
        }
        
        self.timeleftLabel2.text = String(format:"%@  :  %@  :  %@  :  %@", dayString, hourString, minuteString, secondString)
    }
}
