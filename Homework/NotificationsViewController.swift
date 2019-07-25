//
//  NotificationsViewController.swift
//  Homework
//
//  Created by Harrison Resnick on 7/22/19.
//  Copyright © 2019 Et Cetera. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsViewController: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var notifcationOutlet: UIButton!
    @IBOutlet weak var cancelOutlet: UIButton!
    @IBOutlet weak var repeatOutlet: UIButton!
    
    var dateComponent = DateComponents()
    var shouldRepeat = false
    
    var alertNotification = ""
    var message = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        notifcationOutlet.layer.cornerRadius = 8
        cancelOutlet.layer.cornerRadius = 8
        repeatOutlet.layer.cornerRadius = 8
        
        repeatOutlet.setTitle("Not Repeating", for: .normal)
        repeatOutlet.setTitle("Repeating", for: .selected)
        
        dateComponent = datePicker.calendar.dateComponents([.day, .hour, .minute], from: datePicker.date)

        
    }
    
    func presentPopOver() {
        
        let alert = UIAlertController(title: alertNotification, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)

        self.checkForNotifications()
        
    }
    
    
    @IBAction func setNotification(_ sender: Any) {
        
        alertNotification = "Notification Set"
        scheduleNotification()
        presentPopOver()
    }
    
    @IBAction func cancelNotification(_ sender: Any) {
        
        alertNotification = "Notification Canceled"
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        presentPopOver()
    }
    
    @IBAction func repeatNotification(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
    }
    
    func checkForNotifications() {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
            print(notifications)

            DispatchQueue.main.async {
                if notifications != [] {
                    
                    self.cancelOutlet?.isEnabled = true
                    self.cancelOutlet.backgroundColor = .appleBlue()
                    
                } else {
                    
                    self.cancelOutlet?.isEnabled = false
                    self.cancelOutlet.backgroundColor = .gray
                    
                }
                
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    
        self.checkForNotifications()
        

    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent() //The notification's content
        content.title = "Reminder: Complete Survey"
        content.sound = UNNotificationSound.default

        
        if(repeatOutlet.isSelected == true) {
            
            print("Enabled")
            
         // dateComponent = datePicker.calendar.dateComponents([.second], from: datePicker.date)
            dateComponent = datePicker.calendar.dateComponents([.hour, .minute], from: datePicker.date)
            shouldRepeat = true
            
            
        } else {
            
            print("Disabled")
            
            dateComponent = datePicker.calendar.dateComponents([.day, .hour, .minute], from: datePicker.date)
            shouldRepeat = false
            
        }
        
        //let dateComponent2 = datePicker.calendar.dateComponents([.day, .hour, .minute], from: datePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: shouldRepeat)
        
        let notificationReq = UNNotificationRequest(identifier: "completeSurvey", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(notificationReq, withCompletionHandler: nil)
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

extension UIColor {
    static func appleBlue() -> UIColor {
        return UIColor(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
    }
}
