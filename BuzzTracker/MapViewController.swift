//
//  MapViewController.swift
//  BuzzTracker
//
//  Created by Saurav Desai on 11/9/18.
//  Copyright © 2018 Saurav Desai. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase

class MapViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationList: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = Auth.auth().currentUser!.email
        
        let ref1 = Database.database().reference()
        ref1.child("Users").child(Auth.auth().currentUser!.uid).child("userType").observeSingleEvent(of: .value, with: { (snapshot) in
            if let tempUserType = snapshot.value as? String {
                for type in UserType.allCases {
                    if type.rawValue == tempUserType {
                        currUserType = type
                        self.userTypeLabel.text = currUserType.rawValue
                        break
                    }
                }
            }
        })
        
        var longs: [Double] = []
        var lats: [Double] = []
        for loc in locationList {
            let latitude = Double(loc.latitude);
            let longitude = Double(loc.longitude);
            let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            longs.append(longitude!)
            lats.append(latitude!)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = loc.name
            annotation.subtitle = loc.phoneNum
            mapView.addAnnotation(annotation)
        }
        
        // setting the center of the map display and the span (possibly change later for curr location)
        var sumLong = 0.0
        var sumLat = 0.0
        for i in 0..<longs.count {
            sumLong += longs[i]
            sumLat += lats[i]
        }
        let avgLong: Double = sumLong / Double(longs.count)
        let avgLat: Double = sumLat / Double(lats.count)
        let centerLocation = CLLocationCoordinate2D(latitude: avgLat + 0.07, longitude: avgLong)
        let span = MKCoordinateSpan(latitudeDelta: 0.27, longitudeDelta: 0.27)
        let region = MKCoordinateRegion(center: centerLocation, span: span)
        mapView.setRegion(region, animated: true)
    }

}
