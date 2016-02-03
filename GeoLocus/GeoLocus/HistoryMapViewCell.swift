//
//  HistoryMapViewCell.swift
//  GeoLocus
//
//  Created by CTS MAC on 30/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit
import MapKit

class HistoryMapViewCell: UITableViewCell {

    
    @IBOutlet weak var historyMapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
