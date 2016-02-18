//
//  Utility.swift
//  GeoLocus
//
//  Created by CTS MAC on 18/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

class Utility {
    
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
    
    static func getEventType(event:String) -> EventType{
        
        if(event.caseInsensitiveCompare("Acceleration") == NSComparisonResult.OrderedSame){
            return EventType.Acceleration
        }else if (event.caseInsensitiveCompare("Breaking") == NSComparisonResult.OrderedSame) {
            return EventType.Breaking
        }else if (event.caseInsensitiveCompare("Speeding") == NSComparisonResult.OrderedSame) {
            return EventType.Speeding
        }else{
            return EventType.None
        }
    }
}