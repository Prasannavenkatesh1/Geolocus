//
//  Extensions.swift
//  GeoLocus
//
//  Created by CTS MAC on 10/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

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
}

