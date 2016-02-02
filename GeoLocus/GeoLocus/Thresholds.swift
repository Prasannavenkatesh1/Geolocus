//
//  Thresholds.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 01/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

struct Thresholds {
  let acceleration:NSNumber!
  let braking:NSNumber!
  let autotrip:NSNumber!
  
  init(acceleration:NSNumber, braking:NSNumber, autotrip:NSNumber){
    self.acceleration = acceleration
    self.braking = braking
    self.autotrip = autotrip
  }
}