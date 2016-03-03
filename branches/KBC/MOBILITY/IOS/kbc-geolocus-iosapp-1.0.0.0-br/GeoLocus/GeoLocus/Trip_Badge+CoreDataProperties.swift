//
//  Trip_Badge+CoreDataProperties.swift
//  GeoLocus
//
//  Created by CTS MAC on 03/03/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Trip_Badge {

    @NSManaged var badgeDescription: String?
    @NSManaged var isEarned: NSNumber?
    @NSManaged var orderIndex: NSNumber?
    @NSManaged var title: String?
    @NSManaged var type: NSNumber?
    @NSManaged var distanceCovered: NSNumber?

}
