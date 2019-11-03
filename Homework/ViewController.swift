//
//  ViewController.swift
//  Homework
//
//  Created by Harrison Resnick on 6/22/19.
//  Copyright © 2019 Et Cetera. All rights reserved.
//

import UIKit
import FirebaseUI
import GoogleSignIn

class ViewController: UIViewController, FUIAuthDelegate {
    @IBOutlet weak var logInOutlet: UIButton!
    @IBOutlet weak var notifcationOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInOutlet.layer.cornerRadius = 8
        notifcationOutlet.layer.cornerRadius = 8
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // Create default Auth UI
        if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified == true{
            // User is signed in.
            self.performSegue(withIdentifier: "goHome", sender: self)
            
        } else {
            // No user is signed in.
            
            let authUI = FUIAuth.defaultAuthUI()
            
            // Check that it isn't nil
            guard authUI != nil else {
                return
            }
            
            // Set delegate and specify sign in options
            authUI?.delegate = self
            authUI?.providers = [FUIEmailAuth(), FUIGoogleAuth()/*, FUIFacebookAuth()*/]
            
            // Get the auth view controller and present it
            let authViewController = authUI!.authViewController()
            
            //                let backItem = UIBarButtonItem()
            //                backItem.title = "Back"
            //                self.navigationItem.backBarButtonItem = backItem
            
            self.present(authViewController, animated: true, completion: nil)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}


extension ViewController {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        // Check for error
        guard error == nil else {
            return
        }
        var title = ""
        var messege = ""
        
        // Transition to home
        if (Auth.auth().currentUser?.email?.contains("packer.edu"))! {
            
            print("This is a Packer Email Address")
            
            if Auth.auth().currentUser!.isEmailVerified == true {
                
                print("VERIFIED")
                performSegue(withIdentifier: "goHome", sender: self)
            } else {
                
                print("NOT VERIFIED")
                title = "Verify Account"
                messege = "Please check you email and verify your account"
                let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                Auth.auth().currentUser?.sendEmailVerification { (error) in
                    // ...
                }
                self.present(alert, animated: true)
                
            }
            
            
        } else {
            
            print("This is NOT a Packer Email Address")
            
            title = "Invalid Email Address"
            messege = "Plese sign in using your Packer email address"
            let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            let user = Auth.auth().currentUser
            user?.delete { error in
                if error != nil {
                    // An error happened.
                } else {
                    // Account deleted.
                }
            }
        }
    }
}
