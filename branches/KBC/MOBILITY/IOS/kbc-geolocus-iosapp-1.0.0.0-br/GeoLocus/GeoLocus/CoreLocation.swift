//
//  CoreLocation.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 25/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

class CoreLocation: NSObject,CLLocationManagerDelegate {
  
  var autoStartState        :Bool?
  var brakAlert             :Bool?
  var acclAlert             :Bool?
  var hasBeenRun            :Bool?
  var locationmanager       :CLLocationManager
  var locSpeedArray         :[String]?
  var motiontype            :String?
  var speedArray            :[String]?
  var fltDistanceTravelled  :Double
  var distance              :Double?
  var creationTime          :Double?
  var eventtypes            :Events.EventType?
  var configmodel           :ConfigurationModel?
  var startdate             :NSDate?
  var enddate               :NSDate?
  var timezoneid            :String?
  var datausagecalc         :DataUsageCalculation?
  //  var tripmeasurement       :TripMeasurements?
  
  var currentCountForDataUsageCalc :Int?
  var dataUsageArray        :[AnyObject]?
  var finalDataUsageArray   :[AnyObject]?
  
  var oldlocspeed           :CLLocationSpeed = 0
  var oldLocation           :CLLocation!
  
  
  var teststr :String?
  
  override init() {
    locationmanager =  CLLocationManager()
    fltDistanceTravelled = 0
  }
  
  func initLocationManager() {
    dataUsageArray = [AnyObject]()
    finalDataUsageArray = [AnyObject]()
    currentCountForDataUsageCalc = 0
    
    configmodel = FacadeLayer.sharedinstance.configmodel
    
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "getdetails:",
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
    //    locationmanager.stopUpdatingLocation()
    //    if (error!) {
    print("err \(error)")
    //    }
  }
  
  var tempvar = -1
  var check = -1
  var autostartstate:Bool = false
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    let newLocation:CLLocation! = locations.last
    let coord = newLocation.coordinate
    var locspeed:CLLocationSpeed = 0
    var tripmeasurement:TripMeasurements?
    let latitude:Double = coord.latitude
    let longitude:Double = coord.longitude
    
    
    if  let oldLoc = oldLocation {
      tripmeasurement = TripMeasurements(oldlocation: oldLoc,
        newlocation: newLocation,
        oldlocspeed: oldlocspeed)
      if  let tripmeasurement = tripmeasurement {
        locspeed = tripmeasurement.currentlocspeed }
      //      locspeed = newLocation.speed
    }
    
    // Get currnt and previous Data used by teen
    datausagecalc?.getCurrentAndPreviousDataUsed()
    
    //Calculation for autotrip detection
    locSpeedArray!.append(String(format:"%.2f", locspeed * 3.6))
    
    var newlocspeed:Float = 0.0
    var newlocsum:Float = 0.0
    
    for i in 0..<locSpeedArray!.count{
      newlocsum += Float(locSpeedArray![i])!
    }
    
    if(locSpeedArray!.count == 5){
      newlocspeed = newlocsum / Float(locSpeedArray!.count)
      locSpeedArray!.removeAll();
    }
    
    if(locspeed * 3.6 <= 2.8 || newLocation.coordinate.latitude == oldLocation.coordinate.latitude && newLocation.coordinate.longitude == oldLocation.coordinate.longitude){
      //motion type not moving
      self.motiontype = StringConstants.MOTIONTYPE_NOTMOVING
      
    }
    
