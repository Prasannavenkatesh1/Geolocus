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
    @IBOutlet weak var drivingDummyView         : ArcGraphicsController!
    @IBOutlet weak var drivingDummySecView      : ArcGraphicsController!
    @IBOutlet weak var attentionView            : UIView!
    @IBOutlet weak var scrollContentView        : UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    var driveBehTapGestureRecognizer    : UITapGestureRecognizer!
    var speedingTapGestureRecognizer    : UITapGestureRecognizer!
    var ecoTapGestureRecognizer         : UITapGestureRecognizer!
    var attentionTapGestureRecognizer   : UITapGestureRecognizer!
    var overallScores                   = OverallScores?()
    
    
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
    
    /**
     Reload Overallscore page.
    */
    func reloadView() {
        if self.overallScores != nil {
            self.drivingBehaviorArcView.foreGroundArcWidth = Arc.FOREGROUND_WIDTH
            self.drivingBehaviorArcView.backGroundArcWidth = Arc.BACKGROUND_WIDTH
            self.drivingBehaviorArcView.ringLayer.strokeColor = UIColor(range: (self.overallScores?.overallScore.integerValue)!).CGColor
            self.drivingBehaviorArcView.animateScale = (self.overallScores?.overallScore.doubleValue)!/100.0
            self.drivingBehaviorArcView.setNeedsDisplay()
            
            self.speedingArcView.foreGroundArcWidth = Arc.FOREGROUND_WIDTH
            self.speedingArcView.backGroundArcWidth = Arc.BACKGROUND_WIDTH
            self.speedingArcView.ringLayer.strokeColor = UIColor(range: (self.overallScores?.speedingScore.integerValue)!).CGColor
            self.speedingArcView.animateScale = (self.overallScores?.speedingScore.doubleValue)!/100.0
            self.speedingArcView.setNeedsDisplay()
            
            self.ecoArcView.foreGroundArcWidth = Arc.FOREGROUND_WIDTH
            self.ecoArcView.backGroundArcWidth = Arc.BACKGROUND_WIDTH
            self.ecoArcView.ringLayer.strokeColor = UIColor(range: (self.overallScores?.ecoScore.integerValue)!).CGColor
            self.ecoArcView.animateScale = (self.overallScores?.ecoScore.doubleValue)!/100.0
            self.ecoArcView.setNeedsDisplay()
            
            self.totalDistTravelledLabel.text = String("\(self.overallScores!.distanceTravelled) km")
            
            self.driveBehTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "drivingBehaviourViewTapped:")
            self.driveBehTapGestureRecognizer.delegate = self
            self.drivingBehaviorArcView.addGestureRecognizer(self.driveBehTapGestureRecognizer)
            
            self.speedingTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "speedingViewTapped:")
            self.speedingTapGestureRecognizer.delegate = self
            self.speedingArcView.addGestureRecognizer(self.speedingTapGestureRecognizer)
            
            self.ecoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "ecoViewTapped:")
            self.ecoTapGestureRecognizer.delegate = self
            self.ecoArcView.addGestureRecognizer(self.ecoTapGestureRecognizer)
            
            self.attentionTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "attentionViewTapped:")
            self.attentionTapGestureRecognizer.delegate = self
            self.attentionView.addGestureRecognizer(self.attentionTapGestureRecognizer)
            
        }
        
        //dummy view
        self.drivingDummyView.foreGroundArcWidth = 0
        self.drivingDummyView.backGroundArcWidth = 0
        self.drivingDummyView.ringLayer.strokeColor = UIColor.clearColor().CGColor
        self.drivingDummyView.animateScale = 0.0
        self.drivingDummyView.setNeedsDisplay()
        
        //dummy view
        self.drivingDummySecView.foreGroundArcWidth = 0
        self.drivingDummySecView.backGroundArcWidth = 0
        self.drivingDummySecView.ringLayer.strokeColor = UIColor.clearColor().CGColor
        self.drivingDummySecView.animateScale = 0.0
        self.drivingDummySecView.setNeedsDisplay()
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
                //something went bad
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
    
    /**
     Called when driving behaviour view is tapped
     - Parameter gestureRecognizer: To get the data of gesture used
     */
    func drivingBehaviourViewTapped(gestureRecognizer: UITapGestureRecognizer){
        scoreViewTapped(1)
    }
    
    /**
     Called when speeding view is tapped
     - Parameter gestureRecognizer: To get the data of gesture used
     */
    func speedingViewTapped(gestureRecognizer: UITapGestureRecognizer){
        scoreViewTapped(2)
    }
    
    /**
     Called when eco view is tapped
     - Parameter gestureRecognizer: To get the data of gesture used
     */
    func ecoViewTapped(gestureRecognizer: UITapGestureRecognizer){
        scoreViewTapped(3)
    }
    
    /**
     Called when attention view is tapped
     - Parameter gestureRecognizer: To get the data of gesture used
     */
    func attentionViewTapped(gestureRecognizer: UITapGestureRecognizer){
        scoreViewTapped(4)
    }
    
    /**
     Aggregate function for scoreview tapped
     */
    func scoreViewTapped(tag: Int) {
        
        var messageString = String()
        
        switch tag {
        case 1 :
            messageString = self.overallScores!.overallmessage
        case 2 :
            messageString = self.overallScores!.speedingMessage
        case 3:
            messageString = self.overallScores!.ecoMessage
        case 4:
            messageString = self.overallScores!.dataUsageMsg
        default:
            messageString = " "
        }
        
        let alert = UIAlertController(title: nil, message:messageString , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

}
