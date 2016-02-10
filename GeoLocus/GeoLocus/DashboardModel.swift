//
//  DashboardModel.swift
//  GeoLocus
//
//  Created by khan on 09/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

struct DashboardModel {
    
    let score: String
    let levelName: String
    let levelMessage: String
    let distanceTravelled: String
    let totalPoints: String
    let pointsAchieved: String
    let scoreMessage: String
    let tripStatus: String
    
    init(score: String, levelName: String, levelMessage: String, distanceTravelled: String, totalPoints: String, pointsAchieved: String, scoreMessage: String,
        tripStatus: String) {
    
    self.score = score
    self.levelName = levelName
    self.levelMessage = levelMessage
    self.distanceTravelled = distanceTravelled
    self.totalPoints = totalPoints
    self.pointsAchieved = pointsAchieved
    self.scoreMessage = scoreMessage
    self.tripStatus  = tripStatus
            
    }
    
}

