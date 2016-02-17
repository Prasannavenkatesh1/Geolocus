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
                
                if let notificationCountServiceURL = dataDict["NotificationCountServiceURL"] {
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
    
    //MARK: Terms and Conditions Service
    
    func requestTermsAndConditionsData(URL : String, completionHandler:(status : Int,data : NSData?, error : NSError?) -> Void) -> Void{

        httpclient.requestTermsAndConditionsData(URL) { (response, data, error) -> Void in
            if(error == nil){
                completionHandler(status: 1, data: data, error: nil)
            }
            else{
                completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
            }
        }
    }
    
    //MARK: Login Service
    
    func requestLoginData(URL : String, parameterString : String, completionHandler :(status : Int, data : NSData?, error : NSError?) -> Void) -> Void{
        
        httpclient.requestLoginData(URL,parameterString: parameterString) { (response,data,error) -> Void in
            if(error == nil){
                if let resultHeader = response{
                    let tokenID = resultHeader.allHeaderFields[StringConstants.SPRING_SECURITY_COOKIE]
                    if(tokenID != nil){
                        NSUserDefaults.standardUserDefaults().setValue(tokenID, forKey: StringConstants.TOKEN_ID)
                    }
                }
                
                if(data != nil){
                    if let result = data{
                        do{
                            if let jsonData = try! NSJSONSerialization.JSONObjectWithData(result, options: []) as? NSDictionary{
                                let userID = jsonData["userId"]?.stringValue
                                let userName = jsonData["userName"]?.stringValue
                                
                                NSUserDefaults.standardUserDefaults().setValue(userID, forKey: StringConstants.USER_ID)
                                NSUserDefaults.standardUserDefaults().setValue(userName, forKey: StringConstants.USERNAME)
                                
                                completionHandler(status: 1, data: data, error: nil)
                            }
                            else{
                                //something went wrong
                                completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
                            }
                        }
                        catch let error as NSError{
                            print(error)
                        }
                    }
                    else{
                        //something went wrong
                        completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
                    }
                }
                
                else{
                    //something went wrong
                    completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
                }
            }
            else{
                //something went wrong
                completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
            }
        }
    }
    
    //MARK: - History service
    
    func fetchtripDetailData(completionHandler:(status: Int, data: [History]?, error: NSError?) -> Void) -> Void{
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
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
        }
    }
    
    //MARK:- Reoport service
    
    func fetchReportData(timeFrame timeFrame: ReportDetails.TimeFrameType, scoreType: ReportDetails.ScoreType, completionHandler:(success: Bool, error: NSError?, result: Report?) -> Void) -> Void{
        
        if StringConstants.appDataSynced {
            //get from DB and reload table
            //            dbactions.fetchBadgeData({ (status, data, error) -> Void in
            //                completionHandler(succes, error: <#T##NSError?#>)
            //                completionHandler(status: status, data: ni, error: error)
            //            })
            
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
                            completionHandler(success: true, error: nil, result: report)
                        }
                    }
                }
            })
        }
    }

    //MARK: - Dashboard Service
    
    func fetchDashboardData(completionHandler:(status: Int, data: DashboardModel?, error: NSError?) -> Void) -> Void{
        
        httpclient.requestDashboardData("URL") { (response, data, error) -> Void in
            if error == nil {
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
    
    
    //MARK: - Badge service
    
    func fetchBadgeData(completionHandler:(status: Int, data: [Badge]?, error: NSError?) -> Void) -> Void{
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.boolForKey("Badges_Page_Synced") {
            //get from DB and reload table
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
        }
    }
    
    //MARK: - Overall score service
    
    func fetchOverallScoreData(completionHandler:(status: Int, data: OverallScores?, error: NSError?) -> Void) -> Void{
        
        
        if StringConstants.appDataSynced {
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
                            
                            let overallScore = OverallScores(overallScore: Double(scores["overallScore"]!.stringValue)!, speedingScore: Double(scores["overallSpeedingScore"]!.stringValue)!, ecoScore: Double(scores["overallEcoScore"]!.stringValue)!, distanceTravelled: Double(scores["distanceTravelled"]!.stringValue)!, dataUsageMsg: scores["dataUsageMsg"]!.stringValue)
                            
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
        }
    }
    
    //MARK: Notification Services
    func fetchNotificationCount(completionHandler:(status : Int,data : NSData?, error : NSError?) -> Void) -> Void{
        
        httpclient.requestNotificationCount(webService.notificationCountServiceURL!) { (response, data, error) -> Void in
            if error == nil {
                if let result = data {
                    var jsonData = JSON(data: result)
                    self.notificationCount =  "22"

                    if jsonData["statusCode"].intValue == 1{
                        
                        self.notificationCount =  jsonData["Count"].string!

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
                    
                    if jsonData["statusCode"].intValue == 1{
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
                    
                    if jsonData["statusCode"].intValue == 1{
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
        
//        httpclient.requestNotificationDetailsData("") { (response, data, error) -> Void in
//            if error == nil {
//                if let result = data {
//                    var jsonData = JSON(data: result)
//                    
//                    if let notificationDetailsData = jsonData["with"]["content"].dictionary {
//                        
//                        // add new vars to get competition scores and user scores
//                        
//                        let notificationDetails = NotificationDetailsModel(title: (notificationDetailsData["Title"]!.stringValue), date: (notificationDetailsData["Date"]!.stringValue), day: (notificationDetailsData["Day"]!.stringValue), notificationImage: (notificationDetailsData["NotificationImage"]!.stringValue), message: (notificationDetailsData["message"]!.stringValue), notificationType:(notificationDetailsData["Type"]!.stringValue), competition_distance_score: Double(notificationDetailsData["distancescore"]!.stringValue)!, competition_violation: Double(notificationDetailsData["severevoilation"]!.stringValue)!, competition_ecoscore: Double(notificationDetailsData["ecoscore"]!.stringValue)!, competition_attentionscore: Double(notificationDetailsData["attentionscore"]!.stringValue)!, competition_overallscore: Double(notificationDetailsData["overallscore"]!.stringValue)!, competition_speedscore: Double(notificationDetailsData["speedscore"]!.stringValue)!, user_distance_score: Double(notificationDetailsData["distancescore"]!.stringValue)!, user_violation: Double(notificationDetailsData["severevoilation"]!.stringValue)!, user_ecoscore: Double(notificationDetailsData["ecoscore"]!.stringValue)!, user_attentionscore: Double(notificationDetailsData["attentionscore"]!.stringValue)!, user_overallscore: Double(notificationDetailsData["speedscore"]!.stringValue)!, user_speedscore: Double(notificationDetailsData["distancescore"]!.stringValue)!)
//                        
//                        completionHandler(status: 1, data: notificationDetails, error: nil)
//                    }else{
//                        //something went wrong
//                        completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
//                    }
//                }else{
//                    //something went wrong
//                    completionHandler(status: 0, data: nil, error:  NSError.init(domain: "", code: 0, userInfo: nil))
//                }
//            }else {
//                //something went wrong
//                completionHandler(status: 0, data: nil, error: NSError.init(domain: "", code: 0, userInfo: nil))
//            }
//            
//        }
        
    }
}
