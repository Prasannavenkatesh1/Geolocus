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
    var latitude : CLLocationDegrees
    var longitude : CLLocationDegrees
    
    init (latitude : CLLocationDegrees, longitude : CLLocationDegrees) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

class Event {
    var location : EventLocation
    var type : EventType
    var message : String
    
    init(location : EventLocation, type : EventType, message : String){
        self.location = location
        self.type = type
        self.message = message
    }
}

class SpeedZone {
    var maxSpeed : Int
    var aboveSpeed : Int
    var withinSpeed : Int
    var violationCount : Int
    var speedBehaviour : Int
    var distanceTravelled : Int
    
    init(maxSpeed : Int, aboveSpeed : Int, withinSpeed : Int, violationCount : Int, speedBehaviour : Int, distanceTravelled : Int){
        self.maxSpeed = maxSpeed
        self.aboveSpeed = aboveSpeed
        self.withinSpeed = withinSpeed
        self.violationCount = violationCount
        self.speedBehaviour = speedBehaviour
        self.distanceTravelled = distanceTravelled
    }
}

class TripScore {
    var speedScore : Int
    var ecoScore : Int
    var attentionScore : Int?  //neglect in iOS
    
    init(speedScore : Int, ecoScore : Int, attentionScore : Int?){
        
        self.speedScore     = speedScore
        self.ecoScore       = ecoScore
        self.attentionScore = attentionScore
    }
}

class History {
    
    
    
    var tripId : Int
    var tripdDate : NSDate
    var distance : Int
    var tripPoints : Int
    var tripDuration : Int
    var tripScore : TripScore
    var eventLocations : [Event]?
    var speedZones : [SpeedZone]
    
    init(tripid : Int, tripDate : String, distance : Int, tripPoints : Int, tripDuration : Int, tripScore : TripScore,eventLocations : [Event]?, speedZones : [SpeedZone]) {
        
        self.tripId         = tripid
        self.tripdDate      = NSDate(dateString: tripDate)
        self.distance       = distance
        self.tripPoints     = tripPoints
        self.tripDuration   = tripDuration
        self.tripScore      = tripScore
        self.eventLocations = eventLocations
        self.speedZones     = speedZones
        
    }
    
}