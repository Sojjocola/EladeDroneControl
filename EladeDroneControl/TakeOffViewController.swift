//
//  TakeOffViewController.swift
//  EladeDroneControl
//
//  Created by François Chevalier on 20/09/2015.
//  Copyright © 2015 François Chevalier. All rights reserved.
//

import UIKit
import Starscream
import CoreLocation


class TakeOffViewController: UIViewController,WebSocketDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var connexionLabel: UILabel!
    @IBOutlet weak var suiviLabel: UILabel!
    @IBOutlet weak var checklistLabel: UILabel!
    @IBOutlet weak var actionDroneButton: UIButton!
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var locationManager = (UIApplication.sharedApplication().delegate as! AppDelegate).locationManager
    var isInitialPosition = true
    var autoFlightMode = false
    var droneIsReady = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager?.delegate = self
        actionDroneButton.enabled = false
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if appDelegate.socket == nil {
            appDelegate.socket = WebSocket(url: NSURLComponents(string: "ws://\(appDelegate.host!):\(appDelegate.port!)/ws")!.URL!)
        }
        
        appDelegate.socket?.delegate = self;
        appDelegate.socket?.connect()
    }
    
    override func viewWillDisappear(animated: Bool) {
    
        if(appDelegate.socket!.isConnected) {
            appDelegate.socket?.disconnect()
        }
        
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
   
    
    @IBAction func actionDroneButtonPressed(sender: UIButton) {
        
        if !autoFlightMode {
            
            autoFlightMode = true
            
            if sendTakeOffInstruction() {
                locationManager?.startUpdatingHeading()
                 actionDroneButton.setTitle("Atterissage", forState: .Normal)
            }
            
           
            
        } else {
            autoFlightMode = false
            
            locationManager?.stopUpdatingLocation()
            
            if sendLandingInstruction() {
            
                actionDroneButton.setTitle("Décollage!!", forState: .Normal)
            }
        }
        
        
        
    }
    
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
        connexionLabel.textColor = UIColor.greenColor()
        connexionLabel.text = "OK!"
       
        locationManager?.startUpdatingLocation()
    }
    
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocket is disconnected: \(error?.localizedDescription)")
        connexionLabel.textColor = UIColor.blackColor()
        connexionLabel.text = "Déconnecté..."
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
        
        
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("got some data: \(data.length)")
    }
    
    
    func locationManager(manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {
           
            if isInitialPosition {
                
                let currentLocation = locations[0].coordinate
                locationManager?.stopUpdatingLocation()
                
                
                appDelegate.droneStartBehaviour?.generateIntialGpsPosition(currentLocation)
                
                appDelegate.socket?.writeString("INIT/Alt:\(appDelegate.droneStartBehaviour!.altitude!)/heading:\(appDelegate.droneStartBehaviour!.heading!)/gpsfix:\(appDelegate.droneStartBehaviour!.gpsPosition!.latitude),\(appDelegate.droneStartBehaviour!.gpsPosition!.longitude)")
                
                isInitialPosition = false
                
            } else if autoFlightMode {
                
                appDelegate.socket?.writeString("Location changed \(locations[0].altitude)")
            }
            
    }
    

    
    func sendTakeOffInstruction() -> Bool {
        return true
    }
    
    
    func sendLandingInstruction() -> Bool {
        
        return true
    }
    
}
