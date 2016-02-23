//
//  GlobalConstants.swift
//  GeoLocus
//
//  Created by khan on 19/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation


//DECLARE ALL YOUR CONSTANTS HERE


var categoryID:String {
get{
  return "BOOL_CATEGORY"
}
}

struct StringConstants {
    
    //Side Menu List constants
    
    static let MenuCellIdentifier = "Default"
    
    //Category Constants
    
    static let categoryTypeContract    =   "Contract"
    static let categoryTypeDashboard   =   "Dashboard"
    static let categoryTypeHistory     =   "History"
    static let categoryTypeOverall     =   "Overall"
    
    
    
    //Storyboard and Controllers
    static let StoryBoardIdentifier = "Storyboard"
    static let BadgesViewController = "BadgesViewController"
    static let RootNavigationController = "RootNavigationController"
    static let RootViewController = "RootViewController"
    static let ReportsViewController = "ReportsViewController"
    static let GroupBarViewController = "GroupBarViewController"
    static let TermsAndConditionViewController = "TermsAndConditionViewController"
    static let SettingsViewController = "SettingsViewController"
    static let TermsAndConditionsViewController = "TermsAndConditionsViewController"
    static let WelcomePageViewController = "WelcomePageViewController"
    static let PageViewController = "PageViewController"
    static let LanguageSelectionViewController = "LanguageSelectionViewController"
    static let SettingsLanguageViewController = "SettingsLanguageViewController"
    static let SnoozingViewController         = "SnoozingController"
    
    static let MOTIONTYPE_NOTMOVING = "Not Moving"
    static let MOTIONTYPE_NONVEHICLE = "Walking or Running"
    static let MOTIONTYPE_AUTOMOTIVE = "Automotive"
  
    
    /* Language Selection View Controller Constants */
    
    static let LOGINVIEW_STORYBOARD_SEGUE = "loginView"
    static let SELECTED_LANGUAGE_USERDEFAULT_KEY = "selectedLanguage"
    static let SELECTED_LOCALIZE_LANGUAGE_CODE = "userSelectedLanguage"
    
    /* Login View Controller */
    static let USERNAME_IMAGE = "username.png"
    static let PASSWORD_IMAGE = "password.png"
    static let PASSWORD_EYE_IMAGE = "eye.png"
    static let CHECK_BOX_UNSELECTED = "check_box.png"
    static let CHECK_BOX_SELECTED = "checked_box.png"
    
    static let LOGIN_PARAMETERS = "j_password=%@&j_username=%@&languageCode=%@&channel_type=iOS&_spring_security_remember_me=on"
    
    static let REPORT_SERVICE_URL = "https://ec2-52-9-107-182.us-west-1.compute.amazonaws.com/ubi-sei-web/report/get/report?"

    static let NOTIFICATION_DELETE = "https://ec2-52-9-107-182.us-west-1.compute.amazonaws.com/ubi-sei-web/domain/notification/delete?"
    static let NOTIFICATION_DELETE_PARAMETERS = "userId=%@&notificationId=%@&type=%@"
    
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
    
    static var appDataSynced = false
    
    static let CHANNEL_TYPE = "channel_type"
    static let TOKEN_ID = "tokenID"
    static let USER_ID = "userId"
    static let USERNAME = "userName"
    static let SPRING_SECURITY_COOKIE = "SPRING_SECURITY_REMEMBER_ME_COOKIE"
    
    static let ERROR = "Error"
    static let OK = "OK"
    static let CONTRACT_POINTS_ACHIEVED_MESSAGE = "You have achieved your target on %@. Contact parents to redeem points."
    
    static let REPORT_SYNCHRONISATION = "ReportData_Synchronised"
    
    /* Settings View Controller */
    
    static let RADIO_BUTTON_UNSELECTED = "Radio-Button_Unchecked.png"
    static let RADIO_BUTTON_SELECTED = "Radio-Button_Checked.png"
    
    /* Dashboard View Controller */
    
    static let YES = "Yes"
    static let NO = "No"
    static let STOP = "Stop"
    static let CANCEL = "Cancel"
    static let CONTINUE = "Continue"
    static let START_TRIP_MESSAGE = "Do you want to start the trip"
    static let STOP_TRIP_MESSAGE = "Do you want to stop the trip"
}


struct Events {
    
  enum EventType: Int {
    case BRAKING = 1
    case ACCELERATION
    case TIMESERIES
    case STARTTRIP
    case SPEEDING
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
//        case Exit       = "Exit"
      
    }
    
    //Need more elegant way to return array of enum type
    
//    static let MenuList: [String]? = [MenuItems.Badges.rawValue, MenuItems.Settings.rawValue, MenuItems.Reports.rawValue, MenuItems.Terms.rawValue, MenuItems.Exit.rawValue] 
  
  static let MenuList: [String]? = [MenuItems.Badges.rawValue, MenuItems.Settings.rawValue, MenuItems.Reports.rawValue, MenuItems.Terms.rawValue] 
  
    static let MenuSection = ["Default"]
}

struct ErrorConstants {
    static let InvalidLogin = NSLocalizedString("Invalid login credentials", comment: "Login Error")
    
}

struct NotificationKey {
    
    static let SegmentIndexChangedNotification            = "SegmentIndexChangedNotification"
    static let PageViewControllerIndexchangedNotification = "PageViewControllerIndexchangedNotification"
    static let CurrentPageControlIndexNotification        = "currentPageControlIndexNotification"
}

struct CellID {
    static let HISTORY_SCORE  = "HTSCell"
    static let HISTORY_MAP    = "HMVCell"
    static let HISTORY_ZONE   = "HSZCell"
    static let HISTORY_DETAIL = "HTDCell"
    static let BADGE_CELL     = "BadgeCell"
}

struct Font {
    static let HELVETICA_NEUE = "Helvetica Neue"
    static let HELVETICA_NEUE_MEDIUM = "HelveticaNeue-Medium"
}

struct Arc {
    static let BACKGROUND_WIDTH = CGFloat(8)
    static let FOREGROUND_WIDTH = CGFloat(8)
}

struct Resolution {
    struct height {
        static let iPhone4 = CGFloat(480)
        static let iPhone5 = CGFloat(568)
        static let iPhone6 = CGFloat(667)
    }
}

struct BadgeKey {
    static let S_CODE = "statusCode"
    static let S_MESSAGE = "statusMessage"
    static let BADGES = "badges"
    static let LEVELS = "levels"
    static let TITLE  = "badge_title"
    static let DESC   = "badge_description"
    static let EARNED = "isEarned"
    static let INDEX  = "order_index"
}

struct LocalizationConstants {
    
    static let Login_LoginTitle = "Hello"
}
