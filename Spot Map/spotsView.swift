//
//  spotsView.swift
//  Spot Map
//
//  Created by Seth Daetwiler on 2/26/19.
//  Copyright © 2019 Seth Daetwiler. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MapKit

class spotsView: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var search: UISearchBar!
    
    let ss = serverSide()
    let f = functions()
    var spots = [Spot]()
    let cellId = "cell id"
    
    var selectedSpot = Spot()
    //var selected = ["id":"", "location": CLLocationCoordinate2D(),"name": "", "desc": "","tags": ""] as [String : Any]
    
    var searchActive = false
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is selectedSpotView {
            let vc = segue.destination as? selectedSpotView
            vc?.selectedSpot = selectedSpot
//            vc?.id = selected["id"] as! String
//            vc?.location = selected["location"] as! CLLocationCoordinate2D
//            vc?.name = selected["name"] as! String
//            vc?.desc = selected["desc"] as! String
//            vc?.tags = selected["tags"] as! String
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
        if(searchActive){
            return filtered.count
        }
        return spots.count
    }
    // populate the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        if (searchActive){
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
    //excecutes when cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath)")
        if(searchActive){
            selectedSpot = filtered[indexPath.row]

        } else {
            selectedSpot = spots[indexPath.row]
//           
        }
        performSegue(withIdentifier: "spotsToView", sender: self)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        print("search did begin editing")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        print("search did end editing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        print("search did cancel button")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        search.resignFirstResponder()
        print("search did search button")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = f.filterSpotsForString(spots: spots, string: searchText)
        if searchText.count == 0{
            searchActive = false
        } else if filtered.count != 0{
            searchActive = true
        }
        
        self.tableView.reloadData()
    }
    
    
}
