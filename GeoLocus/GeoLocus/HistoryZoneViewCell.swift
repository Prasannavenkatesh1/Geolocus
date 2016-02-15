//
//  HistoryZoneViewCell.swift
//  GeoLocus
//
//  Created by CTS MAC on 30/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class HistoryZoneViewCell: UITableViewCell {

    @IBOutlet weak var maxSpeedLimit: UILabel!
    @IBOutlet weak var indicatorButton: UIButton!
    @IBOutlet weak var speedingView: ArcGraphicsController!
    @IBOutlet weak var severeViolationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var withinMaxSpeedLabel: UILabel!
    @IBOutlet weak var aboveMaxSpeedLabel: UILabel!
    @IBOutlet weak var severeViolationView: UIView!
    
    var svGestureReconizer = UITapGestureRecognizer()
    var delegate: SpeedZoneCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.svGestureReconizer = UITapGestureRecognizer(target: self, action: "severeViolationViewTapped:")
        self.svGestureReconizer.delegate = self
        self.severeViolationView.addGestureRecognizer(self.svGestureReconizer)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func severeViolationViewTapped(gestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.severeViolationViewTapped()
    }
}
