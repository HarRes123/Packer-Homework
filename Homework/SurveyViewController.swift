//
//  SurveyViewController.swift
//  Homework
//
//  Created by Harrison Resnick on 6/22/19.
//  Copyright © 2019 Et Cetera. All rights reserved.
//

import UIKit
import Firebase
import DLRadioButton

class SurveyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstQuestion: UITextField!
    @IBOutlet weak var secondQuestion: UITextField!
    @IBOutlet weak var thirdQuestion: UITextField!
    @IBOutlet weak var titleLabelText: UILabel!
    @IBOutlet weak var saveOutlet: UIButton!
    
    @IBOutlet weak var q1Label: UILabel!
    @IBOutlet weak var q2Label: UILabel!
    @IBOutlet weak var q3Label: UILabel!
    
    @IBOutlet weak var button1Outlet: DLRadioButton!
    @IBOutlet weak var button2Outlet: DLRadioButton!
    @IBOutlet weak var button3Outlet: DLRadioButton!
    @IBOutlet weak var button4Outlet: DLRadioButton!
    @IBOutlet weak var button5Outlet: DLRadioButton!
    
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var refResponse: DatabaseReference!
    var alertNotification = ""
    var message = ""
    var buttonResponse = ""
    
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
        stackView.setCustomSpacing(64.0, after: buttonView)
        stackView.setCustomSpacing(12.0, after: q3Label)
        stackView.setCustomSpacing(64.0, after: thirdQuestion)

        refResponse = Database.database().reference().child("response")
        titleLabelText.text = "\nPlease Answer the \nFollowing Questions"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func firstButton(_ sender: Any) {
        buttonResponse = "Very good"
        print(buttonResponse)
    }
    
    @IBAction func secondButton(_ sender: Any) {
        buttonResponse = "Good"
        print(buttonResponse)
    }
    
    @IBAction func thirdButton(_ sender: Any) {
        buttonResponse = "Neutral"
        print(buttonResponse)
    }
    @IBAction func fourthButton(_ sender: Any) {
        buttonResponse = "Bad"
        print(buttonResponse)
    }
    @IBAction func fifthButton(_ sender: Any) {
        buttonResponse = "Very bad"
        print(buttonResponse)
    }
    
    func presentPopOver() {
        
        if firstQuestion.text != "" && secondQuestion.text != "" && thirdQuestion.text != "" && buttonResponse != "" {
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
                         "buttonResponse": buttonResponse as String,
                         "thirdQuestion": thirdQuestion.text! as String
        ]
        
        refResponse.child(key).setValue(responses)
        
        firstQuestion.text = ""
        secondQuestion.text = ""
        thirdQuestion.text = ""
        buttonResponse = ""
        
        button1Outlet.isSelected = false
        button2Outlet.isSelected = false
        button3Outlet.isSelected = false
        button4Outlet.isSelected = false
        button5Outlet.isSelected = false
        
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
