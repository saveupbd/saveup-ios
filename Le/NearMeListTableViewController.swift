//
//  NearMeListTableViewController.swift
//  Le
//
//  Created by Asif Seraje on 11/23/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit
import CoreLocation
class NearMeListTableViewController: UITableViewController,CLLocationManagerDelegate {

    var nearmeArray = [NearMe]()
    var merchantArray = [String]()
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0  // Movement threshold for new events
        _locationManager.allowsBackgroundLocationUpdates = true // allow in background

        return _locationManager
    }()
    var currentLong = 0.0
    var currentLat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = "Near Me"
        
        let leftbutton   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        leftbutton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        leftbutton.setImage(UIImage(named: "mapIcon"), for: UIControl.State())
        leftbutton.addTarget(self, action: #selector(self.showMapView(_:)), for: UIControl.Event.touchUpInside)
        
        let LeftButton = UIBarButtonItem(customView: leftbutton)
        self.navigationItem.rightBarButtonItem = LeftButton
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        DispatchQueue.main.async {
            manager.stopUpdatingLocation()
            let lat = ("\(userLocation.coordinate.latitude)")
            UserDefaults.standard.set("\(lat)", forKey: "lat")
            print(lat)
            let long = ("\(userLocation.coordinate.longitude)")
            UserDefaults.standard.set("\(long)", forKey: "long")
            print(long)
            
            print("user latitude = \(userLocation.coordinate.latitude)")
            print("user longitude = \(userLocation.coordinate.longitude)")
            
            self.currentLong = (userLocation.coordinate.longitude)
            self.currentLat = (userLocation.coordinate.latitude)
            
            //let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            
            //self.mapView.setRegion(region, animated: true)
           self.nearbyApi()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    @objc func showMapView(_ sender: UIButton!) {
        let objStoreDetails = self.storyboard?.instantiateViewController(withIdentifier: "NearmeViewController") as! NearmeViewController
        self.navigationController?.pushViewController(objStoreDetails, animated: true)
    }
    
    func determineMyCurrentLocation() {
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            
        }
    }

    func messageToast(messageStr:String) {
        
        var style = ToastStyle()
        style.messageFont = messageFont!
        style.messageColor = UIColor.black
        style.messageAlignment = .center
        style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        
        self.navigationController?.view.makeToast(messageStr, duration: 5.0, position: .top, style: style)
    }
    
    func nearbyApi() {
        
        // 1
        let reposURL = NSURL(string: String(format:"%@api/nearmemap_search", Api_Base_URL))
        var request = URLRequest(url:reposURL! as URL)
        request.httpMethod = "POST";
        
        
        print(currentLat)
        print(currentLong)
        
        var postString = ""
        if let tempUserID = UserDefaults.standard.object(forKey: "UserID"){
            postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&latitude=\(currentLat)&longitude=\(currentLong)&lang=en)"
        }else{
            postString = "latitude=\(currentLat)&longitude=\(currentLong)&lang=en)"
        }
        
        
        //let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&latitude=23.788788&longitude=90.403445&lang=en)"//\(product_id!)
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
                    print("Here near me --- \(json!)")
                    
                    self.view.hideToastActivity()
                    
                    if let parseJSON = json {
                        
                        if parseJSON.object(forKey: "status") as! NSInteger == 200 {
                            UserDefaults.standard.synchronize()
                            
                            if let reposArray = parseJSON["store_details"] as? [NSDictionary] {
                                // 5
                                print("Here is my response array for near me -- \(reposArray)")
                                if reposArray.count == 0 {
                                    
                                    var style = ToastStyle()
                                    style.messageFont = messageFont!
                                    style.messageColor = UIColor.black
                                    style.messageAlignment = .center
                                    style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                                    
                                    self.navigationController?.view.makeToast("No Stores Available!", duration: 5.0, position: .center, style: style)
                                }
                                else {
                                    self.nearmeArray.removeAll()
                                    for item in reposArray {
                                        self.nearmeArray.append(NearMe(NearMe: item))
                                        print(self.nearmeArray)
                                    }
                                    self.tableView.reloadData()
                                    
//                                    for locations in self.nearmeArray {
//                                     //   self.merchantArray.append(locations)
//                                        let merchant_id = locations.merchant_id
//                                     //   self.merchantArray.append(merchant_id!)
//                                        print(merchant_id!)
//                                    }
                                    
     
                                    
//                                    for location in self.nearmeArray {
//                                        let annotation = MKPointAnnotation()
//                                        annotation.title = location.store_name
//                                        annotation.subtitle = "Deals - " + location.product_count!
//
//                                       // annotation.subtitle = location.merchant_id!
//                                       // annotation.subtitle = "Deals - " + location.deal_count!
//                                        _  = location.merchant_id
//
//                                       //self.annotation.description = location.merchant_id
//                                        //annotation. = location.merchant_id
//
//                                        UserDefaults.standard.set("\(location.merchant_id!)", forKey: "merchant_id")
//                                        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(location.store_latitude)!, longitude: Double(location.store_longitude)!)
//                                        self.mapView.addAnnotation(annotation)
//                                    }
                                }
                                //self.tableView.reloadData()
                                self.view.hideToastActivity()
                            }
                            
                        }
                        else {
                            
                            var style = ToastStyle()
                            style.messageFont = messageFont!
                            style.messageColor = UIColor.white
                            style.messageAlignment = .center
                            style.backgroundColor = UIColor(red: 28.0/255.0, green:161.0/255.0, blue: 222.0/255.0, alpha: 1.0)
                            
                            self.view.makeToast(parseJSON.object(forKey: "message") as! String, duration: 5.0, position: .center, style: style)
                        }
                    }
                    print("Item added successfully")
                }
                catch {
                    
                    print(error.localizedDescription)
                    self.view.hideToastActivity()
                }
            }
        })
        task.resume()
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearmeArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearMeCell", for: indexPath)
        cell.textLabel?.text = nearmeArray[indexPath.row].store_name
        cell.detailTextLabel?.text = "Products:" + nearmeArray[indexPath.row].product_count
        if nearmeArray[indexPath.row].store_img == "" {
            cell.imageView?.image = UIImage(named: "no-image-icon")
        }
        else {
            cell.imageView?.kf.setImage(with: (StringToURL(text: nearmeArray[indexPath.row].store_img)), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, URL) in
                cell.imageView?.image = cell.imageView?.image?.resized(toWidth:cell.contentView.bounds.width/3.5, height: cell.contentView.bounds.height - 2.0)
                cell.setNeedsLayout()
            })
            //cell.imageView?.kf.setImage(with: (StringToURL(text: nearmeArray[indexPath.row].store_img)))
            
            //cell.imageView?.yy_imageURL = URL(string: nearmeArray[indexPath.row].store_img)
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objStoreDetails = self.storyboard?.instantiateViewController(withIdentifier: "StoreDetailsViewController") as! StoreDetailsViewController
        objStoreDetails.shop_id =  nearmeArray[indexPath.row].merchant_id
        self.navigationController?.pushViewController(objStoreDetails, animated: true)
    }
}
