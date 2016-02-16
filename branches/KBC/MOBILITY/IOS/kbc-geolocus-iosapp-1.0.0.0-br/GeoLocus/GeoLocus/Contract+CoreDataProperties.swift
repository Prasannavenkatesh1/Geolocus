//
//  Contract+CoreDataProperties.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 16/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Contract {

    @NSManaged var attentionPoints: String?
    @NSManaged var bonusPoints: String?
    @NSManaged var contractAchievedDate: String?
    @NSManaged var contractPointsAchieved: String?
    @NSManaged var ecoPoints: String?
    @NSManaged var parentUserName: String?
    @NSManaged var rewardsDescription: String?
    @NSManaged var speedPoints: String?
    @NSManaged var totalContractPoints: String?

}
