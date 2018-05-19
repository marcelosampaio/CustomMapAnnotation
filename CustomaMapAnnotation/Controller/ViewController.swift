//
//  ViewController.swift
//  CustomaMapAnnotation
//
//  Created by Marcelo on 19/05/18.
//  Copyright © 2018 Marcelo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // MARK: - Properties
    private var demoCoordinate : CGPoint = CGPoint(x: -25.4277800, y: -49.2730600)
    private var locationManager : CLLocationManager!
    private var userLocation : CLLocation?
    private var initialLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    private var regionRadius: CLLocationDistance = 1000
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get user location
        getUserLocation()
        
        // MapView Setup
        mapViewSetup()
        
        
    }

    // MARK: - MapView SetUp
    private func mapViewSetup() {
        initialLocation = CLLocation(latitude: CLLocationDegrees(demoCoordinate.x), longitude: CLLocationDegrees(demoCoordinate.y))
        centerMapOnLocation(location: initialLocation)
        plotCoordinateOnMap()
        
        
    }
    
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func plotCoordinateOnMap(){
        let mapAnnotation = MapAnnotation(title: "Title",
                                          locationName: "Location Name",
                                          discipline: "Discipline",
                                          coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(demoCoordinate.x), longitude: CLLocationDegrees(demoCoordinate.y)))
        mapView.addAnnotation(mapAnnotation)
        
    }

    
    // MARK: - Map Vew Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomPin")
        annotationView.image = UIImage(named: "placeImage")
        annotationView.layer.cornerRadius = 60
        annotationView.layer.masksToBounds = true
        annotationView.layer.borderColor = UIColor.white.cgColor
        annotationView.layer.borderWidth = 12
        annotationView.alpha = 1
        let transform = CGAffineTransform(scaleX: 0.55, y: 0.55)
        annotationView.transform = transform
        return annotationView
    }
    
    //MARK: - Map Helper
    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("🗺 start update location")
            locationManager.startUpdatingLocation()
            //            locationManager.startUpdatingHeading()
        }
    }
    
    // MARK: - Core Location Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        manager.stopUpdatingLocation()
        
        print("🗺 user latitude = \(String(describing: userLocation?.coordinate.latitude))")
        print("🗺 user longitude = \(String(describing: userLocation?.coordinate.longitude))")
        
//        // load container data
//        let mapContainerTransientData = getMapContainerTransientData(page: 0)
//        NotificationCenter.default.post(name: Notification.Name("willLoadContainerDetailData"), object: mapContainerTransientData, userInfo: nil)
//
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                    print("location auth did change ‼️")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("🗺 Location Manager Error \(error)")
    }
    
    

}

