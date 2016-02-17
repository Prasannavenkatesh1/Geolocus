//
//  Trip_Detail+CoreDataProperties.swift
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

extension Trip_Detail {

    @NSManaged var attentionScore: NSNumber?
    @NSManaged var dataUsageMessage: String?
    @NSManaged var date: NSDate?
    @NSManaged var distance: NSNumber?
    @NSManaged var duration: NSNumber?
    @NSManaged var ecoScore: NSNumber?
    @NSManaged var speedScore: NSNumber?
    @NSManaged var tripId: String?
    @NSManaged var tripPoints: NSNumber?
    @NSManaged var overallScore: NSNumber?
    @NSManaged var speedingMessage: String?
    @NSManaged var ecoMessage: String?
    @NSManaged var events: NSOrderedSet?
    @NSManaged var speedZones: NSOrderedSet?

}
