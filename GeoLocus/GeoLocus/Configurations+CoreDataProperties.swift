//
//  Configurations+CoreDataProperties.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 24/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Configurations {

    @NSManaged var ecoweightage_acceleration: NSNumber?
    @NSManaged var ecoweightage_braking: NSNumber?
    @NSManaged var thresholds_acceleration: NSNumber?
    @NSManaged var thresholds_autotrip: NSNumber?
    @NSManaged var thresholds_brake: NSNumber?
    @NSManaged var weightage_acceleration: NSNumber?
    @NSManaged var weightage_braking: NSNumber?
    @NSManaged var weightage_severevoilation: NSNumber?
    @NSManaged var weightage_speed: NSNumber?
    @NSManaged var thresholds_minimumspeed: NSNumber?
    @NSManaged var tripid: String?

}
