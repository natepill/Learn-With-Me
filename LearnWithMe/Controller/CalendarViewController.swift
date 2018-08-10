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
    var events = [Event]()
    var calendarName = ""
    
    
    //    var events = [EKEvent]() {
    //        didSet {
    //            calendarTableView.reloadData()
    //        }
    //    }
    
    
    
    @IBOutlet weak var calendarTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarTableView.dataSource = self
        calendarTableView.delegate = self
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Implement with CoreData
        getData()
        calendarTableView.reloadData()
        
        
    }
    
    @IBAction func unwindToCalendarViewController(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("UNWIND SEGUE BACK TO CALENDAR VIEWCONTROLLER")
    }
    
    
    
    //    func loadEvents() {
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy-MM-dd"
    //
    //        let startDate = dateFormatter.date(from: "2016-01-01")
    //        let endDate = dateFormatter.date(from: "2016-12-31")
    //
    //    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return calendarEvents.count
        
        return events.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        IMPLEMENT WITH CORE DATA
        let cell = UITableViewCell()
        let event = events[indexPath.row]
        cell.textLabel?.text = event.title
        cell.detailTextLabel?.text = formatDate(event.startDate)
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarEventCell", for: indexPath) as! UITableViewCell
        //        let event = events[indexPath.row]
        //        cell.textLabel?.text = event.title
        //        cell.detailTextLabel?.text = formatDate(event.startDate)
        
        return cell
        
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete{
            let event = events[indexPath.row]
            context.delete(event)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do{
                events = try context.fetch(Event.fetchRequest())
            }catch{
                print("fetching failed")
            }
            
            calendarTableView.reloadData()

        }
        
    }
    
    
    func getData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            events = try context.fetch(Event.fetchRequest())
        }catch{
            print("fetching failed")
        }
    }
    
    func formatDate(_ date: Date?) -> String {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    
    
    
    
    
    @IBAction func addCalendarButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "eventAddedSegue", sender: self)
    }
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //        if segue.identifier == "eventAddedSegue"{
    //        let destinationVC = segue.destination as! AddEventViewController
    //        destinationVC.calendar = self.calendar
    //        destinationVC.delegate = self
    //
    //        }
    
    func eventDidAdd() {
        
    }
    
    
}











