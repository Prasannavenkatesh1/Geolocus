//
//  Config.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 01/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

struct Portal {
  
  // SIT
  static let baseurl = "https://ec2-52-9-107-182.us-west-1.compute.amazonaws.com/"
  
//  static let baseurl = "https:// ec2-52-9-107-182.us-west-1.compute.amazonaws.com:2443/"
  
  // Production
//  static let baseurl = " "
  
  
  
  static let LoginServiceURL                  = "\(baseurl)ubi-sei-web/j_spring_security_check?"
  
  static let RegistrationServiceURL           = "\(baseurl)ubi-driver-web/login?channel_type=IOS&languageCode="
  
  static let NeedHelpServiceURL               = "\(baseurl)ubi-driver-web/needHelp"
  
  static let ContractServiceURL               = "\(baseurl)ubi-sei-web/domain/get/contract_details?userId="
  
  static let DashboardServiceURL              = "\(baseurl)ubi-sei-web/domain/get/dashboard_details?userId="
  
  static let HistoryServiceURL                = "\(baseurl)ubi-sei-web/report/get/dashboard_history"
  
  static let BadgeServiceURL                  = "\(baseurl)ubi-sei-web/domain/get/badges"
  
  static let OverallServiceURL                = "\(baseurl)ubi-sei-web/report/get/overallScoreDetails"
  
  static let ReportServiceURL                 = "\(baseurl)"
  
  static let TripServiceURL                   = "\(baseurl)"
  
  static let ConfigurationServiceURL          = "\(baseurl)"
  
  static let RegisterPNURL                    = "\(baseurl)"
  
  static let RegisterDeviceTokenServiceURL    = "\(baseurl)"
  
  static let NotificationListServiceURL       = "\(baseurl)ubi-sei-web/domain/notification/getnotificationlist?userId=1"
  
  static let NotificationDetailsServiceURL    = "\(baseurl)ubi-sei-web/domain/notification/getnotificationdetails?userId=1&notificationId=1&type=Promotion"
  
  static let DeleteNotificationServiceURL     = "\(baseurl)ubi-sei-web/domain/notification/delete?userId=7&notificationId=14&type=Promotion"
  
  static let CompetitionAcceptanceServiceURL  = "\(baseurl)ubi-sei-web/domain/notification/acceptance?userId=9&notificationId=1&acceptance=Y"
  
  static let NotificationCountsServiceURL     = "\(baseurl)ubi-sei-web/domain/notification/getnotificationcount?userId=9"
  
  // Seperate Url for Terms
  static let TermConditionsServiceURL         = "http://ec2-52-9-108-237.us-west-1.compute.amazonaws.com:8080/kbc-app-service/admin/get/terms_conditions?languageCode="


}