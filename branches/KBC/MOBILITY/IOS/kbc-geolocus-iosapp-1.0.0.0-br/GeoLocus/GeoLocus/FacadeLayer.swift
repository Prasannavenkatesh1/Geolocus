//
//  FacadeLayer.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit
import SwiftyJSON


struct WebServiceURL {
    var loginServiceURL: String?
    var registrationServiceURL: String?
    var termConditionsServiceURL:String?
    var needHelpServiceURL:String?
    var contractServiceURL:String?
    var dashboardServiceURL:String?
    var historyServiceURL: String?
    var badgeServiceURL: String?
    var overallServiceURL: String?
    var reportServiceURL:String?
    var tripServiceURL:String?
    var configurationServiceURL:String?
    var registerPNURL:String?
}

class FacadeLayer{

    static let sharedinstance = FacadeLayer()
    var dbactions:DatabaseActions
    var httpclient:Httpclient
    var corelocation:CoreLocation
    var webService: WebServiceURL
    var configmodel :ConfigurationModel{
      get{
        return dbactions.getConfiguration()
      }
    }
  
  
  init(){
    dbactions = DatabaseActions()
    httpclient = Httpclient()
    corelocation = CoreLocation()
    webService = WebServiceURL()
    self.getWebServiceURL()
    print(__FUNCTION__)
  }
    
    
    func getWebServiceURL(){
        
        if let path = NSBundle.mainBundle().pathForResource("WebServicesURL", ofType: "plist") {
            if let dataDict = NSDictionary(contentsOfFile: path){
                if let loginServiceURL = dataDict["BaseURL"] {
                    self.webService.loginServiceURL = loginServiceURL as? String
                }
                
                if let loginServiceURL = dataDict["LoginServiceURL"] {
                    self.webService.loginServiceURL = loginServiceURL as? String
                }
                
                if let registrationServiceURL = dataDict["RegistrationServiceURL"] {
                    self.webService.registrationServiceURL = registrationServiceURL as? String
                }
                
                if let termConditionsServiceURL = dataDict["TermConditionsServiceURL"] {
                    self.webService.termConditionsServiceURL = termConditionsServiceURL as? String
                }
                
                if let needHelpServiceURL = dataDict["NeedHelpServiceURL"] {
                    self.webService.needHelpServiceURL = needHelpServiceURL as? String
                }
                
                if let contractServiceURL = dataDict["ContractServiceURL"] {
                    self.webService.contractServiceURL = contractServiceURL as? String
                }
                
                if let dashboardServiceURL = dataDict["DashboardServiceURL"] {
                    self.webService.dashboardServiceURL = dashboardServiceURL as? String
                }
                
                if let historyServiceURL = dataDict["HistoryServiceURL"] {
                    self.webService.historyServiceURL = historyServiceURL as? String
                }
                
                if let badgeServiceURL = dataDict["BadgeServiceURL"] {
                    self.webService.badgeServiceURL = badgeServiceURL as? String
                }
                
                if let overallServiceURL = dataDict["OverallServiceURL"] {
                    self.webService.overallServiceURL = overallServiceURL as? String
                }
                
                if let reportServiceURL = dataDict["ReportServiceURL"] {
                    self.webService.reportServiceURL = reportServiceURL as? String
                }
                
                if let tripServiceURL = dataDict["TripServiceURL"] {
                    self.webService.tripServiceURL = tripServiceURL as? String
                }
                
                if let configurationServiceURL = dataDict["ConfigurationServiceURL"] {
                    self.webService.configurationServiceURL = configurationServiceURL as? String
                }
                
                if let registerPNURL = dataDict["RegisterPNURL"] {
                    self.webService.registerPNURL = registerPNURL as? String
                }
            }
        }
    }
    
    
    //MARK: - History service
    
