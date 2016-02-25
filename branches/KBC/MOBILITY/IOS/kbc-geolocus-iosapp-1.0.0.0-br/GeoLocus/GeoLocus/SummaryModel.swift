//
//  SummaryModel.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 11/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

//struct SummaryModel{
//  let datausage     :NSNumber
//
//  init(datausage:NSNumber){
//
//  }
//}

struct SummaryModel{
  
  let datausage         : NSNumber
  let tripid            : String
  let tripstarttime     : NSDate
  let tripendtime       : NSDate
  let timezone          : String
  let timezoneid        : String
  var isSync            : NSNumber?
  var attentionscore    : NSNumber   = 0
  var brakingcount      : NSNumber
  var accelerationcount : NSNumber
  var totaldistance     : NSNumber
  
  init(datausage:NSNumber ,tripid:String,tripstarttime:NSDate, tripendtime:NSDate, timezone:String, timezoneid:String){
    self.datausage = datausage
    self.tripid = tripid
    self.tripstarttime = tripstarttime
    self.tripendtime = tripendtime
    self.timezone = timezone
    self.timezoneid =  timezoneid
    
    self.brakingcount      = FacadeLayer.sharedinstance.dbactions.fetchEventCount(Events.EventType.BRAKING,tripid:tripid)
    self.accelerationcount = FacadeLayer.sharedinstance.dbactions.fetchEventCount(Events.EventType.ACCELERATION, tripid: tripid)
    self.totaldistance     = FacadeLayer.sharedinstance.dbactions.fetchTotalDistance(tripid)
  }
  
 

  
  var totalduration :NSInteger {
    get{
      return getDuration(tripstarttime, eDate: tripendtime)
    }
  }
  
  
  //           Braking score = 1-(((number of Braking Events in Trip x weightage)/distance in kms))*100
  var brakingscore:NSNumber
    {
    get
    {
      let br:Double = FacadeLayer.sharedinstance.configmodel!.weightage_braking as! Double
      let brc:Double = brakingcount as Double
      let tdistance = totaldistance as Double
      let bscore = 1 - ((brc * br) / tdistance) / 100
      return bscore
    }
  }
  
  //            Acceleration score = 1-(((Number of Acceleration Events in Trip x weightage)/distance km))*100)
  var accelerationscore:NSNumber
    {
    get
    {
      let ac = accelerationcount as Double
      let wc = FacadeLayer.sharedinstance.configmodel!.weightage_acceleration as! Double
      let tdistance = totaldistance as Double
      let ascore = 1 - ((ac * wc) / tdistance) / 100
      return ascore
    }
  }
  
  //            Eco score = (Braking score * W1 + Acceleration score * W2)
  var ecoscore:NSNumber
    {
    get
    {
      let   BrakingSore_W  = (brakingscore as Double) * (FacadeLayer.sharedinstance.configmodel!.ecoweightage_braking as! Double)
      let   Acceleration_W = (accelerationscore as Double) * (FacadeLayer.sharedinstance.configmodel!.ecoweightage_acceleration as! Double)
      let   escore         = BrakingSore_W + Acceleration_W
      return escore
    }
  }
  
}


func getDuration(sDate:NSDate, eDate:NSDate) -> NSInteger{
  let calendar = NSCalendar.currentCalendar()//CalendarUnitSecond
  let datecomponenets = calendar.components(.Second, fromDate:sDate , toDate: eDate, options: [])
  let seconds:NSInteger = datecomponenets.second
  print("Seconds: \(seconds)")
  return seconds
}