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
    static let LoginViewController = "LoginViewController"
    
    static let MOTIONTYPE_NOTMOVING = "Not Moving"
    static let MOTIONTYPE_NONVEHICLE = "Walking or Running"
    static let MOTIONTYPE_AUTOMOTIVE = "Automotive"
  
    
    /* Language Selection View Controller Constants */
    
    static let LOGINVIEW_STORYBOARD_SEGUE = "loginView"
    static let SELECTED_LANGUAGE_USERDEFAULT_KEY = "selectedLanguage"
    static let SELECTED_LOCALIZE_LANGUAGE_CODE = "userSelectedLanguage"
    
    static let TERMS_AND_CONDITIONS_STRING = "TERMS_AND_CONDITIONS_STRING"
    
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
    
    static let BADGE_CONTENT_TITLE_HEIGHT                 = CGFloat(18.0)
    static let BADGE_CONTENT_TITLE_BOTTOM_PADDING         = 10.0
    static let BADGE_CONTENT_DESCRIPTION_BOTTOM_PADDING   = 5.0
    static let BADGE_CONTENT_SHARE_BUTTON_HEIGHT          = 15.0
    static let BADGE_CONTENT_ICON_LEFT_PADDING            = 10.0
    static let BADGE_CONTENT_ICON_RIGHT_PADDING           = 30.0
    static let BADGE_CONTENT_ICON_WIDTH                   = 84.0
    
    static var appDataSynced = false
    
    static let CHANNEL_TYPE           = "channel_type"
    static let TOKEN_ID               = "tokenID"
    static let USER_ID                = "userId"
    static let USERNAME               = "userName"
    static let CHANNEL_ID             = "iOS"
    static let SPRING_SECURITY_COOKIE = "SPRING_SECURITY_REMEMBER_ME_COOKIE"
    
    static let ERROR  = "Error"
    static let OK     = "OK"
    
    static let REPORT_SYNCHRONISATION = "ReportData_Synchronised"
    
    /* Settings View Controller */
    
    static let RADIO_BUTTON_UNSELECTED  = "Radio-Button_Unchecked.png"
    static let RADIO_BUTTON_SELECTED    = "Radio-Button_Checked.png"
    
    /* Dashboard View Controller */
    
    static let YES                = "Yes"
    static let NO                 = "No"
    static let STOP               = "Stop"
    static let CANCEL             = "Cancel"
    static let CONTINUE           = "Continue"
    static let START_TRIP_MESSAGE = "Do you want to start the trip"
    static let STOP_TRIP_MESSAGE  = "Do you want to stop the trip"
    static let  NO_CONTRACT = "You do not have any contract message"
    
    /* Default settings*/
    static let Thresholds_Brake             = "thresholds_brake"
    static let Thresholds_Acceleration      = "thresholds_acceleration"
    static let Thresholds_Autotrip          = "thresholds_autotrip"
    static let Weightage_Braking            = "weightage_braking"
    static let Weightage_Acceleration       = "weightage_acceleration"
    static let Weightage_Speed              = "weightage_speed"
    static let Weightage_Severevoilation    = "weightage_severevoilation"
    static let Ecoweightage_Braking         = "ecoweightage_braking"
    static let Ecoweightage_Acceleration    = "ecoweightage_acceleration"
    static let Thresholds_Minimumspeed      = "thresholds_minimumspeed"
    static let Thresholds_DataUsage         = "thresholds_dataUsage"
    static let Thresholds_Minimumdistance   = "thresholds_minimumdistance"
    static let Thresholds_MinimumIdleTime   = "thresholds_minimumidletime"
    static let Thresholds_MaximumIdleTime   = "thresholds_maximumidletime"
  
  /*  Core Location */
    static let isSnoozeEnabled   = "Snoozing enabled"
  
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
    static let SnoozingNotification                       = "snoozingwindow"
    static let  initialProgress                            = "initialProgress"
  
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

struct ShareView {
    static let defaultMargin = CGFloat(12)
    
    struct Margin {
        static let top = CGFloat(19)
        static let bottom = CGFloat(12)
        static let right = CGFloat(12)
        static let left = CGFloat(12)
    }
    
    struct Icon {
        struct TripPadding {
            static let top = CGFloat(65)
            static let bottom = CGFloat(5)
            static let right = CGFloat(12)
            static let left = CGFloat(12)
        }
        
