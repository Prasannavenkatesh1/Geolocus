//
//  CoreLocation.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 25/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

class CoreLocation: NSObject,CLLocationManagerDelegate {
  
  var autoStartState:Bool?
  var brakAlert:Bool?
  var acclAlert:Bool?
  var hasBeenRun:Bool?
  var locationmanager:CLLocationManager
  var locSpeedArray:[String]?
  var motiontype:String?
  var speedArray:[String]?
  var fltDistanceTravelled,distance:Double?
  var creationTime:Double?
  var eventtypes:Events.EventType?
  
  override init() {
    locationmanager =  CLLocationManager()
  }
  
  func initLocationManager() {
    print("location update")
   // self.locationmanager =
   //   print(self.locationmanager)
    
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "getdetails:",
      name: "tipended",
      object: nil)

    self.locationmanager.delegate = self
    self.locationmanager.desiredAccuracy = kCLLocationAccuracyBest
    if #available(iOS 9.0, *) {
        self.locationmanager.allowsBackgroundLocationUpdates = true
    } else {
        // Fallback on earlier versions
      
    }
    self.locationmanager.requestAlwaysAuthorization()
    self.locationmanager.requestWhenInUseAuthorization()

    locSpeedArray = [String]()
    speedArray = [String]()
    eventtypes = Events.EventType.NONE
    startLocationupdate()
  }
  
  func startLocationupdate() {
    self.locationmanager.startUpdatingLocation()
  }
  
  func stopLocationupdate() {
    self.locationmanager.stopUpdatingLocation()
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//    locationmanager.stopUpdatingLocation()
//    if (error!) {
      print("err \(error)")
//    }
  }
  
  var tempvar = -1
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    let newLocation:CLLocation! = locations.last;
    var oldLocation:CLLocation!
    if (locations.count > 1) {
      oldLocation = locations[locations.count - 2];
    }
  
    let coord = newLocation.coordinate
    
    let mainDelegate:AppDelegateSwift = UIApplication.sharedApplication().delegate as! AppDelegateSwift
    
    print(coord.latitude)
    print(coord.longitude)
    print(newLocation.speed)
    
    // Reteiving the datausage within this speed
//    let datausagedict:Dictionary = Datausage.getDatas()
//    print("datausagedict :%@",datausagedict)
    
    let latitude:Double = coord.latitude
    let longitude:Double = coord.longitude
