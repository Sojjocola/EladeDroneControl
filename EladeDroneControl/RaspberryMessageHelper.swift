//
//  RaspberryMessageHelper.swift
//  EladeDroneControl
//
//  Created by François Chevalier on 27/09/2015.
//  Copyright © 2015 François Chevalier. All rights reserved.
//

import Foundation


class RaspberryMessageHelper {
    
    
    
    func encodeInitialPositionMessage(dsb:DroneStartBehaviour) -> String {
        
        
        
        return ""
    }
    
    
    
    func encodeNextPositionMessage(velocityX:Int, velocityY:Int, velocityZ:Int) -> String {
        
        
        return ""
    }
    
    
    func decodeIncommingMessage(message:String) -> (type:TypeReturnMessage,value:String) {
        
        
        return (.Ack,"")
    }
    
    
}


enum TypeReturnMessage {
    case Ack
    case CheckList
    case Error
    case Alarm
}