//
//  DatabaseActions.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 11/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class DatabaseActions: NSObject {
  
  
  // MARK: -
  // MARK: Core Data Stack
  lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = NSBundle.mainBundle().URLForResource("Geomodel", withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
  }()
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    let persistentStoreCoordinator = self.persistentStoreCoordinator
    
    // Initialize Managed Object Context
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    // Configure Managed Object Context
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    
    return managedObjectContext
  }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    // Initialize Persistent Store Coordinator
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    
    // URL Documents Directory
    let URLs = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    let applicationDocumentsDirectory = URLs[(URLs.count - 1)]
    
    // URL Persistent Store
    let URLPersistentStore = applicationDocumentsDirectory.URLByAppendingPathComponent("Geomodel.sqlite")
    
    do {
      // Add Persistent Store to Persistent Store Coordinator
      try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: URLPersistentStore, options: nil)
      
    } catch {
      // Populate Error
      var userInfo = [String: AnyObject]()
      userInfo[NSLocalizedDescriptionKey] = "There was an error creating or loading the application's saved data."
      userInfo[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
      
      userInfo[NSUnderlyingErrorKey] = error as! NSError
      let wrappedError = NSError(domain: "com.tutsplus.Done", code: 1001, userInfo: userInfo)
      
      NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
      
      abort()
    }
    
    return persistentStoreCoordinator
  }()
  
  // MARK: -
  // MARK: Helper Methods
  private func saveManagedObjectContext() {
    do {
      try self.managedObjectContext.save()
      } catch {
      let saveError = error as NSError
      print("\(saveError), \(saveError.userInfo)")
    }
  }
  
  //MARK:- TripTimeSeries
  
  func saveTimeSeries(timeseriesmodel:TimeSeriesModel){
    let timeseries = NSEntityDescription.insertNewObjectForEntityForName("Trip_timeseries",inManagedObjectContext: self.managedObjectContext) as! Trip_timeseries
    timeseries.isEvent      = timeseriesmodel.isEvent
    timeseries.eventtype    = timeseriesmodel.eventtype
    timeseries.eventvalue   = timeseriesmodel.eventvalue
    timeseries.speed        = timeseriesmodel.speed
    timeseries.latitude     = timeseriesmodel.latitude
    timeseries.longitude    = timeseriesmodel.longitude
    timeseries.datausage    = timeseriesmodel.datausage
    timeseries.distance     = timeseriesmodel.distance
    timeseries.currenttime  = timeseriesmodel.currenttime
    
    do{
      try self.managedObjectContext.save()
    }catch{
      fatalError("not iserted")
    }
 }
  
  func saveTripSummary(summarymodel:SummaryModel){
    let tripsummary = NSEntityDescription.insertNewObjectForEntityForName("TripSummary",inManagedObjectContext: self.managedObjectContext) as! TripSummary
    tripsummary.accelerationcount             = summarymodel.accelerationcount
    tripsummary.attentionscore = summarymodel.attentionscore
    tripsummary.brakingcount = summarymodel.brakingcount
    tripsummary.brakingscore = summarymodel.brakingscore
    tripsummary.datausage = summarymodel.datausage
    tripsummary.ecoscore = summarymodel.ecoscore
    tripsummary.timezone = summarymodel.timezone
//    tripsummary.timezoneid = summarymodel.timezoneid
    tripsummary.totaldistance = summarymodel.totaldistance
    tripsummary.totalduration = summarymodel.totalduration
    tripsummary.tripendtime = summarymodel.tripendtime
    tripsummary.tripid = summarymodel.tripid
    tripsummary.tripstarttime = summarymodel.tripstarttime
    
    
    do{
      try self.managedObjectContext.save()
    }catch{
      fatalError("not iserted")
    }
  }
 
  
  func saveConfiguration(configmodel:ConfigurationModel){
    let configthresholds = NSEntityDescription.insertNewObjectForEntityForName("Configurations",inManagedObjectContext: self.managedObjectContext) as! Configurations
    configthresholds.thresholds_brake             = configmodel.thresholds_brake
    configthresholds.thresholds_acceleration      = configmodel.thresholds_acceleration
    configthresholds.thresholds_autotrip          = configmodel.thresholds_autotrip
    configthresholds.weightage_braking            = configmodel.weightage_braking
    configthresholds.weightage_acceleration       = configmodel.weightage_acceleration
    configthresholds.weightage_speed              = configmodel.weightage_speed
    configthresholds.weightage_severevoilation    = configmodel.weightage_severevoilation
    configthresholds.ecoweightage_braking         = configmodel.ecoweightage_braking
    configthresholds.ecoweightage_acceleration    = configmodel.ecoweightage_acceleration
    
    do{
      try self.managedObjectContext.save()
    }catch{
      fatalError("not iserted")
    }
  }
  
  func getConfiguration() -> ConfigurationModel{
    
    let fetchRequest = NSFetchRequest(entityName: "Configurations")
    do{
       let configdata:Configurations =  try (self.managedObjectContext.executeFetchRequest(fetchRequest))[0] as! Configurations
      
      var configmodeldata:ConfigurationModel    = ConfigurationModel()
      configmodeldata.thresholds_brake          = configdata.thresholds_brake
      configmodeldata.thresholds_acceleration   = configdata.thresholds_acceleration
      configmodeldata.thresholds_autotrip       = configdata.thresholds_autotrip
      configmodeldata.weightage_braking         = configdata.weightage_braking
      configmodeldata.weightage_acceleration    = configdata.weightage_acceleration
      configmodeldata.weightage_speed           = configdata.weightage_speed
      configmodeldata.weightage_severevoilation = configdata.weightage_severevoilation
      configmodeldata.ecoweightage_braking      = configdata.ecoweightage_braking
      configmodeldata.ecoweightage_acceleration = configdata.ecoweightage_acceleration
      
      return configmodeldata

    }catch{
      fatalError("reterive error")
    }
  }
  
  func fetchEventCount(eventtype:Events.EventType) -> NSNumber{
    
    let fetchRequest = NSFetchRequest(entityName: "Trip_timeseries")
    let predicate = NSPredicate(format: "eventtype = %d AND isEvent == 1",eventtype.rawValue)
    fetchRequest.predicate = predicate
    let count = self.managedObjectContext.countForFetchRequest(fetchRequest, error: nil)
    return NSNumber(integer: count)
    
  }
  
  func fetchTotalDistance() -> NSNumber{
    
    let fetchRequest = NSFetchRequest(entityName: "Trip_timeseries")
    let timseries:Trip_timeseries
    do{
      timseries = try (self.managedObjectContext.executeFetchRequest(fetchRequest)).last as! Trip_timeseries
    }catch{
      fatalError("fetch error")
    }
    return timseries.distance!
    
  }
  
  func reterive(){
    var locations  = [Trip_timeseries]()
    
    let fetchRequest = NSFetchRequest(entityName: "Trip_timeseries")
    do{
      
       locations =  try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Trip_timeseries]
      
      for triptimeseries in locations {
        var timeseries:TimeSeriesModel = TimeSeriesModel.init(ctime: triptimeseries.currenttime!,
          lat: triptimeseries.latitude!,
          longt: triptimeseries.longitude!,
          speedval: triptimeseries.speed!,
          datausage: triptimeseries.datausage!,
          iseventval: triptimeseries.isEvent!,
          evetype: triptimeseries.eventtype!,
          eveval: triptimeseries.eventvalue!,
          distance: triptimeseries.distance!)
        print(timeseries)
      }
    }catch{
      fatalError("reterive error")
    }
  }
  
    func saveTripDetail(tripDetail: History) {
        
        let events = NSMutableOrderedSet()
        let speedZones = NSMutableOrderedSet()
        
        let tripDetailRow = NSEntityDescription.insertNewObjectForEntityForName("Trip_Detail",inManagedObjectContext: self.managedObjectContext) as! Trip_Detail
        
        if tripDetail.events?.count > 0 {
            for tripEvent in tripDetail.events! {
                let event = NSEntityDescription.insertNewObjectForEntityForName("Trip_Event",inManagedObjectContext: self.managedObjectContext) as! Trip_Event
                event.latitude      = tripEvent.location.latitude
                event.longitude     = tripEvent.location.longitude
                event.eventType     = tripEvent.type.rawValue
                event.eventMessage  = tripEvent.message
                event.eventTrip     = tripDetailRow
                
                events.addObject(event)
            }
        }
        
        if tripDetail.speedZones.count > 0 {
            for tripZone in tripDetail.speedZones {
                let speedZone = NSEntityDescription.insertNewObjectForEntityForName("Trip_Speed_Zone",inManagedObjectContext: self.managedObjectContext) as! Trip_Speed_Zone
                
                speedZone.speedScore        = tripZone.speedScore
                speedZone.speedBehaviour    = tripZone.speedBehaviour
                speedZone.distanceTravelled = tripZone.distanceTravelled
                speedZone.maxSpeed          = tripZone.maxSpeed
                speedZone.aboveSpeed        = tripZone.aboveSpeed
                speedZone.withinSpeed       = tripZone.withinSpeed
                speedZone.violationCount    = tripZone.violationCount
                speedZone.zoneTrip          = tripDetailRow
                
                speedZones.addObject(speedZone)
            }
        }
        
        
        
        tripDetailRow.tripId            = tripDetail.tripId
        tripDetailRow.date              = NSDate(dateString: tripDetail.tripdDate)
        tripDetailRow.distance          = tripDetail.distance
        tripDetailRow.tripPoints        = tripDetail.tripPoints
        tripDetailRow.speedScore        = tripDetail.tripScore.speedScore
        tripDetailRow.ecoScore          = tripDetail.tripScore.ecoScore
        tripDetailRow.attentionScore    = tripDetail.tripScore.attentionScore
        tripDetailRow.dataUsageMessage  = tripDetail.dataUsageMessage
        tripDetailRow.duration          = tripDetail.tripDuration
        tripDetailRow.events            = events
        tripDetailRow.speedZones        = speedZones
        
        
        
        do{
            try self.managedObjectContext.save()
            //add check
            
            fetchtripDetailData({ (status, response, error) -> Void in
                print(response)
            })
        }catch{
            fatalError("not iserted")
        }
    }
    
    func fetchtripDetailData(completionHandler:(status : Int, response: [History]?, error: NSError?) -> Void) -> Void{
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Trip_Detail")
        
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let sortDescriptors = [dateSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        // Initialize Asynchronous Fetch Request
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (asynchronousFetchResult) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let trips = self.processTripDetailResult(asynchronousFetchResult)
                
                if trips != nil {
                    completionHandler(status: 1, response: trips, error: nil)
                }else{
                    completionHandler(status: 0, response: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                }
            })
        }
        
        do {
            // Execute Asynchronous Fetch Request
            let asynchronousFetchResult = try managedObjectContext.executeRequest(asyncFetchRequest)
            
            print(asynchronousFetchResult)
            
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func processTripDetailResult(asynchronousFetchResult: NSAsynchronousFetchResult) -> [History]? {
        
        if let results = asynchronousFetchResult.finalResult {
            
            var trips = [History]()
            
            for tripDetailObj in results {
                let tripManagedObj = tripDetailObj as! Trip_Detail
                
                var eventsObj = [Event]()
                var speedZonesObj = [SpeedZone]()
                
                //Event array
                for eventObj in tripManagedObj.events!  {
                    let eventManagedObject = eventObj as! Trip_Event
                    
                    let eventLocation = EventLocation(latitude: eventManagedObject.latitude!.doubleValue, longitude: eventManagedObject.longitude!.doubleValue)
                    
                    let event = Event(location: eventLocation, type:EventType(rawValue: eventManagedObject.eventType!.integerValue)! , message: eventManagedObject.eventMessage!)
                    eventsObj.append(event)
                    
                }
                
                //Speedzone array
                
                for zoneObject in tripManagedObj.speedZones! {
                    let zonemanagedObject = zoneObject as! Trip_Speed_Zone
                    
                    let speedZone = SpeedZone(speedScore: zonemanagedObject.speedScore!, maxSpeed: zonemanagedObject.maxSpeed!, aboveSpeed: zonemanagedObject.aboveSpeed!, withinSpeed: zonemanagedObject.withinSpeed!, violationCount: zonemanagedObject.violationCount!, speedBehaviour: zonemanagedObject.speedBehaviour!, distanceTravelled: zonemanagedObject.distanceTravelled!)
                    
                    speedZonesObj.append(speedZone)
                }
                
                let tripScore = TripScore(speedScore: tripManagedObj.speedScore!, ecoScore: tripManagedObj.ecoScore!, attentionScore: nil)
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                
                let trip = History(tripid: tripManagedObj.tripId!, tripDate:dateFormatter.stringFromDate(tripManagedObj.date!), distance: tripManagedObj.distance!, tripPoints: tripManagedObj.tripPoints!, tripDuration: tripManagedObj.duration!, dataUsageMessage: tripManagedObj.dataUsageMessage!, tripScore: tripScore, events: eventsObj, speedZones: speedZonesObj)
                
                trips.append(trip)
            }
            
            return trips
            
        }else{
            
            return nil
        }
    }
    
    
    //MARK: - Badges Methods--------------------------------------------------------------------------------------
    
    func saveBadge(badge: Badge) {
        let badgeRow = NSEntityDescription.insertNewObjectForEntityForName("Trip_Badge",inManagedObjectContext: self.managedObjectContext) as! Trip_Badge
        
        badgeRow.title              = badge.badgeTitle
        badgeRow.badgeDescription   = badge.badgeDescription
        badgeRow.isEarned           = badge.isEarned
        badgeRow.type               = badge.badgeType.rawValue
        badgeRow.orderIndex         = badge.orderIndex
        
        do{
            try self.managedObjectContext.save()
            //add check
            fetchBadgeData({ (status, response, error) -> Void in
                print(response)
            })
        }catch{
            fatalError("not iserted")
        }
    }
    
    
    func fetchBadgeData(completionHandler:(status : Int, response: [Badge]?, error: NSError?) -> Void) -> Void{
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Trip_Badge")
        
        // Initialize Asynchronous Fetch Request
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (asynchronousFetchResult) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let badges = self.processBadgeResult(asynchronousFetchResult)
                
                if badges != nil {
                   completionHandler(status: 1, response: badges, error: nil)
                }else{
                    completionHandler(status: 0, response: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                }
            })
        }
        
        do {
            // Execute Asynchronous Fetch Request
            let asynchronousFetchResult = try managedObjectContext.executeRequest(asyncFetchRequest)
            
            print(asynchronousFetchResult)
            
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func processBadgeResult(asynchronousFetchResult: NSAsynchronousFetchResult) -> [Badge]? {
        
        if let results = asynchronousFetchResult.finalResult {
            
            var badges = [Badge]()
            
            for item in results {
                
                let badgemanagedObj = item as! Trip_Badge
                let badge = Badge(withIcon: "", badgeTitle: badgemanagedObj.title!, badgeDescription:badgemanagedObj.badgeDescription! , isEarned: badgemanagedObj.isEarned!.boolValue, orderIndex: badgemanagedObj.orderIndex!.integerValue, badgeType:Badge.BadgesType(rawValue: badgemanagedObj.type!.integerValue)! , additionalMsg:nil)
                badges.append(badge)
            }
            
            return badges
            
        }else{
            
            return nil
        }
    }
    
    
    //MARK: - Overall Score methods-------------------------------------------------------------------------------------
    
    func saveOverallScore(overallScore: OverallScores){
        let overallScoreRow = NSEntityDescription.insertNewObjectForEntityForName("OverallScore",inManagedObjectContext: self.managedObjectContext) as! OverallScore
        overallScoreRow.overall             = overallScore.overallScore
        overallScoreRow.speeding            = overallScore.speedingScore
        overallScoreRow.eco                 = overallScore.ecoScore
        overallScoreRow.attention           = overallScore.attentionScore
        overallScoreRow.distance            = overallScore.distanceTravelled
        overallScoreRow.dataUsageMessage    = overallScore.dataUsageMsg

                
        do{
            try self.managedObjectContext.save()
            //add check
        }catch{
            fatalError("not iserted")
        }
    }
    
    
    func fetchOverallScoreData(completionHandler:(status : Int, response: OverallScores?, error: NSError?) -> Void) -> Void{
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "OverallScore")
        
        // Initialize Asynchronous Fetch Request
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (asynchronousFetchResult) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let overallScore = self.processOverallScoreResult(asynchronousFetchResult)
                
                if overallScore != nil {
                    completionHandler(status: 1, response: overallScore, error: nil)
                }else{
                    completionHandler(status: 0, response: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                }
            })
        }
        
        do {
            // Execute Asynchronous Fetch Request
            let asynchronousFetchResult = try managedObjectContext.executeRequest(asyncFetchRequest)
            
            print(asynchronousFetchResult)
            
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func processOverallScoreResult(asynchronousFetchResult: NSAsynchronousFetchResult) -> OverallScores? {
        
        if let results = asynchronousFetchResult.finalResult {
            
            if let score = results.first {
                let scoreObj = score as! OverallScore
                
                return OverallScores(overallScore: scoreObj.overall!, speedingScore: scoreObj.speeding!, ecoScore: scoreObj.eco!, distanceTravelled: scoreObj.distance!, dataUsageMsg: scoreObj.dataUsageMessage!)
            }else{
                return nil
            }
        }else{
            
            return nil
        }
    }
    
    
    //MARK: - Delete methods
    
    func removeDateFor(entity: String) {
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.includesPropertyValues = false
        
        do{
            if let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    self.managedObjectContext.deleteObject(result)
                }
                
                do{
                    try self.managedObjectContext.save()
                }catch{
                    fatalError("not saved")
                }
            }
        }catch{
            fatalError("not iserted")
        }
    }
   
}