        struct BadgePadding {
            static let top = CGFloat(18)
            static let bottom = CGFloat(18)
            static let right = CGFloat(18)
            static let left = CGFloat(18)
        }
    }
    
    struct Para {
        struct Padding {
            static let top = CGFloat(8)
            static let bottom = CGFloat(5)
            static let left = CGFloat(12)
        }
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
    
    /* Language Selection View Controller */
    static let Language_German = "German"
    static let Language_French = "French"
    static let Language_English = "English"
    static let Language_Dutch = "Dutch"
    
    /* Login View Controller */
    static let Username_PlaceholderText = "Username"
    static let Password_PlaceholderText = "Password"
    static let Terms_And_Conditions_Title = "I agree to Terms & Conditions"
    static let Login_Title = "Login"
    static let RegisterNow_Title = "Register Now"
    static let NeedHelp_Title = "Need help?"
    
    static let Ok_title = "OK"
    
    /* Contract Page Label */
    static let AddPicture_Title = "Add Picture of your goal here..."
    static let YourGoal_Title = "Your Goal"
    static let TotalPoints_Title = "TOTAL POINTS"
    static let SpeedPoints_Title = "Speed Points"
    static let EcoPoints_Title = "Eco Points"
    static let BonusPoints_Title = "Bonus Points"
    static let CONTRACT_POINTS_ACHIEVED_MESSAGE = "You have achieved your target on %@. Contact parents to redeem points."
    
    /*DashboardPage Label*/
    
    static let Contracts_Points_Earned = "Contracts points earned"
    static let Distance_Travelled      = "Distance Travelled"
    
    struct OverallScore {
        static let Score_Title          = "Overall_Score"
        static let Driving_Behavior     = "Overall_Score_Driving_Behavior"
        static let Speeding             = "Overall_Score_Speeding"
        static let Eco                  = "Overall_Score_Eco"
        static let Attention            = "Overall_Score_Attention"
        static let Distance_Travelled   = "Overall_Score_Distance_Travelled"
    }
    
    struct Badge {
        static let Badges_to_be_Earned  = "Badges_to_be_Earned"
        static let Badges_Earned        = "Badges_Earned"
        static let Levels               = "Levels"
    }
    
    struct History{
        struct Score {
            static let ScoreTitle           = "History_TS_Trip_Score"
            static let Speeding             = "History_TS_Speeding"
            static let Eco                  = "History_TS_Eco"
            static let Attention            = "History_TS_Attention"
        }
        
        struct View {
            static let Map                  = "History_Map"
            static let Speeding_Zone        = "History_Speeding_Zone"
            static let Speeding             = "History_SZ_Speeding"
            static let Severe_Violation     = "History_SZ_Severe_Violation"
            static let Distance             = "History_SZ_Distance"
            static let Within_Max_Speed     = "History_SZ_Within_Max_Speed"
            static let Above_Max_Limit      = "History_SZ_Above_Max_Speed"
        }
        
        struct TripDetails {
            static let Trip_Details         = "History_TD_Trip_Details"
            static let Distance             = "History_TD_Distance"
            static let Trip_Points          = "History_TD_Trip_Points"
        }
    }
    
    struct Share {
        static let AppInfo                  = "Share_Info_Text"
        
        struct Trip {
            static let Title                = "Share_Trip_Score"
            static let Info                 = "Share_Trip_Info"
        }
        
        struct Badge {
            static let Info                 = "Share_Badge_Info"
        }
        
    }
    
    struct Settings {
        static let Settings_Title = "Customer Settings"
        
        struct SettingsCell {
            static let Data_Upload_Title = "Data Upload Type"
            static let Snooze_Title = "Snooze the start"
            static let AutoTrip_Start_Title = "Auto trip Start"
            static let Notification_Title = "Notification"
            static let ShareData_Title = "Share data with parent"
            static let Choose_Language_Title = "Choose your Language"
            static let Reset_Password_Title = "Reset Password"
            static let Coach_Username_Title = "Coach's Username"
        }
        
        struct DataUploadType {
            static let DataUploadType_Title = "Choose Data Upload Type"
            static let Type_Cellular = "Cellular"
            static let Type_Wifi = "Wifi"
            static let Type_CellularWifi = "Cellular and Wifi"
        }
        
        struct Snooze {
            static let AskMeAgain_Title = "Ask me again in"
            static let Hours = "Hours"
            static let Minutes = "Minutes"
            static let Days = "Days"
        }
    }
}
