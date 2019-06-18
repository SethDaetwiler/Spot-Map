//
//  mainView.swift
//  Spot Map
//
//  Created by Seth Daetwiler on 2/20/19.
//  Copyright © 2019 Seth Daetwiler. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class mapView: UIViewController, MKMapViewDelegate {

    let locationManager = CLLocationManager()
    let f = functions()
    let ss = serverSide()
    let def = UserDefaults.standard
    
    var currentSelectedSpot = Spot()
    
    var spotSource = false
    var customLocation = CLLocationCoordinate2D()
    
    @IBOutlet var map: MKMapView!
    @IBOutlet var addView: UIView!
    let regionInMeters: Double = 1000
    
    //hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        def.set(true, forKey: "loggedIn")
        format()
        checkLocationServices()
        makeAnnotations()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is spotCreator {
            let vc = segue.destination as? spotCreator
            vc?.spotSource = self.spotSource
            vc?.customLocation = self.customLocation
        }
        else if segue.destination is selectedSpotView{
            //send from annotation
            let vc = segue.destination as? selectedSpotView
            vc?.selectedSpot = currentSelectedSpot
        }
    }
    
    //Pull spot data from db and make/add annotations to map
    func makeAnnotations(){
        ss.dbRef.child("\(ss.uid!)").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let spot = Spot(id: snapshot.key, long: dictionary["long"] as! String, lat: dictionary["lat"] as! String, name: dictionary["name"] as! String, description: dictionary["desc"] as! String, tags: dictionary["tags"] as! String)
                // Make annotation and append anotation to annotation array
                let annotation = spotAnnotation(spot: spot)
                self.map.addAnnotation(annotation)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.map.dequeueReusableAnnotationView(withIdentifier: "Pin")
        
       
        annotationView?.clusteringIdentifier = "defualtSpotCluster"
        annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        if annotationView == nil{
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
            
        }else{
            annotationView?.annotation = annotation
        }
        
        
        annotationView?.image = UIImage(named: "spot sm")
        annotationView?.layer.cornerRadius = (annotationView?.frame.height)! / 2
        annotationView?.clipsToBounds = true
        //TODO annotation icons
        //annotationView?.image = UIImage(data: ss.def.data(forKey: "image-data.\(annotation.)"))
        
        
        return annotationView
        
        // For marker clustering ----------------------------------------
        
//        var annotationView = self.map.dequeueReusableAnnotationView(withIdentifier: "Pin") as? MKMarkerAnnotationView
//
//        annotationView?.clusteringIdentifier = "defualtSpotCluster"
//
//        if annotation is MKUserLocation{
//            return nil
//        } else if let cluster = annotation as? MKClusterAnnotation{
//            let clusterAnnotationView = self.map.dequeueReusableAnnotationView(withIdentifier: "cluster") as? MKMarkerAnnotationView
//            if annotationView == nil{
//                annotationView = MKMarkerAnnotationView(annotation: nil, reuseIdentifier: "cluster")
//            }
//            clusterAnnotationView?.annotation = cluster
//            clusterAnnotationView?.markerTintColor = UIColor(named: "green")
//            return clusterAnnotationView
//        }
//
//        if annotationView == nil{
//            annotationView = MKMarkerAnnotationView(annotation: nil, reuseIdentifier: "spot")
//        }
//        annotationView?.annotation = annotation
//        annotationView?.clusteringIdentifier = "spot"
//
//        annotationView?.image = UIImage(named: "spot sm")
//
//        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // 1
        if view.annotation is MKUserLocation {
            // Don't proceed with custom callout
            return
        }
        // 2
        let a = view.annotation as! spotAnnotation
        let views = Bundle.main.loadNibNamed("SpotDetailAnnotationView", owner: nil, options: nil)
        let calloutView = views?[0] as! SpotDetailAnnotationView
        calloutView.contentScaleFactor = 0.5
        calloutView.nameLabel.text = a.spot.name
        calloutView.descLabel.text = a.spot.desc
        calloutView.editButton.addTarget(self, action: #selector(editCurrentSpot(sender:)), for: .touchUpInside)
        calloutView.directionsButton.addTarget(self, action: #selector(directionsToCurrentSpot(sender:)), for: .touchUpInside)
        currentSelectedSpot = a.spot
        // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    
    @objc func editCurrentSpot(sender: UIButton)
    {
        performSegue(withIdentifier: "mapToView", sender: self)
    }
    
    @objc func directionsToCurrentSpot(sender: UIButton)
    {
        if (UIApplication.shared.canOpenURL(NSURL(string:"http://maps.apple.com")! as URL)) {
        UIApplication.shared.openURL(NSURL(string:"http://maps.apple.com:/?saddr=\((locationManager.location?.coordinate.latitude)!),\((locationManager.location?.coordinate.longitude)!)&daddr=\(currentSelectedSpot.lat),\(currentSelectedSpot.long)&dirflg=d")! as URL)
        }
    }
    
    //map managers
    //centers and frames the user location
    func centerViewOnUserLocation(){
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
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
            //updates location of user
            locationManager.startUpdatingLocation()
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
    
    
    
    @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        
        if gestureReconizer.state == .began {
            print("long tap")
            spotSource = true
            let location = gestureReconizer.location(in: map)
            let coordinate = map.convert(location,toCoordinateFrom: map)
            customLocation = coordinate
            performSegue(withIdentifier: "mapToSpotCreator", sender: self)
        }
        
    }
    //UI element formatting and adding to view
    func format(){
        //Long press gesture recognizer
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(handleTap))
        gestureRecognizer.delegate = self as? UIGestureRecognizerDelegate
        map.addGestureRecognizer(gestureRecognizer)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], for: .normal)

        
        addView.layer.cornerRadius = addView.frame.height / 2
        addView.layer.borderColor = UIColor.white.cgColor
        addView.layer.borderWidth = 1
        addView.clipsToBounds = true
    }
    @IBAction func addSpot(_ sender: Any) {
        spotSource = false
        customLocation = CLLocationCoordinate2D()
        performSegue(withIdentifier: "mapToSpotCreator", sender: nil)
    }
    
}
//delegate methods of locationManager
extension mapView: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //if there is no location then exit the method
        guard let userLocation = locations.last else { return }
        //center the userLocation in the view when userLocation is updated
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        map.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
