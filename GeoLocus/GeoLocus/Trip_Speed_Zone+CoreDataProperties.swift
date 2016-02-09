//
//  Trip_Speed_Zone+CoreDataProperties.swift
//  GeoLocus
//
//  Created by CTS MAC on 04/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Trip_Speed_Zone {

    @NSManaged var speedScore: NSNumber?
    @NSManaged var speedBehaviour: NSNumber?
    @NSManaged var distanceTravelled: NSNumber?
    @NSManaged var maxSpeed: NSNumber?
    @NSManaged var aboveSpeed: NSNumber?
    @NSManaged var withinSpeed: NSNumber?
    @NSManaged var violationCount: NSNumber?
    @NSManaged var zoneTrip: Trip_Detail?

}
