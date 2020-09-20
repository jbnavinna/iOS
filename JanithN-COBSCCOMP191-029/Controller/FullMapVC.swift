//
//  FullMapVC.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by user180175 on 9/17/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore
import Firebase

class FullMapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    // Used to start getting the users location
    let locationManager = CLLocationManager()
    
    
    var myLocation : CustomMapMarker!
    
    var pickedLattitude: Double = 0
    var pickedLonglitude: Double = 0
    
    var uid=""
    var userFirstName=""
    
    var userUID: String?
    
    var tempData : [TempratureDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        
        userUID = Auth.auth().currentUser?.uid
        
        db.collection("users").whereField("health", isEqualTo: "high possibility").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let documentData = document.data()
                    self.uid = documentData["uid"]! as! String
                    self.userFirstName = documentData["firstname"]! as! String
                    
                    
                    print("Username",self.userFirstName)
                    print("UID",self.uid)
                    
                    
                    
                }
                
                
            }
            
        }
        
        //locationsetup
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        myLocation = CustomMapMarker(coor: CLLocationCoordinate2D(latitude: pickedLattitude, longitude: pickedLonglitude))
        
        fetchTempratreData()
        
    }
    
    @IBAction func centerMap(_ sender: Any) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pickedLattitude, longitude: pickedLonglitude), latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    func refreshMap(){
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            if let userUID = self.userUID {
                for data in self.tempData {
                    if data.uid == userUID {
                        self.mapView.addAnnotation(self.myLocation)
                        continue
                    }
                    
                    let coord = CLLocationCoordinate2D(latitude: data.lat, longitude: data.lon)
                    let pin = CustomMapMarker(coor: coord)
                    
                    if data.temp == "35°C - 37.5°C" {
                        pin.title = "NORMAL"
                    } else {
                        pin.title = "SEVERE"
                    }
                    
                    self.mapView.addAnnotation(pin)
                    
                }
            }
            
        }
    }
    
    func fetchTempratreData(){
        let rtDBRef = Database.database().reference()
        
        rtDBRef.child("temperatureData").observeSingleEvent(of: .value, with: {
            snapshot in
            self.tempData.removeAll()
            
            if let dict = snapshot.value as? [String: Any]{
                for data in dict {
                    guard let innerData = data.value as? [String: Any] else{
                        continue
                    }
                    
                    self.tempData.append(TempratureDataModel(uid: innerData["uid"] as! String, lat: innerData["lat"] as! Double, lon: innerData["lon"] as! Double, temp: innerData["temp"] as! String))
                }
                self.refreshMap()
            }
        })
        
        rtDBRef.child("temperatureData").observe(.childChanged, with: {
            snapshot in
            rtDBRef.child("temperatureData").observeSingleEvent(of: .value, with: {
                snapshot in
                
                self.tempData.removeAll()
                
                if let dict = snapshot.value as? [String: Any]{
                    for data in dict {
                        guard let innerData = data.value as? [String: Any] else{
                            continue
                        }
                        
                        self.tempData.append(TempratureDataModel(uid: innerData["uid"] as! String, lat: innerData["lat"] as! Double, lon: innerData["lon"] as! Double, temp: innerData["temp"] as! String))
                    }
                    self.refreshMap()
                }
            })
        })
        
    }
    
    
}
extension FullMapVC {
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func locateClicked(_ sender: UIButton) {
        
        if pickedLattitude == 0 || pickedLonglitude == 0 {
            
            if let location = locationManager.location {
                let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.setRegion(viewRegion, animated: true)
            }
            
        } else {
            let viewRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pickedLattitude, longitude: pickedLonglitude), latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(viewRegion, animated: true)
        }
    }
    
    //    func refreshMapData(){
    //        DispatchQueue.main.async {
    //            for data in self.tempData{
    //
    //                if data.uid == AppUserDefaults.getUserDefault(key: UserInfoStorage.userUID) {
    //                    self.mapView.addAnnotation(self.myLocation)
    //                    continue
    //                }
    //
    //                let coord = CLLocationCoordinate2D(latitude: data.lat, longitude: data.lon)
    //                let pin = CustomMapMarker(coor: coord)
    //
    //                if data.temperature < 35 {
    //                    pin.title = "NORMAL"
    //                } else {
    //                    pin.title = "SEVERE"
    //                }
    //
    //                self.mapView.addAnnotation(pin)
    //            }
    //
    //        }
    //
    //    }
    
}
extension FullMapVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            mapView.removeAnnotation(myLocation)
            myLocation = CustomMapMarker(coor: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            myLocation.title = "ME"
            self.mapView.addAnnotation(myLocation)
            
            pickedLattitude = location.coordinate.latitude
            pickedLonglitude = location.coordinate.longitude
            let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(viewRegion, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        //alert
        //        self.present(AppPopUpDialogs.displayAlert(title: "Location error", message: error.localizedDescription), animated: true)
    }
    
}

extension FullMapVC : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        if annotation.title == "SEVERE" {
            annotationView.image =  #imageLiteral(resourceName: "marker_severe")
        }
        
        if annotation.title == "NORMAL" {
            annotationView.image =  #imageLiteral(resourceName: "marker_normal")
        }
        
        if annotation.title == "ME" {
            annotationView.image = #imageLiteral(resourceName: "marker_me")
        }
        
        annotationView.canShowCallout = true
        return annotationView
    }
    
}
