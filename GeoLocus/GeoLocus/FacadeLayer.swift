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
    var dbactions         : DatabaseActions
    var httpclient        : Httpclient
    var corelocation      : CoreLocation
    var webService        : WebServiceURL
    var configmodel       : ConfigurationModel?
    var isMannualTrip     : Bool?
    var notificationCount : String?
    
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
        
        if let infoPlist = NSBundle.mainBundle().infoDictionary,
         let appENV = infoPlist["APP_ENV"] as? String {
            if let path = NSBundle.mainBundle().pathForResource("WebServicesURL", ofType: "plist") {
                
                if let envDict = NSDictionary(contentsOfFile: path) {
                    if let dataDict = envDict[appENV]{
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
        }
    }
    
    
    //MARK: Delete data
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
                completionHandler(status: 0, data: nil, error: NSError.init(domain: "No Internet Connection", code: 0, userInfo: nil))
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
                completionHandler(status: 0, data: nil, error: NSError.init(domain: "\(error?.domain)", code: 0, userInfo: nil))
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
                            
                            let parentUserName = jsonData["parentUserName"].stringValue
                            
                            NSUserDefaults.standardUserDefaults().setValue(parentUserName, forKey: StringConstants.PARENT_USERNAME)
                            
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
    }
    
    
    func requestRecentTripData(completionHandler:(status: Int, data: [History]?, error: NSError?) -> Void) -> Void {
        
        if let serviceURL = historyServiceURL() {
            
            httpclient.requestGETService(serviceURL, headers: headers(), completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    
                    var tripArray = [History]()
                    
                    if let result = data {
                        var jsonData = JSON(data: result)
                        
                        if let tripDetails = jsonData[HistoryKey.Trip.DETAILS].array {
                            
                            for tripObj in tripDetails {
                                let trip = tripObj.dictionaryValue
                                
                                var eventsObj = [Event]()
                                var speedZonesObj = [SpeedZone]()
                                
                                let tripScore = TripScore(overallScore: trip[HistoryKey.Trip.Score.OVERALL]!.doubleValue,speedScore: trip[HistoryKey.Trip.Score.SPEEDING]!.doubleValue, ecoScore: trip[HistoryKey.Trip.Score.ECO]!.doubleValue, attentionScore: nil)
                                
                                //Event array
                                for (_,subJson):(String, JSON) in trip[HistoryKey.Trip.Event.EVENT]! {
                                    let eventDict = subJson.dictionaryValue
                                    let eventLocation = EventLocation(latitude: Double(eventDict[HistoryKey.Trip.Event.LATITUDE]!.stringValue)!, longitude:Double(eventDict[HistoryKey.Trip.Event.LONGITUDE]!.stringValue)!)
                                    
                                    let event = Event(location: eventLocation,
                                        type: Utility.getEventType(eventDict[HistoryKey.Trip.Event.TYPE]!.string!),
                                        value: eventDict[HistoryKey.Trip.Event.VALUE]!.doubleValue,
                                        message: eventDict[HistoryKey.Trip.Event.MESSAGE]?.string,
                                        fineMessage: eventDict[HistoryKey.Trip.Event.FINE_MSG]?.string,
                                        threshold: eventDict[HistoryKey.Trip.Event.THRESHOLD]!.doubleValue,
                                        isSevere: eventDict[HistoryKey.Trip.Event.IS_SEVERE]!.stringValue)
                                    
                                    eventsObj.append(event)
                                }
                                
                                //Speedzone array
                                for (_,subjson):(String, JSON) in trip[HistoryKey.Trip.Speedzone.SPEED_ZONE]! {
                                    let zoneDict = subjson.dictionaryValue
                                    let speedZone = SpeedZone(speedScore: Double(zoneDict[HistoryKey.Trip.Speedzone.SPEEDING_SCORE]!.stringValue)!,
                                        maxSpeed: Double(zoneDict[HistoryKey.Trip.Speedzone.MAX_SPEED]!.stringValue)!,
                                        aboveSpeed: Double(zoneDict[HistoryKey.Trip.Speedzone.ABOVE_MAX_SPEED]!.stringValue)!,
                                        withinSpeed: Double(zoneDict[HistoryKey.Trip.Speedzone.WITHIN_MAX_SPEED]!.stringValue)!,
                                        violationCount: Double(zoneDict[HistoryKey.Trip.Speedzone.VIOLATION]!.stringValue)!,
                                        speedBehaviour: Double(zoneDict[HistoryKey.Trip.Speedzone.SPEED_BEHAVIOUR]!.stringValue)!,
                                        distanceTravelled: Double(zoneDict[HistoryKey.Trip.Speedzone.DISTANCE]!.stringValue)!)
                                    
                                    speedZonesObj.append(speedZone)
                                }
                                
                                let durationArray = trip[HistoryKey.Trip.DURATION]!.stringValue.componentsSeparatedByString(":")
                                
                                let dateFormatter = NSDateFormatter()
                                dateFormatter.dateFormat = "dd-MM-yyyy"
                                
                                let hour = Double(durationArray[0])
                                let minute = Double(durationArray[1])
                                let second = Double(durationArray[2])
                                let durationSec =  hour! * 3600 + minute! * 60 + second!
                                
                                let tripDetail = History(tripid:  trip[HistoryKey.Trip.ID]!.stringValue,
                                    tripDate: dateFormatter.stringFromDate(NSDate(jsonDate: String(trip[HistoryKey.Trip.DATE]!))!),
                                    distance: Double(trip[HistoryKey.Trip.DISTANCE]!.stringValue)!,
                                    tripPoints: Int(trip[HistoryKey.Trip.POINTS]!.stringValue)!,
                                    tripDuration:  durationSec,
                                    speedingMessage: trip[HistoryKey.Trip.SPEED_MSG]?.string,
                                    ecoMessage: trip[HistoryKey.Trip.ECO_MSG]!.string,
                                    dataUsageMessage: trip[HistoryKey.Trip.DATA_USAGE_MSG]?.string,
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
            })
            
            
//            httpclient.requestRecentTripData (serviceURL){ (response, data, error) -> Void in
//    
//            }
        }
    }
    
    
    func saveTripDetail(tripDetails: [History], completionhandler:(status: Bool)-> Void) {
        
        self.dbactions.saveTripDetail(tripDetails, completionhandler: { (status) -> Void in
            if status {
                completionhandler(status: true)
            }else{
                completionhandler(status: false)
            }
        })
    }
    
    
    //MARK:- Report service

    func fetchInitialReportData(timeFrame timeFrame: ReportDetails.TimeFrameType, scoreType: ReportDetails.ScoreType, completionHandler:(success: Bool, error: NSError?, result: Report?) -> Void) -> Void {
        dbactions.fetchReportData({ (success, error, result) -> Void in
            if success {
                completionHandler(success: true, error: error, result: result)
            }else{
              completionHandler(success: false, error: error, result: nil)
          }
        })
    }
    
  func requestInitialReportData(timeFrame timeFrame: ReportDetails.TimeFrameType, scoreType: ReportDetails.ScoreType, completionHandler:(success: Bool, error: NSError?, result: Report?) -> Void) -> Void {
    
    var userId = ""
    if let id = NSUserDefaults.standardUserDefaults().valueForKey(StringConstants.USER_ID) as? String {
      userId = id
    }
    
    httpclient.requestReportData(StringConstants.REPORT_SERVICE_URL + "userId=\(userId)&timeFrame=\(timeFrame)&scoreType=\(scoreType)", completionHandler: { (success, data) -> Void in
      if let result = data {
        
        var reportDetails = [ReportDetails]()
        
        let jsonData = JSON(data: result)
        print("reports \(jsonData)")
        if jsonData["statusCode"] == 1 {
          if let reportDetailArr = jsonData["reportDetails"].array {
            
            for reportDetailObj in reportDetailArr {
              let reportDetailDict = reportDetailObj.dictionaryValue
              
              let reportDetail = ReportDetails(timeFrame: ReportDetails.TimeFrameType.monthly, scoreType: ReportDetails.ScoreType.speed, myScore: (reportDetailDict["score"]?.intValue)!, poolAverage: (reportDetailDict["poolAverage"]?.intValue)!)
              reportDetails.append(reportDetail)
            }
          }else{
            completionHandler(success: false, error: NSError(domain: "", code: 0, userInfo: nil), result: nil)
          }
          if let overallScore = jsonData["overallscore"].dictionary {
            let report = Report(reportDetail: reportDetails, totalPoints: (overallScore["totalPoints"]?.intValue)!, distanceTravelled: (overallScore["distanceTravelled"]?.intValue)!, totalTrips: (overallScore["totalTrips"]?.intValue)!)
            completionHandler(success: true, error: nil, result: report)
          }else{
            completionHandler(success: false, error: NSError(domain: "", code: 0, userInfo: nil), result: nil)
          }
        }else {
          completionHandler(success: false, error: NSError(domain: "", code: 0, userInfo: nil), result: nil)
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
  
  func fetchConfigurations(){
    var userId = ""
    if let id = NSUserDefaults.standardUserDefaults().valueForKey(StringConstants.USER_ID) as? String {
      userId = id
    }
  }
  
    func fetchReportData(timeFrame timeFrame: ReportDetails.TimeFrameType, scoreType: ReportDetails.ScoreType, completionHandler:(success: Bool, error: NSError?, result: Report?) -> Void) -> Void{
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey(StringConstants.REPORT_SYNCHRONISATION) {
            dbactions.fetchReportData({ (success, error, result) -> Void in
                if success {
                    completionHandler(success: true, error: error, result: result)
                }else{
                  completionHandler(success: false, error: error, result: nil)
              }
            })
        }else{
          
          var userId = ""
          if let id = NSUserDefaults.standardUserDefaults().valueForKey(StringConstants.USER_ID) as? String {
            userId = id
          }

            httpclient.requestReportData(StringConstants.REPORT_SERVICE_URL + "userId=\(userId)&timeFrame=\(timeFrame)&scoreType=\(scoreType)", completionHandler: { (success, data) -> Void in
                if let result = data {
                    
                    var reportDetails = [ReportDetails]()
                    
                    let jsonData = JSON(data: result)
//                    print(jsonData)
                  print("reports \(jsonData)")
                    if jsonData["statusCode"] == 1 {
                        if let reportDetailArr = jsonData["reportDetails"].array {
                            
                            for reportDetailObj in reportDetailArr {
                                let reportDetailDict = reportDetailObj.dictionaryValue
                                
                                let reportDetail = ReportDetails(timeFrame: ReportDetails.TimeFrameType.monthly, scoreType: ReportDetails.ScoreType.speed, myScore: (reportDetailDict["score"]?.intValue)!, poolAverage: (reportDetailDict["poolAverage"]?.intValue)!)
                                reportDetails.append(reportDetail)
                            }
                        }else{
                          completionHandler(success: false, error: NSError(domain: "", code: 0, userInfo: nil), result: nil)
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
                        }else{
                          completionHandler(success: false, error: NSError(domain: "", code: 0, userInfo: nil), result: nil)
                      }
                    }else{
                      completionHandler(success: false, error: NSError(domain: "", code: 0, userInfo: nil), result: nil)
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
//                        print(jsonData)
                      
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
//                                print(badges)
                                for badgeObj in badgesList {
                                    let badgeDict = badgeObj.dictionaryValue
                                    
                                    let dist_Covered = ((badgeDict[BadgeKey.DIST_COVERED]?.string) != nil) ? Int((badgeDict[BadgeKey.DIST_COVERED]?.string)!)! : 0
                                    
                                    let badge = Badge(withIcon: " ",
                                        badgeTitle: badgeDict[BadgeKey.TITLE]!.stringValue,
                                        badgeDescription: badgeDict[BadgeKey.DESC]!.stringValue,
                                        isEarned: Bool(badgeDict[BadgeKey.EARNED]!.intValue),
                                        orderIndex: badgeDict[BadgeKey.INDEX]!.intValue,
                                        badgeType: Badge.BadgesType.Badge,
                                        additionalMsg: nil, distanceCovered: dist_Covered, shareMsg: " ")
                                    
                                    badges.append(badge)
                                }
                            }
                            
                            if let levelList = jsonData[BadgeKey.LEVELS].array {
//                                print(levelList)
                                for badgeObj in levelList {
                                    let badgeDict = badgeObj.dictionaryValue
                                    
                                    let badge = Badge(withIcon: " ",
                                        badgeTitle: badgeDict[BadgeKey.TITLE]!.stringValue,
                                        badgeDescription: badgeDict[BadgeKey.DESC]!.stringValue,
                                        isEarned: Bool(badgeDict[BadgeKey.EARNED]!.stringValue.toBool()),
                                        orderIndex: badgeDict[BadgeKey.INDEX]!.intValue,
                                        badgeType: Badge.BadgesType.Level,
                                        additionalMsg: nil, distanceCovered: 0, shareMsg: " ")
                                    
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
        }
    }
    
    func saveBadge(badges:[Badge], completionhandler:(status: Bool)-> Void) {

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
    }
    
    func requestOverallScoreData(completionHandler:(status: Int, data: OverallScores?, error: NSError?) -> Void) -> Void{
        
        if let serviceURL = overallServiceURL() {
            
            httpclient.requestGETService(serviceURL, headers: headers(), completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    if let result = data {
                        let jsonData = JSON(data: result)
                        
                        if let scores = jsonData.dictionary {
                            
                            let overallScore = OverallScores(overallScore: Double(scores[OverallScoreKey.TOTAL]!.intValue),
                                speedingScore: Double(scores[OverallScoreKey.SPEEDING]!.intValue),
                                ecoScore: Double(scores[OverallScoreKey.ECO]!.intValue),
                                distanceTravelled: Double(scores[OverallScoreKey.DISTANCE]!.intValue),
                                dataUsageMsg: scores[OverallScoreKey.DATA_USAGE_MSG]!.stringValue,
                                overallmessage: scores[OverallScoreKey.TOTAL_MSG]!.stringValue,
                                speedingMessage: scores[OverallScoreKey.SPEED_MSG]!.stringValue,
                                ecoMessage: scores[OverallScoreKey.ECO_MSG]!.stringValue)
                            
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
            })
            
            
//            httpclient.requestOverallScoreData(serviceURL) { (response, data, error) -> Void in
//                
//            }
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
        
        if let serviceURL = notificationCountServiceURL() {
            httpclient.requestNotificationCount(serviceURL) { (response, data, error) -> Void in
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
    }
    func postDeletedNotification(notificationID: NSNumber, type: String, completionHandler:(status : Int,data : NSData?, error : NSError?) -> Void) -> Void{
        if let serviceURL = notificationDeleteServiceURL(notificationID, type: type) {
            httpclient.postDeletedNotification(serviceURL) { (response, data, error) -> Void in
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
    }
    
    func postAcceptedNotification(notificationID: NSNumber, status: String,completionHandler:(status : Int,data : NSData?, error : NSError?) -> Void) -> Void{
        if let serviceURL = notificationAcceptanceServiceURL(notificationID, status: status) {
            httpclient.postAcceptedNotification(serviceURL) { (response, data, error) -> Void in
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
    }
    
    func requestNotificationListData(completionHandler:(status: Int, data: [NotificationListModel]?, error: NSError?) -> Void) -> Void{
        if let serviceURL = notificationListServiceURL() {
            httpclient.requestNotificationListData(serviceURL) { (response, data, error) -> Void in
                if error == nil {
                    var notificationList = [NotificationListModel]()
                    if let result = data {
                        var jsonData = JSON(data: result)
                        
                        if let notificationListData = jsonData["notificationList"].array where jsonData["notificationList"].array?.count > 0 {
                            
                            
                            for item in notificationListData {
                                let notification = item.dictionaryValue
                                //                            if  let (a,b) = unwrap(optional1: T1?, optional2: T2?, optional3: T3?, optional4: T4?, optional5: T5?, optional6: T6?, optional7: T7?, optional8: T8?, optional9: T9?) {}
                                let notificationObj = NotificationListModel(title: (notification["title"]!.stringValue), date: (notification["startDate"]!.stringValue), notificationImage: (notification["notificationImage"]!.stringValue), message: (notification["notificationMessage"]!.stringValue), notificationID: Double(notification["notificationId"]!.stringValue)!, notificationStatus: (notification["status"]!.stringValue),notificationType: (notification["type"]!.stringValue))
                                
                                notificationList.append(notificationObj)
                            }
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
    }
    
    func requestNotificationDetailsData(notificationID: NSNumber, type: String, completionHandler:(status: Int, data: NotificationDetailsModel?, error: NSError?) -> Void) -> Void{
        if let serviceURL = notificationDetailServiceURL(notificationID, type: type) {
            
            httpclient.requestNotificationDetailsData(serviceURL) { (response, data, error) -> Void in
                if error == nil {
                    if let result = data {
                        let jsonData = JSON(data: result)
                        
                        if let notificationDetailsData = jsonData.dictionary {
                            var notificationDetails:NotificationDetailsModel
                            // add new vars to get competition scores and user scores
                            if "competition" == (notificationDetailsData["notificationType"]!.stringValue){
                                notificationDetails = NotificationDetailsModel(title: (notificationDetailsData["title"]!.stringValue), date: (notificationDetailsData["startDate"]!.stringValue), day: (notificationDetailsData["endDate"]!.stringValue), notificationImage: (notificationDetailsData["notificationImage"]!.stringValue), message: (notificationDetailsData["message"]!.stringValue), notificationType:(notificationDetailsData["notificationType"]!.stringValue), competition_distance_score: Double(notificationDetailsData["distancescore"]!.stringValue)!, competition_violation: Double(notificationDetailsData["severevoilation"]!.stringValue)!, competition_ecoscore: Double(notificationDetailsData["ecoscore"]!.stringValue)!, competition_attentionscore: Double(notificationDetailsData["attentionscore"]!.stringValue)!, competition_overallscore: Double(notificationDetailsData["overallscore"]!.stringValue)!, competition_speedscore: Double(notificationDetailsData["speedscore"]!.stringValue)!, user_distance_score: Double(notificationDetailsData["distancescore"]!.stringValue)!, user_violation: Double(notificationDetailsData["severevoilation"]!.stringValue)!, user_ecoscore: Double(notificationDetailsData["ecoscore"]!.stringValue)!, user_attentionscore: Double(notificationDetailsData["attentionscore"]!.stringValue)!, user_overallscore: Double(notificationDetailsData["speedscore"]!.stringValue)!, user_speedscore: Double(notificationDetailsData["distancescore"]!.stringValue)!)
                                
                                
                            }
                            else if "Promotion" == (notificationDetailsData["notificationType"]!.stringValue){
                                
                                notificationDetails = NotificationDetailsModel(title: (notificationDetailsData["title"]!.stringValue), date: (notificationDetailsData["startDate"]!.stringValue), day: (notificationDetailsData["endDate"]!.stringValue), notificationImage: (notificationDetailsData["notificationImage"]!.stringValue), message: (notificationDetailsData["message"]!.stringValue), notificationType:(notificationDetailsData["notificationType"]!.stringValue), competition_distance_score:0, competition_violation: 0, competition_ecoscore: 0, competition_attentionscore: 0, competition_overallscore: 0, competition_speedscore: 0, user_distance_score: 0, user_violation: 0, user_ecoscore: 0, user_attentionscore: 0, user_overallscore: 0, user_speedscore: 0)
                                
                            }
                            else {
                                
                                notificationDetails = NotificationDetailsModel(title: (notificationDetailsData["title"]!.stringValue), date: (notificationDetailsData["startDate"]!.stringValue), day: (notificationDetailsData["endDate"]!.stringValue), notificationImage: (notificationDetailsData["notificationImage"]!.stringValue), message: (notificationDetailsData["message"]!.stringValue), notificationType:(notificationDetailsData["notificationType"]!.stringValue), competition_distance_score: Double(notificationDetailsData["distancescore"]!.stringValue)!, competition_violation: Double(notificationDetailsData["severevoilation"]!.stringValue)!, competition_ecoscore: Double(notificationDetailsData["ecoscore"]!.stringValue)!, competition_attentionscore: Double(notificationDetailsData["attentionscore"]!.stringValue)!, competition_overallscore: Double(notificationDetailsData["overallscore"]!.stringValue)!, competition_speedscore: Double(notificationDetailsData["speedscore"]!.stringValue)!, user_distance_score: Double(notificationDetailsData["distancescore"]!.stringValue)!, user_violation: Double(notificationDetailsData["severevoilation"]!.stringValue)!, user_ecoscore: Double(notificationDetailsData["ecoscore"]!.stringValue)!, user_attentionscore: Double(notificationDetailsData["attentionscore"]!.stringValue)!, user_overallscore: Double(notificationDetailsData["speedscore"]!.stringValue)!, user_speedscore: Double(notificationDetailsData["distancescore"]!.stringValue)!)
                            }
                            
                            
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
    }

  
//  #MARK - Trip Json Creation
  
  func reteriveTripdetails(tripid:String){
    
    //Userdetails
    let userdetaildatas = FacadeLayer.sharedinstance.dbactions.reteriveTrips()
    let userdata =  userdetaildatas.last
    
    
//    for userdata in userdetaildatas{
//      
//    }
    
    //timeseries
    let timeseriesdatas = FacadeLayer.sharedinstance.dbactions.reteriveTimeSeries(tripid)
    
    //configurations
    let configurationdatas = FacadeLayer.sharedinstance.dbactions.reteriveConfiguration(tripid)
    
    //tripsummary
    let tripsummarydatas = FacadeLayer.sharedinstance.dbactions.reteriveTripSummary(tripid)
    
    
    
    //Convert to Dictionaries
    let timeseriesJson = timeseriesToDictionary(timeseriesdatas)
    let configJson = configurationToDictionary(configurationdatas!)
    let summaryJson = summarymodelDictionary(tripsummarydatas)
    
    //    print("timeseriesJson \(timeseriesJson)")
    //    print("configJson \(configJson)")
    //    print("summaryJson \(summaryJson)")
    var userdetails = Dictionary<String,AnyObject>()
    userdetails["userId"]         = userdata?.userid
    userdetails["tokenId"]        = userdata?.tokenid
    userdetails["channelId"]      = userdata?.channelid
    userdetails["channelVersion"] =  userdata?.channelversion
    
    var TripJson = Dictionary<String,AnyObject>()
    TripJson["userdetails"] = userdetails
    TripJson["tripSummary"] = summaryJson
    TripJson["weightage"] = configJson
    TripJson["tripTimeSeries"] = timeseriesJson
    
//    print("Whole: \(TripJson)")
    
    var error : NSError?
    if let data = try? NSJSONSerialization.dataWithJSONObject(TripJson, options: []) {
      let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)!
      print("Trip Json  Structure\(dataString)")
      
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
          
          let dicttime = ["timeStamp":  currenttime,
            "datausage":  datausage,
            "cumulativeDistance": distance,
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
    
    let dictsummary = ["tripid":  tripsummarymodel.tripid,
      "ecoscore": tripsummarymodel.ecoscore,
      "brakingscore": tripsummarymodel.brakingscore,
      "accelerationscore": tripsummarymodel.accelerationscore,
      "attentionscore": tripsummarymodel.attentionscore,
      "brakingcount": tripsummarymodel.brakingcount,
      "accelerationcount": tripsummarymodel.accelerationcount,
      "datausage":  tripsummarymodel.datausage,
      "tripstarttime": tripsummarymodel.tripstarttime.description,
      "tripendtime": tripsummarymodel.tripendtime.description,
      "timezone": tripsummarymodel.timezone,
      "timezoneid": tripsummarymodel.timezoneid,
      "totaldistance": tripsummarymodel.totaldistance,
      "totalduration": tripsummarymodel.totalduration
     
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
        
       // if  let  serviceURL = self.webService.historyServiceURL {
            if let userID = NSUserDefaults.standardUserDefaults().valueForKey(StringConstants.USER_ID) {
                url = ("\(Portal.HistoryServiceURL)?userId=\(userID)")
            }
        //}
        return url
    }
    
    func overallServiceURL() -> String? {
        
        var url = String?()
        url = nil
        
        //if  let  serviceURL = self.webService.overallServiceURL {
            if let userID = NSUserDefaults.standardUserDefaults().valueForKey(StringConstants.USER_ID) {
                url = ("\(Portal.OverallServiceURL)?userId=\(userID)")
            }
        //}
        return url
    }
    
    func badgeServiceURL() -> String? {
        
        var url = String?()
        url = nil
        
        //if  let  serviceURL = self.webService.badgeServiceURL {
            if let userID = NSUserDefaults.standardUserDefaults().valueForKey(StringConstants.USER_ID) {
                url = ("\(Portal.BadgeServiceURL)?userId=\(userID)")
            }
        //}
        return url
    }
    
    func notificationCountServiceURL() -> String? {
        
        var url = String?()
        url = nil
        
        if  let  serviceURL = self.webService.notificationCountServiceURL {
            if let userID = NSUserDefaults.standardUserDefaults().valueForKey( StringConstants.USER_ID) {
                url = ("\(serviceURL)?userId=\(userID)")
            }
        }
        return url
    }
    func notificationListServiceURL() -> String? {
        
        var url = String?()
        url = nil
        
        if  let  serviceURL = self.webService.notificationListServiceURL {
            if let userID = NSUserDefaults.standardUserDefaults().valueForKey( StringConstants.USER_ID) {
                url = ("\(serviceURL)?userId=\(userID)")
            }
        }
        return url
    }
    func notificationDetailServiceURL(notificationID: NSNumber, type: String) -> String? {
        
        var url = String?()
        url = nil
        
        if  let  serviceURL = self.webService.notificationDetailsServiceURL {
            if let userID = NSUserDefaults.standardUserDefaults().valueForKey( StringConstants.USER_ID) {
                url = ("\(serviceURL)?userId=\(userID)&notificationId=\(notificationID)&type=\(type)")
                
            }
        }
        return url
    }
    func notificationDeleteServiceURL(notificationID: NSNumber, type: String) -> String? {
        
        var url = String?()
        url = nil
        
        if  let  serviceURL = self.webService.deleteNotificationServiceURL {
            if let userID = NSUserDefaults.standardUserDefaults().valueForKey( StringConstants.USER_ID) {
                url = ("\(serviceURL)?userId=\(userID)&notificationId=\(notificationID)&type=\(type)")
            }
        }
        return url
    }
    func notificationAcceptanceServiceURL(notificationID: NSNumber, status: String) -> String? {
        
        var url = String?()
        url = nil
        
        if  let  serviceURL = self.webService.competitionAcceptanceServiceURL {
            if let userID = NSUserDefaults.standardUserDefaults().valueForKey( StringConstants.USER_ID) {
                url = ("\(serviceURL)?userId=\(userID)&notificationId=\(notificationID)&acceptance=\(status)")
            }
        }
        return url
    }
  
  func postZiptoRemote(){
    
    httpclient.postTripDataToServer("http://ec2-52-9-108-237.us-west-1.compute.amazonaws.com:28080",
      uploadString: "This is the text file") { (response, data, error) -> Void in
        print("response: \(response)")
        print("error: \(error)")
    }
    
  }
  
}