    if(newlocspeed >= configmodel?.thresholds_autotrip as! Float){
      // motion ype automotive
      self.motiontype = StringConstants.MOTIONTYPE_AUTOMOTIVE
      if ((hasBeenRun == nil)) // hasBeenRun is a boolean intance variable
      {
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "notMoving", object: nil)
        hasBeenRun = true;
      }
    }
    
    //Auto trip start
    
    if(self.motiontype == StringConstants.MOTIONTYPE_AUTOMOTIVE && autostartstate == false) {
      
      startdate = newLocation.timestamp
      autostartstate = true
      //      if check == -1 {
      TripNotify.init(title: "Do you want to start the trip",
        UUID: NSUUID().UUIDString,
        schedule: NSDate(),
        tripstatus: true)
      print("start trip notification fired")
      //Data Usage
      datausagecalc?.finalDataUsageArray.removeAll(keepCapacity: true)
      //        check++
      //      }
    }
    
    //Auto trip stop
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
    
    //********************End auto trip detection
    
    if let tripmeasurement = tripmeasurement {
      //Calculate time interval based on location change
      let timeElapsed:NSTimeInterval = tripmeasurement.getTimeElapsed()
      
      //Speed Difference
      var speedDifference:Double = tripmeasurement.speedDifference()
      
      var eventval:Double = 0.0
      var iseventval = 0
      
      //Calculate Braking
      var brakingvalue:Double = 0.0
      var braking:String = String(format:"%.1f",0.0) as String
      speedArray!.append(String(format: "%.2f", locspeed * 3.6))
      if(speedArray!.count == 10){
        speedArray!.removeAll()
      }
      brakingvalue = fabs(speedDifference)
      let isBraking = tripmeasurement.brakingCalculation(speedArray!, speedDifference: speedDifference, thresholdBrake: configmodel?.thresholds_brake as! Double)
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
      var acceleration:Double = 0.0
      var accele:String = ""
      accele = String(format: "%.1f", 0.0)
      
      acceleration = Double(speedDifference) / Double(tripmeasurement.getTimeElapsed())
      let isAcceleration = tripmeasurement.accelerationCalculation(speedArray!, speedDifference: speedDifference, thresholdAcceleration: configmodel?.thresholds_acceleration as! Double)
      
      if(isAcceleration){
        eventtypes = Events.EventType.ACCELERATION
        eventval = acceleration
        accele = String(format: "%f", acceleration)
        iseventval = 1
      }else{
        acceleration = 0
        eventval = 0
      }
      
      
      
      var currentdistance:Double = 0
      
      //Calculate distance
      if(newLocation != nil && oldLocation != nil){
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
      
      NSNotificationCenter.defaultCenter().postNotificationName("tracktestinglocation", object: nil)
      
      //Update to DB
      
      //    /*    Testing
      
      //    testing(latitude, longitude: longitude, newLocation: newLocation)
      
      //*/
      
      let defaultsTripID = String(NSUserDefaults.standardUserDefaults().valueForKey(StringConstants.TOKEN_ID))
      let tseries:TimeSeriesModel = TimeSeriesModel.init(tripid:"\(defaultsTripID)" + "1", ctime: newLocation.timestamp,
        lat: latitude,
        longt: longitude,
        speedval: locspeed,
        datausage: 0,
        iseventval: NSNumber(integer: iseventval),
        evetype: NSNumber(integer: eventtypes!.rawValue),
        eveval: NSNumber(double: eventval),
        distance: distance!)
      FacadeLayer.sharedinstance.dbactions.saveTimeSeries(tseries)
      
    }
    oldLocation = newLocation
    oldlocspeed = locspeed
    
    
  }
  
  func notMoving(){
    //Interactive notifications
    TripNotify(title: "Do you want to stop the trip",
      UUID: NSUUID().UUIDString,
      schedule: NSDate(),
      tripstatus: false)
    print("stop trip notification fired")
    getdetails()
    
  }
  
  func getdetails(){
    
    var dataUsageFinalValue: Int?
    if let data  = datausagecalc?.reteriveTotalDatasConsumed() {
      dataUsageFinalValue = data
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let stringval:String = String(format: "\(NSTimeZone.localTimeZone())")
    let defaultsTripID = String(defaults.valueForKey(StringConstants.TOKEN_ID))
    var aid = defaults.integerForKey("tripautoincr") + 1
    defaults.setInteger(aid, forKey: "tripautoincr")
    let defaultsTripAutoID = String(aid)
    
    
    let tokenid:String = defaultsTripID + defaultsTripAutoID // (defaults.integerForKey("tripautoincr") as! String" + defaults.valueForKey(StringConstants.TOKEN_ID) as! String
    let summarymodal:SummaryModel = SummaryModel(datausage: NSNumber(integer: dataUsageFinalValue ?? 0),
      tripid: tokenid,  // TokenID + Autoincrement
      tripstarttime: startdate!,
      tripendtime: enddate!,
      timezone:stringval,
      timezoneid:"temp")
    // print(SummaryModel)
    print("summarymodal: \(summarymodal.brakingscore), \(summarymodal.accelerationscore), \(summarymodal.ecoscore),\(summarymodal.totalduration)")
    
    FacadeLayer.sharedinstance.dbactions.saveTripSummary(summarymodal)
    
    //
    
    FacadeLayer.sharedinstance.reteriveTripdetails("")
    
  }
  
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
        distance: distance!)
      
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
        distance: distance!)
      
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
        distance: distance!)
      
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
        distance: distance!)
      
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
        distance: distance!)
      
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















