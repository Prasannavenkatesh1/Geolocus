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
    
    static let MenuList = [MenuItems.Badges.rawValue, MenuItems.Settings.rawValue, MenuItems.Reports.rawValue, MenuItems.Terms.rawValue, MenuItems.Exit.rawValue]
    
    static let MenuSection = ["Default"]
}

struct ErrorConstants {
    static let InvalidLogin = "Invalid login credentials"
    
}

struct NotificationKey {

}

struct Path {
    
}

