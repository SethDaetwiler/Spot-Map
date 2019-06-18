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


class functions {
    let ss = serverSide()
    
    let screen = UIScreen.main.bounds
    
    let cGreen : UIColor = UIColor(displayP3Red: 51/255, green: 196/255, blue: 135/255, alpha: 1)
    
    
    //ratio (depriciated)
    func r() -> CGFloat{
        return screen.width / 414
    }
    
    //takes a non nil string as an argument and cleans the common seperating characters and integers
    //returns cleaned string
    func separateTagsBySpace(tagString: String) -> String {
        var returnString = String()
        let lTagString = tagString.lowercased()
        
        var tagComponents: [String] = lTagString.components(separatedBy: " ")
        //loop through the tags and remove uneccissary compontents
        for i in 0...tagComponents.count - 1 {
            tagComponents[i] = tagComponents[i].trimmingCharacters(in: CharacterSet(charactersIn: "0123456789,-\\|&/."))
            //fill out returnString with elements
            returnString += tagComponents[i] + " "
        }
        return returnString
    }
    //formats and returns a string for display of tags
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
