//
//  ConfigurationModel.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 09/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

struct  ConfigurationModel{
  
  var thresholds_brake          : NSNumber?
  var thresholds_acceleration   : NSNumber?
  var thresholds_autotrip       : NSNumber?
  var weightage_braking         : NSNumber?
  var weightage_acceleration    : NSNumber?
  var weightage_speed           : NSNumber?
  var weightage_severevoilation : NSNumber?
  var ecoweightage_braking      : NSNumber?
  var ecoweightage_acceleration : NSNumber?
  var thresholds_minimumspeed: NSNumber?
  
  var thresholds_minimumdistance: NSNumber?
  var thresholds_maximumIdletime: NSNumber?
  var thresholds_minimumsIdletime: NSNumber?
  var tripid: String?

}

