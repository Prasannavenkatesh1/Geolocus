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
    
    
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let persistentStoreCoordinator = self.persistentStoreCoordinator
        
        // Initialize Managed Object Context
        var privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        
        // Configure Managed Object Context
        privateManagedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return privateManagedObjectContext
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
    timeseries.tripid       = timeseriesmodel.tripid
    timeseries.isEvent      = timeseriesmodel.isEvent
    timeseries.eventtype    = timeseriesmodel.eventtype
    timeseries.eventvalue   = timeseriesmodel.eventvalue
    timeseries.speed        = timeseriesmodel.speed
    timeseries.latitude     = timeseriesmodel.latitude
    timeseries.longitude    = timeseriesmodel.longitude
    timeseries.datausage    = timeseriesmodel.datausage
    timeseries.distance     = timeseriesmodel.distance
    timeseries.currenttime  = timeseriesmodel.currenttime
    timeseries.isvalidtrip  = timeseriesmodel.isvalidtrip
    
    do{
      try self.managedObjectContext.save()
    }catch{
      fatalError("not iserted")
    }
 }
  
  func saveTripSummary(summarymodel:SummaryModel){
    let tripsummary = NSEntityDescription.insertNewObjectForEntityForName("TripSummary",inManagedObjectContext: self.managedObjectContext) as! TripSummary
    tripsummary.accelerationcount = summarymodel.accelerationcount
    tripsummary.attentionscore    = summarymodel.attentionscore
    tripsummary.brakingcount      = summarymodel.brakingcount
    tripsummary.brakingscore      = summarymodel.brakingscore
    tripsummary.datausage         = summarymodel.datausage
    tripsummary.ecoscore          = summarymodel.ecoscore
    tripsummary.timezone          = summarymodel.timezone
    tripsummary.timezoneid        = summarymodel.timezoneid
    tripsummary.totaldistance     = summarymodel.totaldistance
    tripsummary.totalduration     = summarymodel.totalduration
    tripsummary.tripendtime       = summarymodel.tripendtime
    tripsummary.tripid            = summarymodel.tripid
    tripsummary.tripstarttime     = summarymodel.tripstarttime
    tripsummary.isSync            = summarymodel.isSync
    
    
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
    configthresholds.thresholds_minimumspeed      = configmodel.thresholds_minimumspeed
    configthresholds.tripid                       = configmodel.tripid
    
    do{
      try self.managedObjectContext.save()
    }catch{
      fatalError("not iserted")
    }
  }
  
  func saveTripMaster(tripmodel:TripModel){
    let tripsdatas = NSEntityDescription.insertNewObjectForEntityForName("Trips",inManagedObjectContext: self.managedObjectContext) as! Trips
    tripsdatas.tripid           = tripmodel.tripid
    tripsdatas.channelid        = tripmodel.channelid
    tripsdatas.userid           = tripmodel.userid
    tripsdatas.tokenid          = tripmodel.tokenid
    tripsdatas.channelversion   = tripmodel.channelversion
    
    do{
      try self.managedObjectContext.save()
    }catch{
      fatalError("not inserted")
    }
  }
  
  func deleteTrip(){
    
  }
  
  func getConfiguration(tripid:String) -> ConfigurationModel?{
    
    let fetchRequest = NSFetchRequest(entityName: "Configurations")
    let predicate = NSPredicate(format: "tripid = %@",tripid)
    fetchRequest.predicate = predicate
    do{
      let configs = try (self.managedObjectContext.executeFetchRequest(fetchRequest))
      if configs.count > 0{
        let configdata:Configurations =  configs[0] as! Configurations
        
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
        configmodeldata.thresholds_minimumspeed   = configdata.thresholds_minimumspeed
        configmodeldata.tripid                    = configdata.tripid
        
        
         return configmodeldata
      }
      return nil
      
    }catch{
      fatalError("reterive error")
    }
  }
  
  func fetchEventCount(eventtype:Events.EventType, tripid:String) -> NSNumber{
    
    let fetchRequest = NSFetchRequest(entityName: "Trip_timeseries")
    let predicate = NSPredicate(format: "eventtype = %d AND isEvent == 1 AND tripid = %@",eventtype.rawValue,tripid)
    fetchRequest.predicate = predicate
    let count = self.managedObjectContext.countForFetchRequest(fetchRequest, error: nil)
    return NSNumber(integer: count)
    
  }
  
  func fetchTotalDistance(tripid:String) -> NSNumber{
    
    let fetchRequest = NSFetchRequest(entityName: "Trip_timeseries")
   
    let timseries:Trip_timeseries
    do{
      timseries = try (self.managedObjectContext.executeFetchRequest(fetchRequest)).last as! Trip_timeseries
    }catch{
      fatalError("fetch error")
    }
    return timseries.distance!
    
  }
  
  func reteriveTimeSeries(tripid:String) -> [Trip_timeseries]{
    var locations  = [Trip_timeseries]()
    
    let fetchRequest = NSFetchRequest(entityName: "Trip_timeseries")
    let predicate = NSPredicate(format: "tripid = %@",tripid)
    fetchRequest.predicate = predicate
    do{
      
      locations =  try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Trip_timeseries]
      
      for triptimeseries in locations {
        let timeseries:TimeSeriesModel = TimeSeriesModel.init(tripid: tripid,
          ctime: triptimeseries.currenttime!,
          lat: triptimeseries.latitude!,
          longt: triptimeseries.longitude!,
          speedval: triptimeseries.speed!,
          datausage: triptimeseries.datausage!,
          iseventval: triptimeseries.isEvent!,
          evetype: triptimeseries.eventtype!,
          eveval: triptimeseries.eventvalue!,
          distance: triptimeseries.distance!,
          isvalidtrip: triptimeseries.isvalidtrip!)
//        print(timeseries)
      }
    }catch{
      fatalError("reterive error")
    }
    
    return locations
  }
  
  func reteriveConfiguration(tripid:String) -> ConfigurationModel?{
    
    let fetchRequest = NSFetchRequest(entityName: "Configurations")
    let predicate = NSPredicate(format: "tripid = %@",tripid)
    fetchRequest.predicate = predicate
    
    do{
      let configarr = try (self.managedObjectContext.executeFetchRequest(fetchRequest))
      if configarr.count > 0{
        let configdata:Configurations =  configarr[0] as! Configurations
        
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
        configmodeldata.tripid                    = configdata.tripid
        configmodeldata.thresholds_minimumspeed   = configdata.thresholds_minimumspeed
        
        return configmodeldata
      }
      return nil
      
    }catch{
      fatalError("reterive error")
    }
  }
  
  func reteriveTripSummary(tripid:String) -> SummaryModel{
    var summarymodeldata:SummaryModel
    let fetchRequest = NSFetchRequest(entityName: "TripSummary")
    let predicate = NSPredicate(format: "tripid = %@",tripid)
    fetchRequest.predicate = predicate
    
    do{
      
      let tripsummary:TripSummary = try (self.managedObjectContext.executeFetchRequest(fetchRequest))[0] as! TripSummary
      summarymodeldata  = SummaryModel(datausage: tripsummary.datausage!,
        tripid: tripsummary.tripid!,
        tripstarttime: tripsummary.tripstarttime!,
        tripendtime: tripsummary.tripendtime!,
        timezone:tripsummary.timezone!,
        timezoneid: tripsummary.timezone!)
      
    }catch{
      fatalError("reterive error")
    }
    return summarymodeldata
  }
  
  func reteriveTrips() -> [TripModel]{
    
    var tripsdata = [Trips]()
    var tripsmodeldata = [TripModel]()
    let fetchRequest = NSFetchRequest(entityName: "Trips")
    
    do{
      tripsdata = try (self.managedObjectContext.executeFetchRequest(fetchRequest)) as! [Trips]
      
      for tripdata in tripsdata{
        
        var tripmodeldata = TripModel()
        tripmodeldata.tripid = tripdata.tripid
        tripmodeldata.channelid = tripdata.channelid
        tripmodeldata.userid = tripdata.userid
        tripmodeldata.tokenid = tripdata.tokenid
        tripmodeldata.channelversion = tripdata.channelversion
        tripsmodeldata.append(tripmodeldata)
       
      }
      
    return tripsmodeldata
      
    }catch{
      fatalError("reterive error")
    }
  }
  
  
