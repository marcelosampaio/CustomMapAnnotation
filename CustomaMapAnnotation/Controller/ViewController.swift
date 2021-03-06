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
    private var mapAnnotations = [MapAnnotation]()
    private var coordinates = [CGPoint]()
    private var demoCoordinate : CGPoint = CGPoint(x: -25.420, y: -49.270)
    private var locationManager : CLLocationManager!
    private var userLocation : CLLocation?
    private var initialLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    private var regionRadius: CLLocationDistance = 1000
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load coordinates
        loadCoordinates()
        
        // get user location
        getUserLocation()
        
        // MapView Setup
        mapViewSetup()
        
        
    }

    // MARK: - Application Data Source
    private func loadCoordinates() {
        var place : CGFloat = -49.270
        for i in 1...9 {
            let coordinate = CGPoint(x: -25.420, y: place)
            place = place + (CGFloat(i) / 1000)
            coordinates.append(coordinate)
        }
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
        
        for coordinate in coordinates {
            
            let mapAnnotation = MapAnnotation(title: "(\(coordinate.y))",
                                              locationName: "Location Name",
                                              color: UIColor.yellow,
                                              coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(coordinate.x), longitude: CLLocationDegrees(coordinate.y)))
            
            mapAnnotations.append(mapAnnotation)
            
            
        }
        
        mapView.register(MarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        // Plot all annotations
        mapView.addAnnotations(mapAnnotations)

        
    }

    
    // MARK: - Map Vew Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MapAnnotation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomPin")
            annotationView.image = UIImage(named: "placeImage")
            annotationView.layer.cornerRadius = 60
            annotationView.layer.masksToBounds = true
            annotationView.layer.borderColor = UIColor.white.cgColor
            annotationView.layer.borderWidth = 12
            annotationView.alpha = 1
            let transform = CGAffineTransform(scaleX: 0.55, y: 0.55)
            annotationView.transform = transform
            annotationView.clusteringIdentifier = "identifier"
            return annotationView
        }else if annotation is MKClusterAnnotation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomCluster")
            annotationView.image = UIImage(named: "blue")
            annotationView.layer.cornerRadius = 60
            annotationView.layer.masksToBounds = true
//            annotationView.layer.borderColor = UIColor.red.cgColor
//            annotationView.layer.borderWidth = 12
            annotationView.alpha = 1
            let transform = CGAffineTransform(scaleX: 0.55, y: 0.55)
            annotationView.transform = transform
            annotationView.clusteringIdentifier = "identifier"
            return annotationView
        }
        return MKAnnotationView()
        
    }
    
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        print("DEBUG - ### CLUSTER ####### - clusterAnnotationForMemberAnnotations count:\(memberAnnotations.count)")
        let cluster = MKClusterAnnotation(memberAnnotations: memberAnnotations)
        cluster.title = "8"
        cluster.subtitle = "subtitle"
        return cluster
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

