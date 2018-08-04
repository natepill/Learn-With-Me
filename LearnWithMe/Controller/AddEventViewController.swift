//
//  AddEventViewController.swift
//  LearnWithMe
//
//  Created by Nathan Pillai on 7/30/18.
//  Copyright © 2018 Nathan Pillai. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import EventKitUI


class AddEventViewController: UIViewController{
    
    var eventStore = EKEventStore()
    var calendar: EKCalendar! // Passed in from previous view controller
    var events: [EKEvent]?
    var delegate: EventAddedDelegate?
    
    @IBOutlet weak var benchMarkNameTextField: UITextField!
    @IBOutlet weak var eventStartDatePicker: UIDatePicker!
    @IBOutlet weak var eventEndDatePicker: UIDatePicker!
    @IBOutlet weak var cancelButtonTapped: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(calendar)
        self.eventStartDatePicker.setDate(initialDatePickerValue(), animated: false)
        self.eventEndDatePicker.setDate(initialDatePickerValue(), animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // check safely with guard that your save button is the sender and you can use it
        // if not print message
        guard let uiBarButtonItem = sender as? UIBarButtonItem else {
            print("There is no UIBarButtonItem sender")
            return
        }
        
        // check if you selected the save button
        if cancelButtonTapped == uiBarButtonItem {
            print("save button selected")
        }
    }
    

    

    
    @IBAction func AddEventButtonTapped(_ sender: Any) {
        
        print("AddEventButtonTapped")
        // Create an Event Store instance
        let eventStore = EKEventStore()

        // Use Event Store to create a new calendar instance
        if let calendarForEvent = eventStore.calendar(withIdentifier: self.calendar.calendarIdentifier)
        {
            let newEvent = EKEvent(eventStore: eventStore)
            
            newEvent.calendar = calendarForEvent
            newEvent.title = self.benchMarkNameTextField.text ?? "BenchMark"
            newEvent.startDate = self.eventStartDatePicker.date
            newEvent.endDate = self.eventEndDatePicker.date
            
            // Save the calendar using the Event Store instance
            
            do {
                try eventStore.save(newEvent, span: .thisEvent, commit: true)
                delegate?.eventDidAdd()
                print("CREATED EVENT")
                self.dismiss(animated: true, completion: nil)
            } catch {
                let alert = UIAlertController(title: "Event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                
                self.present(alert, animated: true, completion: nil)

            }
        }
    }
    
    
    
    
    func initialDatePickerValue() -> Date {
        let calendarUnitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]
        
        var dateComponents = (Calendar.current as NSCalendar).components(calendarUnitFlags, from: Date())
        
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return Calendar.current.date(from: dateComponents)!
    }
    
    
    

}
