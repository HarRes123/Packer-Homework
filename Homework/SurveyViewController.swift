//
//  SurveyViewController.swift
//  Homework
//
//  Created by Harrison Resnick on 6/22/19.
//  Copyright © 2019 Et Cetera. All rights reserved.
//

import UIKit
import Firebase

class SurveyViewController: UIViewController {

    @IBOutlet weak var firstQuestion: UITextField!
    @IBOutlet weak var secondQuestion: UITextField!
    @IBOutlet weak var thirdQuestion: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var titleLabelText: UILabel!
    
    var refResponse: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refResponse = Database.database().reference().child("response")
        labelMessage.text = ""
        titleLabelText.text = "\nPlease Answer the Following Questions"

        // Do any additional setup after loading the view.
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
        labelMessage.text = "Added"
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
