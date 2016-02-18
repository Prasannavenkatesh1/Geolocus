//
//  DashboardModel.swift
//  GeoLocus
//
//  Created by khan on 09/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

struct DashboardModel {
    
    var score: String
    var levelName: String
    var levelMessage: String
    var distanceTravelled: String
    var totalPoints: String
    var pointsAchieved: String
    var scoreMessage: String
    var tripStatus: String
    
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

