//
//  HistoryData.swift
//  GeoLocus
//
//  Created by CTS MAC on 27/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

/**
 Types of event during driving.
 
    - Acceleration:     Acceleration Event
    - Breaking:         Breaking event
    - Speeding:         Speeding event
    - None:             No event
 */
enum EventType: Int {
  case Acceleration
  case Breaking
  case Speed
  case None
}
/**
 Store event location
    
    - latitude:         Latitude of location
    - longitude:        Longitude of location
*/
class EventLocation {
    
    let latitude    : CLLocationDegrees
    let longitude   : CLLocationDegrees
    
    init (latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.latitude   = latitude
        self.longitude  = longitude
    }
}

/**
 Store events occured during driving
 
    - location:         Location of event
    - type:             Typre of event
    - message:          Message to user for that event
 */
class Event {
    
    let location    : EventLocation
    let type        : EventType
    let value       : NSNumber
    let message     : String?
    let fineMessage : String?
    var threshold   : NSNumber = 0
    var isSevere    : String = "0"
    
    init(location : EventLocation, type : EventType, value : NSNumber, message : String?, fineMessage: String?, threshold: NSNumber, isSevere : String){
        self.location = location
        self.type     = type
        self.value    = value
        self.message  = message
        self.fineMessage = fineMessage
        self.threshold = threshold
        self.isSevere = isSevere
    }
}

/**
 Store details of trip as per speed zone defined
 
    - speedScore:           Speed score to the trip
    - maxSpeed:             Max permissible speed of the trip
    - aboveSpeed:           Number of times user drived beyond max speed
    - withinSpeed:          Number of times user drived within max speed
    - violationCount:       Count of violations
    - speedBehaviour:       SpeedBehaviour of trip
    - distanceTravelled:    Distance travelled in trip
 */
class SpeedZone {
    
    let speedScore          : NSNumber
    let maxSpeed            : NSNumber
    let aboveSpeed          : NSNumber
    let withinSpeed         : NSNumber
    let violationCount      : NSNumber
    let speedBehaviour      : NSNumber
    let distanceTravelled   : NSNumber
    
    init(speedScore: NSNumber, maxSpeed: NSNumber, aboveSpeed: NSNumber, withinSpeed: NSNumber, violationCount: NSNumber, speedBehaviour: NSNumber, distanceTravelled: NSNumber){
        
        self.speedScore         = speedScore
        self.maxSpeed           = maxSpeed
        self.aboveSpeed         = aboveSpeed
        self.withinSpeed        = withinSpeed
        self.violationCount     = violationCount
        self.speedBehaviour     = speedBehaviour
        self.distanceTravelled  = distanceTravelled
    }
}

/**
 Store scores of a trip
 
    - overallScore:         Overall Score of trip
    - speedScore:           Speed Score of trip
    - ecoScore:             Eco score of trip
    - attentionScore:       Attention score of the trip. Not measured for iOS devices. Instead use 'dataUsageMessage' from 'History'
 */
class TripScore {
    
    let overallScore    : NSNumber
    let speedScore      : NSNumber
    let ecoScore        : NSNumber
    let attentionScore  : NSNumber?
    
    init(overallScore: NSNumber, speedScore: NSNumber, ecoScore: NSNumber, attentionScore: NSNumber?){
        
        self.overallScore   = overallScore
        self.speedScore     = speedScore
        self.ecoScore       = ecoScore
        self.attentionScore = attentionScore
    }
}


///History class encapsulate all the trip related details of the user. It is used as data model for Dashboard History page
class History {
    
    let tripId          : String
    let tripdDate       : String
    let distance        : NSNumber
    let tripPoints      : NSNumber
    let tripDuration    : NSNumber
    let speedingMessage : String?
    let ecoMessage      : String?
    let dataUsageMessage: String?
    let tripScore       : TripScore
    let events          : [Event]?
    let speedZones      : [SpeedZone]
    
    /**
     Initializes a new history trip with the provided info.
     
     - Parameters:
        - tripId:              Unique Id of trip
        - tripdDate:           Date of trip
        - distance:            Distance travelled in trip
        - tripDuration:        Duration of trip
        - speedingMessage:     Message to user as per the speed score
        - ecoMessage :         Message to user as per Eco score
        - dataUsageMessage:    Instead of Attention message, user will get message regarding data usage during trip
        - tripScore:           All scores of a trip
        - events:              List of events in the trip. This is displayed in the map
        - speedZones:          Inforamtion of trip as speed zones
     
     - Returns: Instance of trip details
     */
    init(tripid: String, tripDate: String, distance: NSNumber, tripPoints: NSNumber, tripDuration: NSNumber, speedingMessage: String?, ecoMessage: String?, dataUsageMessage: String?, tripScore: TripScore,events: [Event]?, speedZones: [SpeedZone]) {
        
        self.tripId             = tripid
        self.tripdDate          = tripDate
        self.distance           = distance
        self.tripPoints         = tripPoints
        self.tripDuration       = tripDuration
        self.speedingMessage    = speedingMessage
        self.ecoMessage         = ecoMessage
        self.dataUsageMessage   = dataUsageMessage
        self.tripScore          = tripScore
        self.events             = events
        self.speedZones         = speedZones
        
    }
}