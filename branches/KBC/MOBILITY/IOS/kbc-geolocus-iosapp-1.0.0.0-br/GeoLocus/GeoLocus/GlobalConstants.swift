//
//  GlobalConstants.swift
//  GeoLocus
//
//  Created by khan on 19/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation


//DECLARE ALL YOUR CONSTANTS HERE

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

