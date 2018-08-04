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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToForm(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("UNWIND SEGUE BACK TO FormViewController")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var skillTextField: UITextField!
    
    
    @IBAction func toInviteViewController(_ sender: Any) {
        self.skillText = skillTextField.text!
        performSegue(withIdentifier: "segue", sender: self)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue"{
            var InviteVC = segue.destination as! InviteViewController
            InviteVC.skillString = self.skillText
        }
        
    }
    
    @IBAction func toCalendarViewController(_ sender: Any) {
        performSegue(withIdentifier: "toCalendar", sender: self)
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
