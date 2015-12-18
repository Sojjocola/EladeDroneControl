//
//  DroneStartBehaviour.swift
//  EladeDroneControl
//
//  Created by François Chevalier on 26/09/2015.
//  Copyright © 2015 François Chevalier. All rights reserved.
//

import Foundation
import Darwin
import CoreLocation

class DroneStartBehaviour {
    
    
    var heading:Int?
    var altitude:Int?
    var gpsPosition:CLLocationCoordinate2D?
    
    func generateIntialGpsPosition(basePosition:CLLocationCoordinate2D) {
        
        //http://www.movable-type.co.uk/scripts/latlong-vincenty-direct.html
        
        let φ1 = basePosition.latitude.degreesToRadians
        let λ1 = basePosition.longitude.degreesToRadians
        let α1 = heading!.degreesToRadians;
        let s:Double = 4 // Distance par défaut 4m
        
        let a:Double = 6378137.0
        let b:Double = 6356752.314245
        let f:Double = 1 / 298.257223563
        
        
        let sinα1 = sin(α1)
        let cosα1 = cos(α1)
        
        let tanU1 = Double(1-f) * tan(φ1)
        let cosU1 = 1 / sqrt((1 + tanU1*tanU1))
        let sinU1 = tanU1 * cosU1
        
        let σ1 = atan2(tanU1, cosα1)
        let sinα = cosU1 * sinα1
        let cosSqα = 1 - sinα*sinα
        let uSq = cosSqα * (a*a - b*b) / (b*b)
        let A = 1 + uSq/16384*(4096+uSq*(-768+uSq*(320-175*uSq)))
        let B = uSq/1024 * (256+uSq*(-128+uSq*(74-47*uSq)))
        
        
        var cos2σM:Double
        var sinσ:Double
        var cosσ:Double
        var Δσ:Double
        
        var σ:Double = s / (b*A)
        var σʹ:Double
        var iterations = 0
        
        repeat {
            cos2σM = cos(2*σ1 + σ);
            sinσ = sin(σ)
            cosσ = cos(σ)
            Δσ = B*sinσ*(cos2σM+B/4*(cosσ*(-1+2*cos2σM*cos2σM) - B/6*cos2σM*(-3+4*sinσ*sinσ)*(-3+4*cos2σM*cos2σM)))
            σʹ = σ;
            σ = s / (b*A) + Δσ;
        } while (abs(σ-σʹ) > 1e-12 && ++iterations<200);
        

        let x:Double = sinU1*sinσ - cosU1*cosσ*cosα1
        let φ2:Double = atan2(sinU1*cosσ + cosU1*sinσ*cosα1, (1-f)*sqrt(sinα*sinα + x*x))
        let λ:Double = atan2(sinσ*sinα1, cosU1*cosσ - sinU1*sinσ*cosα1)
        let C:Double = f/16*cosSqα*(4+f*(4-3*cosSqα))
        let L:Double = λ - (1-C) * f * sinα * (σ + C*sinσ*(cos2σM+C*cosσ*(-1+2*cos2σM*cos2σM)))
        var λ2:Double = (λ1 + L + 3 * M_PI) % (2 * M_PI)
        λ2 = λ2 - M_PI // normalise to -180...+180
        
        gpsPosition = CLLocationCoordinate2D(latitude: φ2.radiansToDregrees, longitude: λ2.radiansToDregrees)
        
    }
}

extension Int {
    var degreesToRadians : Double {
        return Double(self) * M_PI / 180.0
    }
}

extension CLLocationDegrees {
    var degreesToRadians : Double {
        return Double(self) * M_PI / 180.0
    }
}

extension Double {
    var radiansToDregrees : Double {
        return self * 180 / M_PI
    }
}
