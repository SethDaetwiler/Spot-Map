//
//  serverSide.swift
//  Spot Map
//
//  Created by Seth Daetwiler on 12/29/18.
//  Copyright © 2018 Seth Daetwiler. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import CoreLocation
import MapKit

class serverSide {
    let def = UserDefaults.standard
    
    
    var dbRef = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    // Checks if user is logged in
    // Signs out the current user
    func logoutUser(){
        
    }
    
    func editSpot(id: String, long: Double, lat: Double, name: String, description: String, tags: String){
        print("editing \(id) ----------")
        dbRef.observeSingleEvent(of: .value) { (snapshot: DataSnapshot!) in
            self.dbRef.child("\(self.uid!)/\(id)").setValue(["name":"\(name)","desc":"\(description)","long":"\(long)","lat":"\(lat)","tags":"\(tags)"])
        }
    }
    
    func postSpot(long: Double, lat: Double, name: String, description: String, tags: String){
        print("post run ----------")
        //adds spots to firbase database and indexes automatically : tested -> functional
        dbRef.observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot!) in
            self.dbRef.child("\(self.uid!)").childByAutoId().setValue(["name":"\(name)","desc":"\(description)","long":"\(long)","lat":"\(lat)","tags":"\(tags)"])
        })
    }

    //gets raw spot data under assoc uid
    func getSpotsFromDB(){
        dbRef.child("\(uid!)").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
        })
    }
    // Pulls data from the database and fills spot and annotation arrays
    func pullSpotsFromDB(){
        dbRef.child("\(uid!)").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                // Make spot object
                let spot = Spot(id: snapshot.key, long: dictionary["long"] as! String, lat: dictionary["lat"] as! String, name: dictionary["name"] as! String, description: dictionary["desc"] as! String, tags: dictionary["tags"] as! String)
                
                // Make annotation and append anotation to annotation array
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: Double(spot.getLat())!, longitude: Double(spot.getLong())!)
                annotation.title = spot.getName()
                // Pass data out of closure
            }
        })
    }
    
}

