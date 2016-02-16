//
//  ContractModel.swift
//  GeoLocus
//
//  Created by Saranya on 16/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

struct ContractModel {
    
    let parentUserName : String
    let attentionPoints : String
    let speedPoints : String
    let ecoPoints : String
    let bonusPoints : String
    let totalContractPoints : String
    let contractPointsAchieved : String
    let rewardsDescription : String
    let contractAchievedDate : String
    
    init(parentUserName : String, attentionPoints : String, speedPoints : String, ecoPoints : String, bonusPoints : String, totalContractPoints : String, contractPointsAchieved : String,
        rewardsDescription: String,contractAchievedDate : String) {
            
            self.parentUserName = parentUserName
            self.attentionPoints = attentionPoints
            self.speedPoints = speedPoints
            self.ecoPoints = ecoPoints
            self.bonusPoints = bonusPoints
            self.totalContractPoints = totalContractPoints
            self.contractPointsAchieved = contractPointsAchieved
            self.rewardsDescription  = rewardsDescription
            self.contractAchievedDate = contractAchievedDate
    }
}
