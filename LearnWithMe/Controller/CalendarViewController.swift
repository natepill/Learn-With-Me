//
//  CalendarViewController.swift
//  LearnWithMe
//
//  Created by Nathan Pillai on 7/26/18.
//  Copyright © 2018 Nathan Pillai. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EventAddedDelegate {

    
    
    func eventDidAdd() {
        print("hello")
    }
    
    let dataSourceArray = ["Item 1", "Item 2", "Item 3"]
    let eventStore = EKEventStore()
    var calendars: [EKCalendar]?
    var calendar: EKCalendar!
    var events: [EKEvent]?
    
    
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var needPermissionView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if events != nil {
            loadEvents()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkCalendarAuthorizationStatus()
    }
    
    @IBAction func unwindToCalendarViewController(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("UNWIND SEGUE BACK TO CALENDAR VIEWCONTROLLER")
    }
    
    func loadCalendars() {
        self.calendars = eventStore.calendars(for: EKEntityType.event)
    }
    
    func refreshTableView() {
        calendarTableView.isHidden = false
        calendarTableView.reloadData()
    }
    
    func loadEvents() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startDate = dateFormatter.date(from: "2016-01-01")
        let endDate = dateFormatter.date(from: "2016-12-31")
        
        if let startDate = startDate, let endDate = endDate {
            let eventStore = EKEventStore()
            
            let eventsPredicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [calendar])
            
            self.events = eventStore.events(matching: eventsPredicate).sorted {
                (e1: EKEvent, e2: EKEvent) in
                
                return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
            }
        }
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = events {
            return events.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarEventCell")!
        cell.textLabel?.text = events?[(indexPath as NSIndexPath).row].title
        cell.detailTextLabel?.text = formatDate(events?[(indexPath as NSIndexPath).row].startDate)
        return cell
    }
    
    func formatDate(_ date: Date?) -> String {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    

    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.loadCalendars()
                    self.refreshTableView()
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
            loadCalendars()
            refreshTableView()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            needPermissionView.fadeIn()
            print("restricted")
        }
    }
    
    
    
    @IBAction func addCalendarButtonTapped(_ sender: Any) {
        
        // Create an Event Store instance
        let eventStore = EKEventStore();
        
        // Use Event Store to create a new calendar instance
        let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
        
        // Probably want to prevent someone from saving a calendar
        // if they don't type in a name...
        newCalendar.title = "Some Calendar Name"
        
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
        
        self.calendar = newCalendar
        self.performSegue(withIdentifier: "eventAddedSegue", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("Before segue identifer")
        if segue.identifier == "eventAddedSegue"{
        let destinationVC = segue.destination as! AddEventViewController
        
//        let addEventVC = destinationVC.childViewControllers[0] as! AddEventViewController
        destinationVC.calendar = self.calendar
        destinationVC.delegate = self
            
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
