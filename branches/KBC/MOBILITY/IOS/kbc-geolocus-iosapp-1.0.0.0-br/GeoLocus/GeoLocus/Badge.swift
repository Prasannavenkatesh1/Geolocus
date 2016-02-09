//
//  Badge.swift
//  GeoLocus
//
//  Created by CTS MAC on 25/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation


class Badge {
    
    enum BadgesType : Int {
        case Badge = 0
        case Level = 1
    }
    
    var badgeIcon : String
    var badgeTitle : String
    var badgeDescription : String
    var isEarned : Bool
    var orderIndex : Int
    var badgeType : BadgesType
    var additionalMsg : String?
    
    init(withIcon badgeIcon: String, badgeTitle: String, badgeDescription: String, isEarned: Bool, orderIndex: Int, badgeType: BadgesType, additionalMsg : String?) {
        self.badgeIcon          = badgeIcon
        self.badgeTitle         = badgeTitle
        self.badgeDescription   = badgeDescription
        self.isEarned           = isEarned
        self.orderIndex         = orderIndex
        self.badgeType          = badgeType
        self.additionalMsg      = additionalMsg
    }
}