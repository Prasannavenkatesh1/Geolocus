//
//  TripSummaryModel.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 05/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

protocol BaseTrip{
  var brakingcount
}

struct TripSummaryModel:BaseTrip {
  let tripid:String
  let ecoscore:NSNumber
  let attentionscore:NSNumber
  let brakingscore:NSNumber
  let tripstarttime:String
  let tripendtime:String
  let totaldistance:NSNumber
//  let brakingcount:NSNumber
//  let accelerationcount:NSNumber
  let timezone:String
  let timezoneid:String
  let totalduration:String
  let datausage:NSNumber
  
  var brakingcount:NSNumber
  {
    get
    {
       return 10
    }
  }
  
  var accelerationcount:NSNumber
    {
    get
    {
      return 10
    }
  }
  
}