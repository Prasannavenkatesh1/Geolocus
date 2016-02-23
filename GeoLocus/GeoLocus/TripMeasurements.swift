//
//  TripMeasurements.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 18/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

struct TripMeasurements {
  var oldlocation:CLLocation
  var newlocation:CLLocation
  var oldlocspeed:CLLocationSpeed
  
  init(oldlocation:CLLocation, newlocation:CLLocation, oldlocspeed:CLLocationSpeed){
    self.oldlocation = oldlocation
    self.newlocation = newlocation
    self.oldlocspeed = oldlocspeed
  }
  
  var currentlocspeed:CLLocationSpeed
  {
    get
    {
      return speedTravelledFromLocation(newlocation, oldLocation: oldlocation)
    }
  }

  func speedTravelledFromLocation(newLocation:CLLocation , oldLocation:CLLocation) -> CLLocationSpeed{
    let timeElapsed:NSTimeInterval!  = newLocation.timestamp.timeIntervalSinceDate(oldLocation.timestamp)
    let distance:Double = newLocation.distanceFromLocation(oldLocation)
    let tempspeed:Double = distance / timeElapsed
    return tempspeed
  }
  
  func getTimeElapsed() -> NSTimeInterval{
    let timeElapsed:NSTimeInterval  = newlocation.timestamp.timeIntervalSinceDate(oldlocation.timestamp)
    return timeElapsed
  }
  
  func speedDifference() -> Double{
      var speedDifference:Double = 0.0
      //Speed difference
      let oldSpeed:Double = oldlocspeed;
      let newSpeed:Double = currentlocspeed;
      speedDifference = (newSpeed - oldSpeed) * 3.6;
      return speedDifference
  }
  
  func brakingCalculation (speedArray:[String], speedDifference:Double, thresholdBrake:Double) -> Bool {
    
    var isBraking = false
    var brakingvalue:Double = 0.0
    let braking:String = String(format:"%.1f",0.0) as String
   
    brakingvalue = fabs(speedDifference)
    
    if (speedDifference < 0)
    {
      
      var sumForBraking:Float = 0.0
      for i in 0..<speedArray.count{
        sumForBraking += Float(speedArray[i])!
      }
      
      if (brakingvalue > thresholdBrake) {
        isBraking = true
      }
    }
    
    return isBraking
  }
  
  func accelerationCalculation (speedArray:[String], speedDifference:Double, thresholdAcceleration:Double) -> Bool {
    
    var isAcceleration = false
    var acceleration:Double = 0.0
    var avgSpeed:Double =  0.0
    let braking:String = String(format:"%.1f",0.0) as String
    
    acceleration = Double(speedDifference) / Double(getTimeElapsed())
    
    if (speedDifference > 0)
    {
      var sum:Float = 0;
      for i in 0..<speedArray.count{
        sum += Float(speedArray[i])!
      }
//      avgSpeed = Float(sum)/Float(speedArray.count)
      
      if (acceleration > thresholdAcceleration) {
        isAcceleration = true
      }
    }
    
    return isAcceleration
  }
  
  func getDistanceInKm(newLocation:CLLocation,oldLocation:CLLocation) -> Double{
    var lat1,lon1,lat2,lon2: Double;
    
    lat1 = newLocation.coordinate.latitude  * M_PI / 180;
    lon1 = newLocation.coordinate.longitude * M_PI / 180;
    
    lat2 = oldLocation.coordinate.latitude  * M_PI / 180;
    lon2 = oldLocation.coordinate.longitude * M_PI / 180;
    
    let R:Double = 6371; // km
    let dLat:Double = lat2-lat1;
    let dLon:Double = lon2-lon1;
    
    let a:Double = sin(dLat/2) * sin(dLat/2) + cos(lat1) * cos(lat2) * sin(dLon/2) * sin(dLon/2);
    let c:Double = 2 * atan2(sqrt(a), sqrt(1-a));
    let d:Double = R * c;
    
    return d;
  }
  
  func getDistanceInMiles(newLocation:CLLocation,oldLocation:CLLocation) -> Double{
    var lat1,lon1,lat2,lon2: Double;
    lat1 = newLocation.coordinate.latitude  * M_PI / 180;
    lon1 = newLocation.coordinate.longitude * M_PI / 180;
    
    lat2 = oldLocation.coordinate.latitude  * M_PI / 180;
    lon2 = oldLocation.coordinate.longitude * M_PI / 180;
    
    let R:Double = 3963; // km
    let dLat:Double = lat2-lat1;
    let dLon:Double = lon2-lon1;
    
    let a:Double = sin(dLat/2) * sin(dLat/2) + cos(lat1) * cos(lat2) * sin(dLon/2) * sin(dLon/2);
    let c:Double = 2 * atan2(sqrt(a), sqrt(1-a));
    let d:Double = R * c;
    
    return d
  }

}