//  func reteriveTrips -> [TripModel]{
//    var locations  = [TripModel]()
//    
//    let fetchRequest = NSFetchRequest(entityName: "Trips")
//    
//    do{
//      
//      locations =  try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Trips]
//      
//      for triptimeseries in locations {
//        let timeseries:TimeSeriesModel = TimeSeriesModel.init(tripid: tripid,
//          ctime: triptimeseries.currenttime!,
//          lat: triptimeseries.latitude!,
//          longt: triptimeseries.longitude!,
//          speedval: triptimeseries.speed!,
//          datausage: triptimeseries.datausage!,
//          iseventval: triptimeseries.isEvent!,
//          evetype: triptimeseries.eventtype!,
//          eveval: triptimeseries.eventvalue!,
//          distance: triptimeseries.distance!,
//          isvalidtrip: triptimeseries.isvalidtrip!)
//        //        print(timeseries)
//      }
//    }catch{
//      fatalError("reterive error")
//    }
//    
//    return locations
//  }

  
    
    //MARK: - History Methods
  
    func saveTripDetail(tripDetails: [History], completionhandler:(status: Bool)-> Void) {
        
        if tripDetails.count > 0 {
            var rowCount = 0
            
            for tripDetail in tripDetails {
                
                let events = NSMutableOrderedSet()
                let speedZones = NSMutableOrderedSet()
                
                let tripDetailRow = NSEntityDescription.insertNewObjectForEntityForName("Trip_Detail",inManagedObjectContext: self.privateManagedObjectContext) as! Trip_Detail
                
                if tripDetail.events?.count > 0 {
                    for tripEvent in tripDetail.events! {
                        let event = NSEntityDescription.insertNewObjectForEntityForName("Trip_Event",inManagedObjectContext: self.privateManagedObjectContext) as! Trip_Event
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
                        let speedZone = NSEntityDescription.insertNewObjectForEntityForName("Trip_Speed_Zone",inManagedObjectContext: self.privateManagedObjectContext) as! Trip_Speed_Zone
                        
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
                tripDetailRow.overallScore      = tripDetail.tripScore.overallScore
                tripDetailRow.speedScore        = tripDetail.tripScore.speedScore
                tripDetailRow.ecoScore          = tripDetail.tripScore.ecoScore
                tripDetailRow.attentionScore    = tripDetail.tripScore.attentionScore
                tripDetailRow.speedingMessage   = tripDetail.speedingMessage
                tripDetailRow.ecoMessage        = tripDetail.ecoMessage
                tripDetailRow.dataUsageMessage  = tripDetail.dataUsageMessage
                tripDetailRow.duration          = tripDetail.tripDuration
                tripDetailRow.events            = events
                tripDetailRow.speedZones        = speedZones
                
                self.privateManagedObjectContext.performBlockAndWait({ () -> Void in
                    do{
                        try self.privateManagedObjectContext.save()
                        
                        rowCount++
                        
                        if rowCount == tripDetails.count{
                            completionhandler(status: true)
                        }
                    }catch{
                        
                        completionhandler(status: false)
                        fatalError("not iserted")
                    }
                })
                
            }
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
                if let eventSet = tripManagedObj.events {
                    for eventObj in eventSet  {
                        let eventManagedObject = eventObj as! Trip_Event
                        
                        let eventLocation = EventLocation(latitude: eventManagedObject.latitude!.doubleValue, longitude: eventManagedObject.longitude!.doubleValue)
                        
                        let event = Event(location: eventLocation, type:EventType(rawValue: eventManagedObject.eventType!.integerValue)! , message: eventManagedObject.eventMessage)
                        eventsObj.append(event)
                    }
                }
                
                //Speedzone array
                if let zoneSet = tripManagedObj.speedZones {
                    for zoneObject in  zoneSet {
                        let zonemanagedObject = zoneObject as! Trip_Speed_Zone
                        
                        let speedZone = SpeedZone(speedScore: zonemanagedObject.speedScore!,
                            maxSpeed: zonemanagedObject.maxSpeed!,
                            aboveSpeed: zonemanagedObject.aboveSpeed!,
                            withinSpeed: zonemanagedObject.withinSpeed!,
                            violationCount: zonemanagedObject.violationCount!,
                            speedBehaviour: zonemanagedObject.speedBehaviour!,
                            distanceTravelled: Utility.roundToDecimal(zonemanagedObject.distanceTravelled!.doubleValue / 1000.0, place: 0))
                        
                        speedZonesObj.append(speedZone)
                    }
                }
                
                let tripScore = TripScore(overallScore: 70,speedScore: tripManagedObj.speedScore!, ecoScore: tripManagedObj.ecoScore!, attentionScore: nil)
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                
                let trip = History(tripid: tripManagedObj.tripId!,
                    tripDate:dateFormatter.stringFromDate(tripManagedObj.date!),
                    distance: Utility.roundToDecimal(tripManagedObj.distance!.doubleValue / 1000.0, place: 0),
                    tripPoints: tripManagedObj.tripPoints!,
                    tripDuration: tripManagedObj.duration!,
                    speedingMessage: tripManagedObj.speedingMessage,
                    ecoMessage:tripManagedObj.ecoMessage,
                    dataUsageMessage: tripManagedObj.dataUsageMessage,
                    tripScore: tripScore,
                    events: eventsObj,
                    speedZones: speedZonesObj)
                
                trips.append(trip)
            }
            
            return trips
            
        }else{
            
            return nil
        }
    }
    
    
    //MARK: - Badges Methods
    
    func saveBadge(badges: [Badge], completionhandler:(status: Bool)-> Void) {
        
        if badges.count > 0 {
            var rowCount = 0
            
            for badge in badges {
                let badgeRow = NSEntityDescription.insertNewObjectForEntityForName("Trip_Badge",inManagedObjectContext: self.privateManagedObjectContext) as! Trip_Badge
                
                badgeRow.title              = badge.badgeTitle
                badgeRow.badgeDescription   = badge.badgeDescription
                badgeRow.isEarned           = badge.isEarned
                badgeRow.type               = badge.badgeType.rawValue
                badgeRow.orderIndex         = badge.orderIndex
                
                self.privateManagedObjectContext.performBlockAndWait({ () -> Void in
                    do{
                        try self.privateManagedObjectContext.save()
                        
                        rowCount++
                        if rowCount == badges.count {
                            completionhandler(status: true)
                        }
                        
                    }catch{
                        completionhandler(status: false)
                        fatalError("not iserted")
                    }
                })
                
                
            }
        }else{
            completionhandler(status: false)
        }
        
    }
    
    func saveDashboardData(dashboardData:DashboardModel , completionhandler:(status:Bool)->Void){
        
         let dashboard = NSEntityDescription.insertNewObjectForEntityForName("Dashboard", inManagedObjectContext: self.managedObjectContext) as! Dashboard
         dashboard.distancetravelled  = dashboardData.distanceTravelled
         dashboard.levelname          = dashboardData.levelName
         dashboard.nextlevelmessage   = dashboardData.levelMessage
         dashboard.pointsachieved     = dashboardData.pointsAchieved
         dashboard.scoremessage       = dashboardData.scoreMessage
         dashboard.scorerange         = dashboardData.score
         dashboard.totalpoints        = dashboardData.totalPoints
         dashboard.tripstatus         = dashboardData.tripStatus
        
        
        do{
            try self.privateManagedObjectContext.save()
                completionhandler(status: true)
        }catch{
            completionhandler(status: false)
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
            
            if results.count > 0 {
                for item in results {
                    
                    let badgemanagedObj = item as! Trip_Badge
                    let badge = Badge(withIcon: "", badgeTitle: badgemanagedObj.title!, badgeDescription:badgemanagedObj.badgeDescription! , isEarned: badgemanagedObj.isEarned!.boolValue, orderIndex: badgemanagedObj.orderIndex!.integerValue, badgeType:Badge.BadgesType(rawValue: badgemanagedObj.type!.integerValue)! , additionalMsg:nil)
                    badges.append(badge)
                }
                return badges
            }else{
                return nil
            }
        }else{
            
            return nil
        }
    }
    
    
    //MARK: - Overall Score methods
    
    func saveOverallScore(overallScore: OverallScores, completionhandler:(status: Bool)-> Void){
        let overallScoreRow = NSEntityDescription.insertNewObjectForEntityForName("OverallScore",inManagedObjectContext: self.privateManagedObjectContext) as! OverallScore
        overallScoreRow.overall             = overallScore.overallScore
        overallScoreRow.speeding            = overallScore.speedingScore
        overallScoreRow.eco                 = overallScore.ecoScore
        overallScoreRow.attention           = overallScore.attentionScore
        overallScoreRow.distance            = Utility.roundToDecimal(overallScore.distanceTravelled.doubleValue / 1000.0, place: 0)
        overallScoreRow.dataUsageMessage    = overallScore.dataUsageMsg
        overallScoreRow.overallMessage      = overallScore.overallmessage
        overallScoreRow.speedingMessage     = overallScore.speedingMessage
        overallScoreRow.ecoMessage          = overallScore.ecoMessage
        
        self.privateManagedObjectContext.performBlockAndWait { () -> Void in
            do{
                try self.privateManagedObjectContext.save()
                //add check
                print("saved")
                completionhandler(status: true)
            }catch{
                completionhandler(status: false)
                fatalError("not iserted")
                
            }
        }
        
    }
    
    func fetchDashboardData(completionHandler:(status : Int, response: DashboardModel?, error: NSError?) -> Void) -> Void{
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Dashboard")
        // Initialize Asynchronous Fetch Request
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest){(asynchronousFetchResult) -> Void in
         
            dispatch_async(dispatch_get_main_queue(),{ () -> Void in
                let dashboardData = self.processDashboardDataResult(asynchronousFetchResult)
                if dashboardData != nil {
                    completionHandler(status: 1, response: dashboardData, error: nil)
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
    
    func processDashboardDataResult(asynchronousFetchResult: NSAsynchronousFetchResult) -> DashboardModel?{
        
        if let results = asynchronousFetchResult.finalResult {
            
            if let dashboardData = results.first {
                let dashboardObj = dashboardData as! Dashboard
                
                return DashboardModel(score: dashboardObj.scorerange!, levelName: dashboardObj.levelname!, levelMessage: dashboardObj.nextlevelmessage!, distanceTravelled: dashboardObj.distancetravelled!, totalPoints: dashboardObj.totalpoints!, pointsAchieved: dashboardObj.pointsachieved!, scoreMessage: dashboardObj.scoremessage!, tripStatus: dashboardObj.tripstatus!)
            }else{
                return nil
            }
        }else{
            
            return nil
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
                
                return OverallScores(overallScore: scoreObj.overall!, speedingScore: scoreObj.speeding!, ecoScore: scoreObj.eco!, distanceTravelled: scoreObj.distance!, dataUsageMsg: scoreObj.dataUsageMessage!,overallmessage: scoreObj.overallMessage!, speedingMessage: scoreObj.speedingMessage!, ecoMessage: scoreObj.ecoMessage!)
            }else{
                return nil
            }
        }else{
            
            return nil
        }
    }
    
    //MARK: Contract Methods
    
    /* save contract data fetched from service in to Core data*/
    func saveContractData(contractData : ContractModel, completionHandler :(status : Bool) -> Void){
        let contractDataValues = NSEntityDescription.insertNewObjectForEntityForName("Contract", inManagedObjectContext: self.privateManagedObjectContext) as! Contract
        
        contractDataValues.parentUserName = contractData.parentUserName
        contractDataValues.attentionPoints = contractData.attentionPoints
        contractDataValues.ecoPoints = contractData.ecoPoints
        contractDataValues.speedPoints = contractData.speedPoints
        contractDataValues.bonusPoints = contractData.bonusPoints
        contractDataValues.totalContractPoints = contractData.totalContractPoints
        contractDataValues.contractAchievedDate = contractData.contractAchievedDate
        contractDataValues.rewardsDescription = contractData.rewardsDescription
        contractDataValues.contractPointsAchieved = contractData.contractPointsAchieved
        
        
        self.privateManagedObjectContext.performBlockAndWait { () -> Void in
            do{
                try self.privateManagedObjectContext.save()
                //add check
                print("saved")
                completionHandler(status: true)
            }catch{
                completionHandler(status: false)
                fatalError("not iserted")
                
            }
        }
        /*
        do{
            try self.managedObjectContext.save()
            completionHandler(status: true)
        }
        catch{
            completionHandler(status: false)
        }*/
    }
    
    /* fetch contract data stored in the core data */
    func fetchContractData(completionHandler : (status : Int, response : ContractModel?, error : NSError?) -> Void) -> Void{
        let fetchRequest = NSFetchRequest(entityName: "Contract")
        
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest : fetchRequest){
            (asynchronousFetchResult) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let contractData = self.processContractData(asynchronousFetchResult)
                
                if contractData != nil {
                    completionHandler(status : 1, response : contractData, error : nil)
                }
                else{
                    completionHandler(status: 0, response: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                }
            })
        }
        do{
            // Execute Asynchronous Fetch Request
            let asynchronousFetchResult = try managedObjectContext.executeRequest(asyncFetchRequest)
        }
        catch{
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }

    /* process Contract Data */

    func processContractData(asychronousFetchResult : NSAsynchronousFetchResult) -> ContractModel? {
        
        if let results = asychronousFetchResult.finalResult{
            
            if let contractValues = results.first{
                let contractObject = contractValues as! Contract
                
                return ContractModel(parentUserName: contractObject.parentUserName!, attentionPoints: contractObject.attentionPoints!, speedPoints: contractObject.speedPoints!, ecoPoints: contractObject.ecoPoints!, bonusPoints: contractObject.bonusPoints!, totalContractPoints: contractObject.totalContractPoints!, contractPointsAchieved: contractObject.contractPointsAchieved!, rewardsDescription: contractObject.rewardsDescription!, contractAchievedDate: contractObject.contractAchievedDate!)
            }
            else{
                return nil
            }
        }
        else{
            return nil
        }
    }
    
    //MARK:- Report Data
    
    func saveReportData(reportData : Report, completionHandler :(status : Bool) -> Void){
        
        for reportItem in reportData.reportDetail {
            
            let report = NSEntityDescription.insertNewObjectForEntityForName("Reports", inManagedObjectContext: self.privateManagedObjectContext) as! Reports
            
            report.timeframe = reportItem.timeFrame.rawValue
            report.scoreoption = reportItem.scoreType.rawValue
            report.myscore = reportItem.myScore.description
            report.poolaveragescore = reportItem.poolAverage.description
            report.distancetravelled = reportData.distanceTravelled
            report.totalcontractpoints = reportData.totalPoints
            report.totaltrip = reportData.totalTrips
        }
        
        self.privateManagedObjectContext.performBlockAndWait { () -> Void in
            do{
                try self.privateManagedObjectContext.save()
                //add check
                print("saved")
                completionHandler(status: true)
            }catch{
                completionHandler(status: false)
                fatalError("not iserted")
                
            }
        }
        
        /*
        do{
            try self.managedObjectContext.save()
            completionHandler(status: true)
        }
        catch{
            completionHandler(status: false)
        }*/
    }
    
    func fetchReportData(completionHandler:(success : Bool, error: NSError?, result: Report?) -> Void) -> Void{
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Reports")
        
        // Initialize Asynchronous Fetch Request
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (asynchronousFetchResult) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let reports = self.reportFetchResult(asynchronousFetchResult)
                
                if reports != nil {
                    completionHandler(success: true, error: nil, result: reports!)
                }else{
                    completionHandler(success: false, error: NSError.init(domain: "", code: 0, userInfo: nil), result: nil)
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

    func reportFetchResult(asynchronousFetchResult: NSAsynchronousFetchResult) -> Report? {
        
        if let results = asynchronousFetchResult.finalResult {
            var reportDetails = [ReportDetails]()
            
            for reportDetailObj in results {
                
                let reportDetailManagedObj = reportDetailObj as! Reports
                if let timeFrame = reportDetailManagedObj.timeframe?.integerValue, scoreType = reportDetailManagedObj.scoreoption?.integerValue, myScore = reportDetailManagedObj.myscore, poolAverage = reportDetailManagedObj.poolaveragescore {
                    
                    let reportDetail = ReportDetails(timeFrame: ReportDetails.TimeFrameType(rawValue: timeFrame)!, scoreType: ReportDetails.ScoreType(rawValue: scoreType)!, myScore: Int(myScore)!, poolAverage: Int(poolAverage)!)
                    reportDetails.append(reportDetail)
                }
            }
            
            if let reportManagedObj = results.first as? Reports {
                if let totalPoints = reportManagedObj.totalcontractpoints, distanceTravelled = reportManagedObj.distancetravelled, totalTrips = reportManagedObj.totaltrip {
                    
                    let report = Report(reportDetail: reportDetails, totalPoints: totalPoints.integerValue, distanceTravelled: distanceTravelled.integerValue, totalTrips: totalTrips.integerValue)
                    return report
                }
            }
        }
        return nil
    }

    //MARK: - Delete methods
    
    func removeData(entity: String) {
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
                    fatalError("not removed")
                }
            }
        }catch{
            fatalError("not removed")
        }
    }
   
}
