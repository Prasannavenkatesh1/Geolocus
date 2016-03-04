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
import Zip

class Httpclient: NSObject,NSURLSessionDelegate {
    var delegate = self
    let defaults = NSUserDefaults.standardUserDefaults()
    /*
    {(parameters) -> returntype in
    
    }
    */
    
    /* Terms and Conditions Service call */
    
    func requestTermsAndConditionsData(completionHandler: (response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
        
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
        
    let selectedLanguageCode : String! = defaults.stringForKey(StringConstants.SELECTED_LANGUAGE_USERDEFAULT_KEY)
      let termsAndConditionsURL = Portal.TermConditionsServiceURL + "\(selectedLanguageCode)"
      
            manager.request(.GET, termsAndConditionsURL)
                    .response { (request, response, data, error) -> Void in
                        completionHandler(response: response, data: data, error: error)
            }
    }
    
    /* Login Service call */
    
    func requestLoginData(parameterString : String, completionHandler:(response:NSHTTPURLResponse?, data : NSData?, error : NSError?) -> Void) -> Void{
        
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
        
        let loginURL : NSURL = NSURL(string : Portal.LoginServiceURL)!
        let loginRequest = NSMutableURLRequest(URL : loginURL)
        loginRequest.HTTPMethod = "POST"
        
        loginRequest.HTTPBody = parameterString.dataUsingEncoding(NSUTF8StringEncoding)
        
        manager.request(loginRequest).response { (Request, response, data, error) -> Void in
            completionHandler(response: response, data: data, error: error)
        }
    }
    
    /* Contract Service call */
    
    func requestContractData(completionHandler : (response : NSHTTPURLResponse?, data : NSData?, error : NSError?) -> Void) -> Void{
        
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
        
        let userID : String! = defaults.stringForKey(StringConstants.USER_ID) //"9"
        let contractServiceURL = Portal.ContractServiceURL + "\(userID)"
      
        let contractRequest = NSMutableURLRequest(URL: NSURL(string : contractServiceURL)!)
        contractRequest.HTTPMethod = "GET"
        
        let tokenID = defaults.valueForKey(StringConstants.TOKEN_ID) as? String
        contractRequest.setValue(tokenID, forHTTPHeaderField: StringConstants.SPRING_SECURITY_COOKIE)
        
        manager.request(contractRequest).response { (Request, response, data, error) -> Void in
            completionHandler(response: response, data: data, error: error)
        }
    }
    
    //MARK:- Generic GET Request Method
    
    func requestGETService(URL: String, headers: Dictionary<String, String>?, completionHandler:(response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
        
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
        
        if let headerDict = headers{
            for(headerKey, headerValue) in headerDict {
                badgesRequest.setValue(headerValue, forHTTPHeaderField: headerKey)
            }
        }
        
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
        if let tokenId: String = NSUserDefaults.standardUserDefaults().stringForKey(StringConstants.TOKEN_ID) {
            reportRequest.setValue(tokenId, forHTTPHeaderField: StringConstants.SPRING_SECURITY_COOKIE)
        }
        
        Alamofire.request(reportRequest)
            .responseJSON { (responseJSON) -> Void in
                
                if let contractData = responseJSON.data{
                    completionHandler(success: true, data: contractData)
                    return
                }
                completionHandler(success: false, data: nil)
                
            }.resume()
    }
    
    //MARK: - History services
    func requestRecentTripData(URL: String, completionHandler:(response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
        
        
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
        badgesRequest.setValue(NSUserDefaults.standardUserDefaults().valueForKey( StringConstants.TOKEN_ID) as? String, forHTTPHeaderField: "SPRING_SECURITY_REMEMBER_ME_COOKIE")
        
        manager.request(badgesRequest).response { (Request, response, data, error) -> Void in
            completionHandler(response: response, data: data, error: error)
        }
    }
    
    //MARK: - Dashboard data
    func requestDashboardData(URL:String, completionHandler:(success: Bool?, data: NSData?) -> Void) -> Void{
        
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
        
        let userID : String! = defaults.stringForKey(StringConstants.USER_ID)
//        let urlString = FacadeLayer.sharedinstance.webService.dashboardServiceURL! + userID
        let urlString = Portal.DashboardServiceURL + userID
      
       // let reportRequest = NSMutableURLRequest(URL: NSURL(string: FacadeLayer.sharedinstance.webService.dashboardServiceURL!)!)
        let reportRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        reportRequest.HTTPMethod = "GET"
        reportRequest.setValue(NSUserDefaults.standardUserDefaults().stringForKey(StringConstants.TOKEN_ID), forHTTPHeaderField: StringConstants.SPRING_SECURITY_COOKIE)
        
        Alamofire.request(reportRequest)
            .responseJSON { (responseJSON) -> Void in
                if let dashboardsData = responseJSON.data{
                    completionHandler(success: true, data: dashboardsData)
                    return
                }
                completionHandler(success: false, data: nil)
            }.resume()
        
        
        
        
        
        
        //        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        //        let session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        //
        //        let request = NSMutableURLRequest(URL: NSURL(string: FacadeLayer.sharedinstance.webService.dashboardServiceURL!)!)
        //        request.HTTPMethod = "GET"
        //
        //        let authValue = NSUserDefaults.standardUserDefaults().stringForKey(StringConstants.TOKEN_ID)
        //        request.setValue(authValue, forHTTPHeaderField: StringConstants.SPRING_SECURITY_COOKIE)
        //
        //        _ = session.dataTaskWithRequest(request) {(let data, let response, let error) in
        //
        //            completionHandler(response: response, data: data, error: error)
        //
        //            }.resume()
    }
    
    //MARK: - Badges services
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
        badgesRequest.setValue(NSUserDefaults.standardUserDefaults().valueForKey( StringConstants.TOKEN_ID) as? String, forHTTPHeaderField: "SPRING_SECURITY_REMEMBER_ME_COOKIE")
        
        manager.request(badgesRequest).response { (Request, response, data, error) -> Void in
            completionHandler(response: response, data: data, error: error)
        }
    }
    
    //MARK: - Overall services
    func requestOverallScoreData(URL:String, completionHandler:(response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
        
        
        
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
        badgesRequest.setValue(NSUserDefaults.standardUserDefaults().valueForKey( StringConstants.TOKEN_ID) as? String, forHTTPHeaderField: "SPRING_SECURITY_REMEMBER_ME_COOKIE")
        
        manager.request(badgesRequest).response { (Request, response, data, error) -> Void in
            completionHandler(response: response, data: data, error: error)
        }
    }
    
    //MARK: - Notification
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
        let tokenID = defaults.valueForKey(StringConstants.TOKEN_ID) as? String
        notificationCountRequest.setValue(tokenID, forHTTPHeaderField: StringConstants.SPRING_SECURITY_COOKIE)
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
        let tokenID = defaults.valueForKey(StringConstants.TOKEN_ID) as? String
        deleteNotificationRequest.setValue(tokenID, forHTTPHeaderField: StringConstants.SPRING_SECURITY_COOKIE)
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
        let tokenID = defaults.valueForKey(StringConstants.TOKEN_ID) as? String
        acceptNotificationRequest.setValue(tokenID, forHTTPHeaderField: StringConstants.SPRING_SECURITY_COOKIE)
        manager.request(acceptNotificationRequest).response { (Request, response, data, error) -> Void in
            completionHandler(response: response, data: data, error: error)
        }
    }
    
    
    func requestNotificationListData(URL:String, completionHandler:(response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
        
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
        
        
        let notificationListRequest = NSMutableURLRequest(URL: NSURL(string: URL)!)
        notificationListRequest.HTTPMethod = "GET"
        let tokenID = defaults.valueForKey(StringConstants.TOKEN_ID) as? String
        notificationListRequest.setValue(tokenID, forHTTPHeaderField: StringConstants.SPRING_SECURITY_COOKIE)
        manager.request(notificationListRequest).response { (Request, response, data, error) -> Void in
            completionHandler(response: response, data: data, error: error)
        }
        
    }
    
    
    func requestNotificationDetailsData(URL:String, completionHandler:(response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
        
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
        
        
        let notificationDetailRequest = NSMutableURLRequest(URL: NSURL(string: URL)!)
        notificationDetailRequest.HTTPMethod = "GET"
        let tokenID = defaults.valueForKey(StringConstants.TOKEN_ID) as? String
        notificationDetailRequest.setValue(tokenID, forHTTPHeaderField: StringConstants.SPRING_SECURITY_COOKIE)
        manager.request(notificationDetailRequest).response { (Request, response, data, error) -> Void in
            completionHandler(response: response, data: data, error: error)
        }
        
    }
  
  // MARK: - Trip Data
  
  func postJsonTripData(URL:String, uploadString:String, completionHandler:(response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
    
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
    
    
    let tripRequest = NSMutableURLRequest(URL: NSURL(string: URL)!)
    tripRequest.HTTPMethod = "POST"
    
    tripRequest.HTTPBody = uploadString.dataUsingEncoding(NSUTF8StringEncoding)
    
//    let tokenID = defaults.valueForKey(StringConstants.TOKEN_ID) as? String
//    notificationDetailRequest.setValue(tokenID, forHTTPHeaderField: StringConstants.SPRING_SECURITY_COOKIE)
    manager.request(tripRequest).response { (Request, response, data, error) -> Void in
      completionHandler(response: response, data: data, error: error)
    }
    
  }
  
  
  
  func postTripDataToServer(URL:String, uploadString:String, completionHandler:(response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void {
    
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
    
    let fileURL: NSURL? = {
      
      do {
        let rawFilePath = try createAndWriteToJsonFileForTripData(uploadString)
        if  let zippedFilePath = zipTripFile(rawFilePath!) { return zippedFilePath }
      }
      catch {
        print("Something went wrong")
      }
      return nil
    }()
    
    guard let filepath = fileURL else { return }
    
    manager.upload(
      .POST,
      URL,
      multipartFormData: {
        multipartFormData in
        multipartFormData.appendBodyPart(fileURL: filepath, name: "Tripfilename")
        //      multipartFormData.appendBodyPart(data: "Alamofire test title".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "title")
        //      multipartFormData.appendBodyPart(data: "test content".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "content")
        //      multipartFormData.appendBodyPart(data: "1".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "type")
      },
      encodingCompletion: {
        encodingResult in
        switch encodingResult {
          
        case .Success(let request, _, _):
          print(request)
          
          
        case .Failure(let encodingError):
          print("Failure")
          print(encodingError)
        }
      }
    )
  }
}




