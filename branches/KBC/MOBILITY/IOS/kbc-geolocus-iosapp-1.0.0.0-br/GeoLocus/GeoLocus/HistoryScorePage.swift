//
//  HistoryScorePage.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class HistoryScorePage: UIViewController {

    @IBOutlet weak var drivingBehaviorArcView: ArcGraphicsController!
    @IBOutlet weak var speedingArcView: ArcGraphicsController!
    @IBOutlet weak var ecoArcView: ArcGraphicsController!
    @IBOutlet weak var totalDistTravelledLabel: UILabel!
    @IBOutlet weak var drivingDummyView: ArcGraphicsController!
    @IBOutlet weak var drivingDummySecView: ArcGraphicsController!
    
    var overallScores = OverallScores?()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        reloadData()
        reloadView()
  
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
            self.drivingBehaviorArcView.ringLayer.strokeColor = UIColor.redColor().CGColor
            self.drivingBehaviorArcView.animateScale = (self.overallScores?.overallScore.doubleValue)!/100.0
            self.drivingBehaviorArcView.setNeedsDisplay()
            
            self.speedingArcView.foreGroundArcWidth = 8
            self.speedingArcView.backGroundArcWidth = 8
            self.speedingArcView.ringLayer.strokeColor = UIColor.greenColor().CGColor
            self.speedingArcView.animateScale = (self.overallScores?.speedingScore.doubleValue)!/100.0
            self.speedingArcView.setNeedsDisplay()
            
            self.ecoArcView.foreGroundArcWidth = 8
            self.ecoArcView.backGroundArcWidth = 8
            self.ecoArcView.ringLayer.strokeColor = UIColor.orangeColor().CGColor
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
        
        if StringConstants.appDataSynced {
            //get from DB and reload table
            
            fetchTripDetailsData({ (status, response, error) -> Void in
                if (status == 1 && error == nil) {
                    self.overallScores = response
                     self.reloadView()
                }else{
                    //something went wrong
                    print("error while fetching badge data from DB")
                }
            })
            
        }else{
            //call services...get data...parse
            //store data in DB
            //reload table
        }
        
        //FacadeLayer.sharedinstance.dbactions.saveOverallScore(OverallScores(overallScore: 75, speedingScore: 60, ecoScore: 30, distanceTravelled: 7564, dataUsageMsg: "message1"))
    }

    
    func fetchTripDetailsData(completionHandler:(status : Int, response: OverallScores?, error: NSError?) -> Void) -> Void{
        
        FacadeLayer.sharedinstance.dbactions.fetchOverallScoreData { (status, response, error) -> Void in
          completionHandler(status: status, response: response, error: error)
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
