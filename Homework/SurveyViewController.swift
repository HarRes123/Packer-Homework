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

    @IBOutlet weak var fourthQuestion: UITextField!
    @IBOutlet weak var saveOutlet: UIButton!
    
    @IBOutlet weak var q1Label: UILabel!
    @IBOutlet weak var q2Label: UILabel!
    @IBOutlet weak var q3Label: UILabel!
    @IBOutlet weak var q4Label: UILabel!
    
    @IBOutlet weak var currentUser: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var button1Outlet: DLRadioButton!
    @IBOutlet weak var button2Outlet: DLRadioButton!
    @IBOutlet weak var button3Outlet: DLRadioButton!
    @IBOutlet weak var button4Outlet: DLRadioButton!
    @IBOutlet weak var button5Outlet: DLRadioButton!
    
    @IBOutlet var subjectButtons: [UIButton]!
    
    @IBOutlet weak var sliderOutlet: UISlider!
    
    @IBOutlet weak var minDisplay: UILabel!
    
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var selectOutlet: UIButton!
    
    @IBOutlet weak var dropDownStackView: UIStackView!
    
    var refResponse: DatabaseReference!
    var alertNotification = ""
    var message = ""
    var buttonResponse = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        fourthQuestion.delegate = self
        fourthQuestion.autocapitalizationType = .sentences
        
        q1Label.text = "\nWhich subject did you spend the most time on tonight?" //drop down menu [math, science, history, english, word language, art, other -- manual input]
        q2Label.text = "How manageable was the work tonight?"
        q3Label.text = "How much time did you spend on homework tonight?" //add slider(?)
        q4Label.text = "Do you have any questions or comments? (Optional)"
        
        saveOutlet.layer.cornerRadius = 8
        
        fourthQuestion.enablesReturnKeyAutomatically = false
        
        stackView.setCustomSpacing(12.0, after: q1Label)
        stackView.setCustomSpacing(64.0, after: dropDownStackView)
        stackView.setCustomSpacing(12.0, after: q2Label)
        stackView.setCustomSpacing(64.0, after: buttonView)
        stackView.setCustomSpacing(12.0, after: q3Label)
        stackView.setCustomSpacing(64.0, after: minDisplay)
        stackView.setCustomSpacing(12.0, after: q4Label)
        stackView.setCustomSpacing(64.0, after: fourthQuestion)

        refResponse = Database.database().reference().child("response")
        
        selectOutlet.setTitle("Select a Subject", for: .normal)
        
        self.hideKeyboardWhenTappedAround()

        minDisplay.text = "Time: 0 minutes"
        
        // Do any additional setup after loading the view.
    }
    
    @objc func signOut(sender: UIBarButtonItem) {
        
        try! Auth.auth().signOut()
        
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "firstVC") as! UINavigationController
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        self.scrollView.addSubview(stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
                
        self.stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
    }
    
    

    
    @IBAction func minSlider(_ sender: UISlider) {
        
        //minDisplay.text = "Minutes: \(sender.value)"
        //minDisplay.text = String(format: "Minutes: %i",Int(sender.value))
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        
        let currentValue = Int(sender.value)
        
        let formattedString = formatter.string(from: TimeInterval(currentValue))!
      
        self.minDisplay.text = "Time: \(formattedString)"
        
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
        
        if minDisplay.text != "Time: 0 minutes" && buttonResponse != "" && selectOutlet.titleLabel?.text != "Select a Subject" {
            alertNotification = "Your Response Has Been Saved!"
            message = "Thank you for your input!"
            addResponse()
        } else {
            
            alertNotification = "You Response has not Been Saved"
            message = "Please complete all required fields"
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
        
        var fourthQuestionResponse = fourthQuestion.text! as String
        
        if fourthQuestion.text! == "" {
            fourthQuestionResponse = "No response"
        }
        
        let responses = [
                         "emailAddress": Auth.auth().currentUser?.email,
                         "firstQuestion": selectOutlet.titleLabel?.text,
                         "secondQuestion": buttonResponse as String,
                         "thirdQuestion": minDisplay.text! as String,
                         "fourthQuestion": fourthQuestionResponse
            
        ]
        
        refResponse.child(key).setValue(responses)
        

        fourthQuestion.text = ""
        selectOutlet.setTitle("Select a Subject", for: .normal)
        buttonResponse = ""
        minDisplay.text = "Time: 0 minutes"
        sliderOutlet.value = 0
        
        button1Outlet.isSelected = false
        button2Outlet.isSelected = false
        button3Outlet.isSelected = false
        button4Outlet.isSelected = false
        button5Outlet.isSelected = false
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
        currentUser.text = "Current User: \(Auth.auth().currentUser?.email ?? "N/A")"
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
    
    @IBAction func handleSelection(_ sender: UIButton) {
        subjectButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    enum Subjects: String {
        case english = "English"
        case history = "History"
        case math = "Math"
        case science = "Science"
        case language = "World Language"
        case elective = "Elective"
    }
    
    @IBAction func subjectTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let subject = Subjects(rawValue: title) else {
            return
        }
        
        switch subject {
            
        case .english:
            print("Enlgish")
            selectOutlet.setTitle("English", for: .normal)
        case .history:
            print("History")
            selectOutlet.setTitle("History", for: .normal)
        case .math:
            print("Math")
            selectOutlet.setTitle("Math", for: .normal)
        case .science:
            print("Science")
            selectOutlet.setTitle("Science", for: .normal)
        case .language:
            print("World Language")
            selectOutlet.setTitle("World Language", for: .normal)
        case .elective:
            print("Elective")
            selectOutlet.setTitle("Elective", for: .normal)
        
        }
        
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
