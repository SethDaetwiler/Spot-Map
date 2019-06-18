//
//  spot.swift
//  Spot Map
//
//  Created by Seth Daetwiler on 2/19/19.
//  Copyright © 2019 Seth Daetwiler. All rights reserved.
//

import Foundation
import CoreLocation

class Spot{
    
    var id: String
    
    var long: String
    
    var lat: String
    
    var name: String
    
    var desc: String
    
    var tags: String
    
    //Intit 
    init(){
        id = ""
        long = "0.0"
        lat = "0.0"
        name = ""
        desc = ""
        tags = ""
        
    }
    
    init(id: String, long: String, lat: String, name: String, description: String, tags: String){
        self.id = id
        self.long = long
        self.lat = lat
        self.name = name
        self.desc = description
        self.tags = tags
    }
    
    
    //Assignment methods
    public func setLocation(long: String, lat: String){
        self.long = long
        self.lat = lat
    }

    public func setName(name: String){
        self.name = name
    }
    
    public func setDescription(description: String){
        self.desc = description
    }
    
    public func setDescription(tags: String){
        self.tags = tags
    }

    //Get methods
    public func getId() -> String{
        return id
    }
    public func getLong() -> String{
        return long
    }
    public func getLat() -> String{
        return lat
    }
    
    public func getName() -> String{
        return name
    }
    
    public func getDescription() -> String{
        return desc
    }
    
    public func getTags() -> String{
        return tags
    }
    
    public func containsTag(tag: String) -> Bool {
        let lTag = tag.lowercased()
        if(tags.contains(lTag)){
            return true
        }
        return false
    }
}
