//
//  MarkerAnnotationView.swift
//  CustomaMapAnnotation
//
//  Created by Marcelo on 20/05/18.
//  Copyright © 2018 Marcelo. All rights reserved.
//

import UIKit
import MapKit


class MarkerAnnotationView: MKMarkerAnnotationView {

    // MARK: - Annotation
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? MapAnnotation else { return }
            clusteringIdentifier = annotation.locationName
            markerTintColor = annotation.color
            glyphText = annotation.title
        }
    }

}
