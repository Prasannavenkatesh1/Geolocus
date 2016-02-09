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
    @IBOutlet weak var attentionView: UIView!
    
    var delegate: ScoreCellDelegate?
    
    var speedingTapGestureRecognizer : UITapGestureRecognizer!
    var ecoTapGestureRecognizer : UITapGestureRecognizer!
    var attentionTapGestureRecognizer : UITapGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.speedingTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "speedingViewTapped:")
        self.speedingTapGestureRecognizer.delegate = self
        self.speedingView.addGestureRecognizer(self.speedingTapGestureRecognizer)
        
        self.ecoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "ecoViewTapped:")
        self.ecoTapGestureRecognizer.delegate = self
        self.ecoView.addGestureRecognizer(self.ecoTapGestureRecognizer)
        
        self.attentionTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "attentionViewTapped:")
        self.attentionTapGestureRecognizer.delegate = self
        self.attentionView.addGestureRecognizer(self.attentionTapGestureRecognizer)
    }
    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
//    {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.selectionStyle = UITableViewCellSelectionStyle.None
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func speedingViewTapped(gestureRecognizer: UITapGestureRecognizer){
        delegate?.scoreViewTapped(1)
    }
    
    func ecoViewTapped(gestureRecognizer: UITapGestureRecognizer){
        delegate?.scoreViewTapped(2)
    }
    
    func attentionViewTapped(gestureRecognizer: UITapGestureRecognizer){
        delegate?.scoreViewTapped(3)
    }

}
