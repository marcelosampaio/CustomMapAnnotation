//
//  MapAnnotation.swift
//  CustomaMapAnnotation
//
//  Created by Marcelo on 19/05/18.
//  Copyright © 2018 Marcelo. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let color: UIColor
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, color: UIColor, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.color = color
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
