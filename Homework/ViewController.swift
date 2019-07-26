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
        if Auth.auth().currentUser != nil {
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
            authUI?.providers = [FUIEmailAuth(), FUIGoogleAuth(), FUIFacebookAuth()]
            
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
        
        // Transition to home
        performSegue(withIdentifier: "goHome", sender: self)
    }
    
}

