//
//  CoreLocation.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 25/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

class CoreLocation: NSObject,CLLocationManagerDelegate {
  
  var autoStartState              : Bool?
  var brakAlert                   : Bool?
  var acclAlert                   : Bool?
  var hasBeenRun                  : Bool?
  var locationmanager             : CLLocationManager
  var locSpeedArray               : [String]?
  var motiontype                  : String?
  var speedArray                  : [String]?
  var fltDistanceTravelled        : Double
  var distance                    : Double?
  var creationTime                : Double?
  var eventtypes                  : Events.EventType?
  var startdate                   : NSDate?
  var enddate                     : NSDate?
  var timezoneid                  : String?
  var datausagecalc               : DataUsageCalculation?
  var currentCountForDataUsageCalc: Int?
  var dataUsageArray              : [AnyObject]?
  var finalDataUsageArray         : [AnyObject]?
  var defaultsTripID              : String = ""
  
  var oldlocspeed                 : CLLocationSpeed = 0
  var oldLocation                 : CLLocation!
  var isVechileMoving             : Bool = false
  
  var teststr :String?
  
  override init() {
    locationmanager =  CLLocationManager()
    fltDistanceTravelled = 0
  }
  
  func initLocationManager() {
    dataUsageArray = [AnyObject]()
    finalDataUsageArray = [AnyObject]()
    currentCountForDataUsageCalc = 0
    
    
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "getdetails",
      name: "tipended",
      object: nil)
    
