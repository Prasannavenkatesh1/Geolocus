//
//  Trip_timeseries+CoreDataProperties.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 28/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Trip_timeseries {

    @NSManaged var currenttime: String?
    @NSManaged var datausage: NSNumber?
    @NSManaged var distance: String?
    @NSManaged var eventtype: NSNumber?
    @NSManaged var eventvalue: NSNumber?
    @NSManaged var isEvent: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var speed: NSNumber?

}
