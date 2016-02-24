//
//  HistoryTripScoreCell.swift
//  GeoLocus
//
//  Created by CTS MAC on 28/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class HistoryTripScoreCell: UITableViewCell {

    @IBOutlet weak var speedingView : ArcGraphicsController!
    @IBOutlet weak var ecoView      : ArcGraphicsController!
    @IBOutlet weak var attentionView: UIView!
    
    var speedingTapGestureRecognizer  : UITapGestureRecognizer!
    var ecoTapGestureRecognizer       : UITapGestureRecognizer!
    var attentionTapGestureRecognizer : UITapGestureRecognizer!
    var delegate                      : ScoreCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.speedingTapGestureRecognizer          = UITapGestureRecognizer(target: self, action: "speedingViewTapped:")
        self.speedingTapGestureRecognizer.delegate = self
        self.speedingView.addGestureRecognizer(self.speedingTapGestureRecognizer)
        
        self.ecoTapGestureRecognizer          = UITapGestureRecognizer(target: self, action: "ecoViewTapped:")
        self.ecoTapGestureRecognizer.delegate = self
        self.ecoView.addGestureRecognizer(self.ecoTapGestureRecognizer)
        
        self.attentionTapGestureRecognizer          = UITapGestureRecognizer(target: self, action: "attentionViewTapped:")
        self.attentionTapGestureRecognizer.delegate = self
        self.attentionView.addGestureRecognizer(self.attentionTapGestureRecognizer)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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


extension HistoryTripScoreCell {
    
    func configure(tripScore: TripScore?) -> Void {
        self.speedingView.foreGroundArcWidth = Arc.FOREGROUND_WIDTH
        self.speedingView.backGroundArcWidth = Arc.BACKGROUND_WIDTH
        self.ecoView.foreGroundArcWidth      = Arc.FOREGROUND_WIDTH
        self.ecoView.backGroundArcWidth      = Arc.BACKGROUND_WIDTH
        
        if let score = tripScore {
            self.speedingView.ringLayer.strokeColor = UIColor(range:score.speedScore.integerValue).CGColor
            self.speedingView.animateScale          = score.speedScore.doubleValue/100.0
            self.ecoView.ringLayer.strokeColor      = UIColor(range:score.ecoScore.integerValue).CGColor
            self.ecoView.animateScale               = score.ecoScore.doubleValue/100.0
        }
        
        if let del = self.delegate {
            if del.scoreCellRefreshRequired() {
                self.speedingView.setNeedsDisplay()
                self.ecoView.setNeedsDisplay()
            }
        }
    }
}
