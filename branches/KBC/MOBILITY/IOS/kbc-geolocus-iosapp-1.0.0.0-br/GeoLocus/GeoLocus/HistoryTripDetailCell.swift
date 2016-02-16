//
//  HistoryTripDetailCell.swift
//  GeoLocus
//
//  Created by CTS MAC on 30/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class HistoryTripDetailCell: UITableViewCell {

    @IBOutlet weak var tripDateLabel: UILabel!
    @IBOutlet weak var tripDurationLabel: UILabel!
    @IBOutlet weak var tripDistanceLabel: UILabel!
    @IBOutlet weak var tripPointsLabel: UILabel!
    @IBOutlet weak var tripShareButton: UIButton!
    
    
    @IBOutlet weak var distanceConstraint: NSLayoutConstraint!
    @IBOutlet weak var tripPointsConstraint: NSLayoutConstraint!
    
    var delegate: TripDetailCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if StringConstants.SCREEN_HEIGHT == 480 {
            distanceConstraint.constant = 115
            tripPointsConstraint.constant = 180
        }else if StringConstants.SCREEN_HEIGHT == 568 {
            distanceConstraint.constant = 115
            tripPointsConstraint.constant = 180
        }else if StringConstants.SCREEN_HEIGHT == 667 {
            distanceConstraint.constant = 135
            tripPointsConstraint.constant = 220
        }else {
            distanceConstraint.constant = 150
            tripPointsConstraint.constant = 250
        }
        
        //self.layoutIfNeeded()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func shareButtonTapped(sender: AnyObject) {
        //let indexPath = (self.superview as! UITableView).indexPathForCell(self)
        
        self.delegate?.shareButtonTapped(self)
    }
}
