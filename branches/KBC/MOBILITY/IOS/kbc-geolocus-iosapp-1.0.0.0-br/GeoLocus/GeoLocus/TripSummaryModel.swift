//
//  TripSummaryModel.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 05/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

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

struct TripSummaryModel:BaseTrip,Score {
  
  let datausage     :NSNumber
  let tripid        :String
  let tripstarttime :String
  let tripendtime   :String
  let timezone      :String
  let timezoneid    :String
  let totalduration :String
  
  var brakingcount:NSNumber
  {
    get
    {
       return FacadeLayer.sharedinstance.dbactions.fetchEventCount(Events.EventType.BRAKING)
    }
  }
  
  var accelerationcount:NSNumber
    {
    get
    {
      return FacadeLayer.sharedinstance.dbactions.fetchEventCount(Events.EventType.ACCELERATION)
    }
  }
  
  var totaldistance:NSNumber{
    get{
      
    }
  }
  
  var attentionscore:NSNumber
  {
    get
    {
      return 0
    }
  }
  
//           Braking score = 1-(((number of Braking Events in Trip x weightage)/distance in kms))*100
  var brakingscore:NSNumber
  {
    get
    {
      let bscore = (brakingcount * 0.9) / 100
      return 0
    }
  }
  
//            Acceleration score = 1-(((Number of Acceleration Events in Trip x weightage)/distance km))*100)
  var accelerationscore:NSNumber
  {
    get
    {
      return 0
    }
  }
  
//            Eco score = (Braking score * W1 + Acceleration score * W2)
  var ecoscore:NSNumber
    {
    get
    {
      return 0
    }
  }
  
  
}