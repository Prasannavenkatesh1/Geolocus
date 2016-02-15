//
//  Report.swift
//  GeoLocus
//
//  Created by Balagurunath on 2/15/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

struct Report {
    
    var reportDetail: [ReportDetails]
    var totalPoints: NSNumber
    var distanceTravelled: NSNumber
    var totalTrips: NSNumber
    
    init(reportDetail: [ReportDetails], totalPoints: NSNumber, distanceTravelled: NSNumber, totalTrips: NSNumber) {
        self.reportDetail = reportDetail
        self.totalPoints = totalPoints
        self.distanceTravelled = distanceTravelled
        self.totalTrips = totalPoints
    }
}

struct ReportDetails {
    
    enum TimeFrameType: Int {
        case weekly = 0
        case monthly = 1
    }
    
    enum ScoreType: Int {
        case speed = 0
        case eco = 1
        case attention = 2
    }

    var timeFrame: TimeFrameType
    var scoreType: ScoreType
    var myScore: NSNumber
    var poolAverage: NSNumber

    init(timeFrame: TimeFrameType, scoreType: ScoreType, myScore: NSNumber, poolAverage: NSNumber) {
        self.timeFrame = timeFrame
        self.scoreType = scoreType
        self.myScore = myScore
        self.poolAverage = poolAverage
    }
}