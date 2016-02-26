//
//  DataUsageCalculation.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 18/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

class DataUsageCalculation {
  let datausagedict: NSDictionary = Datausage.getDatas()
  var currentCountForDataUsageCalc :Int?
  var dataUsageArray        :[AnyObject]?
  var finalDataUsageArray   :[AnyObject] = [AnyObject]()
  var defaults              : NSUserDefaults      = NSUserDefaults.standardUserDefaults()
  var dataUsagePerMin : Int?
}


//  MARK: - Datausage Calculation
extension DataUsageCalculation{

  func getCurrentAndPreviousDataUsed(){
    if currentCountForDataUsageCalc == 2 {
      self.calculateDataUsage()
      currentCountForDataUsageCalc = 1
      dataUsageArray?.removeAtIndex(0)
    }
    
    if currentCountForDataUsageCalc < 2 {
      //        print("array :%@",dataUsageArray)
      dataUsageArray!.append(datausagedict)
      if let currentCount = currentCountForDataUsageCalc {
        currentCountForDataUsageCalc = currentCount + 1
      }
    }
  }
    
    func getDataUsagePerMin() -> Int {
        
        var dataSentWAN       :Int  = 0
        var dataReceivedWAN   :Int  = 0
        var dataSentWIFI      :Int  = 0
        var dataReceivedWIFI  :Int  = 0
        var dataSent          :Int  = 0
        var dataReceived      :Int  = 0
            for (key,value) in datausagedict as! NSDictionary{
                //        print(key)
                //        print(value)
                if key as! String == "WWANReceived"{
                    if let datareceived = datausagedict["WWANReceived"]{
                        dataReceivedWAN = (datareceived as! Int)
                    }
                }
                else if key as! String == "WWANSent"{
                    if let dataSent  = datausagedict["WWANSent"] {
                        dataSentWAN  = (dataSent as! Int)
                    }
                }
                else if key as! String == "WiFiReceived"{
                    if let datareceived  = datausagedict["WiFiReceived"] {
                        dataReceivedWIFI  = (datareceived as! Int)
                    }
                }
                else if key as! String == "WiFiSent"{
                    if let datasent  = datausagedict["WiFiSent"] {
                        dataSentWIFI  = (datasent as! Int)
                    }
                }
                
            }
            dataSent = dataSentWAN + dataSentWIFI
            dataReceived = dataReceivedWAN + dataReceivedWIFI
            return dataSent + dataReceived
        
    }

   func calculateDataUsage(){
//    print(dataUsageArray)
    var dataSentWAN       :Int  = 0
    var dataReceivedWAN   :Int  = 0
    var dataSentWIFI      :Int  = 0
    var dataReceivedWIFI  :Int  = 0
    var dataSent          :Int  = 0
    var dataReceived      :Int  = 0
    var tempDict                = [String: Int]()
    var tempArray               = [AnyObject]()
   
    for dataUsage in dataUsageArray! {
      
      for (key,value) in dataUsage as! NSDictionary{
//        print(key)
//        print(value)
        if key as! String == "WWANReceived"{
          if let datareceived = dataUsage["WWANReceived"]{
            dataReceivedWAN = (datareceived as! Int)
          }
        }
        else if key as! String == "WWANSent"{
          if let dataSent  = dataUsage["WWANSent"] {
            dataSentWAN  = (dataSent as! Int)
          }
        }
        else if key as! String == "WiFiReceived"{
          if let datareceived  = dataUsage["WiFiReceived"] {
            dataReceivedWIFI  = (datareceived as! Int)
          }
        }
        else if key as! String == "WiFiSent"{
          if let datasent  = dataUsage["WiFiSent"] {
            dataSentWIFI  = (datasent as! Int)
          }
        }
        
      }
      dataSent = dataSentWAN + dataSentWIFI
      dataReceived = dataReceivedWAN + dataReceivedWIFI
      tempDict["dataSent"] = dataSent
      tempDict["dataReceived"] = dataReceived
      tempArray.append(tempDict)
    }
    
    var previousDataUsageDict = tempArray[0] as! Dictionary<String,Int>
    var currentDataUsageDict  = tempArray[1] as! Dictionary<String,Int>
    
    var finalDataSent     = currentDataUsageDict["dataSent"]! - previousDataUsageDict["dataSent"]!
    var finalDataReceived = currentDataUsageDict["dataReceived"]! - previousDataUsageDict["dataReceived"]!
    self.dataUsagePerMin = finalDataSent + finalDataReceived
    finalDataUsageArray.append(finalDataSent+finalDataReceived)
//    print(finalDataUsageArray)
  }
  
  func reteriveTotalDatasConsumed() -> Int? {
    let tempDataUsageArray = finalDataUsageArray
    var dataUsageFinalValue : Int = 0
    if  tempDataUsageArray.count > 0 {
      if var thresholdValue = tempDataUsageArray.first {
        thresholdValue = ((thresholdValue as! Double) * (defaults.doubleForKey(StringConstants.Thresholds_DataUsage)))/100
        for var i = 1; i < tempDataUsageArray.count; i++ {
          let dataUsageDifference = (tempDataUsageArray[i] as! Int) - (thresholdValue as! Int)
          if dataUsageDifference > 0 {
            dataUsageFinalValue = dataUsageFinalValue + dataUsageDifference
          }
        }
      }
    }
    return dataUsageFinalValue
  }
}