//    let altitude:Double = newLocation.altitude
//    let accuracy:Double = newLocation.horizontalAccuracy
    
    //Calculation for autotrip detection
    locSpeedArray!.append(String(format:"%.2f", newLocation.speed * 3.6))
    
    var newlocspeed:Float = 0.0
    var newlocsum:Float = 0.0
    
    for i in 0..<locSpeedArray!.count{
      newlocsum += Float(locSpeedArray![i])!
    }
    print("newlocsum = \(newlocsum)")
    
    if(locSpeedArray!.count == 5){
      newlocspeed = newlocsum / Float(locSpeedArray!.count)
      locSpeedArray!.removeAll();
    }
    self.motiontype = ""
    
    if(newLocation.speed * 3.6 <= 2.8 || newLocation.coordinate.latitude == oldLocation.coordinate.latitude && newLocation.coordinate.longitude == oldLocation.coordinate.longitude){
      //motion type not moving
      self.motiontype = StringConstants.MOTIONTYPE_NOTMOVING
      
    }
    
    if(newlocspeed >= 7.0){
      // motion ype automotive
      self.motiontype = StringConstants.MOTIONTYPE_AUTOMOTIVE
      if ((hasBeenRun == nil)) // hasBeenRun is a boolean intance variable
      {
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "notMoving", object: nil)
        hasBeenRun = true;
      }
    }
    
    //Auto trip start
    if(self.motiontype == StringConstants.MOTIONTYPE_AUTOMOTIVE && self.autoStartState == false && mainDelegate.globalAutoTrip == true) {
        self.autoStartState = true
        mainDelegate.globalAutoTrip = false
      TripNotify.init(title: "Do you want to start the trip",
        UUID: NSUUID().UUIDString,
        schedule: NSDate(),
        tripstatus: true)

    }
    
    //Auto trip stop
    if(self.motiontype == StringConstants.MOTIONTYPE_NOTMOVING){
      // stop the trip
      if (hasBeenRun == true) // hasBeenRun is a boolean instance variable
      {
        hasBeenRun = false;
        self.performSelector("notMoving", withObject: nil, afterDelay: 900)
      }
    }
    
    //********************End auto trip detection
    
    //Calculate time interval based on location change
    var timeElapsed:NSTimeInterval!
    
    if(oldLocation != nil){
      timeElapsed = newLocation.timestamp.timeIntervalSinceDate(oldLocation.timestamp)
    }else
    {
      timeElapsed = 1.0
    }
    
    //Speed Difference
    var speedDifference:Double = 0.0
    if (oldLocation != nil) {
      //Speed difference
      let oldSpeed:Double = oldLocation.speed;
      let newSpeed:Double = newLocation.speed;
      speedDifference = (newSpeed - oldSpeed) * 3.6;
    }
    
    var eventval:Double = 0.0
    //Calculate Braking
    var brakingvalue:Double = 0.0
    var braking:String = String(format:"%.1f",0.0) as String
    speedArray!.append(String(format: "%.2f", newLocation.speed * 3.6))
    
    if(speedArray!.count == 10){
      speedArray!.removeAll()
    }
    
    brakingvalue = fabs(speedDifference)
    
    var avgSum:Float = 0.0
    if (speedDifference < 0)
    {
      
      var sumForBraking:Float = 0.0
      for i in 0..<speedArray!.count{
        sumForBraking += Float(speedArray![i])!
      }
      
      avgSum = Float(sumForBraking) / Float(speedArray!.count);
      
      if (brakingvalue > 7.0) {
//        if (avgSum > 30.0 && brakAlert == true) {
        
          eventtypes = Events.EventType.BRAKING
          eventval = brakingvalue
          braking = String(format: "%f", brakingvalue)
          brakAlert = false;
          
//        }
      }
    }else{
      brakAlert = true
    }
    
    // Calculate Acceleration
    var acceleration:Double = 0.0
    var accele:String = ""
    accele = String(format: "%.1f", 0.0)
    
    if(speedDifference > 0){
      acceleration = Double(speedDifference) / Double(timeElapsed)
      
      var avgSpeed:Float = 0.0;
      var sum:Float = 0;
      for i in 0..<speedArray!.count{
        sum += Float(speedArray![i])!
      }
      
      avgSpeed = Float(sum)/Float(speedArray!.count)
      print("average speed\(avgSpeed)")
      
      if (acceleration > 5.0) {
//        if (avgSpeed > 35.0 && acclAlert == true){
        
          eventtypes = Events.EventType.ACCELERATION
          eventval = acceleration
          accele = String(format: "%f", acceleration)
          acclAlert = false
          
//        }
      }
    }else
    {
      acclAlert = true
    }
    
    //Calculate Over Speed
    var speedValue = "0.0"
    
    if (newLocation.speed * 3.6 >=  Double(mainDelegate.speedLimit)) {
//      speedValue = [NSString stringWithFormat:@"%.1f", newLocation.speed*3.6f];
      speedValue = String(format: "%.1", newLocation.speed*3.6)
    }
  
    //Calculate distance
    if(newLocation != nil && oldLocation != nil){
      fltDistanceTravelled? += self.getDistanceInKm(newLocation, oldLocation: oldLocation)
      distance = fltDistanceTravelled
      
      var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
      defaults.setDouble(fltDistanceTravelled!, forKey: "distanceTravelled")
    }else
    {
      distance = 0.0;
    }
    
    //Data creation time
    creationTime = 1000.0 * NSDate().timeIntervalSince1970
    var dataCreatTime:String = String(format: "%f", creationTime!)
    
    //Update to DB
    var iseventval:Int = 0
    if(eventtypes ==  Events.EventType.ACCELERATION || eventtypes == Events.EventType.STARTTRIP || eventtypes == Events.EventType.BRAKING){
      iseventval = 1
    }else{
      iseventval = 0
    }

