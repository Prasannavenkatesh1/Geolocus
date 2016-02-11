//
//  TripSummaryModel.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 05/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

//struct TripSummaryModel{
//  let datausage     :NSNumber
//  
//  init(datausage:NSNumber){
//    
//  }
//}


/*
protocol BaseTrip{
  var brakingcount      :NSNumber
  var accelerationcount :NSNumber
  var totaldistance     :NSNumber
}

protocol Score{
  var brakingscore      :NSNumber
  var accelerationscore :NSNumber
  var ecoscore          :NSNumber
}

//struct TripSummaryModel : BaseTrip,Score {

struct TripSummaryModel{

  let datausage     :NSNumber?
  let tripid        :String
  let tripstarttime :String
  let tripendtime   :String?
  let timezone      :String?
  let timezoneid    :String?
  let totalduration :String?
  
  var attentionscore    :NSNumber   = 0
  var brakingcount      :NSNumber   = FacadeLayer.sharedinstance.dbactions.fetchEventCount(Events.EventType.BRAKING)
  var accelerationcount :NSNumber   = FacadeLayer.sharedinstance.dbactions.fetchEventCount(Events.EventType.ACCELERATION)
  var totaldistance     :NSNumber   = FacadeLayer.sharedinstance.dbactions.fetchTotalDistance()
  
  init(tripid:String,tripstarttime:String){
    
  }
  

//           Braking score = 1-(((number of Braking Events in Trip x weightage)/distance in kms))*100
  var brakingscore:NSNumber
  {
    get
    {
      let bscore = 1 - ((brakingcount * FacadeLayer.sharedinstance.configmodel.weightage_braking) / totaldistance) / 100
      return bscore
    }
  }
  
//            Acceleration score = 1-(((Number of Acceleration Events in Trip x weightage)/distance km))*100)
  var accelerationscore:NSNumber
  {
    get
    {
      let ascore = 1 - ((brakingcount * FacadeLayer.sharedinstance.configmodel.weightage_acceleration) / totaldistance) / 100
      return ascore
    }
  }
  
//            Eco score = (Braking score * W1 + Acceleration score * W2)
  var ecoscore:NSNumber
  {
    get
    {
      var   BrakingSore_W  = brakingscore * FacadeLayer.sharedinstance.configmodel.ecoweightage_braking
      var   Acceleration_W = brakingscore * FacadeLayer.sharedinstance.configmodel.ecoweightage_acceleration
      var   escore         = BrakingSore_W + Acceleration_W
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

*/
