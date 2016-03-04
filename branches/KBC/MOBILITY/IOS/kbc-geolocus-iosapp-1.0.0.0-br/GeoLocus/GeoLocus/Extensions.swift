//
//  Extensions.swift
//  GeoLocus
//
//  Created by CTS MAC on 10/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

//MARK: - Extensions



extension Int {
  var milliSecondsToSeconds: Double {
    return Double(self) / 1000
  }
}

//extension String {
//  
//  
//  var Timestamp: String {
//    return "\(NSDate().timeIntervalSince1970 * 1000)"
//  }
//}


extension NSDate {
    convenience init?(jsonDate: String) {
    
        let scanner = NSScanner(string: jsonDate)

        // Read milliseconds part:
        var milliseconds : Int64 = 0
        if scanner.scanLongLong(&milliseconds) {
            // Milliseconds to seconds:
            var timeStamp = NSTimeInterval(milliseconds)/1000.0
            
            // Read optional timezone part:
            var timeZoneOffset : Int = 0
            if scanner.scanInteger(&timeZoneOffset) {
                let hours = timeZoneOffset / 100
                let minutes = timeZoneOffset % 100
                // Adjust timestamp according to timezone:
                timeStamp += NSTimeInterval(3600 * hours + 60 * minutes)
            }
    
            // Success! Create NSDate and return.
            self.init(timeIntervalSince1970: timeStamp)
            return
            
        }
    
    // Wrong format, return nil. (The compiler requires us to
    // do an initialization first.)
    self.init(timeIntervalSince1970: 0)
    return nil
    }
}

public extension NSDate {    
    
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "dd-MM-yyyy"         //TODO : check the format
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")  //TODO : check the locale if it changes dynamically
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
    
    convenience init(range:Int) {
        //assert(range < 0 && range > 100, "Invalid range")
    
        switch range {
        case 0...50:
            self.init(netHex:0xff3b3b)
        case 51...60:
            self.init(netHex:0xf99d1c)
        case 61...70:
            self.init(netHex:0xffd200)
        case 71...80:
            self.init(netHex:0x4cd964)
        case 80...Int.max as ClosedInterval:
            self.init(netHex:0x07a05a)
        default:
            self.init(netHex:0xc7c7cc)
        }
    }
}


extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func toBool() -> Bool {
        switch self {
        case "True", "TRUE", "true", "yes", "YES", "1":
            return true
        case "False", "FALSE", "false", "no", "NO", "0":
            return false
        default:
            return false
        }
    }
}


extension Int {
    
    public func suffix() -> String {
        let absSelf = abs(self)
        
        switch (absSelf % 100) {
            
        case 11...13:
            return "th"
        default:
            switch (absSelf % 10) {
            case 1:
                return "st"
            case 2:
                return "nd"
            case 3:
                return "rd"
            default:
                return "th"
            }
        }
    }
}

