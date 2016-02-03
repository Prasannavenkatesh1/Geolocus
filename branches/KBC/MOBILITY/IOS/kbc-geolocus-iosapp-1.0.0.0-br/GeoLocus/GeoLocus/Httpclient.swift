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
  }
  
    //History services
    func requestHistoryData(URL: String, HTTPbody : Dictionary<String, String>, completionHandler:(status : (String, String), response: History?, error: NSError?) -> Void) -> Void{
        
    }
    
    //Badge services
    func requestBadgeData(URL: String, completionHandler:(status : Int, response: Badge?, error: NSError?) -> Void) -> Void{
        
        
    }
}




