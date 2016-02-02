//
//  BaseModel.swift
//  GeoLocus
//
//  Created by khan on 01/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation
import UIKit


//Protocol for contract and dashboard as they have common elements
protocol BaseModel {
   var statusCode: Int? { get  }
   var statusMessage: String? { get }
   var totalPoints: Int {get}
   var pointsAchieved: Int {get}
}





struct DashboardModel: BaseModel {
    
    let statusCode: Int?
    let statusMessage: String?
    let score: String
    let scoreMessage: String
    let badgeName: String
    let badgeMessage: String
    let distanceTravelled: String
    let totalPoints: Int
    let pointsAchieved: Int
    let tripStatus: String
    
    init(statusCode: Int? = nil, statusMessage: String? = nil, score: String, scoreMessage: String, badgeName: String, badgeMessage: String, distanceTravelled: String, totalPoints: Int, pointsAchieved: Int, tripStatus: String){
        
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.score  = score
        self.scoreMessage  = scoreMessage
        self.badgeName = badgeName
        self.badgeMessage = badgeMessage
        self.distanceTravelled = distanceTravelled
        self.totalPoints = totalPoints
        self.pointsAchieved = pointsAchieved
        self.tripStatus = tripStatus
        
    }
}


struct ContractModel: BaseModel {
    
    let statusCode: Int?
    let statusMessage: String?
    let totalPoints: Int
    let pointsAchieved: Int
    let speedPoints: Double
    let ecoPoints: Int
    let rewardsDescription: String
    let contractAchievedDate: String
    let bonusPoints: Int
    let parentUserName: String
    
    init(statusCode: Int? = nil, statusMessage: String? = nil, totalPoints: Int, pointsAchieved: Int, speedPoints: Double, ecoPoints: Int, rewardsDescription: String, contractAchievedDate: String, bonusPoints: Int, parentUserName: String) {
        
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.totalPoints = totalPoints
        self.pointsAchieved = pointsAchieved
        self.speedPoints = speedPoints
        self.ecoPoints = ecoPoints
        self.rewardsDescription = rewardsDescription
        self.contractAchievedDate = contractAchievedDate
        self.bonusPoints = bonusPoints
        self.parentUserName = parentUserName
    }
    
    
}

