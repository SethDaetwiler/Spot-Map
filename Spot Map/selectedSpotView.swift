//
//  selectedSpotView.swift
//  Spot Map
//
//  Created by Seth Daetwiler on 3/11/19.
//  Copyright © 2019 Seth Daetwiler. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class selectedSpotView: UIViewController {
    
    var selectedSpot = Spot()
    
    let regionInMeters: Double = 1000
    
    let locationManager = CLLocationManager()
    let ss = serverSide()
    let f = functions()
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var map: MKMapView!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var tagsTextView: UITextView!
    //hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //set name label text
        nameLabel.text = selectedSpot.name.capitalizeBySpace()
        //make annotation in map
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(selectedSpot.lat)!, longitude: Double(selectedSpot.long)!)
        annotation.title = selectedSpot.name
        map.addAnnotation(annotation)
        //set description text
        descriptionTextView.text = selectedSpot.desc
        //set tags text
        tagsTextView.text = f.formatTagsForDisplay(tagString: selectedSpot.tags)
        
        //format map region scale
        let region = MKCoordinateRegion.init(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.setRegion(region, animated: true)
        
        format()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is spotCreator {
            let vc = segue.destination as? spotCreator
            vc?.editSpot = selectedSpot
            vc?.edit = true
        }
    }
    
    //centers and frames the user location
    func centerViewOnUserLocation(){
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            map.setRegion(region, animated: true)
        }
    }
    //sets the accuracy of the location manager
    func setupLocationManager(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    //checks if location services are enabled
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            //show alert letting the user know that have to turn it on for function
        }
    }
    //checks for user permissions
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            //shows user on map
            map.showsUserLocation = true
            //centers and zooms in on user location
            centerViewOnUserLocation()
            break
        case .denied:
            //show alert
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
            break
        case .restricted:
            //show alert
            break
        case .authorizedAlways:
            break
        }
    }
    
    func format(){
        map.layer.cornerRadius = 10
        map.clipsToBounds = true
        
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.2
        
        descriptionTextView.layer.borderWidth = 1
        tagsTextView.layer.borderWidth = 1
        
        descriptionTextView.layer.borderColor = nameLabel.textColor.cgColor
        tagsTextView.layer.borderColor = nameLabel.textColor.cgColor
    }

    @IBAction func backButtonAction(_ sender: Any) {
    }
    @IBAction func editButtonAction(_ sender: Any) {
    }
    
}
