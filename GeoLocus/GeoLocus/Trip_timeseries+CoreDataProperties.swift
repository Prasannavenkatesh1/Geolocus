//
//  Trip_timeseries+CoreDataProperties.swift
//  
//
//  Created by Wearables Mac Mini on 28/01/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Trip_timeseries {

    @NSManaged var currenttime: String?
    @NSManaged var datausage: Double
    @NSManaged var distance: String?
    @NSManaged var eventtype: Int16
    @NSManaged var eventvalue: Double
    @NSManaged var isEvent: Bool
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var speed: Double

}
