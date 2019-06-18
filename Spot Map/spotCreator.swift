//
//  spotCreator.swift
//  Spot Map
//
//  Created by Seth Daetwiler on 2/21/19.
//  Copyright © 2019 Seth Daetwiler. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class spotCreator: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var scrollview: UIScrollView!
    
    @IBOutlet var map: MKMapView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var tagsTextView: UITextView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageButton: UIButton!
    
    @IBOutlet var addSpotButton: UIButton!
    
    
    
    //variable that determines how spotCreator displays content false : current, true : custom
    var spotSource = false
    var customLocation = CLLocationCoordinate2D()
    
    let locationManager = CLLocationManager()
    let ss = serverSide()
    let f = functions()
    
    var edit = false
    var editSpot = Spot()
    
    var imageName = String()
    
    //hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        format()
        if edit{
            //add annotation to the map
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(editSpot.lat)!, longitude: Double(editSpot.long)!)
            map.addAnnotation(annotation)
            let region = MKCoordinateRegion.init(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            map.setRegion(region, animated: true)
            //fill in text from spot
            nameTextField.text = editSpot.name
            descriptionTextView.text = editSpot.desc
            tagsTextView.text = f.formatTagsForDisplay(tagString: editSpot.tags)
            imageName = editSpot.name

            if ss.def.data(forKey: "image-data.\(editSpot.name)") != nil {
                loadImage(name: editSpot.name)
            }
            
            //change button prompts
            addSpotButton.setTitle("Edit Spot", for: .normal)
            
        } else {
            if(spotSource){
                //custom location
                let annotation = MKPointAnnotation()
                annotation.coordinate = customLocation
                map.addAnnotation(annotation)
                let region = MKCoordinateRegion.init(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                map.setRegion(region, animated: true)
            } else {
                //current location
                checkLocationAuthorization()
            }
        }
        
        
        //listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is selectedSpotView {
            let vc = segue.destination as? selectedSpotView
            vc?.selectedSpot = editSpot
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
    
    //image handlers
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imageData = image.jpegData(compressionQuality: 0.5)!
        imageName = nameTextField.text!
        
        ss.def.set(imageData, forKey: "image-data.\(imageName)")
        //if an image is already saved under the key imageName then load the image
        
        loadImage(name: imageName)
    }
    
    func loadImage(name: String){
        imageView.image = UIImage(data: ss.def.data(forKey: "image-data.\(name)")!)
    }
    
    //keyboard managers
    @objc func keyboardWillChange(notification: Notification){
        print("keyboard will show: \(notification.name.rawValue)")
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if (notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification) {
            scrollview.setContentOffset(CGPoint(x: 0, y: keyboardRect.height), animated: true)
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.frame.origin.y = 0
        
        //update image data referance key if the user changes the name between adding and image and adding the spot
        if nameTextField.text != imageName{
            ss.def.set(ss.def.data(forKey: "image-data.\(imageName)"), forKey: "image-data.\(nameTextField.text!)")
            ss.def.removeObject(forKey: "image-data.\(imageName)")
            imageName = nameTextField.text!
            
            print("Name changed to: \(imageName)")
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            view.frame.origin.y = 0
            scrollview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == "Describe your spot a little"){
            textView.text = ""
            textView.textColor = .black
        }
        if(textView.text == "Restauraunt, Campsite, Vaction Spot"){
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func format(){
        map.layer.cornerRadius = 10
        map.clipsToBounds = true
        
        nameTextField.layer.borderColor = addSpotButton.backgroundColor?.cgColor
        nameTextField.layer.borderWidth = 1
        
        addSpotButton.layer.cornerRadius = addSpotButton.frame.height / 2
        addSpotButton.clipsToBounds = true
        
        nameTextField.layer.borderColor = addSpotButton.backgroundColor?.cgColor
        
        descriptionTextView.layer.borderWidth = 1
        tagsTextView.layer.borderWidth = 1
        
        descriptionTextView.layer.borderColor = addSpotButton.backgroundColor?.cgColor
        tagsTextView.layer.borderColor = addSpotButton.backgroundColor?.cgColor
        
        imageView.layer.cornerRadius = imageView.frame.height / 10
        imageView.clipsToBounds = true
        
       
        
    }
    
    
    @IBAction func imageButtonAction(_ sender: Any) {
        // makes sure there is name to use as a key for the image before displaying the camera
        if(imageName != nil){
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func addSpotButtonAction(_ sender: Any) {
        
        if ss.def.data(forKey: "image-data.\(imageName)") == nil{
            ss.def.set(Data(), forKey: "image-data.\(imageName)")
        }
        
        if edit{
            ss.editSpot(id: editSpot.id, long: Double(editSpot.long)!, lat: Double(editSpot.lat)!, name: "\(nameTextField.text ?? "No Name")", description: "\(descriptionTextView.text ?? "No Description")", tags: f.separateTagsBySpace(tagString: tagsTextView.text))
            editSpot = Spot(id: editSpot.id, long: editSpot.long, lat: editSpot.lat, name: "\(nameTextField.text ?? "No Name")", description: "\(descriptionTextView.text ?? "No Description")", tags: f.separateTagsBySpace(tagString: tagsTextView.text))
            performSegue(withIdentifier: "editToView", sender: self)
        } else {
            if(spotSource){
                //custom
                ss.postSpot(long: customLocation.longitude, lat: customLocation.latitude, name: "\(nameTextField.text ?? "No Name")", description: "\(descriptionTextView.text ?? "No Description")", tags: f.separateTagsBySpace(tagString: tagsTextView.text))
            } else {
                //current
                ss.postSpot(long: (locationManager.location?.coordinate.longitude)!, lat: (locationManager.location?.coordinate.latitude)!, name: "\(nameTextField.text ?? "No Name")", description: "\(descriptionTextView.text ?? "No Description")", tags: f.separateTagsBySpace(tagString: tagsTextView.text))
            }
            
            performSegue(withIdentifier: "toMainFromAdd", sender: self)
            
        }
    }
    
    
}
