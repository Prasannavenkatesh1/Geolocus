//
//  TimeSeriesModel.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 27/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

struct TimeSeriesModel {
  let currenttime: String
  let latitude: NSNumber
  let longitude: NSNumber
  let speed: NSNumber
  let timezone: String
  let isEvent: NSNumber
  let eventtype: NSNumber
  let eventvalue: NSNumber
  
  init(ctime:String, lat:NSNumber, longt:NSNumber, speedval:NSNumber, tzone:String, iseventval:NSNumber, evetype:NSNumber, eveval:NSNumber){
    self.currenttime = ctime
    self.latitude = lat
    self.longitude = longt
    self.speed = speedval
    self.timezone = tzone
    self.isEvent = iseventval
    self.eventtype = evetype
    self.eventvalue = eveval
  }
}