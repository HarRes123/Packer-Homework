//
//  SurveyViewController.swift
//  Homework
//
//  Created by Harrison Resnick on 6/22/19.
//  Copyright © 2019 Et Cetera. All rights reserved.
//

import UIKit
import Firebase

class SurveyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstQuestion: UITextField!
    @IBOutlet weak var secondQuestion: UITextField!
    @IBOutlet weak var thirdQuestion: UITextField!
    @IBOutlet weak var titleLabelText: UILabel!
    
    var refResponse: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstQuestion.delegate = self
        secondQuestion.delegate = self
        thirdQuestion.delegate = self

        firstQuestion.tag = 0
        secondQuestion.tag = 1
        thirdQuestion.tag = 2

        refResponse = Database.database().reference().child("response")
        titleLabelText.text = "\nPlease Answer the \nFollowing Questions"

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            var alertNotification = ""
            var message = ""
            
            if firstQuestion.text != "" && secondQuestion.text != "" && thirdQuestion.text != "" {
                alertNotification = "Your Response Has Been Saved!"
                message = "Thank you for your input!"
                addResponse()
            } else {
                
                alertNotification = "You Response has not Been Saved"
                message = "Please complete all fields"
            }
            
            let alert = UIAlertController(title: alertNotification, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
        // Do not add a line break
        return false
    }
    
    
    func addResponse() {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MMMM dd, yyyy -- h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        let dateString = formatter.string(from: Date())
        
        let key = (Auth.auth().currentUser?.displayName)! + ": " + dateString
        
        let responses = [
                         "emailAddress": Auth.auth().currentUser?.email,
                         "firstQuestion": firstQuestion.text! as String,
                         "secondQuestion": secondQuestion.text! as String,
                         "thirdQuestion": thirdQuestion.text! as String
        ]
        
        refResponse.child(key).setValue(responses)
        firstQuestion.text = ""
        secondQuestion.text = ""
        thirdQuestion.text = ""
    }

    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        addResponse()
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
