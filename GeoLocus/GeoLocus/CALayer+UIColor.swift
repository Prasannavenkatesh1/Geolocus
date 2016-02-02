//
//  CALayer+UIColor.swift
//  GeoLocus
//
//  Created by Saranya on 01/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

extension CALayer {
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.CGColor
        }
        
        get {
            return UIColor(CGColor: self.borderColor!)
        }
    }
}