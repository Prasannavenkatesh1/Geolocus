//
//  BadgeCell.swift
//  GeoLocus
//
//  Created by CTS MAC on 25/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class BadgeCell: UITableViewCell {

    
    @IBOutlet weak var badgeIcon        : UIImageView!
    @IBOutlet weak var badgeTitle       : UILabel!
    @IBOutlet weak var badgeDescription : UILabel!
    @IBOutlet weak var shareButton      : UIButton!
    
    var delegate: BadgesDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension BadgeCell {
    
    func configure(badge: Badge) -> Void {
        
        if badge.isEarned {
            self.shareButton.hidden         = false
            self.badgeTitle.font            = UIFont(name: Font.HELVETICA_NEUE_MEDIUM, size: 15.0)
            self.badgeTitle.textColor       = UIColor(netHex: 0x003665)
            self.badgeDescription.textColor = UIColor(netHex: 0x181F29)
            
        }else {
            self.shareButton.hidden         = true         
            self.badgeTitle.font            = UIFont(name: Font.HELVETICA_NEUE, size: 15.0)
            self.badgeTitle.textColor       = UIColor(netHex: 0x003665)
            self.badgeDescription.textColor = UIColor(netHex: 0x4c7394)
        }
        
        self.badgeIcon.image        = UIImage(named: badge.badgeIcon)
        self.badgeTitle.text        = badge.badgeTitle
        
        if let addMsg = badge.additionalMsg {
            self.badgeDescription.text  = badge.badgeDescription + "\n" + addMsg
        }else{
            self.badgeDescription.text  = badge.badgeDescription
        }
        
        let attributes      = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let attributedText  = NSAttributedString(string: self.shareButton.currentTitle!, attributes: attributes)
        self.shareButton.titleLabel?.attributedText = attributedText
        self.shareButton.addTarget(self, action: "shareButtonTapped:", forControlEvents: .TouchUpInside)
    }
    
    
    func shareButtonTapped(sender: UIButton!) {
        delegate?.shareButtonTapped(sender)
    }
}
