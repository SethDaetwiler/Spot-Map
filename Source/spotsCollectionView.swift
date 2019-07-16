//
//  spotsCollectionView.swift
//  Spot Map
//
//  Created by Seth Daetwiler on 4/11/19.
//  Copyright © 2019 Seth Daetwiler. All rights reserved.
//

import UIKit

class spotsCollectionView: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
//    @IBOutlet var search: UISearchBar!
//    @IBOutlet var collectionView: UICollectionView!
  
    
    let ss = serverSide()
    let g = global()
    var spots = [Spot]()
    let cellId = "cell id"
    
    var selectedSpot = Spot()
    
    var searchActive = false
    
    var filtered = [Spot]()
    
    // Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeSpots()
        //search.delegate = self

        // Do any additional setup after loading the view.
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
                    //self.collectionView.reloadData()
                }
            }
        })
    }

    // Sets Number of rows for collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchActive){
            return filtered.count
        }
        return spots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! spotsCollectionViewCell
        
        #if targetEnvironment(simulator)
        // simulator code
            if (searchActive){
                let spot = filtered[indexPath.item]
                cell.nameLabel.text = spot.name
            } else {
                let spot = spots[indexPath.item]
                cell.nameLabel.text = spot.name
            }
        #else
        // real device code
        // If searchActive use filtered array
            if (searchActive){
                let spot = filtered[indexPath.item]
                cell.nameLabel.text = spot.name
                cell.imageView.image = UIImage(data: ss.def.data(forKey: "image-data.\(spot.name)")!)
            } else {
                let spot = spots[indexPath.item]
                cell.nameLabel.text = spot.name
                cell.imageView.image = UIImage(data: ss.def.data(forKey: "image-data.\(spot.name)")!)
            }
        #endif
        
        return cell
    }
    
    // Cell selected --> stopped here
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item: \(indexPath)")
        if(searchActive){
            selectedSpot = filtered[indexPath.item]
        } else {
            selectedSpot = spots[indexPath.item]
        }
        performSegue(withIdentifier: "spotsToView", sender: self)
    }
    
    // Search
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Set search active to true when search bar editing begins
        searchActive = true;
        print("search did begin editing")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Set search active to false when search bar ends editing
        searchActive = false;
        print("search did end editing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Set search active to false when search bar is canceled
        searchActive = false;
        print("search did cancel button")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Set search active to false when search button is clicked and resign keyboard
        searchActive = false;
        //search.resignFirstResponder()
        print("search did search button")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // On change of searchbar text set filtered array to return of filteredSpotsForString
        filtered = g.filterSpotsForString(spots: spots, string: searchText)
        // Refresh searchActive as a result of searchBar contents length on change
        if searchText.count == 0{
            searchActive = false
        } else if filtered.count != 0{
            searchActive = true
        }
        //self.collectionView.reloadData()
    }
    
}
