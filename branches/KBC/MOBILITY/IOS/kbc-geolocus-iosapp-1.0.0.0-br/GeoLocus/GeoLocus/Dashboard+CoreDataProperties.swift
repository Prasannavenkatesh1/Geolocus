//
//  Dashboard+CoreDataProperties.swift
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

extension Dashboard {

    @NSManaged var scorerange: String?
    @NSManaged var levelname: String?
    @NSManaged var nextlevelmessage: String?
    @NSManaged var distancetravelled: String?
    @NSManaged var totalpoints: String?
    @NSManaged var pointsachieved: String?
    @NSManaged var scoremessage: String?
    @NSManaged var tripstatus: String?

}
