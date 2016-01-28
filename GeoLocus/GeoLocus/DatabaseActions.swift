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
      
      userInfo[NSUnderlyingErrorKey] = error as NSError
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
      
      var tb: UITableView = {
        let gg:UITableView = UITableView()
        gg.allowsMultipleSelection = true
         return gg
        
      }()
    } catch {
      let saveError = error as NSError
      print("\(saveError), \(saveError.userInfo)")
    }
  }
  
  func saveTimeSeries(timeseriesmodel:TimeSeriesModel){
    let timeseries = NSEntityDescription.insertNewObjectForEntityForName("Trip_timeseries",inManagedObjectContext: self.managedObjectContext) as! Trip_timeseries
    timeseries.isEvent = timeseriesmodel.isEvent
    timeseries.eventtype = timeseriesmodel.eventtype
    timeseries.eventvalue = timeseriesmodel.eventvalue
    timeseries.speed = timeseriesmodel.speed
    timeseries.latitude = timeseriesmodel.latitude
    timeseries.longitude = timeseriesmodel.longitude
    timeseries.datausage = timeseriesmodel.datausage
    timeseries.distance = "10"//timeseriesmodel.distance
    timeseries.currenttime = "342342342" //timeseriesmodel.currenttime
    
    do{
      try self.managedObjectContext.save()
      self.reterive()
    }catch{
      fatalError("not iserted")
    }
 }
  
  func reterive(){
    var locations  = [Trip_timeseries]()
    
    let fetchRequest = NSFetchRequest(entityName: "Trip_timeseries")
    do{
      try locations = self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Trip_timeseries]
      print(locations.count)
    }catch{
      fatalError("reterive error")
    }
    

//    if self.managedObjectContext.save(&e) {
//      print("insert error: \(e.localizedDescription)")
//      abort()
//    }
  }

  

}
