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
    var events = [EKEvent]()
    
    var delegate: EventAddedDelegate?
   
    
    @IBOutlet weak var benchMarkNameTextField: UITextField!
    @IBOutlet weak var eventStartDatePicker: UIDatePicker!
    @IBOutlet weak var eventEndDatePicker: UIDatePicker!
    @IBOutlet weak var cancelButtonTapped: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Calendar that passed into AddEventVC: \(calendar)")
        self.eventStartDatePicker.setDate(initialDatePickerValue(), animated: false)
        self.eventEndDatePicker.setDate(initialDatePickerValue(), animated: false)
    
    }
    
   override func viewWillAppear(_ animated: Bool) {
        eventStartDatePicker.minimumDate = Date()
        eventEndDatePicker.minimumDate = Date()
    }
    
    

    
    func createCalendarEvent() {
        
        
        // Create an Event Store instance
        let eventStore = EKEventStore()
        
        // Use Event Store to create a new calendar instance
//        guard let calendarForEvent = eventStore.calendar(withIdentifier: self.calendar.calendarIdentifier) else {
//            return assertionFailure("Failed to get calendar with id ")
//        }
        
        // create context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let event = Event(context: context)
        
        event.title = self.benchMarkNameTextField.text ?? "Default BenchMark"
        //event.calendar = calendarForEvent.calendarIdentifier
        event.startDate = self.eventStartDatePicker.date
        event.endDate = self.eventEndDatePicker.date
        
        //(UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        do {
            try context.save()
            
        } catch {
            print("Failed saving")
        }

        
        
//        navigationController?.popViewController(animated: true)
        
        
//        // Create an Event Store instance
//        let eventStore = EKEventStore()
//
//        // Use Event Store to create a new calendar instance
//        guard let calendarForEvent = eventStore.calendar(withIdentifier: self.calendar.calendarIdentifier) else {
//            return assertionFailure("Failed to get calendar with id ")
//        }
//
//        let newEvent = EKEvent(eventStore: eventStore)
//
//        newEvent.calendar = calendarForEvent
//        newEvent.title = self.benchMarkNameTextField.text ?? "Default BenchMark"
//        newEvent.startDate = self.eventStartDatePicker.date
//        newEvent.endDate = self.eventEndDatePicker.date
//
//        // Save the calendar using the Event Store instance
//
//        do {
//            try eventStore.save(newEvent, span: .thisEvent, commit: true)
//            delegate?.eventDidAdd()
//
//            // self.dismiss(animated: true, completion: nil)
//
//        } catch {
//            let alert = UIAlertController(title: "Event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
//            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(OKAction)
//            self.present(alert, animated: true, completion: nil)
//
//        }
//
//
//        //set event array to User defaults
//
//
//
//
//        self.events.append(newEvent)

    }
    
    
    
    @IBAction func AddEventButtonTapped(_ sender: Any) {
        
        print("AddEventButtonTapped")
        
        
        if (benchMarkNameTextField.text?.isEmpty)!{
            let alert = UIAlertController(title: "No Benchmark Name", message: "Must enter a benchmark name in order to continue", preferredStyle: .alert)
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
        } else {
            
            createCalendarEvent()

            self.performSegue(withIdentifier: "unwindToCalendarView", sender: self)
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
