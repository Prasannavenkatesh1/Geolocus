//
//  Trip_Event+CoreDataProperties.swift
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

extension Trip_Event {

    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var eventType: NSNumber?
    @NSManaged var eventMessage: String?
    @NSManaged var thresholdSpeed: NSNumber?
    @NSManaged var eventTrip: Trip_Detail?

}
