//
//  HistoryScorePage.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class HistoryScorePage: BaseViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var drivingBehaviorArcView   : ArcGraphicsController!
    @IBOutlet weak var speedingArcView          : ArcGraphicsController!
    @IBOutlet weak var ecoArcView               : ArcGraphicsController!
    @IBOutlet weak var totalDistTravelledLabel  : UILabel!
    @IBOutlet weak var attentionView            : UIView!
    @IBOutlet weak var scrollContentView        : UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var drivingBehaviourLabel    : UILabel!
    @IBOutlet weak var speedingLabel            : UILabel!
    @IBOutlet weak var ecoLabel                 : UILabel!
    @IBOutlet weak var attentionLabel           : UILabel!
    @IBOutlet weak var distanceLabel            : UILabel!
    @IBOutlet weak var overallScoreLabel        : UILabel!
    
    
    var driveBehTapGestureRecognizer    : UITapGestureRecognizer!
    var speedingTapGestureRecognizer    : UITapGestureRecognizer!
    var ecoTapGestureRecognizer         : UITapGestureRecognizer!
    var attentionTapGestureRecognizer   : UITapGestureRecognizer!
    var overallScores                   = OverallScores?()
    let scoreTapSelector                : Selector = "scoreViewTapped:"
    
    //MARK: - Viewcontroller methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setContentHeight()
        reloadView()        //to check dummy view
        reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
    }
    
    //MARK: - Reload Methods
    /**
     Reload Overallscore page.
    */
    func reloadView() {
        if self.overallScores != nil {
            
            self.overallScoreLabel.text     = LocalizationConstants.OverallScore.Score_Title.localized()
            self.drivingBehaviourLabel.text = LocalizationConstants.OverallScore.Driving_Behavior.localized()
            self.speedingLabel.text         = LocalizationConstants.OverallScore.Speeding.localized()
            self.ecoLabel.text              = LocalizationConstants.OverallScore.Eco.localized()
            self.attentionLabel.text        = LocalizationConstants.OverallScore.Attention.localized()
            self.distanceLabel.text         = LocalizationConstants.OverallScore.Distance_Travelled.localized()
            
            self.drivingBehaviorArcView.foreGroundArcWidth      = Arc.FOREGROUND_WIDTH
            self.drivingBehaviorArcView.backGroundArcWidth      = Arc.BACKGROUND_WIDTH
            self.drivingBehaviorArcView.ringLayer.strokeColor   = UIColor(range: (self.overallScores?.overallScore.integerValue)!).CGColor
            self.drivingBehaviorArcView.animateScale            = (self.overallScores?.overallScore.doubleValue)!/100.0
            self.drivingBehaviorArcView.setNeedsDisplay()
            
            self.speedingArcView.foreGroundArcWidth             = Arc.FOREGROUND_WIDTH
            self.speedingArcView.backGroundArcWidth             = Arc.BACKGROUND_WIDTH
            self.speedingArcView.ringLayer.strokeColor          = UIColor(range: (self.overallScores?.speedingScore.integerValue)!).CGColor
            self.speedingArcView.animateScale                   = (self.overallScores?.speedingScore.doubleValue)!/100.0
            self.speedingArcView.setNeedsDisplay()
            
            self.ecoArcView.foreGroundArcWidth                  = Arc.FOREGROUND_WIDTH
            self.ecoArcView.backGroundArcWidth                  = Arc.BACKGROUND_WIDTH
            self.ecoArcView.ringLayer.strokeColor               = UIColor(range: (self.overallScores?.ecoScore.integerValue)!).CGColor
            self.ecoArcView.animateScale                        = (self.overallScores?.ecoScore.doubleValue)!/100.0
            self.ecoArcView.setNeedsDisplay()
            
            self.totalDistTravelledLabel.text                   = String("\(self.overallScores!.distanceTravelled) km")
            
            self.driveBehTapGestureRecognizer                   = UITapGestureRecognizer(target: self, action: scoreTapSelector)
            self.driveBehTapGestureRecognizer.delegate          = self
            self.drivingBehaviorArcView.addGestureRecognizer(self.driveBehTapGestureRecognizer)
            self.drivingBehaviorArcView.tag                     = Tag.OverallScore.View.driving
            
            self.speedingTapGestureRecognizer                   = UITapGestureRecognizer(target: self, action: scoreTapSelector)
            self.speedingTapGestureRecognizer.delegate          = self
            self.speedingArcView.addGestureRecognizer(self.speedingTapGestureRecognizer)
            self.speedingArcView.tag                            = Tag.OverallScore.View.speeding
            
            self.ecoTapGestureRecognizer                        = UITapGestureRecognizer(target: self, action: scoreTapSelector)
            self.ecoTapGestureRecognizer.delegate               = self
            self.ecoArcView.addGestureRecognizer(self.ecoTapGestureRecognizer)
            self.ecoArcView.tag                                 = Tag.OverallScore.View.eco
            
            self.attentionTapGestureRecognizer                  = UITapGestureRecognizer(target: self, action: scoreTapSelector)
            self.attentionTapGestureRecognizer.delegate         = self
            self.attentionView.addGestureRecognizer(self.attentionTapGestureRecognizer)
            self.attentionView.tag                              = Tag.OverallScore.View.attention
        }
    }
    
    /**
     Get data from DB and reload the page
     */
    func reloadData() {
        
        FacadeLayer.sharedinstance.fetchOverallScoreData { (status, data, error) -> Void in
            if (status == 1 && error == nil){
                self.overallScores = data
                self.reloadView()
            }else{
                //something went wrong
            }
        }
    }
    
    /**
     Setter for the height of the scroll view
     */
    func setContentHeight() {
        
        if StringConstants.SCREEN_HEIGHT == 480 {
            self.contentViewHeightConstraint.constant = 500
        }else if StringConstants.SCREEN_HEIGHT == 568 {
            self.contentViewHeightConstraint.constant = 500
        }else if StringConstants.SCREEN_HEIGHT == 667 {
            self.contentViewHeightConstraint.constant = StringConstants.SCREEN_HEIGHT - 105
        }else {
            self.contentViewHeightConstraint.constant = StringConstants.SCREEN_HEIGHT - 105
        }
    }
    
    //MARK: - Gesture Recognizer Methods
    
    /**
     Called when score views are tapped
     - Parameter gestureRecognizer: To get the data of gesture used
     */
    func scoreViewTapped(gestureRecognizer: UITapGestureRecognizer) {
        
        var messageString = String()
        let view = gestureRecognizer.view! as UIView

        switch view.tag {
            case 101 :
                messageString = self.overallScores!.overallmessage
            case 102 :
                messageString = self.overallScores!.speedingMessage
            case 103:
                messageString = self.overallScores!.ecoMessage
            case 104:
                messageString = self.overallScores!.dataUsageMsg
            default:
                messageString = " "
        }
        
        let alert = UIAlertController(title: nil, message:messageString , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
