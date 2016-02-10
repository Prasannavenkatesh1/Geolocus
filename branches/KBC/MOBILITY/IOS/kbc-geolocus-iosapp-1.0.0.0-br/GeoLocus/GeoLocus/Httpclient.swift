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

  /*
  {(parameters) -> returntype in
  
  }
*/
  func tmp() {
    Alamofire.request(.GET, "asd")
    
    Alamofire.request(.GET, "http://ec2-52-9-108-237.us-west-1.compute.amazonaws.com:8080/kbc-app-service/admin/get/terms_conditions?languageCode=en_be").response { (req, res, data, error) -> Void in
        print(res)
        let outputString = NSString(data: data!, encoding:NSUTF8StringEncoding)
        print(outputString)
        print(res)
    }

    
    }

    
    //History services
    func requestRecentTripData(completionHandler:(response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void) -> Void{
       
        let parameters = ["userId":"<user id>","tokenId":"<get from server>","channel_type":StringConstants.CHANNEL_TYPE,"language_code":"en_be"]
        
        if let historyServiceURL = FacadeLayer.sharedinstance.webService.historyServiceURL{
            
            Alamofire.request(.POST, historyServiceURL, parameters: parameters, encoding: .JSON, headers: nil).response{ (request, response, data, error) -> Void in
                
                completionHandler(response: response, data: data, error: error)
                
                //let outputString = NSString(data: data!, encoding:NSUTF8StringEncoding)
                
            }
        }
    }
    
    //Badge services
    func requestBadgeData(URL: String, completionHandler:(status : Int, response: Badge?, error: NSError?) -> Void) -> Void{
        
        
    }
}




