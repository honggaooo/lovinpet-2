//
//  MapViewController.swift
//  lovinpet
//
//  Created by Hong Gao on 2017/11/18.
//  Copyright © 2017年 Hong Gao. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let ref = Database.database().reference()
    var annotations = [MKPointAnnotation]()

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        
        ref.child("locations")
            .observe(.value, with: { (snapshot: DataSnapshot) in
                self.mapView.removeAnnotations(self.annotations)
                self.annotations.removeAll()
                
                
                for item in snapshot.children {
                    let ele: DataSnapshot = item as! DataSnapshot
                    
                    if ele.key != Global.sharedInstance.user.uid {
                        let snapshotValue = ele.value as! [String: AnyObject]
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: snapshotValue["lat"] as! Double, longitude: snapshotValue["long"] as! Double)
                        annotation.title = snapshotValue["email"] as? String
                        
                        self.annotations.append(annotation)
                        self.mapView.addAnnotation(annotation)
                    }
                }
            })
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let coor = location?.coordinate
        
        ref.child("locations").child(Global.sharedInstance.user.uid).setValue(["lat": coor?.latitude ?? 0, "long": coor?.longitude ?? 0, "email": Global.sharedInstance.user.email ?? ""]) { (error, ref) in
            if error != nil {
                print("error: \(error!.localizedDescription)")
            }
        }
        
        centerMapOnLocation(location: location!)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
