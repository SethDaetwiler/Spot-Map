//
//  functions.swift
//  Spot Map
//
//  Created by Seth Daetwiler on 12/28/18.
//  Copyright © 2018 Seth Daetwiler. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation


class global {
    //App globals
    let ss = serverSide()
    let screen = UIScreen.main.bounds
    let cGreen : UIColor = UIColor(displayP3Red: 51/255, green: 196/255, blue: 135/255, alpha: 1)
    //Map globals
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    
    // Takes a non nil string as an argument and cleans the common seperating characters and integers
    // Returns cleaned string
    func separateTagsBySpace(tagString: String) -> String {
        var returnString = String()
        let lTagString = tagString.lowercased()
        var tagComponents: [String] = lTagString.components(separatedBy: " ")
        // Loop through the tags and remove uneccissary compontents
        for i in 0...tagComponents.count - 1 {
            tagComponents[i] = tagComponents[i].trimmingCharacters(in: CharacterSet(charactersIn: "0123456789,-\\|&/."))
            // Fill out returnString with elements
            returnString += tagComponents[i] + " "
        }
        return returnString
    }
    // Formats and returns a string for display of tags
    func formatTagsForDisplay(tagString: String) -> String{
        var returnString = ""
        let tags : [String] = tagString.components(separatedBy: " ")
        //loop through the tags and format for string
        for i in 0...tags.count - 2{
            if tags[i + 1] != ""{
                returnString += tags[i] + ", "
            } else {
                 returnString += tags[i]
            }
        }
        //add last element
        returnString += tags[tags.count - 1]
        
        return returnString
    }
    
    //filters an array of spots for string and returns array of spots that contain such string
    func filterSpotsForString(spots: [Spot], string: String) -> [Spot]{
        //array to be returned
        var filteredSpots = [Spot]()
        //lowercase the string
        let lString = string.lowercased()
        //iterate through spots
        for spot in spots{
            //check if spot elements contain string
            if spot.getName().lowercased().contains(lString){
                filteredSpots.append(spot)
            } else if spot.getTags().contains(lString){
                filteredSpots.append(spot)
            }
        }
        return filteredSpots
    }
    
    func capitalizeBySpace(string: String) -> String{
        var returnString = ""
        let stringComps : [String] = string.components(separatedBy: " ")
        
        for s in stringComps{
            returnString += s.prefix(1).uppercased() + s.lowercased().dropFirst()
        }
        
        return returnString
    }
    
    
    // Map Managers
    //-----------------------------------------------------------------------
    //centers and frames the user location
    func centerViewOnUserLocation(map: MKMapView){
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
    func checkLocationServices(map: MKMapView){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization(map: map)
        } else {
            //show alert letting the user know that have to turn it on for function
        }
    }
    //checks for user permissions
    func checkLocationAuthorization(map: MKMapView){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            //shows user on map
            map.showsUserLocation = true
            //centers and zooms in on user location
            centerViewOnUserLocation(map: map)
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

}

extension UIView{
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        // need to be false to apply contraints
        translatesAutoresizingMaskIntoConstraints = false
        
        // set anchor constraints
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        
        // if width an height arn't zero then set contraints to provided sizes
        if (size.width != 0){
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if (size.height != 0){
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
}


extension String {
    //Capitalize the first letter of each charSet separated by whitespace
    func capitalizeBySpace() -> String{
        var returnString = ""
        let stringComps : [String] = self.components(separatedBy: " ")
        for s in stringComps{
            returnString += s.prefix(1).uppercased() + s.lowercased().dropFirst() + " "
        }
        returnString = String(returnString.dropLast())
        return returnString
    }
}

