//
//  FacadeLayer.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit


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
        
        httpclient.requestRecentTripData { (response, data, error) -> Void in
            
            if error == nil {
                
                //completionHandler(status: 1, data: <#T##[History]?#>, error: <#T##NSError?#>)
            }
            
        }
        
    }

}
