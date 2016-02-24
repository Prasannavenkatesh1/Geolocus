//
//  HistoryTripDetailCell.swift
//  GeoLocus
//
//  Created by CTS MAC on 30/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class HistoryTripDetailCell: UITableViewCell {

    @IBOutlet weak var tripDateLabel    : UILabel!
    @IBOutlet weak var tripDurationLabel: UILabel!
    @IBOutlet weak var tripDistanceLabel: UILabel!
    @IBOutlet weak var tripPointsLabel  : UILabel!
    @IBOutlet weak var tripShareButton  : UIButton!
    @IBOutlet weak var distanceLabel    : UILabel!
    @IBOutlet weak var pointsLabel      : UILabel!

    @IBOutlet weak var distanceConstraint   : NSLayoutConstraint!
    @IBOutlet weak var tripPointsConstraint : NSLayoutConstraint!
    
    var delegate: TripDetailCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if StringConstants.SCREEN_HEIGHT == 480 {
            distanceConstraint.constant   = 115
            tripPointsConstraint.constant = 180
        }else if StringConstants.SCREEN_HEIGHT == 568 {
            distanceConstraint.constant   = 115
            tripPointsConstraint.constant = 180
        }else if StringConstants.SCREEN_HEIGHT == 667 {
            distanceConstraint.constant   = 135
            tripPointsConstraint.constant = 220
        }else {
            distanceConstraint.constant   = 150
            tripPointsConstraint.constant = 250
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func shareButtonTapped(sender: AnyObject) {
        self.delegate?.shareButtonTapped(self)
    }
}


extension HistoryTripDetailCell {
    
    func configure(detail: History) -> Void {
        
        let dateFormatter           = NSDateFormatter()
        dateFormatter.dateFormat    = "dd-MM-yyyy"
        let tripDate                = dateFormatter.dateFromString(detail.tripdDate)
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
        let components              = NSCalendar.currentCalendar().components(unitFlags, fromDate: tripDate!)
        
        //consider Localization
        self.tripDateLabel.text     = String("\(components.day)th \(Utility.getMonthString(components.month)) \(components.year)")
        self.tripDurationLabel.text = String("\(detail.tripDuration) Hrs")
        self.tripDistanceLabel.text = String("\(detail.distance) km")
        self.tripPointsLabel.text   = String(detail.tripPoints)
        
        if (UIColor(range:detail.tripScore.speedScore.integerValue) == UIColor(netHex: 0xff3b3b)) || (UIColor(range: detail.tripScore.ecoScore.integerValue) == UIColor(netHex: 0xff3b3b)) || (UIColor(range: detail.tripScore.overallScore.integerValue) == UIColor(netHex: 0xff3b3b)) {
            self.tripShareButton.hidden = true
        }else{
            self.tripShareButton.hidden = false
        }
        
        if let del = self.delegate {
            del.localizeTripDetails(self)
        }
    }
}

