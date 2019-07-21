//
//  spotsCollectionView.swift
//  Spot Map
//
//  Created by Seth Daetwiler on 4/11/19.
//  Copyright © 2019 Seth Daetwiler. All rights reserved.
//

import UIKit

class spotsCollectionView: UIViewController, UISearchBarDelegate {
    
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
    
    var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.register(customCell.self, forCellWithReuseIdentifier: "customCell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // UI formatting
        format()
        
        // Network call to get spot data from user
        makeSpots()
        
        //search.delegate = self

        
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
                    self.collectionView.reloadData()
                }
            }
        })
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
    
    func format(){
        // Add subviews in appropriate order
        view.addSubview(collectionView)
        
        // constraints and other stuff
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
    
}

// tags collectionView code here

extension spotsCollectionView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // Sets Number of rows for collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchActive){
            return filtered.count
        }
        return spots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! customCell
        
        #if targetEnvironment(simulator)
        // simulator code
        if (searchActive){
            let spot = filtered[indexPath.item]
            cell.titleLabel.text = spot.name
        } else {
            let spot = spots[indexPath.item]
            cell.titleLabel.text = spot.name
        }
        #else
        // real device code
        // If searchActive use filtered array
        if (searchActive){
            let spot = filtered[indexPath.item]
            cell.titleLabel.text = spot.name
            // TODO
            //cell.imageView.image = UIImage(data: ss.def.data(forKey: "image-data.\(spot.name)")!)
        } else {
            let spot = spots[indexPath.item]
            cell.titleLabel.text = spot.name
            //cell.imageView.image = UIImage(data: ss.def.data(forKey: "image-data.\(spot.name)")!)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width / 2, height: 100)
    }
}


class customCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        cellSetup()
    }
    
    var baseView : UIView = {
        let base = UIView()
        base.backgroundColor = .blue
        return base
    }()
    
    var dataView : UIView = {
        let dataView = UIView()
        return dataView
    }()
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(8)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    var editButton : UIButton = {
        let button = UIButton()
        button.setTitle("...", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.baselineAdjustment = .alignCenters
        return button
    }()
    
    
    func cellSetup(){
        addSubview(baseView)
            baseView.addSubview(dataView)
                dataView.addSubview(titleLabel)
                dataView.addSubview(editButton)
        
        
        
        baseView.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        dataView.anchor(top: nil, bottom: baseView.bottomAnchor, leading: baseView.leadingAnchor, trailing: baseView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 40))
        editButton.anchor(top: dataView.topAnchor, bottom: dataView.bottomAnchor, leading: nil, trailing: dataView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        titleLabel.anchor(top: dataView.topAnchor, bottom: dataView.bottomAnchor, leading: dataView.leadingAnchor, trailing: editButton.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 40))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