//    /*    Testing
    
    if(tempvar == -1){
      eventtypes =  Events.EventType.STARTTRIP
      TripNotify.init(title: "Do you want to start the trip",
        UUID: NSUUID().UUIDString,
        schedule: NSDate(),
        tripstatus: true)
    }
    if(tempvar == 0){
      eventtypes =  Events.EventType.TIMESERIES
    }

    if(tempvar == 1){
      eventval = 10
      eventtypes =  Events.EventType.ACCELERATION
    }else if(tempvar == 2){
      eventval = 15
      eventtypes =  Events.EventType.BRAKING
    }else if(tempvar == 3){
      eventval = 0
      tempvar = 0
      eventtypes =  Events.EventType.TIMESERIES
      TripNotify.init(title: "Do you want to stop the trip",
        UUID: NSUUID().UUIDString,
        schedule: NSDate(),
        tripstatus: false)
      
    }

    tempvar++

//*/
  
     let tseries:TimeSeriesModel = TimeSeriesModel.init(ctime: newLocation.timestamp,
      lat: latitude,
      longt: longitude,
      speedval: newLocation.speed*3.6,
      datausage: 0,
      iseventval: NSNumber(integer: iseventval),
      evetype: NSNumber(integer: eventtypes!.rawValue),
      eveval: NSNumber(double: eventval),
      distance: distance!)
    
      FacadeLayer.sharedinstance.dbactions.saveTimeSeries(tseries)
    
  }
  
  func notMoving(){
    //Interactive notifications
    TripNotify.init(title: "Do you want to stop the trip",
      UUID: NSUUID().UUIDString,
      schedule: NSDate(),
      tripstatus: false)
  }
  
  func getdetails(notification: NSNotification){
//    let alert: UIAlertView = UIAlertView()
//    alert.delegate = self
//    
//    alert.title = "aaa"
//    alert.message = "mmm"
//    alert.addButtonWithTitle("OK")
//    
//    alert.show()
    
    // calculation neds to be done
    
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
  
  
  func getDistanceInKm(newLocation:CLLocation,oldLocation:CLLocation) -> Double{
    var lat1,lon1,lat2,lon2: Double;
    
    lat1 = newLocation.coordinate.latitude  * M_PI / 180;
    lon1 = newLocation.coordinate.longitude * M_PI / 180;
    
    lat2 = oldLocation.coordinate.latitude  * M_PI / 180;
    lon2 = oldLocation.coordinate.longitude * M_PI / 180;
    
    let R:Double = 6371; // km
    let dLat:Double = lat2-lat1;
    let dLon:Double = lon2-lon1;
    
    let a:Double = sin(dLat/2) * sin(dLat/2) + cos(lat1) * cos(lat2) * sin(dLon/2) * sin(dLon/2);
    let c:Double = 2 * atan2(sqrt(a), sqrt(1-a));
    let d:Double = R * c;
    
    return d;
  }
  
  func getDistanceInMiles(newLocation:CLLocation,oldLocation:CLLocation) -> Double{
    var lat1,lon1,lat2,lon2: Double;
    lat1 = newLocation.coordinate.latitude  * M_PI / 180;
    lon1 = newLocation.coordinate.longitude * M_PI / 180;
    
    lat2 = oldLocation.coordinate.latitude  * M_PI / 180;
    lon2 = oldLocation.coordinate.longitude * M_PI / 180;
    
    let R:Double = 3963; // km
    let dLat:Double = lat2-lat1;
    let dLon:Double = lon2-lon1;
    
    let a:Double = sin(dLat/2) * sin(dLat/2) + cos(lat1) * cos(lat2) * sin(dLon/2) * sin(dLon/2);
    let c:Double = 2 * atan2(sqrt(a), sqrt(1-a));
    let d:Double = R * c;
    
    return d
  }
  
}

















