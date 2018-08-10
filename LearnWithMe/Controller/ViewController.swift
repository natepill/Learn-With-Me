//
//  ViewController.swift
//  LearnWithMe
//
//  Created by Nathan Pillai on 7/23/18.
//  Copyright © 2018 Nathan Pillai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet var ViewControllerView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
    }

    @IBAction func viewSchedule(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "calshow://")! as URL)

    }
    
    @IBAction func unwindToViewController(for unwindSegue: UIStoryboard, towardsViewController subsequentVC: UIViewController){        print("UNWIND SEGUE BACK TO VIEWCONTROLLER")}
    


}

