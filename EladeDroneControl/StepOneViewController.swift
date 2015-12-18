//
//  StepOneViewController.swift
//  EladeDroneControl
//
//  Created by François Chevalier on 20/09/2015.
//  Copyright © 2015 François Chevalier. All rights reserved.
//

import UIKit

class StepOneViewController: UIViewController {

    @IBOutlet weak var positionImage: UIImageView!
    @IBOutlet weak var slider: UISlider!
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appDelegate.droneStartBehaviour == nil {
            appDelegate.droneStartBehaviour = DroneStartBehaviour()
        }
        
        
        appDelegate.droneStartBehaviour?.heading = Int(slider.value)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        //LightContent
        return UIStatusBarStyle.LightContent
        
        //Default
        //return UIStatusBarStyle.Default
        
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
    
        positionImage.transform = CGAffineTransformMakeRotation(CGFloat(slider.value) * 2 * CGFloat(M_PI) / CGFloat(slider.maximumValue));
        appDelegate.droneStartBehaviour?.heading = Int(slider.value)
    
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Step2" {
            segue.destinationViewController.navigationItem.title = "Etape 2"
        }
    }
    

}
