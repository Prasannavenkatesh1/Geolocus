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

class Httpclient: NSObject {
    var delegate = self
  /*
  {(parameters) -> returntype in
  
  }
*/
  func tmp() {
    Alamofire.request(.GET, "asd")
    
    }
    
    /* Terms and Conditions Service call */
    
    func getContentFromTermsAndConditionsRequest(URL : String, completionHandler : (success : Bool, data : NSData?) -> Void){
        Alamofire.request(.GET, URL)
            .responseString { (responseString) -> Void in
                if let termsAndConditionsString = responseString.data{
                    completionHandler(success: true, data: termsAndConditionsString)
                    return
                }
                completionHandler(success: false, data: nil)
        }.resume()
    }
    
    func requestLoginData(URL:String, parametersHTTPBody : [String:String!]){
        let loginRequest = NSMutableURLRequest(URL: NSURL(string: URL)!)
        loginRequest.HTTPMethod = "POST"
        loginRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        loginRequest.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parametersHTTPBody, options: [])
        Alamofire.request(loginRequest)
            .responseJSON{ responseJSON in
                switch responseJSON.result {
                case .Failure(let error):
                    print(error)
                case .Success(let responseObject):
                    print(responseObject)
                    let responseHeader = responseObject.allHeaderFields
                    print(responseHeader)
                    let responseJSON = responseObject as! NSDictionary
                    let userID = responseJSON.objectForKey("userID")
                    print(userID)
            }
        }.resume()
    }
    
    //History services
    func requestHistoryData(URL: String, HTTPbody : Dictionary<String, String>, completionHandler:(status : (String, String), response: History?, error: NSError?) -> Void) -> Void{
        
    }
    
    //Badge services
    func requestBadgeData(URL: String, completionHandler:(status : Int, response: Badge?, error: NSError?) -> Void) -> Void{
        
        
    }
}




