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
    var registerDeviceTokenServiceURL:String?
    var notificationCountServiceURL:String?
    var notificationListServiceURL:String?
    var notificationDetailsServiceURL:String?
    var deleteNotificationServiceURL:String?
    var competitionAcceptanceServiceURL:String?
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
   var notificationCount:String?
    
  init(){
    dbactions = DatabaseActions()
    httpclient = Httpclient()
    corelocation = CoreLocation()
    webService = WebServiceURL()
    self.getWebServiceURL()
    print(__FUNCTION__)
  }
    
    //MARK: - Webservice settings
    
    func getWebServiceURL(){
        
        if let path = NSBundle.mainBundle().pathForResource("WebServicesURL", ofType: "plist") {
            if let dataDict = NSDictionary(contentsOfFile: path){
                print(dataDict)
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
                
                if let registerDeviceTokenServiceURL = dataDict["RegisterDeviceTokenServiceURL"] {
                    self.webService.registerDeviceTokenServiceURL = registerDeviceTokenServiceURL as? String
                }
                
                if let notificationCountServiceURL = dataDict["NotificationCountsServiceURL"] {
                    self.webService.notificationCountServiceURL = notificationCountServiceURL as? String
                }
                
                if let notificationListServiceURL = dataDict["NotificationListServiceURL"] {
                    self.webService.notificationListServiceURL = notificationListServiceURL as? String
                }
                
                if let notificationDetailsServiceURL = dataDict["NotificationDetailsServiceURL"] {
                    self.webService.notificationDetailsServiceURL = notificationDetailsServiceURL as? String
                }
                
                if let deleteNotificationServiceURL = dataDict["DeleteNotificationServiceURL"] {
                    self.webService.deleteNotificationServiceURL = deleteNotificationServiceURL as? String
                }
                
                if let competitionAcceptanceServiceURL = dataDict["CompetitionAcceptanceServiceURL"] {
                    self.webService.competitionAcceptanceServiceURL = competitionAcceptanceServiceURL as? String
                }
            }
        }
    }
    
    
    //DB Method
    func removeData(entity: String) {
        self.dbactions.removeData(entity)
    }
    
    //MARK: Terms and Conditions Service
    
    func requestTermsAndConditionsData(completionHandler:(status : Int,data : NSData?, error : NSError?) -> Void) -> Void{

        httpclient.requestTermsAndConditionsData{ (response, data, error) -> Void in
            if(error == nil){
                completionHandler(status: 1, data: data, error: nil)
            }
            else{
                completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
            }
        }
    }
    
    //MARK: Login Service
    
    func requestLoginData(parameterString : String, completionHandler :(status : Int, data : NSData?, error : NSError?) -> Void) -> Void{
        
        httpclient.requestLoginData(parameterString) { (response,data,error) -> Void in
            if(error == nil){
                if let resultHeader = response{
                    let tokenID = resultHeader.allHeaderFields[StringConstants.SPRING_SECURITY_COOKIE]
                    if(tokenID != nil){
                        NSUserDefaults.standardUserDefaults().setValue(tokenID, forKey: StringConstants.TOKEN_ID)
                    }
                }
                
                if(data != nil && data?.length != 0){
                    if let result = data{
                        do{
                            if let jsonData = try! NSJSONSerialization.JSONObjectWithData(result, options: []) as? NSDictionary{
                                let userID = jsonData["userId"]?.stringValue
                                let userName = jsonData["userName"] as! String
                                
                                NSUserDefaults.standardUserDefaults().setValue(userID, forKey: StringConstants.USER_ID)
                                NSUserDefaults.standardUserDefaults().setValue(userName, forKey: StringConstants.USERNAME)
                                
                                completionHandler(status: 1, data: data, error: nil)
                            }
                            else{
                                //something went wrong
                                completionHandler(status: 0, data: nil, error:  NSError.init(domain: "\(error)", code: 0, userInfo: nil))
                            }
                        }
                        catch let error as NSError{
                            print("\(error)")
                        }
                    }
                    else{
                        //something went wrong
                        completionHandler(status: 0, data: nil, error:  NSError.init(domain: "\(error)", code: 0, userInfo: nil))
                    }
                }
                
                else{
                    //something went wrong
                    completionHandler(status: 0, data: nil, error:  NSError.init(domain: ErrorConstants.InvalidLogin, code: 0, userInfo: nil))
                }
            }
            else{
                //something went wrong
                completionHandler(status: 0, data: nil, error: NSError.init(domain: "\(error)", code: 0, userInfo: nil))
            }
        }
    }
    
    //MARK: Contract Service
    
    func requestContractData(completionHandler : (status : Int, data : ContractModel?, error: NSError?) -> Void) -> Void{
        
        if(StringConstants.appDataSynced){
            /* retrieve data from DB */
            dbactions.fetchContractData( {(status, response, error) -> Void in completionHandler(status: status, data: response, error: error)
            })
        }
        else{
            /* make service call and store data in to DB */
            httpclient.requestContractData{ (response, data, error) -> Void in
                if(error == nil){
                    if let result = data{
                        var jsonData = JSON(data: result)
                        
                        if (jsonData["statusCode"].intValue == 1) {
                            let contractData = ContractModel(parentUserName: (jsonData["parentUserName"].stringValue), attentionPoints: (jsonData["attentionPoints"].stringValue), speedPoints: (jsonData["speedPoints"].stringValue), ecoPoints: (jsonData["ecoPoints"].stringValue), bonusPoints: (jsonData["bonusPoints"].stringValue), totalContractPoints: (jsonData["totalContractPoints"].stringValue), contractPointsAchieved: (jsonData["contractPointsAchieved"].stringValue), rewardsDescription: (jsonData["rewardsDescription"].stringValue), contractAchievedDate: (jsonData["contractAchievedDate"].stringValue))
                            
                            self.dbactions.removeData("Contract")
                            
                            /* store data to DB */
                            self.dbactions.saveContractData(contractData, completionHandler: { (status) -> Void in
                                
                                if status{
                                    completionHandler(status: 1, data: contractData, error: nil)
                                }
                                else{
                                    completionHandler(status: 0, data: nil, error:  NSError.init(domain: "\(error)", code: 0, userInfo: nil))
                                }
                            })
                        }
                        else{
                            //something went wrong
                            completionHandler(status: 0, data: nil, error:  NSError.init(domain: "\(error)", code: 0, userInfo: nil))
                        }
                    }
                    else{
                        //something went wrong
                        completionHandler(status: 0, data: nil, error:  NSError.init(domain: "\(error)", code: 0, userInfo: nil))
                    }
                }
                else{
                    //something went wrong
                    completionHandler(status: 0, data: nil, error:  NSError.init(domain: "\(error)", code: 0, userInfo: nil))
                }
            }
        }
    }
    
    func saveContractData(contractData: ContractModel, completionHandler:(status: Bool)-> Void){
        self.dbactions.saveContractData(contractData, completionHandler: { (status) -> Void in
            if status {
                completionHandler(status: true)
            }else{
                completionHandler(status: false)
            }
        })
    }
    
    //MARK: - History service
    
    func fetchtripDetailData(completionHandler:(status: Int, data: [History]?, error: NSError?) -> Void) -> Void{
        
        self.dbactions.fetchtripDetailData({ (status, response, error) -> Void in
            completionHandler(status: status, data: response, error: error)
        })
        
        
        
        /*let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.boolForKey("History_Page_Synced") {
            //get from DB and reload table
            
            self.dbactions.fetchtripDetailData({ (status, response, error) -> Void in
                completionHandler(status: status, data: response, error: error)
            })
        }else{
            //call services...get data...parse
            //store data in DB
            //reload table
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
                                
                                let tripScore = TripScore(overallScore: trip["tripOverallScore"]!.doubleValue,speedScore: trip["speedscore"]!.doubleValue, ecoScore: trip["ecoscore"]!.doubleValue, attentionScore: nil)
                                
                                //Event array
                                
                                for (_,subJson):(String, JSON) in trip["event"]! {
                                    let eventDict = subJson.dictionaryValue
                                    let eventLocation = EventLocation(latitude: Double(eventDict["lat"]!.stringValue)!, longitude:Double(eventDict["long"]!.stringValue)!)
                                    let event = Event(location: eventLocation, type:Helper.getEventType(eventDict["event_type"]!.string!) , message: eventDict["eventMessage"]!.string!)
                                    
                                    eventsObj.append(event)
                                }
                                
                                //Speedzone array
                                
                                for (_,subjson):(String, JSON) in trip["speed_zone"]! {
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
                                
                                let tripDetail = History(tripid:  trip["tripId"]!.string!, tripDate: dateFormatter.stringFromDate(NSDate(jsonDate: trip["date"]!.string!)!), distance: Double(trip["distance"]!.stringValue)!, tripPoints: Int(trip["trippoints"]!.stringValue)!, tripDuration:  Double(trip["hours"]!.stringValue)!, speedingMessage: trip["speedingMessage"]!.string!, ecoMessage: trip["ecoMessage"]!.string!, dataUsageMessage: trip["dataUsageMsg"]!.string!, tripScore: tripScore, events: eventsObj, speedZones: speedZonesObj)
                                
                                tripArray.append(tripDetail)
                                
                            }
                            
                            //delete the data
                            //insert new data
                            //return
                            
                            self.dbactions.removeData("Trip_Detail")
                            self.dbactions.saveTripDetail(tripArray, completionhandler: { (status) -> Void in
                                if status {
                                    defaults.setBool(true, forKey: "History_Page_Synced")
                                    completionHandler(status: 1, data: tripArray, error: nil)
                                }else{
                                    defaults.setBool(false, forKey: "History_Page_Synced")
                                    completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                                }
                            })
                        }else{
                            defaults.setBool(false, forKey: "History_Page_Synced")
                            completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                        }
                    }else{
                        defaults.setBool(false, forKey: "History_Page_Synced")
                        completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                    }
                }else{
                    defaults.setBool(false, forKey: "History_Page_Synced")
                    completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                }
            }
        }*/
    }
    
    
    func requestRecentTripData(completionHandler:(status: Int, data: [History]?, error: NSError?) -> Void) -> Void {
        
        if let serviceURL = historyServiceURL() {
            httpclient.requestRecentTripData (serviceURL){ (response, data, error) -> Void in
                
                if error == nil {
                    
                    var tripArray = [History]()
                    
                    if let result = data {
                        var jsonData = JSON(data: result)
                        
                        if let tripDetails = jsonData["tripDetails"].array {
                            
                            for tripObj in tripDetails {
                                let trip = tripObj.dictionaryValue
                                
                                var eventsObj = [Event]()
                                var speedZonesObj = [SpeedZone]()
                                
                                let tripScore = TripScore(overallScore: trip["tripOverallScore"]!.doubleValue,speedScore: trip["speedScore"]!.doubleValue, ecoScore: trip["ecoScore"]!.doubleValue, attentionScore: nil)
                                
                                //Event array
                                for (_,subJson):(String, JSON) in trip["event"]! {
                                    let eventDict = subJson.dictionaryValue
                                    let eventLocation = EventLocation(latitude: Double(eventDict["latitude"]!.stringValue)!, longitude:Double(eventDict["longitude"]!.stringValue)!)
                                    let event = Event(location: eventLocation,
                                        type:Utility.getEventType(eventDict["eventType"]!.string!) ,
                                        message: eventDict["eventMessage"]?.string)
                                    
                                    eventsObj.append(event)
                                }
                                
                                //Speedzone array
                                for (_,subjson):(String, JSON) in trip["speedZone"]! {
                                    let zoneDict = subjson.dictionaryValue
                                    let speedZone = SpeedZone(speedScore: Double(zoneDict["speedingScore"]!.stringValue)!,
                                        maxSpeed: Double(zoneDict["maxSpeed"]!.stringValue)!,
                                        aboveSpeed: Double(zoneDict["aboveMaxspeed"]!.stringValue)!,
                                        withinSpeed: Double(zoneDict["withinMaxspeed"]!.stringValue)!,
                                        violationCount: Double(zoneDict["violationCount"]!.stringValue)!,
                                        speedBehaviour: Double(zoneDict["speedBehaviour"]!.stringValue)!,
                                        distanceTravelled: Double(zoneDict["distanceTravelled"]!.stringValue)!)
                                    
                                    speedZonesObj.append(speedZone)
                                }
                                
                                let durationArray = trip["totalDuration"]!.stringValue.componentsSeparatedByString(":")
                                
                                let dateFormatter = NSDateFormatter()
                                dateFormatter.dateFormat = "dd-MM-yyyy"
                                
                                let hour = Double(durationArray[0])
                                let minute = Double(durationArray[1])
                                let second = Double(durationArray[2])
                                let durationSec =  hour! * 3600 + minute! * 60 + second!
                                
                                let tripDetail = History(tripid:  trip["tripId"]!.stringValue,
                                    tripDate: dateFormatter.stringFromDate(NSDate(jsonDate: String(trip["date"]!))!),
                                    distance: Double(trip["distance"]!.stringValue)!,
                                    tripPoints: Int(trip["tripPoints"]!.stringValue)!,
                                    tripDuration:  durationSec,
                                    speedingMessage: trip["speedScoreMessage"]?.string,
                                    ecoMessage: trip["ecoScoreMessage"]!.string,
                                    dataUsageMessage: trip["dataUsageMsg"]?.string,
                                    tripScore: tripScore,
                                    events: eventsObj,
                                    speedZones: speedZonesObj)
                                
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
    }
    
    
    func saveTripDetail(tripDetails: [History], completionhandler:(status: Bool)-> Void) {
        
        //self.dbactions.removeData("Trip_Detail")
        self.dbactions.saveTripDetail(tripDetails, completionhandler: { (status) -> Void in
            if status {
                completionhandler(status: true)
            }else{
                completionhandler(status: false)
            }
        })
    }
    
    
    //MARK:- Reoport service

    func fetchInitialReportData(timeFrame timeFrame: ReportDetails.TimeFrameType, scoreType: ReportDetails.ScoreType, completionHandler:(success: Bool, error: NSError?, result: Report?) -> Void) -> Void {
        dbactions.fetchReportData({ (success, error, result) -> Void in
            if success {
                completionHandler(success: true, error: error, result: result)
            }
        })
    }
    
    func requestInitialReportData(timeFrame timeFrame: ReportDetails.TimeFrameType, scoreType: ReportDetails.ScoreType, completionHandler:(success: Bool, error: NSError?, result: Report?) -> Void) -> Void {
        httpclient.requestReportData(StringConstants.REPORT_SERVICE_URL + "userId=9&timeFrame=\(timeFrame)&scoreType=\(scoreType)", completionHandler: { (success, data) -> Void in
            if let result = data {
                
                var reportDetails = [ReportDetails]()
                
                let jsonData = JSON(data: result)
                print(jsonData)
                if jsonData["statusCode"] == 1 {
                    if let reportDetailArr = jsonData["reportDetails"].array {
                        
                        for reportDetailObj in reportDetailArr {
                            let reportDetailDict = reportDetailObj.dictionaryValue
                            
                            let reportDetail = ReportDetails(timeFrame: ReportDetails.TimeFrameType.monthly, scoreType: ReportDetails.ScoreType.speed, myScore: (reportDetailDict["score"]?.intValue)!, poolAverage: (reportDetailDict["poolAverage"]?.intValue)!)
                            reportDetails.append(reportDetail)
                        }
                    }
                    if let overallScore = jsonData["overallscore"].dictionary {
                        let report = Report(reportDetail: reportDetails, totalPoints: (overallScore["totalPoints"]?.intValue)!, distanceTravelled: (overallScore["distanceTravelled"]?.intValue)!, totalTrips: (overallScore["totalTrips"]?.intValue)!)
                        completionHandler(success: true, error: nil, result: report)
                    }
                }
            } else {
                completionHandler(success: false, error: NSError(domain: "", code: 0, userInfo: nil), result: nil)
            }
        })
    }
    
    func saveInitialReportData(reportData : Report, completionHandler :(status : Bool) -> Void) {
        self.dbactions.removeData("Reports")
        self.dbactions.saveReportData(reportData, completionHandler: { (status) -> Void in
            if status {
                completionHandler(status: true)
            } else {
                completionHandler(status: false)
            }
        })
    }
    
    func fetchReportData(timeFrame timeFrame: ReportDetails.TimeFrameType, scoreType: ReportDetails.ScoreType, completionHandler:(success: Bool, error: NSError?, result: Report?) -> Void) -> Void{
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey(StringConstants.REPORT_SYNCHRONISATION) {
            dbactions.fetchReportData({ (success, error, result) -> Void in
                if success {
                    completionHandler(success: true, error: error, result: result)
                }
            })
        }else{
            httpclient.requestReportData(StringConstants.REPORT_SERVICE_URL + "userId=9&timeFrame=\(timeFrame)&scoreType=\(scoreType)", completionHandler: { (success, data) -> Void in
                if let result = data {
                    
                    var reportDetails = [ReportDetails]()
                    
                    let jsonData = JSON(data: result)
                    print(jsonData)
                    if jsonData["statusCode"] == 1 {
                        if let reportDetailArr = jsonData["reportDetails"].array {
                            
                            for reportDetailObj in reportDetailArr {
                                let reportDetailDict = reportDetailObj.dictionaryValue
                                
                                let reportDetail = ReportDetails(timeFrame: ReportDetails.TimeFrameType.monthly, scoreType: ReportDetails.ScoreType.speed, myScore: (reportDetailDict["score"]?.intValue)!, poolAverage: (reportDetailDict["poolAverage"]?.intValue)!)
                                reportDetails.append(reportDetail)
                            }
                        }
                        if let overallScore = jsonData["overallscore"].dictionary {
                            let report = Report(reportDetail: reportDetails, totalPoints: (overallScore["totalPoints"]?.intValue)!, distanceTravelled: (overallScore["distanceTravelled"]?.intValue)!, totalTrips: (overallScore["totalTrips"]?.intValue)!)
                            
                            self.dbactions.removeData("Reports")
                            self.dbactions.saveReportData(report, completionHandler: { (status) -> Void in
                                if status {
                                    defaults.setBool(true, forKey: StringConstants.REPORT_SYNCHRONISATION)
                                    completionHandler(success: status, error: nil, result: report)
                                } else {
                                    defaults.setBool(false, forKey: StringConstants.REPORT_SYNCHRONISATION)
                                    completionHandler(success: false, error: NSError(domain: "", code: 0, userInfo: nil), result: nil)
                                }
                            })
                        }
                    }
                } else {
                    completionHandler(success: false, error: NSError(domain: "", code: 0, userInfo: nil), result: nil)
                }
            })
        }
    }

    //MARK: - Dashboard Service
    
    func requestDashboardData(completionHandler:(status: Int, data: DashboardModel?, error: NSError?) -> Void) -> Void{
        
        httpclient.requestDashboardData("URL") { (success, data) -> Void in
            if success == true {
                var dashboard : DashboardModel
                
                if let result = data {
                    var jsonData = JSON(data: result)
                    
                    if jsonData["statusCode"].intValue == 1{
                        print(jsonData)
                        
                        var score             : String?
                        var level             : String?
                        var nextLevelMessage  : String?
                        var distanceTravelled : String?
                        var totalPoints       : String?
                        var pointsAchieved    : String?
                        var scoreMessage      : String?
                        var tripStatus        : String?
                        
                        if let dashboardDictionary = jsonData["dashboard"].dictionary{
                            
                            distanceTravelled = dashboardDictionary["distanceTravelled"]?.stringValue
                            if let dashBoardScore = dashboardDictionary["score"]?.stringValue{
                                score = dashBoardScore
                            }
                            if let totalpoints = dashboardDictionary["totalPoints"]?.stringValue{
                                totalPoints = totalpoints
                            }
                            if let points = dashboardDictionary["pointsAchieved"]?.stringValue{
                                pointsAchieved = points
                            }
                            scoreMessage      = dashboardDictionary["scoreMessage"]?.stringValue
                            tripStatus        = dashboardDictionary["tripStatus"]?.stringValue
                            
                            if let badgeDictionary = dashboardDictionary["badge"]?.dictionaryValue{
                                level            = badgeDictionary["level"]?.stringValue
                                nextLevelMessage = badgeDictionary["nextLevelMessage"]?.stringValue
                            }
                            
                            dashboard = DashboardModel(score: score!, levelName: level!, levelMessage: nextLevelMessage!, distanceTravelled: distanceTravelled!, totalPoints:totalPoints!, pointsAchieved: pointsAchieved!, scoreMessage: scoreMessage!, tripStatus: tripStatus!)
                            
//                            self.dbactions.removeData("Dashboard")
//                            self.dbactions.saveDashboardData(dashboard, completionhandler: { (status) -> Void in
//                                if status{
//                                    completionHandler(status: 1, data: dashboard, error: nil)
//                                }else{
//                                    completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
//                                }
//                            })

                            completionHandler(status: 1, data: dashboard, error: nil)
                        }else{
                            //something went wrong
                            completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
                        }

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
    
    func saveDashBoardData(dashboardData:DashboardModel, completionhandler:(status: Bool)-> Void){
        
        self.dbactions.saveDashboardData(dashboardData, completionhandler: { (status) -> Void in
            if status {
                completionhandler(status: true)
            }else{
                completionhandler(status: false)
            }
        })
    }
    
    func fetchDashboardData(completionHandler:(status: Int, data: DashboardModel?, error: NSError?) -> Void) -> Void{
        
        dbactions.fetchDashboardData { (status, response, error) -> Void in
            completionHandler(status: status, data: response, error: error)
        }
    }
    

    
    
    //MARK: - Badge service
    
    func fetchBadgeData(completionHandler:(status: Int, data: [Badge]?, error: NSError?) -> Void) -> Void{
        
        dbactions.fetchBadgeData({ (status, data, error) -> Void in
            completionHandler(status: status, data: data, error: error)
        })
        
        
        /*let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.boolForKey("Badges_Page_Synced") {
           
            dbactions.fetchBadgeData({ (status, data, error) -> Void in
                completionHandler(status: status, data: data, error: error)
            })
            
        }else{
            httpclient.requestBadgesData(webService.badgeServiceURL!) { (response, data, error) -> Void in
                if error == nil {
                    var badges = [Badge]()
                    
                    if let result = data {
                        var jsonData = JSON(data: result)
                        
                        if jsonData["statusCode"].intValue == 1{
                            if let badgesList = jsonData["badges"].array {
                                print(badges)
                                for badgeObj in badgesList {
                                    let badgeDict = badgeObj.dictionaryValue
                                    
                                    let badge = Badge(withIcon: " ", badgeTitle: badgeDict["badge_title"]!.stringValue, badgeDescription: badgeDict["badge_description"]!.stringValue, isEarned: Bool(badgeDict["isEarned"]!.intValue), orderIndex: badgeDict["order_index"]!.intValue, badgeType: Badge.BadgesType.Badge, additionalMsg: nil)
                                    
                                    badges.append(badge)
                                }
                            }
                            
                            if let levelList = jsonData["levels"].array {
                                print(levelList)
                                for badgeObj in levelList {
                                    let badgeDict = badgeObj.dictionaryValue
                                    
                                    let badge = Badge(withIcon: " ", badgeTitle: badgeDict["badge_title"]!.stringValue, badgeDescription: badgeDict["badge_description"]!.stringValue, isEarned: Bool(badgeDict["isEarned"]!.intValue), orderIndex: badgeDict["order_index"]!.intValue, badgeType: Badge.BadgesType.Level, additionalMsg: nil)
                                    
                                    badges.append(badge)
                                }
                                
                                //delete
                                //save
                                //return
                                self.dbactions.removeData("Trip_Badge")
                                self.dbactions.saveBadge(badges, completionhandler: { (status) -> Void in
                                    if status{
                                        defaults.setBool(true, forKey: "Badges_Page_Synced")
                                        completionHandler(status: 1, data: badges, error: nil)
                                    }else{
                                        defaults.setBool(false, forKey: "Badges_Page_Synced")
                                        completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                                    }
                                })
                            }else{
                                defaults.setBool(false, forKey: "Badges_Page_Synced")
                                completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                            }
                        }else{
                            defaults.setBool(false, forKey: "Badges_Page_Synced")
                            //something went wrong
                            completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
                        }
                    }else{
                        defaults.setBool(false, forKey: "Badges_Page_Synced")
                        //something went wrong
                        completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
                    }
                }else {
                    defaults.setBool(false, forKey: "Badges_Page_Synced")
                    //something went wrong
                    completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                }
            }
        }*/
    }
    
    
    func requestBadgesData(completionHandler:(status: Int, data: [Badge]?, error: NSError?) -> Void) -> Void{
        
        if let serviceURL = badgeServiceURL() {
            httpclient.requestGETService(serviceURL, headers: headers(), completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    var badges = [Badge]()
                    
                    if let result = data {
                        var jsonData = JSON(data: result)
                        
                        if jsonData[BadgeKey.S_CODE].intValue == 1 {
                            if let badgesList = jsonData[BadgeKey.BADGES].array {
                                print(badges)
                                for badgeObj in badgesList {
                                    let badgeDict = badgeObj.dictionaryValue
                                    
                                    let badge = Badge(withIcon: " ",
                                        badgeTitle: badgeDict[BadgeKey.TITLE]!.stringValue,
                                        badgeDescription: badgeDict[BadgeKey.DESC]!.stringValue,
                                        isEarned: Bool(badgeDict[BadgeKey.EARNED]!.intValue),
                                        orderIndex: badgeDict[BadgeKey.INDEX]!.intValue,
                                        badgeType: Badge.BadgesType.Badge,
                                        additionalMsg: nil)
                                    
                                    badges.append(badge)
                                }
                            }
                            
                            if let levelList = jsonData[BadgeKey.LEVELS].array {
                                print(levelList)
                                for badgeObj in levelList {
                                    let badgeDict = badgeObj.dictionaryValue
                                    
                                    let badge = Badge(withIcon: " ",
                                        badgeTitle: badgeDict[BadgeKey.TITLE]!.stringValue,
                                        badgeDescription: badgeDict[BadgeKey.DESC]!.stringValue,
                                        isEarned: Bool(badgeDict[BadgeKey.EARNED]!.intValue),
                                        orderIndex: badgeDict[BadgeKey.INDEX]!.intValue,
                                        badgeType: Badge.BadgesType.Level,
                                        additionalMsg: nil)
                                    
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
                    }else{
                        //something went wrong
                        completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
                    }
                }else {
                    completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                }
            })
            
            
            /*
            httpclient.requestBadgesData(serviceURL) { (response, data, error) -> Void in
                
            }*/
        }
    }
    
    func saveBadge(badges:[Badge], completionhandler:(status: Bool)-> Void) {
        //delete...save...return
        //self.dbactions.removeData("Trip_Badge")
        self.dbactions.saveBadge(badges, completionhandler: { (status) -> Void in
            if status{
                completionhandler(status: true)
            }else{
                completionhandler(status: false)
            }
        })
    }
    
    
    //MARK: - Overall score service
    
    func fetchOverallScoreData(completionHandler:(status: Int, data: OverallScores?, error: NSError?) -> Void) -> Void{
        
        dbactions.fetchOverallScoreData({ (status, response, error) -> Void in
            completionHandler(status: status, data: response, error: error)
        })
        
        /*if StringConstants.appDataSynced {
            //get from DB and reload table
            dbactions.fetchOverallScoreData({ (status, response, error) -> Void in
                completionHandler(status: status, data: response, error: error)
            })
            
        }else{
            //call services...get data...parse
            //store data in DB
            //reload table
            
            httpclient.requestOverallScoreData("") { (response, data, error) -> Void in
                if error == nil {
                    if let result = data {
                        var jsonData = JSON(data: result)
                        
                        if let scores = jsonData["with"]["content"].dictionary {
                            
                            let overallScore = OverallScores(overallScore: Double(scores["overallScore"]!.stringValue)!, speedingScore: Double(scores["overallSpeedingScore"]!.stringValue)!, ecoScore: Double(scores["overallEcoScore"]!.stringValue)!, distanceTravelled: Double(scores["distanceTravelled"]!.stringValue)!, dataUsageMsg: scores["dataUsageMsg"]!.stringValue, overallmessage: scores["OverallScoremessage"]!.stringValue, speedingMessage: scores["OverallspeedingMessage"]!.stringValue, ecoMessage: scores["OverallecoMessage"]!.stringValue)
                            
                            self.dbactions.removeData("OverallScore")
                            //store to DB
                            self.dbactions.saveOverallScore(overallScore, completionhandler: { (status) -> Void in
                                if status {
                                    //return
                                    completionHandler(status: 1, data: overallScore, error: nil)
                                }else{
                                    //something went wrong
                                    completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
                                }
                            })
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
        }*/
    }
    
    func requestOverallScoreData(completionHandler:(status: Int, data: OverallScores?, error: NSError?) -> Void) -> Void{
        
        if let serviceURL = overallServiceURL() {
            httpclient.requestOverallScoreData(serviceURL) { (response, data, error) -> Void in
                if error == nil {
                    if let result = data {
                        let jsonData = JSON(data: result)
                        
                        if let scores = jsonData.dictionary {
                            
                            let overallScore = OverallScores(overallScore: Double(scores["totalScore"]!.intValue), speedingScore: Double(scores["speedingScore"]!.intValue), ecoScore: Double(scores["ecoScore"]!.intValue), distanceTravelled: Double(scores["distance"]!.intValue), dataUsageMsg: scores["dataUsagemessage"]!.stringValue, overallmessage: scores["totalScoreMessage"]!.stringValue, speedingMessage: scores["speedingScoreMessage"]!.stringValue, ecoMessage: scores["ecoScoreMessage"]!.stringValue)
                            
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
    
    
    func saveOverallScore(overallScore: OverallScores, completionhandler:(status: Bool)-> Void){
        //self.dbactions.removeData("OverallScore")
        self.dbactions.saveOverallScore(overallScore, completionhandler: { (status) -> Void in
            if status {
                completionhandler(status: true)
            }else{
                completionhandler(status: false)
            }
        })
    }
    
    //MARK: Notification Services
    func fetchNotificationCount(completionHandler:(status : Int,data : NSData?, error : NSError?) -> Void) -> Void{
        
        httpclient.requestNotificationCount(webService.notificationCountServiceURL!) { (response, data, error) -> Void in
            if error == nil {
                if let result = data {
                    var jsonData = JSON(data: result)
                    //self.notificationCount =  "22"

                    if jsonData["status"].intValue == 1{
                        
                        self.notificationCount =  jsonData["count"].string!
                        completionHandler(status: 1, data: data, error: NSError.init(domain: "", code: 0, userInfo: nil))


                        //
                    }else{
                        //defaults.setBool(false, forKey: "Badges_Page_Synced")
                        completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                    }
                }else{
                    //defaults.setBool(false, forKey: "Badges_Page_Synced")
                    //something went wrong
                    completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
                }
            }else{
                //defaults.setBool(false, forKey: "Badges_Page_Synced")
                //something went wrong
                completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
            }
        }
    }
    func postDeletedNotification(completionHandler:(status : Int,data : NSData?, error : NSError?) -> Void) -> Void{
        
        httpclient.postDeletedNotification(webService.deleteNotificationServiceURL!) { (response, data, error) -> Void in
            if error == nil {
                
                if let result = data {
                    var jsonData = JSON(data: result)
                    
                    if jsonData["status"].intValue == 1{
                        completionHandler(status: 1, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                        //
                    }else{
                        //defaults.setBool(false, forKey: "Badges_Page_Synced")
                        completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                    }
                }else{
                    //defaults.setBool(false, forKey: "Badges_Page_Synced")
                    //something went wrong
                    completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
                }
            }else{
                //defaults.setBool(false, forKey: "Badges_Page_Synced")
                //something went wrong
                completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
            }
        }
    }
    
    func postAcceptedNotification(completionHandler:(status : Int,data : NSData?, error : NSError?) -> Void) -> Void{
        
        httpclient.postAcceptedNotification(webService.competitionAcceptanceServiceURL!) { (response, data, error) -> Void in
            if error == nil {
                
                if let result = data {
                    var jsonData = JSON(data: result)
                    
                    if jsonData["status"].intValue == 1{
                        completionHandler(status: 1, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))

                        //
                    }else{
                        //defaults.setBool(false, forKey: "Badges_Page_Synced")
                        completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
                    }
                }else{
                    //defaults.setBool(false, forKey: "Badges_Page_Synced")
                    //something went wrong
                    completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
                }
            }else{
                //defaults.setBool(false, forKey: "Badges_Page_Synced")
                //something went wrong
                completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
            }
        }
    }

    func requestNotificationListData(completionHandler:(status: Int, data: NotificationListModel?, error: NSError?) -> Void) -> Void{
        
        httpclient.requestNotificationListData("") { (response, data, error) -> Void in
            if error == nil {
                if let result = data {
                    var jsonData = JSON(data: result)
                    
                    if let notificationListData = jsonData["with"]["content"].dictionary {
                        
                        let notificationList = NotificationListModel(title: (notificationListData["Title"]!.stringValue), date: (notificationListData["Date"]!.stringValue), day: (notificationListData["Day"]!.stringValue), notificationImage: (notificationListData["NotificationImage"]!.stringValue), message: (notificationListData["message"]!.stringValue), notificationID: Double(notificationListData["Notification ID"]!.stringValue)!, notificationStatus: (notificationListData["Status"]!.stringValue))
                        
                        completionHandler(status: 1, data: notificationList, error: nil)
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
    
    func requestNotificationDetailsData(completionHandler:(status: Int, data: NotificationDetailsModel?, error: NSError?) -> Void) -> Void{
        
        httpclient.requestNotificationDetailsData("") { (response, data, error) -> Void in
            if error == nil {
                if let result = data {
                    var jsonData = JSON(data: result)
                    
                    if let notificationDetailsData = jsonData["with"]["content"].dictionary {
                        
                        // add new vars to get competition scores and user scores
                        
                        let notificationDetails = NotificationDetailsModel(title: (notificationDetailsData["Title"]!.stringValue), date: (notificationDetailsData["Date"]!.stringValue), day: (notificationDetailsData["Day"]!.stringValue), notificationImage: (notificationDetailsData["NotificationImage"]!.stringValue), message: (notificationDetailsData["message"]!.stringValue), notificationType:(notificationDetailsData["Type"]!.stringValue), competition_distance_score: Double(notificationDetailsData["distancescore"]!.stringValue)!, competition_violation: Double(notificationDetailsData["severevoilation"]!.stringValue)!, competition_ecoscore: Double(notificationDetailsData["ecoscore"]!.stringValue)!, competition_attentionscore: Double(notificationDetailsData["attentionscore"]!.stringValue)!, competition_overallscore: Double(notificationDetailsData["overallscore"]!.stringValue)!, competition_speedscore: Double(notificationDetailsData["speedscore"]!.stringValue)!, user_distance_score: Double(notificationDetailsData["distancescore"]!.stringValue)!, user_violation: Double(notificationDetailsData["severevoilation"]!.stringValue)!, user_ecoscore: Double(notificationDetailsData["ecoscore"]!.stringValue)!, user_attentionscore: Double(notificationDetailsData["attentionscore"]!.stringValue)!, user_overallscore: Double(notificationDetailsData["speedscore"]!.stringValue)!, user_speedscore: Double(notificationDetailsData["distancescore"]!.stringValue)!)
                        
                        completionHandler(status: 1, data: notificationDetails, error: nil)
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
  
//  #MARK - Trip Json Creation
  
  func reteriveTripdetails(tripid:String){
    //timeseries
    let timeseriesdatas = FacadeLayer.sharedinstance.dbactions.reteriveTimeSeries()
    
    //configurations
    let configurationdatas = FacadeLayer.sharedinstance.dbactions.reteriveConfiguration(tripid)
    
    //tripsummary
    let tripsummarydatas = FacadeLayer.sharedinstance.dbactions.reteriveTripSummary(tripid)
    
    //    print("timeseries \(timeseriesdatas)")
    //    print("config \(configurationdatas)")
    //    print("tripsummary \(tripsummarydatas)")
    
    //Convert to Dictionaries
    let timeseriesJson = timeseriesToDictionary(timeseriesdatas)
    let configJson = configurationToDictionary(configurationdatas)
    let summaryJson = summarymodelDictionary(tripsummarydatas)
    
    //    print("timeseriesJson \(timeseriesJson)")
    //    print("configJson \(configJson)")
    //    print("summaryJson \(summaryJson)")
    var userdetails = Dictionary<String,AnyObject>()
    userdetails["userId"]         = StringConstants.USER_ID
    userdetails["tokenId"]        = StringConstants.TOKEN_ID
    userdetails["channelId"]      = StringConstants.CHANNEL_TYPE
    userdetails["channelVersion"] =  UIDevice.currentDevice().systemVersion;
    
    var TripJson = Dictionary<String,AnyObject>()
    TripJson["userdetails"] = userdetails
    TripJson["tripSummary"] = summaryJson
    TripJson["tripTimeSeries"] = timeseriesJson
    
//    print("Whole: \(TripJson)")
    
    var error : NSError?
    if let data = try? NSJSONSerialization.dataWithJSONObject(TripJson, options: []) {
      let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)!
      print("Trip Json Structure\(dataString)")
      
      // do other stuff on success
      
    } else {
      print("JSON serialization failed:  \(error)")
    }
    
  }
  
  func unwrap<T1, T2, T3, T4, T5, T6, T7, T8, T9>(optional1: T1?, optional2: T2?, optional3: T3?, optional4: T4? ,optional5: T5?, optional6: T6?, optional7: T7?, optional8: T8?, optional9: T9?) -> (T1, T2, T3, T4,T5, T6, T7, T8, T9)? {
    
    switch (optional1, optional2, optional3, optional4, optional5, optional6, optional7, optional8, optional9) {
    case let (.Some(value1), .Some(value2), .Some(value3), .Some(value4) , .Some(value5), .Some(value6), .Some(value7), .Some(value8), .Some(value9)):
      return (value1, value2, value3, value4, value5, value6, value7, value8, value9)
    default:
      return nil
    }
    
  }
  
  func timeseriesToDictionary(locationseries: [Trip_timeseries]) -> [Dictionary<String, AnyObject>] {
    var arrTimeseries: [Dictionary<String, AnyObject>] = []
    for dictTimeseries in locationseries {
      
      
      if let (currenttime,datausage,distance,eventtype,eventvalue,isevent,latitude,longitude,speed) = unwrap(dictTimeseries.currenttime?.description,
        optional2: dictTimeseries.datausage,
        optional3: dictTimeseries.distance,
        optional4: dictTimeseries.eventtype,
        optional5: dictTimeseries.eventvalue,
        optional6: dictTimeseries.isEvent,
        optional7: dictTimeseries.latitude,
        optional8: dictTimeseries.longitude,
        optional9: dictTimeseries.speed){
          
          let dicttime = ["currenttime":  currenttime,
            "datausage":  datausage,
            "distance": distance,
            "eventtype": eventtype,
            "eventvalue": eventvalue,
            "isEvent": isevent,
            "latitude": latitude,
            "longitude": longitude,
            "speed": speed
          ]
          arrTimeseries.append(dicttime)
      }
      
    }
    return arrTimeseries
    
  }
  
  
  
  func configurationToDictionary(configmodel: ConfigurationModel) -> [Dictionary<String, AnyObject>] {
    var arrTimeseries: [Dictionary<String, AnyObject>] = []
    if let (thresholds_brake,thresholds_acceleration,thresholds_autotrip,weightage_braking,weightage_acceleration,weightage_speed,weightage_severevoilation,ecoweightage_braking,ecoweightage_acceleration) = unwrap(configmodel.thresholds_brake,
      optional2: configmodel.thresholds_acceleration,
      optional3: configmodel.thresholds_autotrip,
      optional4: configmodel.weightage_braking,
      optional5: configmodel.weightage_acceleration,
      optional6: configmodel.weightage_speed,
      optional7: configmodel.weightage_severevoilation,
      optional8: configmodel.ecoweightage_braking,
      optional9: configmodel.ecoweightage_acceleration){
        
        let dicttime = ["thresholds_brake":  thresholds_brake,
          "thresholds_acceleration":  thresholds_acceleration,
          "thresholds_autotrip": thresholds_autotrip,
          "weightage_braking": weightage_braking,
          "weightage_acceleration": weightage_acceleration,
          "weightage_speed": weightage_speed,
          "weightage_severevoilation": weightage_severevoilation,
          "ecoweightage_braking": ecoweightage_braking,
          "ecoweightage_acceleration": ecoweightage_acceleration
        ]
        arrTimeseries.append(dicttime)
    }
    return arrTimeseries
    
  }
 
  
  func summarymodelDictionary(tripsummarymodel: SummaryModel) -> [Dictionary<String, AnyObject>] {
    var arrsummary: [Dictionary<String, AnyObject>] = []
    
    let dictsummary = ["datausage":  tripsummarymodel.datausage,
      "tripid":  tripsummarymodel.tripid,
      "tripstarttime": tripsummarymodel.tripstarttime.description,
      "tripendtime": tripsummarymodel.tripendtime.description,
      "timezone": tripsummarymodel.timezone,
      "timezoneid": tripsummarymodel.timezoneid,
      "attentionscore": tripsummarymodel.attentionscore,
      "brakingcount": tripsummarymodel.brakingcount,
      "accelerationcount": tripsummarymodel.accelerationcount,
      "totaldistance": tripsummarymodel.totaldistance,
      "totalduration": tripsummarymodel.totalduration,
      "ecoscore": tripsummarymodel.ecoscore,
      "brakingscore": tripsummarymodel.brakingscore,
      "accelerationscore": tripsummarymodel.accelerationscore
    ]
    arrsummary.append(dictsummary)
    
    return arrsummary
    
  }
  
    //MARK: - URL Header Utility Methods
    
    func headers() -> Dictionary<String, String>? {
        
        var header = Dictionary<String , String>?()
        
        if let cookieString = NSUserDefaults.standardUserDefaults().valueForKey( StringConstants.TOKEN_ID) {
            header = ["SPRING_SECURITY_REMEMBER_ME_COOKIE":cookieString as! String]
        }
        return header
    }
    
    func historyServiceURL() -> String? {
        
        var url = String?()
        url = nil
        
        if  let  serviceURL = self.webService.historyServiceURL {
            if let tokenID = NSUserDefaults.standardUserDefaults().valueForKey( StringConstants.USER_ID) {
                url = ("\(serviceURL)?userId=\(7)")
            }
        }
        return url
    }
    
    func overallServiceURL() -> String? {
        
        var url = String?()
        url = nil
        
        if  let  serviceURL = self.webService.overallServiceURL {
            if let tokenID = NSUserDefaults.standardUserDefaults().valueForKey( StringConstants.USER_ID) {
                url = ("\(serviceURL)?userId=\(7)&channel_type=IOS")
            }
        }
        return url
    }
    
    func badgeServiceURL() -> String? {
        
        var url = String?()
        url = nil
        
        if  let  serviceURL = self.webService.badgeServiceURL {
            if let tokenID = NSUserDefaults.standardUserDefaults().valueForKey( StringConstants.USER_ID) {
                url = ("\(serviceURL)?userId=\(tokenID)")
            }
        }
        return url
    }
  
}
