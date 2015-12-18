//
//  StepTwoViewController.swift
//  EladeDroneControl
//
//  Created by François Chevalier on 20/09/2015.
//  Copyright © 2015 François Chevalier. All rights reserved.
//

import UIKit

class StepTwoViewController: UIViewController {

    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate.droneStartBehaviour?.altitude = Int(slider.value)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        altitudeLabel.text = String(Int(slider.value))
        appDelegate.droneStartBehaviour?.altitude = Int(slider.value)
    }

    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        //LightContent
        return UIStatusBarStyle.LightContent
        
        //Default
        //return UIStatusBarStyle.Default
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Connexion" {
            segue.destinationViewController.navigationItem.title = "Connexion"
        }
    }
    

}
