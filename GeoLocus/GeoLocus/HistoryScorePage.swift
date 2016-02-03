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
    @IBOutlet weak var attentionArcView: ArcGraphicsController!
    @IBOutlet weak var totalDistTravelledLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
  
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.drivingBehaviorArcView.foreGroundArcWidth = 6
        self.drivingBehaviorArcView.backGroundArcWidth = 3
        self.drivingBehaviorArcView.ringLayer.strokeColor = UIColor.redColor().CGColor
        self.drivingBehaviorArcView.animateScale = 0.75
        self.drivingBehaviorArcView.setNeedsDisplay()
        
        self.speedingArcView.foreGroundArcWidth = 6
        self.speedingArcView.backGroundArcWidth = 3
        self.speedingArcView.ringLayer.strokeColor = UIColor.greenColor().CGColor
        self.speedingArcView.animateScale = 0.75
        self.speedingArcView.setNeedsDisplay()
        
        self.ecoArcView.foreGroundArcWidth = 6
        self.ecoArcView.backGroundArcWidth = 3
        self.ecoArcView.ringLayer.strokeColor = UIColor.orangeColor().CGColor
        self.ecoArcView.animateScale = 0.75
        self.ecoArcView.setNeedsDisplay()
        
        self.attentionArcView.foreGroundArcWidth = 6
        self.attentionArcView.backGroundArcWidth = 3
        self.attentionArcView.ringLayer.strokeColor = UIColor.yellowColor().CGColor
        self.attentionArcView.animateScale = 0.75
        self.attentionArcView.setNeedsDisplay()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
    }
    
    
    func reloadData() {
        //fetch the data
        //populate the data structure
        //load the views
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
