//
//  NotificationModel.swift
//  GeoLocus
//
//  Created by sathishkumar on 03/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

struct NotificationListModel {
    let title: String?
    let date: String
    //let day: String
    let notificationImage: String
    let message: String
    let notificationID: NSNumber
    let notificationStatus: String
    let notificationType: String
    
    init(title:String, date:String, notificationImage:String, message:String, notificationID:NSNumber, notificationStatus:String, notificationType:String){
        
        self.title = title
        self.date = date
        //self.day = day
        self.notificationImage = notificationImage
        self.message = message
        self.notificationID = notificationID
        self.notificationStatus = notificationStatus
        self.notificationType = notificationType
    }
}

struct NotificationDetailsModel {
    let title: String
    let date: String
    let day: String
    let notificationImage: String
    let message: String
    let notificationType: String
    let competition_distance_score: NSNumber
    let competition_violation: NSNumber
    let competition_ecoscore: NSNumber
    let competition_attentionscore: NSNumber
    let competition_overallscore: NSNumber
    let competition_speedscore: NSNumber
    let user_distance_score: NSNumber
    let user_violation: NSNumber
    let user_ecoscore: NSNumber
    let user_attentionscore: NSNumber
    let user_overallscore: NSNumber
    let user_speedscore: NSNumber
    
    init(title:String, date:String, day:String, notificationImage:String, message:String, notificationType:String, competition_distance_score:NSNumber, competition_violation:NSNumber, competition_ecoscore:NSNumber, competition_attentionscore:NSNumber, competition_overallscore:NSNumber, competition_speedscore:NSNumber, user_distance_score:NSNumber, user_violation:NSNumber, user_ecoscore:NSNumber, user_attentionscore:NSNumber, user_overallscore:NSNumber, user_speedscore:NSNumber){
        
        self.title = title
        self.date = date
        self.day = day
        self.notificationImage = notificationImage
        self.message = message
        self.notificationType = notificationType
        self.competition_distance_score = competition_distance_score
        self.competition_violation = competition_violation
        self.competition_ecoscore = competition_ecoscore
        self.competition_attentionscore = competition_attentionscore
        self.competition_overallscore = competition_overallscore
        self.competition_speedscore = competition_speedscore
        self.user_distance_score = user_distance_score
        self.user_violation = user_violation
        self.user_ecoscore = user_ecoscore
        self.user_attentionscore = user_attentionscore
        self.user_overallscore = user_overallscore
        self.user_speedscore = user_speedscore
    }
}
