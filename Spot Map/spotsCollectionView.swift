//
//  spotsCollectionView.swift
//  Spot Map
//
//  Created by Seth Daetwiler on 4/11/19.
//  Copyright © 2019 Seth Daetwiler. All rights reserved.
//

import UIKit

class spotsCollectionView: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var search: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
  
    
    let ss = serverSide()
    let f = functions()
    var spots = [Spot]()
    let cellId = "cell id"
    
    var selectedSpot = Spot()
    
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

        // Do any additional setup after loading the view.
    }
    
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
                    self.collectionView.reloadData()
                }
            }
        })
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchActive){
            return filtered.count
        }
        return spots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! spotsCollectionViewCell
        
        // Filters the spots based on search active
        // Set cell properties
        if (searchActive){
            let spot = filtered[indexPath.item]
            cell.nameLabel.text = spot.name
            cell.imageView.image = UIImage(data: ss.def.data(forKey: "image-data.\(spot.name)")!)
        } else {
            let spot = spots[indexPath.item]
            cell.nameLabel.text = spot.name
            cell.imageView.image = UIImage(data: ss.def.data(forKey: "image-data.\(spot.name)")!)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item: \(indexPath)")
        if(searchActive){
            selectedSpot = filtered[indexPath.item]
            
        } else {
            selectedSpot = spots[indexPath.item]
            
        }
        performSegue(withIdentifier: "spotsToView", sender: self)
    }
    
    
    //Search
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
        
        self.collectionView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
