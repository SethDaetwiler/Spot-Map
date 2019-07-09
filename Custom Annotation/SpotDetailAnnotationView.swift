//
//  SpotDetailAnnotationView.swift
//  Spot Map
//
//  Created by Seth Daetwiler on 4/11/19.
//  Copyright © 2019 Seth Daetwiler. All rights reserved.
//

import UIKit
import MapKit
class SpotDetailAnnotationView: UIView  {
    @IBOutlet var backgroundButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var directionsButton: UIButton!
    @IBOutlet var editButton: UIButton!
    
    var spot: Spot!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    func configureWithSpot(spot: Spot) { // 5
        self.spot = spot
        nameLabel.text = spot.name
        descLabel.text = spot.desc
    }
    
    
    

}
