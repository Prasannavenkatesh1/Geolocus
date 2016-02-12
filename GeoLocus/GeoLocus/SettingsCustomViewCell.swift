//
//  SettingsCustomViewCell.swift
//  GeoLocus
//
//  Created by Saranya on 11/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

class SettingsCustomViewCell : UITableViewCell{
    
    @IBOutlet weak var settingsSwitch: UISwitch!
    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}