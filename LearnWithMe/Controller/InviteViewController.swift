//
//  InviteViewController.swift
//  LearnWithMe
//
//  Created by Nathan Pillai on 7/25/18.
//  Copyright © 2018 Nathan Pillai. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {
    
    
    @IBOutlet weak var skillDisplayLabel: UILabel!
    
    @IBOutlet weak var accomplishDisplayLabel: UILabel!
    @IBOutlet weak var phoneDisplayLabel: UILabel!
    @IBOutlet weak var emailDisplayLabel: UILabel!
    
    
    var skillString = String()
    var accomplishmentString = String()
    var emailString = String()
    var phoneNumberString = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        skillDisplayLabel.text = skillString
        accomplishDisplayLabel.text = accomplishmentString
        phoneDisplayLabel.text = phoneNumberString
        emailDisplayLabel.text = emailString

    }
    
    
    
    @IBAction func takeScreenshotButtonTapped(_ sender: Any) {
            //Create the UIImage
            UIGraphicsBeginImageContext(view.frame.size)
        guard let CGContext = UIGraphicsGetCurrentContext() else {return}
        view.layer.render(in: CGContext)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else{return}
            UIGraphicsEndImageContext()
            //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
