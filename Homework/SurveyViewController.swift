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
    @IBOutlet weak var saveOutlet: UIButton!
    
    @IBOutlet weak var q1Label: UILabel!
    @IBOutlet weak var q2Label: UILabel!
    @IBOutlet weak var q3Label: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var refResponse: DatabaseReference!
    var alertNotification = ""
    var message = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstQuestion.delegate = self
        secondQuestion.delegate = self
        thirdQuestion.delegate = self

        saveOutlet.layer.cornerRadius = 8
        
        firstQuestion.enablesReturnKeyAutomatically = false
        secondQuestion.enablesReturnKeyAutomatically = false
        thirdQuestion.enablesReturnKeyAutomatically = false
        
        stackView.setCustomSpacing(64.0, after: titleLabelText)
        stackView.setCustomSpacing(12.0, after: q1Label)
        stackView.setCustomSpacing(64.0, after: firstQuestion)
        stackView.setCustomSpacing(12.0, after: q2Label)
        stackView.setCustomSpacing(64.0, after: secondQuestion)
        stackView.setCustomSpacing(12.0, after: q3Label)
        stackView.setCustomSpacing(64.0, after: thirdQuestion)

        refResponse = Database.database().reference().child("response")
        titleLabelText.text = "\nPlease Answer the \nFollowing Questions"

        // Do any additional setup after loading the view.
    }
    
    func presentPopOver() {
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
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
        
        presentPopOver()
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
