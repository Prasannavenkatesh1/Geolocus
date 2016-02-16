//
//  Httpclient.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 11/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class Httpclient: NSObject,NSURLSessionDelegate {
    var delegate = self
  /*
  {(parameters) -> returntype in
  
  }
*/
  func tmp() {
    Alamofire.request(.GET, "asd")
    
    }
    
    /* Terms and Conditions Service call */
    
    func requestTermsAndConditionsData(URL : String, completionHandler: (response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
                Alamofire.request(.GET, URL)
                    .response { (request, response, data, error) -> Void in
                        completionHandler(response: response, data: data, error: error)
            }
    }
    
    /* Login Service call */
    
    /*func requestLoginData(URL:String, parametersHTTPBody : [String:String!]){
        let loginRequest = NSMutableURLRequest(URL: NSURL(string: URL)!)
        loginRequest.HTTPMethod = "POST"
       // loginRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //loginRequest.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parametersHTTPBody, options: [])
        Alamofire.request(loginRequest)
            .validate()
            .responseJSON{ responseJSON in
                switch responseJSON.result {
                    case .Failure(let error):
                        print(error)
                    case .Success(let responseObject):
                        print(responseObject)
                        
                        let tokenID = responseJSON.response?.allHeaderFields["SPRING_SECURITY_REMEMBER_ME_COOKIE"]//SPRING_SECURITY_REMEMBER_ME_COOKIE
                        print(tokenID)
                        NSUserDefaults.standardUserDefaults().setValue(tokenID, forKey: StringConstants.TOKEN_ID)
                        
                        let responseJSON = responseObject as! NSDictionary
                        let userID = responseJSON.objectForKey("userID")
                        print(userID)
                }
        }.resume()
    }*/
    
    /* Login Service call */

    func requestLoginData(URL : String, parameterString : String, completionHandler:(response:NSHTTPURLResponse?, data : NSData?, error : NSError?) -> Void) -> Void{
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        let loginURL : NSURL = NSURL(string : URL)!
        
        let loginRequest = NSMutableURLRequest(URL : loginURL)
        loginRequest.HTTPMethod = "POST"
        
        loginRequest.HTTPBody = parameterString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(loginRequest) {
            (let data, let response, let error) in
            
            guard let data = data , let response = response as? NSHTTPURLResponse where error == nil else {
                print("error")
                return
            }
            completionHandler(response: response, data: data, error: error)
        }
        task.resume()
    }
    
    /* Contract Service call */
    
    func requestContractData(URL : String, completionHandler : (response : NSHTTPURLResponse?, data : NSData?, error : NSError?) -> Void) -> Void{
        
        let manager = Alamofire.Manager.sharedInstance
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
            var credential: NSURLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if challenge.protectionSpace.host == "ec2-52-9-107-182.us-west-1.compute.amazonaws.com" {
                    disposition = NSURLSessionAuthChallengeDisposition.UseCredential
                    
                    credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
                }
            }
            return (disposition, credential)
        }
        
        let badgesRequest = NSMutableURLRequest(URL: NSURL(string: URL)!)
        badgesRequest.HTTPMethod = "GET"
        badgesRequest.setValue("SWs5cVUyeUFDTDg5bnhMMnZaOWVLUT09Om16Vm01Q3pPVHErZXJyUUV3ZHMyM3c9PQ", forHTTPHeaderField: "SPRING_SECURITY_REMEMBER_ME_COOKIE")
        
        manager.request(badgesRequest).response { (Request, response, data, error) -> Void in
            completionHandler(response: response, data: data, error: error)
        }

        
    }
    
    //MARK:- Report Service
    func requestReportData(URL:String, completionHandler:(success: Bool?, data: NSData?) -> Void) -> Void{
        
        let manager = Alamofire.Manager.sharedInstance
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
            var credential: NSURLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if challenge.protectionSpace.host == "ec2-52-9-107-182.us-west-1.compute.amazonaws.com" {
                    disposition = NSURLSessionAuthChallengeDisposition.UseCredential
                    
                    credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
                }
            }
            return (disposition, credential)
        }

        let reportRequest = NSMutableURLRequest(URL: NSURL(string: URL)!)
        reportRequest.HTTPMethod = "GET"
        reportRequest.setValue("SWs5cVUyeUFDTDg5bnhMMnZaOWVLUT09Om16Vm01Q3pPVHErZXJyUUV3ZHMyM3c9PQ", forHTTPHeaderField: "SPRING_SECURITY_REMEMBER_ME_COOKIE")
        
        Alamofire.request(reportRequest)
            .responseJSON { (responseJSON) -> Void in
                if let contractData = responseJSON.data{
                    completionHandler(success: true, data: contractData)
                    return
                }
                completionHandler(success: false, data: nil)
            }.resume()
    }

    //History services
    func requestRecentTripData(URL: String, completionHandler:(response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
        
        if let filePath = NSBundle.mainBundle().pathForResource("trip_details", ofType: "json"), data = NSData(contentsOfFile: filePath) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                print(json)
                
                //****************************************//
                
                let parameters = ["userId":"<user id>","tokenId":"<get from server>","channel_type":StringConstants.CHANNEL_TYPE,"language_code":"en_be"]
                
                if let historyServiceURL = FacadeLayer.sharedinstance.webService.historyServiceURL{
                    
                    Alamofire.request(.POST, historyServiceURL, parameters: json as? Dictionary, encoding: .JSON, headers: nil).response{ (request, response, data, error) -> Void in
                        
                        completionHandler(response: response, data: data, error: error)
                        
                    }
                }
                
                //*****************************************//
                
            }
            catch {
                //Handle error
            }
        }
        
        
    }
    
    func requestDashboardData(URL:String, completionHandler:(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let request = NSMutableURLRequest(URL: NSURL(string: FacadeLayer.sharedinstance.webService.dashboardServiceURL!)!)
        request.HTTPMethod = "GET"
        
        let authValue = "SWs5cVUyeUFDTDg5bnhMMnZaOWVLUT09Om16Vm01Q3pPVHErZXJyUUV3ZHMyM3c9PQ"
        request.setValue(authValue, forHTTPHeaderField: "SPRING_SECURITY_REMEMBER_ME_COOKIE")
        
        _ = session.dataTaskWithRequest(request) {(let data, let response, let error) in
            
            completionHandler(response: response, data: data, error: error)
            
            }.resume()
    }
    
    //Badges services
    func requestBadgesData(URL:String, completionHandler:(response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
    
        let manager = Alamofire.Manager.sharedInstance
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
            var credential: NSURLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if challenge.protectionSpace.host == "ec2-52-9-107-182.us-west-1.compute.amazonaws.com" {
                    disposition = NSURLSessionAuthChallengeDisposition.UseCredential
                    
                    credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
                }
            }
            return (disposition, credential)
        }
        
        let badgesRequest = NSMutableURLRequest(URL: NSURL(string: URL)!)
        badgesRequest.HTTPMethod = "GET"
        badgesRequest.setValue("SWs5cVUyeUFDTDg5bnhMMnZaOWVLUT09Om16Vm01Q3pPVHErZXJyUUV3ZHMyM3c9PQ", forHTTPHeaderField: "SPRING_SECURITY_REMEMBER_ME_COOKIE")
        
        manager.request(badgesRequest).response { (Request, response, data, error) -> Void in
             completionHandler(response: response, data: data, error: error)
        }

        /*
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let request = NSMutableURLRequest(URL: NSURL(string: FacadeLayer.sharedinstance.webService.badgeServiceURL!)!)
        request.HTTPMethod = "GET"
        
        let authValue = "SWs5cVUyeUFDTDg5bnhMMnZaOWVLUT09Om16Vm01Q3pPVHErZXJyUUV3ZHMyM3c9PQ"
        request.setValue(authValue, forHTTPHeaderField: "SPRING_SECURITY_REMEMBER_ME_COOKIE")
        
        _ = session.dataTaskWithRequest(request) {(let data, let response, let error) in
            
            completionHandler(response: response, data: data, error: error)
            
        }.resume()*/
    }

    //Overall services
    func requestOverallScoreData(URL:String, completionHandler:(response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
        
        
        if let filePath = NSBundle.mainBundle().pathForResource("overallscore", ofType: "json"), data = NSData(contentsOfFile: filePath) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                print(json)
                
                //****************************************//
                
                let parameters = ["userId":"<user id>","tokenId":"<get from server>","channel_type":StringConstants.CHANNEL_TYPE,"language_code":"en_be"]
                
                if let overallScoreServiceURL = FacadeLayer.sharedinstance.webService.overallServiceURL{
                    
                    Alamofire.request(.POST, overallScoreServiceURL, parameters: json as? Dictionary, encoding: .JSON, headers: nil).response{ (request, response, data, error) -> Void in
                        
                        completionHandler(response: response, data: data, error: error)
                        
                    }
                }
                
                //*****************************************//
                
            }
            catch {
                //Handle error
            }
        }
    }
    func requestNotificationCount(URL : String, completionHandler: (response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
        
        let manager = Alamofire.Manager.sharedInstance
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
            var credential: NSURLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if challenge.protectionSpace.host == "ec2-52-9-107-182.us-west-1.compute.amazonaws.com" {
                    disposition = NSURLSessionAuthChallengeDisposition.UseCredential
                    
                    credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
                }
            }
            return (disposition, credential)
        }
        
        
        let notificationCountRequest = NSMutableURLRequest(URL: NSURL(string: URL)!)
        notificationCountRequest.HTTPMethod = "GET"
        notificationCountRequest.setValue("SWs5cVUyeUFDTDg5bnhMMnZaOWVLUT09Om16Vm01Q3pPVHErZXJyUUV3ZHMyM3c9PQ", forHTTPHeaderField: "SPRING_SECURITY_REMEMBER_ME_COOKIE")
        
        manager.request(notificationCountRequest).response { (Request, response, data, error) -> Void in
            completionHandler(response: response, data: data, error: error)
        }
    }
    
    
    func postDeletedNotification(URL : String, completionHandler: (response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
        
        let manager = Alamofire.Manager.sharedInstance
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
            var credential: NSURLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if challenge.protectionSpace.host == "ec2-52-9-107-182.us-west-1.compute.amazonaws.com" {
                    disposition = NSURLSessionAuthChallengeDisposition.UseCredential
                    
                    credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
                }
            }
            return (disposition, credential)
        }
        
        let deleteNotificationRequest = NSMutableURLRequest(URL: NSURL(string: URL)!)
        deleteNotificationRequest.HTTPMethod = "POST"
        deleteNotificationRequest.setValue("SWs5cVUyeUFDTDg5bnhMMnZaOWVLUT09Om16Vm01Q3pPVHErZXJyUUV3ZHMyM3c9PQ", forHTTPHeaderField: "SPRING_SECURITY_REMEMBER_ME_COOKIE")
        
        manager.request(deleteNotificationRequest).response { (Request, response, data, error) -> Void in
            completionHandler(response: response, data: data, error: error)
        }
    }
    
    
    func postAcceptedNotification(URL : String, completionHandler: (response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
        
        let manager = Alamofire.Manager.sharedInstance
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
            var credential: NSURLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if challenge.protectionSpace.host == "ec2-52-9-107-182.us-west-1.compute.amazonaws.com" {
                    disposition = NSURLSessionAuthChallengeDisposition.UseCredential
                    
                    credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
                }
            }
            return (disposition, credential)
        }
        
        let acceptNotificationRequest = NSMutableURLRequest(URL: NSURL(string: URL)!)
        acceptNotificationRequest.HTTPMethod = "POST"
        acceptNotificationRequest.setValue("SWs5cVUyeUFDTDg5bnhMMnZaOWVLUT09Om16Vm01Q3pPVHErZXJyUUV3ZHMyM3c9PQ", forHTTPHeaderField: "SPRING_SECURITY_REMEMBER_ME_COOKIE")
        
        manager.request(acceptNotificationRequest).response { (Request, response, data, error) -> Void in
            completionHandler(response: response, data: data, error: error)
        }
    }
    
    
    func requestNotificationListData(URL:String, completionHandler:(response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
        
        
        if let filePath = NSBundle.mainBundle().pathForResource("NotificationList", ofType: "json"), data = NSData(contentsOfFile: filePath) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                print(json)
                
                //****************************************//
                
                let parameters = ["userId":"<user id>","tokenId":"<get from server>","channel_type":StringConstants.CHANNEL_TYPE,"language_code":"en_be"]
                
                if let notificationListServiceURL = FacadeLayer.sharedinstance.webService.notificationListServiceURL{
                    
                    Alamofire.request(.POST, notificationListServiceURL, parameters: json as? Dictionary, encoding: .JSON, headers: nil).response{ (request, response, data, error) -> Void in
                        
                        completionHandler(response: response, data: data, error: error)
                        
                    }
                }
                
                //*****************************************//
                
            }
            catch {
                //Handle error
            }
        }
    }
    
    
    func requestNotificationDetailsData(URL:String, completionHandler:(response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
        
        
        if let filePath = NSBundle.mainBundle().pathForResource("NotificationDetails", ofType: "json"), data = NSData(contentsOfFile: filePath) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                print(json)
                //****************************************//
                
                let parameters = ["userId":"<user id>","tokenId":"<get from server>","channel_type":StringConstants.CHANNEL_TYPE,"language_code":"en_be"]
                
                if let notificationDetailsServiceURL = FacadeLayer.sharedinstance.webService.notificationDetailsServiceURL{
                    
                    Alamofire.request(.POST, notificationDetailsServiceURL, parameters: json as? Dictionary, encoding: .JSON, headers: nil).response{ (request, response, data, error) -> Void in
                        
                        completionHandler(response: response, data: data, error: error)
                        
                    }
                }
                
                //*****************************************//
                
            }
            catch {
                //Handle error
            }
        }
    }
    
    //MARK: Delegate Methods
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if challenge.protectionSpace.host == "ec2-52-9-107-182.us-west-1.compute.amazonaws.com" {
                let credential = NSURLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, credential)
            }
        }
    }
}




