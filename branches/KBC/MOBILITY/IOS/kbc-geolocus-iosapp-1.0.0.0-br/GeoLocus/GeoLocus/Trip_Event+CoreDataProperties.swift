//
//  Trip_Event+CoreDataProperties.swift
//  GeoLocus
//
//  Created by CTS MAC on 25/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Trip_Event {

    @NSManaged var eventMessage: String?
    @NSManaged var eventType: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var threshold: NSNumber?
    @NSManaged var fineMessage: String?
    @NSManaged var eventValue: NSNumber?
    @NSManaged var isSevere: String?
    @NSManaged var eventTrip: Trip_Detail?

}
