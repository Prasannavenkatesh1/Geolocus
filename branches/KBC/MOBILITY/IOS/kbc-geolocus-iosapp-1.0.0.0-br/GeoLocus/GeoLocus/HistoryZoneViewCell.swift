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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var indicatorButtonTapped: UIButton!
}