    self.locationmanager.delegate = self
    self.locationmanager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationmanager.activityType = CLActivityType.AutomotiveNavigation
    if #available(iOS 9.0, *) {
      self.locationmanager.allowsBackgroundLocationUpdates = true
    } else {
      // Fallback on earlier versions
      
    }
    self.locationmanager.requestAlwaysAuthorization()
    self.locationmanager.requestWhenInUseAuthorization()
    
    locSpeedArray = [String]()
    speedArray    = [String]()
    eventtypes    = Events.EventType.NONE
    startLocationupdate()
  }
  
  func startLocationupdate() {
    self.locationmanager.startUpdatingLocation()
  }
  
  func stopLocationupdate() {
    self.locationmanager.stopUpdatingLocation()
  }
  
  func speedTravelledFromLocation(newLocation:CLLocation , oldLocation:CLLocation) -> CLLocationSpeed{
    let timeElapsed:NSTimeInterval!  = newLocation.timestamp.timeIntervalSinceDate(oldLocation.timestamp)
    let distance:Double = newLocation.distanceFromLocation(oldLocation)
    let tempspeed:Double = distance / timeElapsed
    return tempspeed
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    print("err \(error)")
  }
  
  func createTripConfigDatas(tripid:String){
    
    let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var conmodel:ConfigurationModel = ConfigurationModel()
    conmodel.tripid = tripid
    conmodel.thresholds_brake           = NSNumber(double: defaults.doubleForKey(StringConstants.Thresholds_Brake))
    conmodel.thresholds_acceleration    = NSNumber(double: defaults.doubleForKey(StringConstants.Thresholds_Acceleration))
    conmodel.thresholds_autotrip        = NSNumber(double: defaults.doubleForKey(StringConstants.Thresholds_Autotrip))
    conmodel.thresholds_minimumspeed    = NSNumber(double: defaults.doubleForKey(StringConstants.Thresholds_Minimumspeed))
    conmodel.weightage_braking          = NSNumber(double: defaults.doubleForKey(StringConstants.Weightage_Braking))
    conmodel.weightage_acceleration     = NSNumber(double: defaults.doubleForKey(StringConstants.Weightage_Acceleration))
    conmodel.weightage_speed            = NSNumber(double: defaults.doubleForKey(StringConstants.Weightage_Speed))
    conmodel.weightage_severevoilation  = NSNumber(double: defaults.doubleForKey(StringConstants.Weightage_Severevoilation))
    conmodel.ecoweightage_braking       = NSNumber(double: defaults.doubleForKey(StringConstants.Ecoweightage_Braking))
    conmodel.ecoweightage_acceleration  = NSNumber(double: defaults.doubleForKey(StringConstants.Ecoweightage_Acceleration))
    FacadeLayer.sharedinstance.dbactions.saveConfiguration(conmodel)
    
    //Insert Master Trip Details
    var tripmodel:TripModel = TripModel()
    tripmodel.tripid          = tripid
    tripmodel.userid          = defaults.valueForKey(StringConstants.USER_ID) as? String
    tripmodel.tokenid         = defaults.valueForKey(StringConstants.TOKEN_ID) as? String
    tripmodel.channelid       = StringConstants.CHANNEL_ID
    tripmodel.channelversion  = UIDevice.currentDevice().systemVersion
    
    FacadeLayer.sharedinstance.dbactions.saveTripMaster(tripmodel)
    
    FacadeLayer.sharedinstance.configmodel = FacadeLayer.sharedinstance.dbactions.getConfiguration(tripid)
    
  }
  

  var autostartstate:Bool = false
  
  func generateTipID(){
    let defaults = NSUserDefaults.standardUserDefaults()
    let tokenid = String(defaults.valueForKey(StringConstants.TOKEN_ID))
    var defaultstripcount = defaults.integerForKey("autoincr_tripid")
    
    defaultsTripID = "\(tokenid) + \(defaultstripcount)"
    
    defaultstripcount = defaultstripcount + 1
    defaults.setInteger(defaultstripcount, forKey: "autoincr_tripid")
  }
  
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    let newLocation     : CLLocation! = locations.last
    var iseventval = 0
    let coord = newLocation.coordinate
    var accele:String = ""
    
    if let oldLocation = oldLocation{
      
    }else
    {
      oldLocation = newLocation
    }
    
    var locspeed        : CLLocationSpeed     = 0
    var tripmeasurement : TripMeasurements?
    let latitude        : Double              = coord.latitude
    let longitude       : Double              = coord.longitude
    var isvalidtrip     : Bool                = false
    var eventval        : Double              = 0.0
    var acceleration    : Double              = 0.0
    var currentdistance : Double              = 0
    var brakingvalue    : Double              = 0.0
    var braking         : String              = String(format:"%.1f",0.0) as String
    var defaults        : NSUserDefaults      = NSUserDefaults.standardUserDefaults()
    
    
    if  let oldLoc = oldLocation {
      tripmeasurement = TripMeasurements(oldlocation: oldLoc,
        newlocation: newLocation,
        oldlocspeed: oldlocspeed)
      if  let tripmeasurement = tripmeasurement {
//        locspeed = speedTravelledFromLocation(newLocation, oldLocation: oldLocation)
//        tripmeasurement.currentlocspeed = locspeed
        
        locspeed = tripmeasurement.currentlocspeed
//        print("***locspeed: \(locspeed)")
        
        //      locspeed = newLocation.speed
      }else{
        locspeed = 0
      }
      
      // Get currnt and previous Data used by teen
      datausagecalc?.getCurrentAndPreviousDataUsed()
      
      locSpeedArray!.append(String(format:"%.2f", locspeed * 3.6))
      
      var newlocspeed:Double = 0.0
      var newlocsum:Double = 0.0
      
      for i in 0..<locSpeedArray!.count{
        newlocsum += Double(locSpeedArray![i])!
      }
      
      if(locSpeedArray!.count == 5){
        newlocspeed = newlocsum / Double(locSpeedArray!.count)
        locSpeedArray!.removeAll();
      }
      
      // Vechile is Not Moving
      if(locspeed * 3.6 <= defaults.doubleForKey(StringConstants.Thresholds_Minimumspeed) || newLocation.coordinate.latitude == oldLocation.coordinate.latitude && newLocation.coordinate.longitude == oldLocation.coordinate.longitude){
        //motion type not moving
        self.motiontype = StringConstants.MOTIONTYPE_NOTMOVING
        
      }
      
      //Vechile is moving in Minimum speed
      if(locspeed * 3.6 > defaults.doubleForKey(StringConstants.Thresholds_Minimumspeed) || newLocation.coordinate.latitude == oldLocation.coordinate.latitude && newLocation.coordinate.longitude == oldLocation.coordinate.longitude && isVechileMoving == false){
        
        isVechileMoving = true
        startdate = newLocation.timestamp
        
        //Data Usage
        datausagecalc?.finalDataUsageArray.removeAll(keepCapacity: true)
        
        // create tripid and save configurations
        generateTipID()
        createTripConfigDatas(defaultsTripID)
        
      }
      
      print(newlocspeed)
      if isVechileMoving {
        
        if(newlocspeed  >=  defaults.doubleForKey(StringConstants.Thresholds_Autotrip)) {
          // motion ype automotive
          self.motiontype = StringConstants.MOTIONTYPE_AUTOMOTIVE
          isvalidtrip = true
          if (hasBeenRun == false) // hasBeenRun is a boolean intance variable
          {
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "notMoving", object: nil)
            hasBeenRun = true;
          }
        }
        
        //Auto trip start
        
        if(self.motiontype == StringConstants.MOTIONTYPE_AUTOMOTIVE && autostartstate == false) {
          
          autostartstate = true
          if FacadeLayer.sharedinstance.isMannualTrip == false{
            TripNotify.init(title: "Do you want to start the trip",
              UUID: NSUUID().UUIDString,
              schedule: NSDate(),
              tripstatus: true)
            print("start trip notification fired")
          }
          
        }
        
        //trip stop
        if(self.motiontype == StringConstants.MOTIONTYPE_NOTMOVING){
          // stop the trip
          if (hasBeenRun == true) // hasBeenRun is a boolean instance variable
          {
            hasBeenRun = false
            autostartstate = false
            enddate = newLocation.timestamp
            self.performSelector("notMoving", withObject: nil, afterDelay: 10) //900 - 15 mins | 30 - .5
          }
          
        }
        
        
        if let tripmeasurement = tripmeasurement {
          
          //Calculate time interval based on location change
          let timeElapsed:NSTimeInterval = tripmeasurement.getTimeElapsed()
          
          //Speed Difference
          var speedDifference:Double = tripmeasurement.speedDifference()
          
          //Calculate Braking
          
          speedArray!.append(String(format: "%.2f", locspeed * 3.6))
          if(speedArray!.count == 10){
            speedArray!.removeAll()
          }
          brakingvalue = fabs(speedDifference)
          let isBraking = tripmeasurement.brakingCalculation(speedArray!, speedDifference: speedDifference, thresholdBrake: defaults.doubleForKey(StringConstants.Thresholds_Brake))
          if (isBraking) {
            eventtypes = Events.EventType.BRAKING
            eventval = brakingvalue
            braking = String(format: "%f", brakingvalue)
            iseventval = 1
          }else{
            brakingvalue = 0
            eventval = 0
          }
          
          // Calculate Acceleration
          
          accele = String(format: "%.1f", 0.0)
          
          acceleration = Double(speedDifference) / Double(tripmeasurement.getTimeElapsed())
          let isAcceleration = tripmeasurement.accelerationCalculation(speedArray!, speedDifference: speedDifference, thresholdAcceleration: defaults.doubleForKey(StringConstants.Thresholds_Acceleration))
          
          if(isAcceleration){
            eventtypes = Events.EventType.ACCELERATION
            eventval = acceleration
            accele = String(format: "%f", acceleration)
            iseventval = 1
          }else{
            acceleration = 0
            eventval = 0
          }
          
          
          
          //Calculate distance
          if let  oldLocation = oldLocation , newLocation = newLocation{
            currentdistance = tripmeasurement.getDistanceInKm(newLocation, oldLocation: oldLocation)
            fltDistanceTravelled += currentdistance
            distance = fltDistanceTravelled
          }else
          {
            distance = 0.0;
          }
          
          let str = String(format:"\n ********** \n latitude:\(latitude) \n longitude: \(longitude) \n time: \(newLocation.timestamp) \n calcsped: \(locspeed) \n speed: \(newLocation.speed) \n Acceleration: \(acceleration) \n Braking: \(brakingvalue) \n Motiontype: \(self.motiontype) \n C_Distance: \(currentdistance) \n cumm_D: \(fltDistanceTravelled)" )
          
          let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
          var getstr = defaults.objectForKey("motionlat") as! String
          getstr = getstr + str
          defaults.setObject(getstr, forKey: "motionlat")
          teststr = getstr as String
          
          //        NSNotificationCenter.defaultCenter().postNotificationName("tracktestinglocation", object: nil)
            
//          let dataUsagePerMin = datausagecalc?.getDataUsagePerMin()
          var dataUsagePerMin = datausagecalc?.getDataUsagePerMin()
            
          
          
          let tseries:TimeSeriesModel = TimeSeriesModel.init(tripid:defaultsTripID, ctime: newLocation.timestamp,
            lat: latitude,
            longt: longitude,
            speedval: locspeed,
            datausage: 0,
            iseventval: NSNumber(integer: iseventval),
            evetype: NSNumber(integer: eventtypes!.rawValue),
            eveval: NSNumber(double: eventval),
            distance: distance!,
            isvalidtrip:isvalidtrip)
//          print("timeseries: \(tseries)")
          
          FacadeLayer.sharedinstance.dbactions.saveTimeSeries(tseries)
          
        }
      }
      
      oldLocation = newLocation
      oldlocspeed = locspeed
      
    }
    
  }
  
  func notMoving(){
    //Interactive notifications
    TripNotify(title: "Do you want to stop the trip",
      UUID: NSUUID().UUIDString,
      schedule: NSDate(),
      tripstatus: false)
    print("stop trip notification fired")
    
    self.performSelector("deleteTripDatas", withObject: nil, afterDelay: 5) //900 - 15 mins | 30 - .5
  }
  
  func deleteTripDatas(){
    print("delete trip datas")
    
    
  }
  
  func getdetails(){
    
//    isVechileMoving = false // re_setting the vechile to not moving stage
    
    // to cancel the timer while not tapping the notification
    NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "deleteTripDatas", object: nil)
    
    FacadeLayer.sharedinstance.isMannualTrip = false
    
    var dataUsageFinalValue: Int = 0
    if let data  = datausagecalc?.reteriveTotalDatasConsumed() {
      dataUsageFinalValue = data
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let stringval:String = String(format: "\(NSTimeZone.localTimeZone())")
    
    let summarymodal:SummaryModel = SummaryModel(datausage: NSNumber(integer: dataUsageFinalValue ?? 0),
      tripid: defaultsTripID,
      tripstarttime: startdate!,
      tripendtime: enddate!,
      timezone:stringval,
      timezoneid:"temp")
    
    FacadeLayer.sharedinstance.dbactions.saveTripSummary(summarymodal)
    
    // Convert to Json and send to Server
    FacadeLayer.sharedinstance.reteriveTripdetails(defaultsTripID)
    
  }
  
  /*
  var tempvar = -1
  func testing(latitude:Double,longitude:Double, newLocation:CLLocation){
    
    var eventval:Double = 0.0
    let defaultsTripID = NSUserDefaults.standardUserDefaults().valueForKey(StringConstants.TOKEN_ID)
    if(tempvar == -1){
      startdate = newLocation.timestamp
      distance = 10
      eventtypes =  Events.EventType.STARTTRIP
      //      TripNotify.init(title: "Do you want to start the trip",
      //        UUID: NSUUID().UUIDString,
      //        schedule: NSDate(),
      //        tripstatus: true)
      let tseries:TimeSeriesModel = TimeSeriesModel.init(tripid:"\(defaultsTripID)" + "1", ctime: newLocation.timestamp,
        lat: latitude,
        longt: longitude,
        speedval: newLocation.speed*3.6,
        datausage: 0,
        iseventval: NSNumber(integer: 0),
        evetype: NSNumber(integer: eventtypes!.rawValue),
        eveval: NSNumber(double: eventval),
        distance: distance!,
        isvalidtrip:1)
      
      FacadeLayer.sharedinstance.dbactions.saveTimeSeries(tseries)
    }
    if(tempvar == 0){
      distance = 20
      eventtypes =  Events.EventType.TIMESERIES
      eventval = 0
      let tseries:TimeSeriesModel = TimeSeriesModel.init(tripid:"\(defaultsTripID)" + "1",ctime: newLocation.timestamp,
        lat: latitude,
        longt: longitude,
        speedval: newLocation.speed*3.6,
        datausage: 0,
        iseventval: NSNumber(integer: 0),
        evetype: NSNumber(integer: eventtypes!.rawValue),
        eveval: NSNumber(double: eventval),
        distance: distance!,
        isvalidtrip:1)
      
      FacadeLayer.sharedinstance.dbactions.saveTimeSeries(tseries)
    }
    if(tempvar == 1){
      distance = 30
      eventval = 12
      eventtypes =  Events.EventType.ACCELERATION
      let tseries:TimeSeriesModel = TimeSeriesModel.init(tripid:"\(defaultsTripID)" + "1",ctime: newLocation.timestamp,
        lat: latitude,
        longt: longitude,
        speedval: newLocation.speed*3.6,
        datausage: 0,
        iseventval: NSNumber(integer: 1),
        evetype: NSNumber(integer: eventtypes!.rawValue),
        eveval: NSNumber(double: eventval),
        distance: distance!,
        isvalidtrip:1)
      
      FacadeLayer.sharedinstance.dbactions.saveTimeSeries(tseries)
    }
    else if(tempvar == 2){
      distance = 30
      eventval = 10
      eventtypes =  Events.EventType.ACCELERATION
      let tseries:TimeSeriesModel = TimeSeriesModel.init(tripid:"\(defaultsTripID)" + "1",ctime: newLocation.timestamp,
        lat: latitude,
        longt: longitude,
        speedval: newLocation.speed*3.6,
        datausage: 0,
        iseventval: NSNumber(integer: 1),
        evetype: NSNumber(integer: eventtypes!.rawValue),
        eveval: NSNumber(double: eventval),
        distance: distance!,
        isvalidtrip:1)
      
      FacadeLayer.sharedinstance.dbactions.saveTimeSeries(tseries)
    }else if(tempvar == 3){
      distance = 40
      eventval = 15
      eventtypes =  Events.EventType.BRAKING
      let tseries:TimeSeriesModel = TimeSeriesModel.init(tripid:"\(defaultsTripID)" + "1",ctime: newLocation.timestamp,
        lat: latitude,
        longt: longitude,
        speedval: newLocation.speed*3.6,
        datausage: 0,
        iseventval: NSNumber(integer: 1),
        evetype: NSNumber(integer: eventtypes!.rawValue),
        eveval: NSNumber(double: eventval),
        distance: distance!,
        isvalidtrip:1)
      
      FacadeLayer.sharedinstance.dbactions.saveTimeSeries(tseries)
    }else if(tempvar == 10){
      eventval = 0
      //      tempvar = 0
      enddate = newLocation.timestamp
      eventtypes =  Events.EventType.TIMESERIES
      //      TripNotify.init(title: "Do you want to stop the trip",
      //        UUID: NSUUID().UUIDString,
      //        schedule: NSDate(),
      //        tripstatus: false)
    }
    tempvar++
  }

*/
  
  func locationManager(manager: CLLocationManager,
    didChangeAuthorizationStatus status: CLAuthorizationStatus) {
      var shouldIAllow = false
      var locationStatus = ""
      
      switch status {
      case CLAuthorizationStatus.Restricted:
        locationStatus = "Restricted Access to location"
      case CLAuthorizationStatus.Denied:
        locationStatus = "User denied access to location"
      case CLAuthorizationStatus.NotDetermined:
        locationStatus = "Status not determined"
      default:
        locationStatus = "Allowed to location Access"
        shouldIAllow = true
      }
      if (shouldIAllow == true) {
        NSLog("Location to Allowed")
        // Start location services
        
      } else {
        NSLog("Denied access: \(locationStatus)")
      }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    let updateheading:Double = newHeading.magneticHeading
    let value = updateheading
    var headingDirection = "";
    
    
    if(value >= 0 && value < 23)
    {
      headingDirection = "\(value) N"
    }
    else if((value >= 23) && (value < 68))
    {
      headingDirection = "\(value) NE"
    }
    else if(value >= 68 && value < 113)
    {
      headingDirection = "\(value) E"
    }
    else if(value >= 113 && value < 185)
    {
      headingDirection = "\(value) SE"
    }
    else if(value >= 185 && value < 203)
    {
      headingDirection = "\(value) S"
    }
    else if(value >= 203 && value < 249)
    {
      headingDirection = "\(value) SE"
    }
    else if(value >= 249 && value < 293)
    {
      headingDirection = "\(value) W"
    }
    else if(value >= 293 && value < 350)
    {
      headingDirection = "\(value) NW"
    }
    
    let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    defaults.setValue(headingDirection, forKey: "heading")
    
  }
  
  func startReadingLocation(){
    locationmanager.startUpdatingLocation()
    locationmanager.startUpdatingHeading()
  }
  
  
  
}















