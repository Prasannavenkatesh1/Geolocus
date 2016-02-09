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
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    
    static let BADGE_CELL_TOP_MARGIN = 10.0
    static let BADGE_CELL_BOTTOM_MARGIN = 10.0
    static let BADGE_CELL_LEFT_MARGIN = 20.0
    static let BADGE_CELL_RIGHT_MARGIN = 20.0
    
    static let BADGE_CONTENT_TITLE_HEIGHT = CGFloat(18.0)
    static let BADGE_CONTENT_TITLE_BOTTOM_PADDING = 10.0
    static let BADGE_CONTENT_DESCRIPTION_BOTTOM_PADDING = 5.0
    static let BADGE_CONTENT_SHARE_BUTTON_HEIGHT = 15.0
    static let BADGE_CONTENT_ICON_LEFT_PADDING = 10.0
    static let BADGE_CONTENT_ICON_RIGHT_PADDING = 30.0
    static let BADGE_CONTENT_ICON_WIDTH = 84.0
    
    static var appDataSynced = true
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

/*
var color = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF)
var color2 = UIColor(netHex:0xFFFFFF)
*/
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}


extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}

/*
myLabel.font = myLabel.font.boldItalic()
myLabel.font = myLabel.font.bold()
myLabel.font = myLabel.font.withTraits(.TraitCondensed, .TraitBold, .TraitItalic)
*/
extension UIFont {
    
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(.TraitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(.TraitItalic)
    }
    
    func boldItalic() -> UIFont {
        return withTraits(.TraitBold, .TraitItalic)
    }
    
}

class Helper {
    
    static func getMonthString(month: Int) -> String {
        var monthString = String()
        
        switch month {
        case 1: monthString = "Jan"
        case 2: monthString = "Feb"
        case 3: monthString = "Mar"
        case 4: monthString = "Apr"
        case 5: monthString = "May"
        case 6: monthString = "Jun"
        case 7: monthString = "Jul"
        case 8: monthString = "Aug"
        case 9: monthString = "Sep"
        case 10:monthString = "Oct"
        case 11:monthString = "Nov"
        case 12:monthString = "Dec"
        default: monthString = "UDF"
        }
        return monthString
    }
}


