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
    
    func requestLoginData(URL:String, parametersHTTPBody : [String:String!]){
        let loginRequest = NSMutableURLRequest(URL: NSURL(string: URL)!)
        loginRequest.HTTPMethod = "POST"
        loginRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        loginRequest.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parametersHTTPBody, options: [])
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
    }
    
    /* Contract Service call */
    func requestContractData(URL : String, completionHandler : (success : Bool, data : NSData?) -> Void){
        
        let contractRequest = NSMutableURLRequest(URL: NSURL(string: URL)!)
        contractRequest.HTTPMethod = "GET"
        contractRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        Alamofire.request(contractRequest)
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
    
    //Badges services
    func requestBadgesData(URL:String, completionHandler:(response: NSURLResponse?/*NSHTTPURLResponse?*/, data: NSData?, error: NSError?) -> Void) -> Void{
        
        
        /*if let filePath = NSBundle.mainBundle().pathForResource("badges", ofType: "json"), data = NSData(contentsOfFile: filePath) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                print(json)
                
                //****************************************//
                
                let parameters = ["userId":"<user id>","tokenId":"<get from server>","channel_type":StringConstants.CHANNEL_TYPE,"language_code":"en_be"]
                
                if let badgesServiceURL = FacadeLayer.sharedinstance.webService.badgeServiceURL{
                   
                    var header:[String: String] = ["SPRING_SECURITY_REMEMBER_ME_COOKIE":"NkJYQURVV3poNlkxQU5xdUVEOFdrdz09OnRkL2xEMWUrN0lOTG40UXpLcS9iQ1E9PQ"]
                    Alamofire.request(.GET, badgesServiceURL, parameters:nil /*json as? Dictionary*/, encoding: .JSON, headers: header).response{ (request, response, data, error) -> Void in
                        
                        completionHandler(response: response, data: data, error: error)
                        
                    }
                }
                
                //*****************************************//
                
            }
            catch {
                //Handle error
            }
        }*/
        
        
    
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let request = NSMutableURLRequest(URL: NSURL(string: FacadeLayer.sharedinstance.webService.badgeServiceURL!)!)
        request.HTTPMethod = "GET"
        
        let authValue = "SWs5cVUyeUFDTDg5bnhMMnZaOWVLUT09Om16Vm01Q3pPVHErZXJyUUV3ZHMyM3c9PQ"
        request.setValue(authValue, forHTTPHeaderField: "SPRING_SECURITY_REMEMBER_ME_COOKIE")
        
        
        
//        let session = NSURLSession.sharedSession()
//        
//        let loginRequest = NSMutableURLRequest(URL: NSURL(string: FacadeLayer.sharedinstance.webService.badgeServiceURL!)!)
//        loginRequest.HTTPMethod = "GET"
//        loginRequest.setValue("SPRING_SECURITY_REMEMBER_ME_COOKIE", forHTTPHeaderField: "NkJYQURVV3poNlkxQU5xdUVEOFdrdz09OnRkL2xEMWUrN0lOTG40UXpLcS9iQ1E9PQ")
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            completionHandler(response: response, data: data, error: error)
            
//            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
//            
//                return
//            }
//            
//            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            print(dataString)
            
        }.resume()
        
        
    }
    
    //Overall services
    func requestOverallScoreData(URL:String, completionHandler:(response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
        
        
        if let filePath = NSBundle.mainBundle().pathForResource("badges", ofType: "json"), data = NSData(contentsOfFile: filePath) {
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
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if challenge.protectionSpace.host == "ec2-52-9-107-182.us-west-1.compute.amazonaws.com" {
                let credential = NSURLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, credential)
            }
        }
    }
}




