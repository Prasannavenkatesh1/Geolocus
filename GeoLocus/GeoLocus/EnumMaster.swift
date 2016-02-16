//
//  EnumMaster.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 16/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

enum Actions:String{
  case yes = "YES"
  case no = "NO"
}

enum LanguageCode:String{
  case English = "en_uk"
  case French = "fr_be"
  case Nederlands = "nl_be"
  case Duits = "de_be"
}

enum EventType: Int {
  case Acceleration
  case Breaking
  case Speeding
  case None
}


