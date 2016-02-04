//
//  GlobalConstants.swift
//  GeoLocus
//
//  Created by khan on 19/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation


//DECLARE ALL YOUR CONSTANTS HERE

enum Actions:String{
  case yes = "YES"
  case no = "NO"
}


var categoryID:String {
get{
  return "BOOL_CATEGORY"
}
}

struct StringConstants {
    
    //Side Menu List constants
    
    static let MenuCellIdentifier = "Default"
    
    
    
    //Storyboard and Controllers
    static let StoryBoardIdentifier = "Storyboard"
    static let BadgesViewController = "BadgesViewController"
    static let RootNavigationController = "RootNavigationController"
    static let RootViewController = "RootViewController"
    static let ReportsViewController = "ReportsViewController"
    static let TermsAndConditionViewController = "TermsAndConditionViewController"
    static let SettingsViewController = "SettingsViewController"
  
    static let MOTIONTYPE_NOTMOVING = "Not Moving"
    static let MOTIONTYPE_NONVEHICLE = "Walking or Running"
    static let MOTIONTYPE_AUTOMOTIVE = "Automotive"
  
    
    /* Language Selection View Controller Constants */
    
    static let LOGINVIEW_STORYBOARD_SEGUE = "loginView"
    static let SELECTED_LANGUAGE_USERDEFAULT_KEY = "selectedLanguage"
    
    /* Login View Controller */
    static let USERNAME_IMAGE = "username.png"
    static let PASSWORD_IMAGE = "password.png"
    static let PASSWORD_EYE_IMAGE = "eye.png"
    static let CHECK_BOX_UNSELECTED = "check_box.png"
    static let CHECK_BOX_SELECTED = "checked_box.png"
    
    static let REGISTER_NOW_URL = "http://www.google.com"
    static let NEED_HELP_URL = "http://www.google.com"
    static let LOGIN_URL = ""
    static let TERMS_AND_CONDITIONS_URL = ""
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
}


struct Events {
    
  enum EventType: Int {
    case BRAKING = 1
    case ACCELERATION
    case TIMESERIES
    case STARTTRIP
    case NONE
  }
  
}


struct ArrayConstants {
    
     //Side Menu Constants
    
    enum MenuItems: String {
        
        case Badges     = "Badges"
        case Settings   = "Settings"
        case Reports    = "Reports"
        case Terms      = "Terms & Condition"
        case Exit       = "Exit"
        
    }
    
    //Need more elegant way to return array of enum type
    
    static let MenuList: [String]? = [MenuItems.Badges.rawValue, MenuItems.Settings.rawValue, MenuItems.Reports.rawValue, MenuItems.Terms.rawValue, MenuItems.Exit.rawValue] 
    
    static let MenuSection = ["Default"]
}

struct ErrorConstants {
    static let InvalidLogin = NSLocalizedString("Invalid login credentials", comment: "Login Error")
    
}

struct NotificationKey {

}

struct Path {
    
}

struct Timeseries {
   var currenttime: String
   var latitude: NSNumber
   var longitude: NSNumber
   var speed: NSNumber
   var timezone: String
   var isEvent: NSNumber
   var eventtype: NSNumber
   var eventvalue: NSNumber
  
  init(ctime:String, lat:NSNumber, longt:NSNumber, speedval:NSNumber, tzone:String, iseventval:NSNumber, evetype:NSNumber, eveval:NSNumber){
    self.currenttime = ctime
    self.latitude = lat
    self.longitude = longt
    self.speed = speedval
    self.timezone = tzone
    self.isEvent = iseventval
    self.eventtype = evetype
    self.eventvalue = eveval
  }
}


//MARK: - Extensions
//shift to helper class
public extension NSDate {
    
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "dd-MM-yyyy"         //TO DO : check the format
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")  //TO DO : check the locale if it changes dynamically
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}

