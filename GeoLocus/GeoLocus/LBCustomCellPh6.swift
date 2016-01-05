//
//  LBCustomCellPh6.swift
//  GeoLocus
//
//  Created by macuser on 06/07/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

import UIKit

class LBCustomCellPh6: UITableViewCell {

    @IBOutlet weak var lapLabel: UILabel!
    @IBOutlet weak var processDateLabel: UILabel!
    @IBOutlet weak var distanceDrivenLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected (selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
