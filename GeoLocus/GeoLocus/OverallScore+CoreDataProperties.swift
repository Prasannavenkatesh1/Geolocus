//
//  OverallScore+CoreDataProperties.swift
//  GeoLocus
//
//  Created by CTS MAC on 17/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension OverallScore {

    @NSManaged var attention: NSNumber?
    @NSManaged var dataUsageMessage: String?
    @NSManaged var distance: NSNumber?
    @NSManaged var eco: NSNumber?
    @NSManaged var overall: NSNumber?
    @NSManaged var speeding: NSNumber?
    @NSManaged var overallMessage: String?
    @NSManaged var speedingMessage: String?
    @NSManaged var ecoMessage: String?

}