    func requestRecentTripData(completionHandler:(status: Int, data: [History]?, error: NSError?) -> Void) -> Void{
        
        httpclient.requestRecentTripData ("url"){ (response, data, error) -> Void in
            
            if error == nil {
                
                var tripArray = [History]()
                
                if let result = data {
                    var jsonData = JSON(data: result)
                    
                    if let tripDetails = jsonData["with"]["content"]["tripdetails"].array {
                        //print(tripDetails)
                        
                        for tripObj in tripDetails {
                            let trip = tripObj.dictionaryValue
                            
                            var eventsObj = [Event]()
                            var speedZonesObj = [SpeedZone]()
                            
                            let tripScore = TripScore(speedScore: trip["speedscore"]!.doubleValue, ecoScore: trip["ecoscore"]!.doubleValue, attentionScore: nil)
                            
                            //Event array
                            
                            for (_,subJson):(String, JSON) in trip["event"]! {
                                let eventDict = subJson.dictionaryValue
                                let eventLocation = EventLocation(latitude: Double(eventDict["lat"]!.stringValue)!, longitude:Double(eventDict["long"]!.stringValue)!)
                                let event = Event(location: eventLocation, type:Helper.getEventType(eventDict["event_type"]!.string!) , message: eventDict["eventMessage"]!.string!)
                                
                                eventsObj.append(event)
                            }
                            
                            //Speedzone array
                            
                            for (index,subjson):(String, JSON) in trip["speed_zone"]! {
                                let zoneDict = subjson.dictionaryValue
                                let speedZone = SpeedZone(speedScore: Double(zoneDict["speedScore"]!.stringValue)!,
                                    maxSpeed: Double(zoneDict["max_speed"]!.stringValue)!,
                                    aboveSpeed: Double(zoneDict["Above_maxspeed"]!.stringValue)!,
                                    withinSpeed: Double(zoneDict["within_maxspeed"]!.stringValue)!,
                                    violationCount: Double(zoneDict["violation_count"]!.stringValue)!,
                                    speedBehaviour: Double(zoneDict["speedbehaviour"]!.stringValue)!,
                                    distanceTravelled: Double(zoneDict["distance_travelled"]!.stringValue)!)
                                
                                speedZonesObj.append(speedZone)
                            }
                            
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy"
                            

                            let tripDetail = History(tripid: trip["tripId"]!.string!, tripDate:dateFormatter.stringFromDate(NSDate(jsonDate: trip["date"]!.string!)!), distance: Double(trip["distance"]!.stringValue)!, tripPoints: Int(trip["trippoints"]!.stringValue)!, tripDuration: Double(trip["hours"]!.stringValue)!, dataUsageMessage: trip["dataUsageMsg"]!.string!, tripScore: tripScore, events: eventsObj, speedZones: speedZonesObj)
                            
                            tripArray.append(tripDetail)
                            
                        }
                         completionHandler(status: 1, data: tripArray, error: nil)
                    }else{
                        completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                    }
                }else{
                    completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                }
            }else{
                completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
            }
            
        }
        
    }

    
    //MARK: - History service
    
    func requestBadgesData(completionHandler:(status: Int, data: [Badge]?, error: NSError?) -> Void) -> Void{
        
        
        httpclient.requestBadgesData("URL") { (response, data, error) -> Void in
            if error == nil {
                var badges = [Badge]()
                
                if let result = data {
                    var jsonData = JSON(data: result)
                    
                    if let badgesList = jsonData["with"]["content"]["badges"].array {
                        print(badges)
                        for badgeObj in badgesList {
                            let badgeDict = badgeObj.dictionaryValue
                            
                            let badge = Badge(withIcon: " ", badgeTitle: badgeDict["badge_title"]!.stringValue, badgeDescription: badgeDict["badge_description"]!.stringValue, isEarned: Bool(badgeDict["isEarned"]!.intValue), orderIndex: badgeDict["order_index"]!.intValue, badgeType: Badge.BadgesType.Badge, additionalMsg: nil)
                            
                            badges.append(badge)
                        }
                        
                    }
                    
                    if let levelList = jsonData["with"]["content"]["levels"].array {
                        print(levelList)
                        for badgeObj in levelList {
                            let badgeDict = badgeObj.dictionaryValue
                            
                            let badge = Badge(withIcon: " ", badgeTitle: badgeDict["badge_title"]!.stringValue, badgeDescription: badgeDict["badge_description"]!.stringValue, isEarned: Bool(badgeDict["isEarned"]!.intValue), orderIndex: badgeDict["order_index"]!.intValue, badgeType: Badge.BadgesType.Level, additionalMsg: nil)
                            
                            badges.append(badge)
                        }
                        completionHandler(status: 1, data: badges, error: nil)
                    }else{
                        completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                    }
                }else{
                    //something went wrong
                    completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
                }
            }else {
                //something went wrong
                completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
            }
        }
        
    }

    
    func requestOverallScoreData(completionHandler:(status: Int, data: OverallScores?, error: NSError?) -> Void) -> Void{
        
        httpclient.requestOverallScoreData("") { (response, data, error) -> Void in
            if error == nil {
                if let result = data {
                    var jsonData = JSON(data: result)
                    
                    if let scores = jsonData["with"]["content"].dictionary {
                        
                        let overallScore = OverallScores(overallScore: Double(scores["overallScore"]!.stringValue)!, speedingScore: Double(scores["overallSpeedingScore"]!.stringValue)!, ecoScore: Double(scores["overallEcoScore"]!.stringValue)!, distanceTravelled: Double(scores["distanceTravelled"]!.stringValue)!, dataUsageMsg: scores["dataUsageMsg"]!.stringValue)
                        
                        completionHandler(status: 1, data: overallScore, error: nil)
                    }else{
                        //something went wrong
                        completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
                    }
                }else{
                    //something went wrong
                    completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
                }
            }else {
                //something went wrong
                completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
            }
            
        }
        
    }

}
