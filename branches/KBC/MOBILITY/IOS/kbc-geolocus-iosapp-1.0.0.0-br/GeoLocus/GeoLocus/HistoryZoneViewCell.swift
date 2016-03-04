//
//  HistoryZoneViewCell.swift
//  GeoLocus
//
//  Created by CTS MAC on 30/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class HistoryZoneViewCell: UITableViewCell {

    @IBOutlet weak var maxSpeedLimit        : UILabel!
    @IBOutlet weak var indicatorButton      : UIButton!
    @IBOutlet weak var speedingView         : ArcGraphicsController!
    @IBOutlet weak var severeViolation      : UILabel!
    @IBOutlet weak var distanceTravelled    : UILabel!
    @IBOutlet weak var withinMaxSpeed       : UILabel!
    @IBOutlet weak var aboveMaxSpeed        : UILabel!
    @IBOutlet weak var severeViolationView  : UIView!
    @IBOutlet weak var speedingLabel        : UILabel!
    @IBOutlet weak var severeViolationLabel : UILabel!
    @IBOutlet weak var distanceLabel        : UILabel!
    @IBOutlet weak var withinMaxSpeedLabel  : UILabel!
    @IBOutlet weak var aboveMaxSpeedLabel   : UILabel!
    
    var svGestureReconizer = UITapGestureRecognizer()
    var delegate: SpeedZoneCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.svGestureReconizer          = UITapGestureRecognizer(target: self, action: "severeViolationViewTapped:")
        self.svGestureReconizer.delegate = self
        self.severeViolationView.addGestureRecognizer(self.svGestureReconizer)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func severeViolationViewTapped(gestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.severeViolationViewTapped(self)
    }
}

extension HistoryZoneViewCell {
    
    func configure(tripZone: SpeedZone?) -> Void{
        
        self.speedingView.foreGroundArcWidth = Arc.FOREGROUND_WIDTH
        self.speedingView.backGroundArcWidth = Arc.BACKGROUND_WIDTH
        //self.indicatorButton.selected        = false
        
        if let zone = tripZone {
            self.speedingView.ringLayer.strokeColor = UIColor(range: (zone.speedBehaviour.integerValue)).CGColor
            self.speedingView.animateScale  = zone.speedBehaviour.doubleValue/100.0
            self.severeViolation.text       = String(zone.violationCount)
            self.distanceTravelled.text     = String("\(zone.distanceTravelled) km")
            self.maxSpeedLimit.text         = String("\(zone.maxSpeed) km/h")
            self.withinMaxSpeed.text        = String("\(zone.withinSpeed) km")
            self.aboveMaxSpeed.text         = String("\(zone.aboveSpeed) km")
        }
        
        if let del = self.delegate {
            del.localizeMapZone(self)
            //del.setIndicatorButton(self)
            if del.zoneCellRefreshRequired() {
                self.speedingView.setNeedsDisplay()
            }
        }
    }
}
