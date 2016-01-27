//
//  CoreLocation.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 25/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

class CoreLocation: NSObject,CLLocationManagerDelegate {
  var locationmanager:CLLocationManager!
  var locSpeedArray:[String]!
  var motiontype:String!
  var autoStartState:Bool!
  var speedArray:[String]!
  var brakAlert:Bool!
  
  func initLocationManager() {
    locationmanager = CLLocationManager()
    locationmanager?.delegate = self
    locationmanager.desiredAccuracy = kCLLocationAccuracyBest
    locationmanager.requestAlwaysAuthorization() // for use in background
    locationmanager.requestWhenInUseAuthorization() // for use in foreground
    locSpeedArray = [String]()
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//    locationmanager.stopUpdatingLocation()
//    if (error!) {
      print(error)
//    }
  }
  
  
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    let newLocation:CLLocation! = locations.last;
    var oldLocation:CLLocation!
    if (locations.count > 1) {
      oldLocation = locations[locations.count - 2];
    }
  
    let coord = newLocation.coordinate
    
    var mainDelegate:AppDelegateSwift = UIApplication.sharedApplication().delegate as! AppDelegateSwift
    
    print(coord.latitude)
    print(coord.longitude)
    
    // Reteiving the datausage within this speed
    let datausagedict:Dictionary = Datausage.getDatas()
    print("datausagedict :%@",datausagedict)
    
    let latitude:Double = coord.latitude
    let longitude:Double = coord.longitude
    let altitude:Double = newLocation.altitude
    let accuracy:Double = newLocation.horizontalAccuracy
    
    //Calculation for autotrip detection
    locSpeedArray.append(String(format:"%.2f", newLocation.speed * 3.6))
    
    var newlocspeed:Float = 0.0
    var newlocsum:Float = 0.0
    
    for i in 0..<locSpeedArray.count{
      newlocsum += Float(locSpeedArray[i])!
    }
    print("newlocsum = \(newlocsum)")
    
    if(locSpeedArray.count == 5){
      newlocspeed = newlocsum / Float(locSpeedArray.count)
      locSpeedArray.removeAll();
    }
    self.motiontype = ""
    
    if(newLocation.speed * 3.6 <= 2.8 || newLocation.coordinate.latitude == oldLocation.coordinate.latitude && newLocation.coordinate.longitude == oldLocation.coordinate.longitude){
      //motion type not moving
      self.motiontype = StringConstants.MOTIONTYPE_NOTMOVING
      
    }
    
    if(newlocspeed >= 7.0){
      // motion ype automotive
      self.motiontype = StringConstants.MOTIONTYPE_AUTOMOTIVE
    }
    
    //Auto trip start
    if(self.motiontype == StringConstants.MOTIONTYPE_AUTOMOTIVE && self.autoStartState == false && mainDelegate.globalAutoTrip == true) {
        self.autoStartState = true
        mainDelegate.globalAutoTrip = false
      
      // Post a notification for autostart
//      [[NSNotificationCenter defaultCenter] postNotificationName:@"autoStart" object:nil];
      
      //start the trip
//      autoStopController = [[GeoLocusViewController alloc] init];
//      [autoStopController enabledStateChanged];
      
    }
    
    //Auto trip stop
    if(self.motiontype == StringConstants.MOTIONTYPE_NOTMOVING){
      // stop the  trip
      //        [self performSelector:@selector(notMoving) withObject:nil afterDelay:600.0];
    }
    
    //********************End auto trip detection
    
    //Calculate time intrval based on location change
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
    
    //Calculate Braking
    var brakingvalue:Double = 0.0
    var braking:String = String(format:"%.1f",0.0) as String
    speedArray.append(String(format: "%.2f", newLocation.speed * 3.6))
    
    if(speedArray.count == 10){
      speedArray.removeAll()
    }
    
    brakingvalue = fabs(speedDifference)
    
    var avgSum:Float = 0.0
    if (speedDifference < 0)
    {
      var sumForBraking:Float = 0.0
      for i in 0..<speedArray.count{
        sumForBraking += Float(speedArray[i])!
      }
      
      avgSum = Float(sumForBraking) / Float(speedArray.count);
      
      if (brakingvalue > 7.0) {
        if (avgSum > 30.0 && brakAlert == true) {
          braking = String(format: "%f", brakingvalue)
          brakAlert = false;
        }
      }
    }else{
      brakAlert = true
    }
    

    // Calculate Acceleration
    var acceleration:Float = 0.0
    var accele:String = ""
    accele = String(format: "%.1f", 0.0)
    
    if(speedDifference > 0){
      acceleration = Float(speedDifference) / Float(timeElapsed)
      
      var avgSpeed:Float = 0.0;
      var sum:Float = 0;
      for i in 0..<speedArray.count{
        sum += Float(speedArray[i])!
      }
      
//      avgSpeed = sum / speedArray.count
      
    }
    
    
    
    
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
