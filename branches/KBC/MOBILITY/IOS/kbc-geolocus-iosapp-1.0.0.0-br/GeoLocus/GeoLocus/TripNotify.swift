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
  
  init(title:String, UUID:String, schedule:NSDate){
    self.title = title
    self.UUID = UUID
    self.schedule = schedule
  }
  
  func addItem(){
    
    let calendar = NSCalendar.currentCalendar()
    let fireDate = calendar.dateByAddingUnit(.Second,
      value: 5,
      toDate: self.schedule,
      options:[])
//    nowComponents.timeZone = NSTimeZone(abbreviation: "GMT")
   print("fireDate : \(fireDate)")
    
    
    
    let notification = UILocalNotification()
    notification.alertBody = "Todo Item "
    notification.alertAction = "open"
    notification.fireDate = fireDate
    notification.soundName = UILocalNotificationDefaultSoundName
    notification.userInfo = ["title": "hi", "UUID": "new notify"]
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
  }
}