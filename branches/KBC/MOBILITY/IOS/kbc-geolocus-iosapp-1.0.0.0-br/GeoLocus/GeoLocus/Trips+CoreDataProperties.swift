//
//  Trips+CoreDataProperties.swift
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

extension Trips {

    @NSManaged var tripid: String?
    @NSManaged var channelid: String?
    @NSManaged var userid: String?
    @NSManaged var tokenid: String?
    @NSManaged var channelversion: String?
    @NSManaged var triptoconfig: Configurations?
    @NSManaged var triptosummary: TripSummary?
    @NSManaged var triptotimeseries: NSSet?

}
