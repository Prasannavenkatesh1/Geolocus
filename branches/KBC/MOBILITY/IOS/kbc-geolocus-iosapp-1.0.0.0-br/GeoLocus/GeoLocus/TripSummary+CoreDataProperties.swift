//
//  TripSummary+CoreDataProperties.swift
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

extension TripSummary {

    @NSManaged var accelerationcount: NSNumber?
    @NSManaged var attentionscore: NSNumber?
    @NSManaged var brakingcount: NSNumber?
    @NSManaged var brakingscore: NSNumber?
    @NSManaged var datausage: NSNumber?
    @NSManaged var ecoscore: NSNumber?
    @NSManaged var timezone: String?
    @NSManaged var timezoneid: String?
    @NSManaged var totaldistance: NSNumber?
    @NSManaged var totalduration: NSNumber?
    @NSManaged var tripendtime: NSDate?
    @NSManaged var tripid: String?
    @NSManaged var tripstarttime: NSDate?
    @NSManaged var isSync: NSNumber?

}
