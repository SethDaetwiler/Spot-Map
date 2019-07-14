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
    let g = global()
    
    
    
//    @IBOutlet var backButton: UIButton!
//    @IBOutlet var editButton: UIButton!
//    @IBOutlet var map: MKMapView!
//    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var directionsButton: UIImageView!
    @IBOutlet var imageButton: UIImageView!
    @IBOutlet var mapButton: UIImageView!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var tagsCollectionView: UICollectionView!
    @IBOutlet var latLabel: UILabel!
    @IBOutlet var longLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var edit2Button: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    
    //hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var backButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
    
    var editButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
    
    var map : MKMapView = {
        let mapView = MKMapView()
        mapView.showsPointsOfInterest = false
        mapView.showsUserLocation = false
        mapView.isScrollEnabled = false
        mapView.isRotateEnabled = false
        return mapView
    }()
    
    var nameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.backgroundColor = .red
        return label
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set name label text
        nameLabel.text = selectedSpot.name.capitalizeBySpace()
        // Make annotation in map
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(selectedSpot.lat)!, longitude: Double(selectedSpot.long)!)
        annotation.title = selectedSpot.name
        map.addAnnotation(annotation)
        // Set description text
        descriptionTextView.text = selectedSpot.desc
        // Set tags text
        //tagsTextView.text = g.formatTagsForDisplay(tagString: selectedSpot.tags)
        // Format map region scale
        let region = MKCoordinateRegion.init(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.setRegion(region, animated: true)
        // UI Setup
        format()
    }
    
    // Pass data to views on segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is spotCreator {
            let vc = segue.destination as? spotCreator
            vc?.editSpot = selectedSpot
            vc?.edit = true
        }
    }
    
    //UI Setup
    func format(){
        // map formatting
        view.addSubview(map)
        map.anchor(top: view.topAnchor, bottom: nil, leading: nil, trailing: nil, size: .init(width: self.view.frame.width, height: 200))
        map.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        map.layer.cornerRadius = 20
        map.clipsToBounds = true
        // back button formatting
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: nil, padding: .init(top: 10, left: 10, bottom: 0, right: 0))
        // top edit button formatting
        view.addSubview(editButton)
        editButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 10))
        // name formatting
        view.addSubview(nameLabel)
        nameLabel.anchor(top: map.bottomAnchor, bottom: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: 30))
        
        
       
        
        descriptionTextView.layer.borderWidth = 0.5
        //tagsTextView.layer.borderWidth = 1
        
        descriptionTextView.layer.borderColor = g.cGreen.cgColor
        //tagsTextView.layer.borderColor = nameLabel.textColor.cgColor
        
        
        let colorTop =  UIColor(red: 43.0/255.0, green: 247.0/255.0, blue: 159.0/255.0, alpha: 1.0).cgColor
        let colorBottom = g.cGreen.cgColor
            
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
            
        self.view.layer.insertSublayer(gradientLayer, at:0)
        

    }

    @IBAction func backButtonAction(_ sender: Any) {
    }
    @IBAction func editButtonAction(_ sender: Any) {
    }
    
    
}

