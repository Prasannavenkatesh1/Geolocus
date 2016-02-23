//
//  CustomButton.swift
//  GeoLocus
//
//  Created by Harsh on 2/22/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation
import UIKit


class CustomButton: UIButton{
    
    override func drawRect(rect: CGRect) {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }
}