//
//  loadView.swift
//  Spot Map
//
//  Created by Seth Daetwiler on 2/26/19.
//  Copyright © 2019 Seth Daetwiler. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseAuth

class loadView: UIViewController {
    let def = UserDefaults.standard
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLocationAuthorization()
        autoLogin()
    }
    
    func autoLogin(){
        guard let email = def.string(forKey: "email") else {print("No Def Email"); self.performSegue(withIdentifier: "loadToLogin", sender: self); return}
        guard let pass = def.string(forKey: "password") else {print("No Def Password"); self.performSegue(withIdentifier: "loadToLogin", sender: self); return}
        
        Auth.auth().signIn(withEmail: email, password: pass){user, error in
            if(error == nil && user != nil){
                print("User auto logged in")
                self.performSegue(withIdentifier: "loadToMain", sender: self)
            } else {
                print("Error auto logging in: \(error!.localizedDescription)")
                self.performSegue(withIdentifier: "loadToLogin", sender: self)
            }
        }
    }
    
    //checks for user permissions
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
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
    
    /*
     
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
