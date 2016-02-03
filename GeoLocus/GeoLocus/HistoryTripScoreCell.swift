//
//  HistoryTripScoreCell.swift
//  GeoLocus
//
//  Created by CTS MAC on 28/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class HistoryTripScoreCell: UITableViewCell {

    @IBOutlet weak var speedingView: ArcGraphicsController!
    @IBOutlet weak var ecoView: ArcGraphicsController!
    @IBOutlet weak var attentionView: ArcGraphicsController!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
