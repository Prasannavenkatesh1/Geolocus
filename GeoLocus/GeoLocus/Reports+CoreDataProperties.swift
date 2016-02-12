//
//  Reports+CoreDataProperties.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 12/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Reports {

    @NSManaged var myscore: String?
    @NSManaged var poolaveragescore: String?
    @NSManaged var timeframe: NSNumber?
    @NSManaged var scoreoption: NSNumber?

}
