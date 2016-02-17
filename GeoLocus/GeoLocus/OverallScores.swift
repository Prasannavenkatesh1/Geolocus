//
//  OverallScores.swift
//  GeoLocus
//
//  Created by CTS MAC on 05/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

class OverallScores {
    
    let overallScore        : NSNumber
    let speedingScore       : NSNumber
    let ecoScore            : NSNumber
    var attentionScore      : NSNumber?
    let distanceTravelled   : NSNumber
    let dataUsageMsg        : String
    let overallmessage      : String
    let speedingMessage     : String
    let ecoMessage          : String
    
    init (overallScore: NSNumber, speedingScore: NSNumber, ecoScore: NSNumber, distanceTravelled: NSNumber, dataUsageMsg: String, overallmessage: String, speedingMessage: String, ecoMessage: String){
        self.overallScore       = overallScore
        self.speedingScore      = speedingScore
        self.ecoScore           = ecoScore
        self.distanceTravelled  = distanceTravelled
        self.dataUsageMsg       = dataUsageMsg
        self.overallmessage     = overallmessage
        self.speedingMessage    = speedingMessage
        self.ecoMessage         = ecoMessage
        
    }
}