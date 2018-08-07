//
//  FormViewController.swift
//  LearnWithMe
//
//  Created by Nathan Pillai on 7/25/18.
//  Copyright © 2018 Nathan Pillai. All rights reserved.
//

import UIKit

class FormViewController: UIViewController{

    var skillText = ""
    var accomplishmentText = ""
    var emailText = ""
    var phoneNumberText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var skillTextField: UITextField!
    @IBOutlet weak var accomplishmentTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var calendarNameTextField: UITextField!
    
    
    @IBAction func unwindToForm(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("UNWIND SEGUE BACK TO FormViewController")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue"{
            var InviteVC = segue.destination as! InviteViewController

            InviteVC.skillString = "Lets learn \(self.skillText) together"
            InviteVC.accomplishmentString = self.accomplishmentText
            InviteVC.phoneNumberString = self.phoneNumberText
            InviteVC.emailString = self.emailText
        }
            if segue.identifier == "toCalendar"{
                var CalendarVC = segue.destination as! CalendarViewController
                guard let calendarNameText = calendarNameTextField.text else{return}
                CalendarVC.calendarName = calendarNameText
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
            }
            else{performSegue(withIdentifier: "toCalendar", sender: self)}
        

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
