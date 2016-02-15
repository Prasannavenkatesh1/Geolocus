//
//  HistoryScorePage.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class HistoryScorePage: BaseViewController {

    @IBOutlet weak var drivingBehaviorArcView: ArcGraphicsController!
    @IBOutlet weak var speedingArcView: ArcGraphicsController!
    @IBOutlet weak var ecoArcView: ArcGraphicsController!
    @IBOutlet weak var totalDistTravelledLabel: UILabel!
    @IBOutlet weak var drivingDummyView: ArcGraphicsController!
    @IBOutlet weak var drivingDummySecView: ArcGraphicsController!
    @IBOutlet weak var scrollContentView: UIView!
    var overallScores = OverallScores?()
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
  
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setContentHeight()
        reloadData()
        reloadView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
    }
    
    func reloadView() {
        if self.overallScores != nil {
            self.drivingBehaviorArcView.foreGroundArcWidth = 8
            self.drivingBehaviorArcView.backGroundArcWidth = 8
            self.drivingBehaviorArcView.ringLayer.strokeColor = UIColor(range: (self.overallScores?.overallScore.integerValue)!).CGColor
            self.drivingBehaviorArcView.animateScale = (self.overallScores?.overallScore.doubleValue)!/100.0
            self.drivingBehaviorArcView.setNeedsDisplay()
            
            self.speedingArcView.foreGroundArcWidth = 8
            self.speedingArcView.backGroundArcWidth = 8
            self.speedingArcView.ringLayer.strokeColor = UIColor(range: (self.overallScores?.speedingScore.integerValue)!).CGColor
            self.speedingArcView.animateScale = (self.overallScores?.speedingScore.doubleValue)!/100.0
            self.speedingArcView.setNeedsDisplay()
            
            self.ecoArcView.foreGroundArcWidth = 8
            self.ecoArcView.backGroundArcWidth = 8
            self.ecoArcView.ringLayer.strokeColor = UIColor(range: (self.overallScores?.ecoScore.integerValue)!).CGColor
            self.ecoArcView.animateScale = (self.overallScores?.ecoScore.doubleValue)!/100.0
            self.ecoArcView.setNeedsDisplay()
            
            self.totalDistTravelledLabel.text = String("\(self.overallScores!.distanceTravelled) km")
            
        }
        
        //dummy view
        self.drivingDummyView.foreGroundArcWidth = 0
        self.drivingDummyView.backGroundArcWidth = 0
        self.drivingDummyView.ringLayer.strokeColor = self.view.backgroundColor!.CGColor
        self.drivingDummyView.animateScale = 0.0
        self.drivingDummyView.setNeedsDisplay()
        
        //dummy view
        self.drivingDummySecView.foreGroundArcWidth = 0
        self.drivingDummySecView.backGroundArcWidth = 0
        self.drivingDummySecView.ringLayer.strokeColor = self.view.backgroundColor!.CGColor
        self.drivingDummySecView.animateScale = 0.0
        self.drivingDummySecView.setNeedsDisplay()
    }
    
    func reloadData() {
        //fetch the data
        //populate the data structure
        //load the views
            
            /*FacadeLayer.sharedinstance.fetchOverallScoreData({ (status, data, error) -> Void in
                if (status == 1 && error == nil) {
                    self.overallScores = data
                    self.reloadView()
                }else{
                    //something went wrong
                    print("error while fetching badge data from DB")
                }
            })*/
        
        
//        FacadeLayer.sharedinstance.dbactions.saveOverallScore(OverallScores(overallScore: 75, speedingScore: 60, ecoScore: 30, distanceTravelled: 7564, dataUsageMsg: "25")) { (status) -> Void in
//            print("saved")
//        }
        
    }

    
    /*func fetchTripDetailsData(completionHandler:(status : Int, response: OverallScores?, error: NSError?) -> Void) -> Void{
        
        FacadeLayer.sharedinstance.dbactions.fetchOverallScoreData { (status, response, error) -> Void in
          completionHandler(status: status, response: response, error: error)
        }
    }
    
    func requestOverallScoreData(completionHandler:(status: Int, data: OverallScores?, error: NSError?) -> Void) -> Void{
        
        FacadeLayer.sharedinstance.requestOverallScoreData { (status, data, error) -> Void in
            completionHandler(status: status, data: data, error: error)
        }
    }*/
    
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
    
    //
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
