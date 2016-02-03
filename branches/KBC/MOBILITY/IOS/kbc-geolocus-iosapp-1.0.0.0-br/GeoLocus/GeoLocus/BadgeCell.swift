//
//  BadgeCell.swift
//  GeoLocus
//
//  Created by CTS MAC on 25/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class BadgeCell: UITableViewCell {

    
    @IBOutlet weak var badgeIcon: UIImageView!
    @IBOutlet weak var badgeTitle: UILabel!
    @IBOutlet weak var badgeDescription: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
