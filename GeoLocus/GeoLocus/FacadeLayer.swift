//
//  FacadeLayer.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class FacadeLayer{
  
  static let sharedinstance = FacadeLayer()
  var dbactions:DatabaseActions
  var httpclient:Httpclient
  var corelocation:CoreLocation
  
  var configmodel :ConfigurationModel{
    get{
      return self.dbactions.getConfiguration()
    }
  }
  
  init(){
    dbactions = DatabaseActions()
    httpclient = Httpclient()
    corelocation = CoreLocation()
    print(__FUNCTION__)
  }

}
