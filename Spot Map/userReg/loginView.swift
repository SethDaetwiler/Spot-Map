//
//  loginView.swift
//  Spot Map
//
//  Created by Seth Daetwiler on 12/28/18.
//  Copyright © 2018 Seth Daetwiler. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth


class loginView : UIViewController, UITextFieldDelegate{
    
    let def = UserDefaults.standard
    
    let f = functions()
    let ss = serverSide()
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    
    //hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        format()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // This block skips login view is createUser was successful
        guard def.string(forKey: "email") != nil else {print("No Def Email"); return}
        guard def.string(forKey: "password") != nil else {print("No Def Password"); return}
        dismiss(animated: false, completion: nil);
    }
    
    func format() {
        
        
        
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let pass = passwordTextField.text else { return }
        
        def.set(email, forKey: "email")
        def.set(pass, forKey: "password")
        
        Auth.auth().signIn(withEmail: email, password: pass){user, error in
            if(error == nil && user != nil){
                print("User logged in")
                self.dismiss(animated: false, completion: nil)
            } else {
                print("Error logging in: \(error!.localizedDescription)")
            }
        }
    }
    
    
    
    //keyboard managers
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
