//
//  MerchantLocationVC.swift
//  Le
//
//  Created by Akramul Haque on 18/3/19.
//  Copyright © 2019 Munesan M. All rights reserved.
//

import UIKit
import MapKit

final class ShowAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
    var region: MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        return MKCoordinateRegion(center: coordinate, span: span)
    }
}


class MerchantLocationVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lat = "\(UserDefaults.standard.string(forKey: "latitude")!)"
        print(lat)
        let long = "\(UserDefaults.standard.string(forKey: "longitude")!)"
        print(long)
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let storeCoordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
        let storeAnnotation = ShowAnnotation(coordinate: storeCoordinate, title: "Merchant Location", subtitle: "")
        mapView.addAnnotation(storeAnnotation)
        mapView.setRegion(storeAnnotation.region, animated: true)
        
        self.navigationItem.title = "Merchant Location"
    }
    
}


