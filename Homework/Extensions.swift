//
//  Extensions.swift
//  Homework
//
//  Created by Harrison Resnick on 6/23/19.
//  Copyright © 2019 Et Cetera. All rights reserved.
//

import Foundation
import FirebaseUI

extension ViewController {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        // Check for error
        guard error == nil else {
            return
        }
        
        // Transition to home
        let backItem = UIBarButtonItem()
        backItem.title = "Log Out"
        navigationItem.backBarButtonItem = backItem
        performSegue(withIdentifier: "goHome", sender: self)
    }
    
}
