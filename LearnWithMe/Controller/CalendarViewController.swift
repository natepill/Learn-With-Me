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

    
    let eventStore = EKEventStore()
    var calendars: [EKCalendar]?
    var calendar: EKCalendar?
    
    var events = [EKEvent]() {
        didSet {
            calendarTableView.reloadData()
        }
    }
    var calendarName = ""
    
    
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var needPermissionView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if events != nil {
//            print("This is an array of calendar events: \(events)")
//            loadEvents()
//        }
//
//        print("Events Count: \(events.count)")
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        checkCalendarAuthorizationStatus()
        
        if events != nil {
            print("This is an array of calendar events: \(events)")
            loadEvents()
        }
        
        print("Events Count: \(events.count)")
        
        print("The calendar name that was passed through the previous VC was: \(calendarName)!")
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
        
//        if let startDate = startDate, let endDate = endDate {
//            let eventStore = EKEventStore()
//
//            guard let calendar = self.calendar else { return
//                assertionFailure("Failed to receive calender")
//            }
//
//            let eventsPredicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
//
//
//            self.events = eventStore.events(matching: eventsPredicate).sorted {
//                (e1: EKEvent, e2: EKEvent) in
//
//                return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
//            }
//        }
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarEventCell", for: indexPath)
        let event = events[indexPath.row]
        
        cell.textLabel?.text = event.title
        cell.detailTextLabel?.text = formatDate(event.startDate)
//        cell.textLabel?.text = events[(indexPath as NSIndexPath).row].title
//        cell.detailTextLabel?.text = formatDate(events[(indexPath as NSIndexPath).row].startDate)
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

        self.performSegue(withIdentifier: "eventAddedSegue", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "eventAddedSegue"{
        let destinationVC = segue.destination as! AddEventViewController
        destinationVC.calendar = self.calendar
        destinationVC.delegate = self
            
        }
    }
    
    
    
    
    func eventDidAdd() {
        
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
