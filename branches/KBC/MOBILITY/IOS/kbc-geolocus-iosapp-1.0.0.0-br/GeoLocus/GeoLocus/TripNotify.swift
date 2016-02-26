//
//  TripNotify.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 03/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

struct TripNotify {
  var title:String
  var UUID:String
  var schedule:NSDate
  var tripstatus:Bool
  
  init(title:String, UUID:String, schedule:NSDate, tripstatus:Bool){
    self.title = title
    self.UUID = UUID
    self.schedule = schedule
    self.tripstatus = tripstatus
    
    setTripNotification()
  }
  
  func setTripNotification(){
    
    let fireDate = self.schedule.dateByAddingTimeInterval(1.0)
    let notification = UILocalNotification()
    notification.alertBody = self.title
    notification.alertAction = "open"
    notification.fireDate = fireDate
    notification.repeatInterval = NSCalendarUnit.Day
    notification.soundName = UILocalNotificationDefaultSoundName
    notification.userInfo = ["title": self.title, "UUID": self.UUID, "triptype":self.tripstatus]
    notification.category = categoryID
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
    
  }
  
}