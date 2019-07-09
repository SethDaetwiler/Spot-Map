//
//  spotAnnotation.swift
//  Spot Map
//
//  Created by Seth Daetwiler on 4/11/19.
//  Copyright © 2019 Seth Daetwiler. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class spotAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var spot: Spot
    
    init(spot: Spot) {
        self.spot = spot
        coordinate = CLLocationCoordinate2D(latitude: Double(spot.lat)!, longitude: Double(spot.long)!)
        super.init()
    }
    
    var title: String? {
        return spot.name
    }
    
    
    
    

}
