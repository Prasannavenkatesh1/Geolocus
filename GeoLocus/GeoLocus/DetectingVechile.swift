//
//  DetectingVechile.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 04/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation
import CoreMotion

struct DetectingVechile {
  let activitymanager = CMMotionActivityManager()
  let motionmanager = CMMotionManager()
//  var str = ""
  
  
  func startDetectingVechile(){
    
    self.motionmanager.deviceMotionUpdateInterval = 0.01;
    self.motionmanager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (motion, err) -> Void in
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
        // do some task
        
        print("asasas")
      }
    }
//    
//    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
//      withHandler:^(CMDeviceMotion *motion, NSError *error){
//      dispatch_async(dispatch_get_main_queue(), ^{
//      NSLog(@"acceleration x %f", motion.userAcceleration.x);
//      NSLog(@"acceleration y %f", motion.userAcceleration.y);
//      NSLog(@"acceleration z %f", motion.userAcceleration.z);
//      }
//      );
//      }
//    ];
    
  }

  
/*
  func startDetectingVechile(){
    var str = ""
    if(CMMotionActivityManager.isActivityAvailable()){
      self.activitymanager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data) -> Void in
        let data1  = data! as CMMotionActivity
        //data1.timestamp + " -> " +
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          if(data1.stationary == true){
           str = "\(data1.startDate) -> Stationary / Sitting $ \(data1.confidence.rawValue)\n"
          } else if (data1.walking == true){
            str = "\(data1.startDate) -> Walking $ \(data1.confidence.rawValue) \n"
          } else if (data1.running == true){
            str = "\(data1.startDate) -> Running $ \(data1.confidence.rawValue) \n"
          } else if (data1.automotive == true){
            str = "\(data1.startDate) -> Vechile $ \(data1.confidence.rawValue) \n"
          }else if (data1.unknown == true){
            str = "\(data1.startDate) -> unknown $ \(data1.confidence.rawValue) \n"
          }
          
          print("test \(str)")
//          let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
//          var getstr = defaults.objectForKey("motion") as! String
//          getstr = getstr + str
//          defaults.setObject(getstr, forKey: "motion")
//          self.activityState!.text = getstr as String
        })
      })
    }
  }
  */
  func stopDetectingVechile(){
    self.activitymanager.stopActivityUpdates()
  }
}

