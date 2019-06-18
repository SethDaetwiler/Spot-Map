//
//  createView.swift
//  Spot Map
//
//  Created by Seth Daetwiler on 2/26/19.
//  Copyright © 2019 Seth Daetwiler. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import FirebaseAuth



class createView: UIViewController, UITextFieldDelegate {
    let ss = serverSide()
    let f = functions()
    
    let def = UserDefaults.standard
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var createButton: UIButton!
    
    //hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        format()
       
    }
    
    func format() {
        
        
    }
    
    @IBAction func createButtonAction(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let pass = passwordTextField.text else { return }
        
        def.set(email, forKey: "email")
        def.set(pass, forKey: "password")
        
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            if(error == nil && user != nil){
                print("User created")
                self.dismiss(animated: false, completion: nil)
            } else {
                print("Error creating user: \(error!.localizedDescription)")
            }
        }
        
    }
    
    //keyboard managers
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
