
//
//  EnumMaster.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 02/03/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

enum Actions:String{
  case yes = "YES"
  case no = "NO"
}

enum LanguageCode : String{
  case English = "en_uk"
  case French = "fr_be"
  case Nederlands = "nl_be"
  case Duits = "de_be"
}

enum Language : String{
  case English = "English"
  case German = "German"
  case French = "French"
  case Dutch = " Dutch"
}

enum LocalizeLanguageCode: String {
  case English = "en"
  case French = "fr"
  case German = "de"
  case Nederlands = "nl"
}

enum Service: Int {
  case CALLED
  case CALLING
  case NONE
}


