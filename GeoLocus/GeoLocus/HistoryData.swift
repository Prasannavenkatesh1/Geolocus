//
//  HistoryData.swift
//  GeoLocus
//
//  Created by CTS MAC on 27/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

enum EventType: Int {
    case Acceleration
    case Breaking
    case Speeding
}

class EventLocation {
    
    let latitude    : CLLocationDegrees
    let longitude   : CLLocationDegrees
    
    init (latitude : CLLocationDegrees, longitude : CLLocationDegrees) {
        self.latitude   = latitude
        self.longitude  = longitude
    }
}

class Event {
    
    let location    : EventLocation
    let type        : EventType
    let message     : String
    
    init(location : EventLocation, type : EventType, message : String){
        self.location = location
        self.type     = type
        self.message  = message
    }
}

class SpeedZone {
    
    let speedScore          : NSNumber
    let maxSpeed            : NSNumber
    let aboveSpeed          : NSNumber
    let withinSpeed         : NSNumber
    let violationCount      : NSNumber
    let speedBehaviour      : NSNumber
    let distanceTravelled   : NSNumber
    
    init(speedScore: NSNumber, maxSpeed : NSNumber, aboveSpeed : NSNumber, withinSpeed : NSNumber, violationCount : NSNumber, speedBehaviour : NSNumber, distanceTravelled : NSNumber){
        
        self.speedScore         = speedScore
        self.maxSpeed           = maxSpeed
        self.aboveSpeed         = aboveSpeed
        self.withinSpeed        = withinSpeed
        self.violationCount     = violationCount
        self.speedBehaviour     = speedBehaviour
        self.distanceTravelled  = distanceTravelled
    }
}

class TripScore {
    
    let speedScore      : NSNumber
    let ecoScore        : NSNumber
    let attentionScore  : NSNumber?  //neglect in iOS
    
    init(speedScore : NSNumber, ecoScore : NSNumber, attentionScore : NSNumber?){
        
        self.speedScore     = speedScore
        self.ecoScore       = ecoScore
        self.attentionScore = attentionScore
    }
}

class History {
    
    let tripId          : String
    let tripdDate       : String
    let distance        : NSNumber
    let tripPoints      : NSNumber
    let tripDuration    : NSNumber
    let dataUsageMessage: String
    let tripScore       : TripScore
    let events          : [Event]?
    let speedZones      : [SpeedZone]
    
    init(tripid : String, tripDate : String, distance : NSNumber, tripPoints : NSNumber, tripDuration : NSNumber, dataUsageMessage: String, tripScore : TripScore,events : [Event]?, speedZones : [SpeedZone]) {
        
        self.tripId             = tripid
        self.tripdDate          = tripDate
        self.distance           = distance
        self.tripPoints         = tripPoints
        self.tripDuration       = tripDuration
        self.dataUsageMessage   = dataUsageMessage
        self.tripScore          = tripScore
        self.events             = events
        self.speedZones         = speedZones
        
    }
    
}