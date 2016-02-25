//
//  TimeSeriesModel.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 27/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

struct TimeSeriesModel {
  let tripid :String
  let currenttime: NSDate
  let latitude: NSNumber
  let longitude: NSNumber
  let speed: NSNumber
  let datausage: NSNumber
  let distance: NSNumber
  let isEvent: NSNumber
  let eventtype: NSNumber
  let eventvalue: NSNumber
  var isvalidtrip: NSNumber
  
  init(tripid: String,ctime:NSDate, lat:NSNumber, longt:NSNumber, speedval:NSNumber, datausage:NSNumber, iseventval:NSNumber, evetype:NSNumber, eveval:NSNumber, distance:NSNumber, isvalidtrip: NSNumber){
    self.tripid = tripid
    self.currenttime = ctime
    self.latitude = lat
    self.longitude = longt
    self.speed = speedval
    self.datausage = datausage
    self.distance = distance
    self.isEvent = iseventval
    self.eventtype = evetype
    self.eventvalue = eveval
    self.isvalidtrip = isvalidtrip
  }
}


