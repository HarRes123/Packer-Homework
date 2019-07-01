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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInOutlet.layer.cornerRadius = 8
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // Create default Auth UI
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
   
        let backItem = UIBarButtonItem()
        backItem.title = "Sign Out"
        navigationItem.backBarButtonItem = backItem
        
        present(authViewController, animated: true, completion: nil)
        
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

