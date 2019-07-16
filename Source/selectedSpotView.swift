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
//    @IBOutlet var directionsButton: UIImageView!
//    @IBOutlet var imageButton: UIImageView!
//    @IBOutlet var mapButton: UIImageView!
//    @IBOutlet var descriptionTextView: UITextView!
//    @IBOutlet var tagsCollectionView: UICollectionView!
//    @IBOutlet var latLabel: UILabel!
//    @IBOutlet var longLabel: UILabel!
//    @IBOutlet var dateLabel: UILabel!
//    @IBOutlet var edit2Button: UIButton!
//    @IBOutlet var deleteButton: UIButton!
    
    
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
    
    var mapContainer : UIView = {
        let containerView = UIView()
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 20.0
        containerView.layer.shadowOpacity = 0.5
        return containerView
    }()
    
    var map : MKMapView = {
        let mapView = MKMapView()
        mapView.showsPointsOfInterest = false
        mapView.showsUserLocation = false
        mapView.isScrollEnabled = false
        mapView.isRotateEnabled = false
        
        mapView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        mapView.layer.cornerRadius = 20
        mapView.clipsToBounds = true
        
        
        return mapView
    }()
    
    var nameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // Containers for buttons in container view
    var directionsContainerView : UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    var imageContainerView : UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    var mapContainerView : UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    // Buttons in button container views
    var directionsButton : UIButton = {
        let button = UIButton()
        button.setTitle("Directions", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainGreen
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()

    var imageButton : UIButton = {
        let button = UIButton()
        button.setTitle("Image", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainGreen
        
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()

    var mapButton : UIButton = {
        let button = UIButton()
        button.setTitle("Map", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainGreen
        
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()
    
    // view that holds button containers
    var buttonContainerView : UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOffset = .zero
        stackView.layer.shadowOpacity = 1
        stackView.layer.shadowRadius = 10
        return stackView
    }()
    
    var descriptionTextView : UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        
        textView.layer.borderColor = UIColor.mainGreen.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 2
        textView.clipsToBounds = true
        return textView
    }()
    
    var tagsCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.register(CustomTagCell.self, forCellWithReuseIdentifier: "customTagCell")
        return collectionView
    }()
    
    var latLabel : UILabel = {
        let label = UILabel()
        label.text = "Latitude: "
        label.font = label.font.withSize(17)
        label.textColor = .lightGray
        return label
    }()
    
    var longLabel : UILabel = {
        let label = UILabel()
        label.text = "Longitude: "
        label.font = label.font.withSize(17)
        label.textColor = .lightGray
        return label
    }()
    
    var dateLabel : UILabel = {
        let label = UILabel()
        label.text = "Created On: "
        label.font = label.font.withSize(17)
        label.textColor = .black
        return label
    }()
    
    var bottomButtonContainerView : UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    var bottomEditButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainGreen
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()
    
    var bottomDeleteButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainRed
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI Setup
        format()
        // Set name label text
        nameLabel.text = selectedSpot.name.capitalizeBySpace()
        // Make annotation in map
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(selectedSpot.lat)!, longitude: Double(selectedSpot.long)!)
        annotation.title = selectedSpot.name
        map.addAnnotation(annotation)
        
        // Text Setting
        // Set description text
        descriptionTextView.text = selectedSpot.desc
        // Latitude text
        latLabel.text = "Latitude: \(selectedSpot.lat)"
        // Longitude text
        longLabel.text = "Longitude: \(selectedSpot.long)"
        // TODO: Date created
        
        // Format map region scale
        let region = MKCoordinateRegion.init(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.setRegion(region, animated: true)
        
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
        
        // add views in order for
        view.addSubview(mapContainer)
            mapContainer.addSubview(map)
        view.addSubview(backButton)
        view.addSubview(editButton)
        view.addSubview(nameLabel)
        view.addSubview(buttonContainerView)
            directionsContainerView.addSubview(directionsButton)
            imageContainerView.addSubview(imageButton)
            mapContainerView.addSubview(mapButton)
        view.addSubview(descriptionTextView)
        view.addSubview(tagsCollectionView)
        view.addSubview(latLabel)
        view.addSubview(longLabel)
        view.addSubview(dateLabel)
        view.addSubview(bottomButtonContainerView)
            bottomButtonContainerView.addSubview(bottomEditButton)
            bottomButtonContainerView.addSubview(bottomDeleteButton)
        
        // backButton layout
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: nil, padding: .init(top: 10, left: 10, bottom: 0, right: 0))
        
        // topEdit button layout
        editButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 10))
        
        // mapContainer layout
        mapContainer.anchor(top: view.topAnchor, bottom: nil, leading: nil, trailing: nil, size: .init(width: self.view.frame.width, height: 200))
            // map layout
            map.anchor(top: mapContainer.topAnchor, bottom: mapContainer.bottomAnchor, leading: mapContainer.leadingAnchor, trailing: mapContainer.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        // nameLabel layout
        nameLabel.anchor(top: map.bottomAnchor, bottom: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: 30))
        
        // buttonContainerView layout
        buttonContainerView.anchor(top: nameLabel.bottomAnchor, bottom: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 75))
        buttonContainerView.addArrangedSubview(directionsContainerView)
        buttonContainerView.addArrangedSubview(imageContainerView)
        buttonContainerView.addArrangedSubview(mapContainerView)
        
            // buttons in container views
            directionsButton.anchor(top: directionsContainerView.topAnchor, bottom: directionsContainerView.bottomAnchor, leading: directionsContainerView.leadingAnchor, trailing: directionsContainerView.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
            imageButton.anchor(top: imageContainerView.topAnchor, bottom: imageContainerView.bottomAnchor, leading: imageContainerView.leadingAnchor, trailing: imageContainerView.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
            mapButton.anchor(top: mapContainerView.topAnchor, bottom: mapContainerView.bottomAnchor, leading: mapContainerView.leadingAnchor, trailing: mapContainerView.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        
        // descriptionView layout
        descriptionTextView.anchor(top: buttonContainerView.bottomAnchor, bottom: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: 100))
        
        // Following layout is in bottom up order
        // bottomButtonContainerView
        bottomButtonContainerView.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 10, right: 10), size: .init(width: 0, height: 45))
            // buttons in container view
            bottomEditButton.anchor(top: bottomButtonContainerView.topAnchor, bottom: bottomButtonContainerView.bottomAnchor, leading: bottomButtonContainerView.leadingAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 130, height: 0))
            bottomDeleteButton.anchor(top: bottomButtonContainerView.topAnchor, bottom: bottomButtonContainerView.bottomAnchor, leading: nil, trailing: bottomButtonContainerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 130, height: 0))
        
        // dateLabel layout
        dateLabel.anchor(top: nil, bottom: bottomButtonContainerView.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 30, right: 10))
        
        // longitudeLabel layout
        longLabel.anchor(top: latLabel.bottomAnchor, bottom: dateLabel.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 5, left: 10, bottom: 20, right: 10))
        
        // latitudeLabel layout
        latLabel.anchor(top: nil, bottom: longLabel.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 5, right: 10))
        
        // collectionView delegate, datasource, layout
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        tagsCollectionView.anchor(top: descriptionTextView.bottomAnchor, bottom: latLabel.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 20, right: 10), size: .init(width: 0, height: 0))
        
        
    }

    @IBAction func backButtonAction(_ sender: Any) {
    }
    @IBAction func editButtonAction(_ sender: Any) {
    }
    
    
}

extension selectedSpotView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return g.getTagArray(tagString: selectedSpot.tags).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customTagCell", for: indexPath) as! CustomTagCell
        cell.label.text = g.getTagArray(tagString: selectedSpot.tags)[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: g.getTagArray(tagString: selectedSpot.tags)[indexPath.item].size(withAttributes: nil).width + 30, height: 20)
    }
    
    
    
}

class CustomTagCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellSetup()
    }
    
    public var label : UILabel = {
        let label = UILabel()
        label.text = "Default"
        label.textColor = .white
        label.backgroundColor = .mainGreen
        return label
    }()
    
    // UI Setup for cell
    private func cellSetup(){
        backgroundColor = .mainGreen
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
//        label.layer.cornerRadius = label.frame.height / 2
//        label.clipsToBounds = true
        
        addSubview(label)
        label.sizeToFit()
        label.textAlignment = .center
        label.font = label.font.withSize(10)
        label.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10), size: .init(width: label.frame.width, height: 0))
        label.baselineAdjustment = .alignCenters
    }
    // required : don't know why
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


