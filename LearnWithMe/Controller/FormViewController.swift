//
//  FormViewController.swift
//  LearnWithMe
//
//  Created by Nathan Pillai on 7/25/18.
//  Copyright © 2018 Nathan Pillai. All rights reserved.
//

import UIKit
import EventKit

class FormViewController: UIViewController{

    var skillText = ""
    var accomplishmentText = ""
    var emailText = ""
    var phoneNumberText = ""
    var calendarName = ""
    var calendars: [EKCalendar]?
    var calendar: EKCalendar?
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
   override func viewWillAppear(_ animated: Bool) {
        checkCalendarAuthorizationStatus()
    }
    
    @IBOutlet weak var skillTextField: UITextField!
    @IBOutlet weak var accomplishmentTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var calendarNameTextField: UITextField!
    
    @IBOutlet weak var needPermissionView: UIView!
    
    
    @IBAction func unwindToForm(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("UNWIND SEGUE BACK TO FormViewController")
    }
    
    @IBAction func toInviteViewController(_ sender: Any) {
        self.skillText = skillTextField.text!
        self.accomplishmentText = accomplishmentTextField.text!
        self.emailText = emailTextField.text!
        self.phoneNumberText = phoneNumberTextField.text!
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        
        if identifier == "toCalendar"{
            if (calendarNameTextField.text?.isEmpty)!{
                print("You must enter a name for calendar")
                return false
            }
            else{return true}
        }
        return true
    }

    
    func createNewCalendar() -> EKCalendar {
        
    
        // Create an Event Store instance
        let eventStore = EKEventStore()
        
        // Use Event Store to create a new calendar instance
        // Configure its title
        let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
    
        // Probably want to prevent someone from saving a calendar
        // if they don't type in a name...
        newCalendar.title = "Calendar Name"
        
        // Access list of available sources from the Event Store
        let sourcesInEventStore = eventStore.sources
        
        // Filter the available sources and select the "Local" source to assign to the new calendar's
        // source property
        newCalendar.source = sourcesInEventStore.filter{
            (source: EKSource) -> Bool in
            source.sourceType.rawValue == EKSourceType.local.rawValue
            }.first!
        
        // Save the calendar using the Event Store instance
        do {
            try eventStore.saveCalendar(newCalendar, commit: true)
            UserDefaults.standard.set(newCalendar.calendarIdentifier, forKey: "EventTrackerPrimaryCalendar")
        } catch {
            let alert = UIAlertController(title: "Calendar could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        

        
        return newCalendar

    }
    
    
    func requestAccessToCalendar() {
        
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    
                    //TO DO: WHAT TO OUT IN HERE? SEGUE TO VIEW CONTROLLER?
                    
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.needPermissionView.fadeIn()
                })
            }
        })
    }
    
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            print("not Determined")
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            print("authorized")

        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            needPermissionView.fadeIn()
            print("restricted")
        }
    }

    
    @IBAction func toCalendarViewController(_ sender: Any) {
        
        
        
        if (calendarNameTextField.text?.isEmpty)!{
            let alert = UIAlertController(title: "No Calendar Name", message: "Must enter a calendar name in order to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
            
                }}))
            
            self.present(alert, animated: true, completion: nil)
            print("You must enter a name for calendar")
        } else {
            
            performSegue(withIdentifier: "toCalendar", sender: self)
            
            
         
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue"{
            var InviteVC = segue.destination as! InviteViewController
            
            InviteVC.skillString = "Lets learn \(self.skillText) together"
            InviteVC.accomplishmentString = self.accomplishmentText
            InviteVC.phoneNumberString = self.phoneNumberText
            InviteVC.emailString = self.emailText
        }
        if segue.identifier == "toCalendar"{
            let CalVC = segue.destination as! UINavigationController
            let CalendarVC = CalVC.topViewController as! CalendarViewController
            
            guard let calendarNameText = calendarNameTextField.text else{return}
            
            calendar = createNewCalendar()
            print("Help me Uchenna: \(calendar)")
            
            CalendarVC.calendar = self.calendar
            CalendarVC.calendarName = calendarNameText
            
        }
    }


}



extension UIView {
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}







