//
//  Trip_timeseries+CoreDataProperties.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 20/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Trip_timeseries {

    @NSManaged var acceleration: Double
    @NSManaged var breaking: Double
    @NSManaged var currenttime: String?
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var speed: Double
    @NSManaged var timezone: String?

}
