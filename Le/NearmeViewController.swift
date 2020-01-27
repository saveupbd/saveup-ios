//
//  NearmeViewController.swift
//  Le
//
//  Created by 2Base MacBook Pro on 04/05/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var currentLong = 0.0
var currentLat = 0.0

class NearmeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationText : UITextField!
    
    var nearmeArray = [NearMe]()
    var merchantArray = [String]()
 //   var merchantArray : [Int] = []

    
    var  locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        mapView.showsUserLocation = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Near by Locations"
        
        if revealViewController() != nil {
            
            let rightRevealButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu")!, style: .done, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            self.navigationItem.leftBarButtonItem = rightRevealButtonItem
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineMyCurrentLocation()
        let reachability = Reachability()!
        
        if reachability.isReachable {
            self.view.hideToastActivity()
            self.view.makeToastActivity(.center)
        }
        else{
            self.showNetworkErrorAlert()
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
        
        //user default
        //        let pervez = UserDefaults.standard.string(forKey: "lat")
        //        print(("mama i am printing --  \(pervez!)"))
        //        let rashed = UserDefaults.standard.string(forKey: "long")
        //        print("mama i am printing --  \(rashed!)")
        
        //End userdefault
        
        
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
        
        //let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&latitude=\(currentLat)&longitude=\(currentLong)&lang=en)"//\(product_id!)
        
        
        //let postString = "user_id=\(UserDefaults.standard.object(forKey: "UserID")!)&latitude=23.788788&longitude=90.403445&lang=en)"//\(product_id!)
       
        
        print("poststring -- \(postString)")
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
                                    for item in reposArray {
                                        self.nearmeArray.append(NearMe(NearMe: item))
                                        print(self.nearmeArray)
                                        print(item)
                                    }
                                    
                                    for location in self.nearmeArray {
                                        let merchant_id = location.merchant_id
                                        print(merchant_id!)
                                        let annotation = MKPointAnnotation()
                                        annotation.title = location.store_name
                                        annotation.subtitle = "Deals - " + location.product_count!
                                        _  = location.merchant_id
                                        
                                        UserDefaults.standard.set("\(location.merchant_id!)", forKey: "merchant_id")
                                        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(location.store_latitude)!, longitude: Double(location.store_longitude)!)
                                        self.mapView.addAnnotation(annotation)
                                    }
                                }
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "location-icon")
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let objStoreDetails = self.storyboard?.instantiateViewController(withIdentifier: "StoreDetailsViewController") as! StoreDetailsViewController
        //  objStoreDetails.shop_id = (view.annotation?.subtitle)!
        
        for item in nearmeArray{
            if item.store_name == view.annotation?.title as? String{
                objStoreDetails.shop_id = item.merchant_id
                break
            }
        }
        
        
        // objStoreDetails.shop_id = (view.annotation?.)
        self.navigationController?.pushViewController(objStoreDetails, animated: true)
    }
    
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        guard let annotation = view.annotation else {
//            return
//        }
//        for (index, item) in LocationList().shop.enumerated() {
//            if let title = view.annotation?.subtitle {
//                if item.name! == title! {
//                    print(index)
//                    break
//                }
//            }
//        }
    
    
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            currentLong = (locationManager.location?.coordinate.longitude)!
            currentLat = (locationManager.location?.coordinate.latitude)!
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
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
            
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            
            self.mapView.setRegion(region, animated: true)
           self.nearbyApi()
        }
    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    //        print("locations = \(locValue.latitude) \(locValue.longitude)")
    //    }

    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == locationText) {
            
            locationText.resignFirstResponder()
            
            getLatandLong(location: locationText.text!)
        }
        return true
    }
    
    func getLatandLong(location : String) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) {
            if let placemarks = $0 {
                print(placemarks)
                
                if let placemark = placemarks.first {
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    
                    let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
                    
                    self.mapView.setRegion(region, animated: true)
                }
            } else {
                print($1!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

