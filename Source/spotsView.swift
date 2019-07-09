//
//  spotsView.swift
//  Spot Map
//
//  Created by Seth Daetwiler on 2/26/19.
//  Copyright © 2019 Seth Daetwiler. All rights reserved.
//

// ONLY WORK ON COLLECTION VIEW


import UIKit
import Foundation
import CoreLocation
import MapKit

class spotsView: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var search: UISearchBar!
    
    let ss = serverSide()
    let g = global()
    var spots = [Spot]()
    let cellId = "cell id"
    
    var selectedSpot = Spot()
    // Class scoped boolean for functions to referance if searchIsActive
    var searchIsActive = false
    // Array that stores spots with filtered constraints
    var filtered = [Spot]()
    //hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSpots()
        search.delegate = self
    }
    
    // Pass data to views on segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is selectedSpotView {
            let vc = segue.destination as? selectedSpotView
            vc?.selectedSpot = selectedSpot
        }
    }
    
    // fill the spots array
    func makeSpots(){
        ss.dbRef.child("\(ss.uid!)").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                // Make spot object
                let spot = Spot(id: snapshot.key, long: dictionary["long"] as! String, lat: dictionary["lat"] as! String, name: dictionary["name"] as! String, description: dictionary["desc"] as! String, tags: dictionary["tags"] as! String)
                self.spots.append(spot)
                //Updates the table view
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    // Sets num of cells in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If searchIsActive then use the filtered array size for the # of rows
        if(searchIsActive){
            return filtered.count
        }
        return spots.count
    }
    
    // Populate the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        // If search is active use filtered as the
        if (searchIsActive){
            let spot = filtered[indexPath.row]
            cell.textLabel?.text = spot.name
            cell.detailTextLabel?.text = spot.desc
        } else {
            let spot = spots[indexPath.row]
            cell.textLabel?.text = spot.name
            cell.detailTextLabel?.text = spot.desc
        }
        return cell
    }
    
    // Excecutes when cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath)")
        if(searchIsActive){
            selectedSpot = filtered[indexPath.row]
        } else {
            selectedSpot = spots[indexPath.row]
        }
        performSegue(withIdentifier: "spotsToView", sender: self)
    }
    
    // Search text editing began
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchIsActive = true;
        print("search did begin editing")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchIsActive = false;
        print("search did end editing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchIsActive = false;
        print("search did cancel button")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchIsActive = false;
        search.resignFirstResponder()
        print("search did search button")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = g.filterSpotsForString(spots: spots, string: searchText)
        if searchText.count == 0{
            searchIsActive = false
        } else if filtered.count != 0{
            searchIsActive = true
        }
        
        self.tableView.reloadData()
    }
    
    
}
