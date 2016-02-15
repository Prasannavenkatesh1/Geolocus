//
//  NotificationDetailsViewController.swift
//  GeoLocus
//
//  Created by sathishkumar on 02/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class NotificationDetailsViewController: BaseViewController {

    @IBOutlet weak var notificationDescription: UILabel!
    @IBOutlet weak var competitionAcceptanceView: UIView!
    @IBOutlet weak var competitionScoresView: UIView!
    @IBOutlet weak var baseScrollView: UIScrollView!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var ShareWithKBCButton: UIButton!
    
    @IBOutlet weak var ecoScoreArc: ArcGraphicsController!
    @IBOutlet weak var overallScoreArc: ArcGraphicsController!
    @IBOutlet weak var speedingScoreArc: ArcGraphicsController!
    
    @IBOutlet weak var userEcoScoreArc: ArcGraphicsController!
    @IBOutlet weak var userOverallScoreArc: ArcGraphicsController!
    @IBOutlet weak var userSpeedingScoreArc: ArcGraphicsController!
    var notificationDetailsModel = NotificationDetailsModel?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationDescription.text = "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files , to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions"
        declineButton.layer.borderColor = UIColor(red:240/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).CGColor
        competitionAcceptanceView.hidden = true
        //competitionScoresView.hidden = true
        
        reloadView()
        
        self.navigationItem.title = "Notification"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:0/255.0, green:54/255.0, blue:101/255.0, alpha: 1.0),NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 18)!]
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "BackButton"), forState: .Normal)
        backButton.frame = CGRectMake(0, 0, 12, 21)
        backButton.addTarget(self, action: Selector("backButtonPressed:"), forControlEvents: .TouchUpInside)
        
        let kbcicon = UIImageView()
        kbcicon.image=UIImage(named: "KBCIcon")
        kbcicon.frame = CGRectMake(0, 0, 35, 32)
        let backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        let kbcIconItem:UIBarButtonItem = UIBarButtonItem(customView: kbcicon)
        
        self.navigationItem.setLeftBarButtonItems([backButtonItem,kbcIconItem], animated:true)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        //baseScrollView.contentSize = CGSizeMake(baseScrollView.frame.size.width, competitionAcceptanceView.frame.origin.y+competitionAcceptanceView.frame.size.height);
        baseScrollView.contentSize = CGSizeMake(baseScrollView.frame.size.width, competitionScoresView.frame.origin.y+competitionScoresView.frame.size.height);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButtonPressed(sender:UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func reloadView() {
        self.ecoScoreArc.foreGroundArcWidth = 4
        self.ecoScoreArc.backGroundArcWidth = 4
        self.ecoScoreArc.ringLayer.strokeColor = UIColor.orangeColor().CGColor
        self.ecoScoreArc.animateScale = 60/100.0
        self.ecoScoreArc.setNeedsDisplay()
        
        self.overallScoreArc.foreGroundArcWidth = 4
        self.overallScoreArc.backGroundArcWidth = 4
        self.overallScoreArc.ringLayer.strokeColor = UIColor.greenColor().CGColor
        self.overallScoreArc.animateScale = 60/100.0
        self.overallScoreArc.setNeedsDisplay()
        
        self.speedingScoreArc.foreGroundArcWidth = 4
        self.speedingScoreArc.backGroundArcWidth = 4
        self.speedingScoreArc.ringLayer.strokeColor = UIColor.greenColor().CGColor
        self.speedingScoreArc.animateScale = 60/100.0
        self.speedingScoreArc.setNeedsDisplay()
        
        self.userEcoScoreArc.foreGroundArcWidth = 4
        self.userEcoScoreArc.backGroundArcWidth = 4
        self.userEcoScoreArc.ringLayer.strokeColor = UIColor.orangeColor().CGColor
        self.userEcoScoreArc.animateScale = 60/100.0
        self.userEcoScoreArc.setNeedsDisplay()
        
        self.userOverallScoreArc.foreGroundArcWidth = 4
        self.userOverallScoreArc.backGroundArcWidth = 4
        self.userOverallScoreArc.ringLayer.strokeColor = UIColor.greenColor().CGColor
        self.userOverallScoreArc.animateScale = 60/100.0
        self.userOverallScoreArc.setNeedsDisplay()
        
        self.userSpeedingScoreArc.foreGroundArcWidth = 4
        self.userSpeedingScoreArc.backGroundArcWidth = 4
        self.userSpeedingScoreArc.ringLayer.strokeColor = UIColor.greenColor().CGColor
        self.userSpeedingScoreArc.animateScale = 60/100.0
        self.userSpeedingScoreArc.setNeedsDisplay()
        
        //--------------
        if self.notificationDetailsModel != nil {
            self.ecoScoreArc.foreGroundArcWidth = 4
            self.ecoScoreArc.backGroundArcWidth = 4
            self.ecoScoreArc.ringLayer.strokeColor = UIColor.greenColor().CGColor
            self.ecoScoreArc.animateScale = 60/100.0
            self.ecoScoreArc.setNeedsDisplay()
//            self.ecoScoreArc.ringLayer.strokeColor = UIColor(range: (self.notificationDetailsModel?.competition_ecoscore.integerValue)!).CGColor
//            self.ecoScoreArc.animateScale = (self.notificationDetailsModel?.competition_ecoscore.doubleValue)!/100.0
//            self.ecoScoreArc.setNeedsDisplay()
//            
//            self.overallScoreArc.foreGroundArcWidth = 4
//            self.overallScoreArc.backGroundArcWidth = 4
//            self.overallScoreArc.ringLayer.strokeColor = UIColor(range: (self.notificationDetailsModel?.competition_overallscore.integerValue)!).CGColor
//            self.overallScoreArc.animateScale = (self.notificationDetailsModel?.competition_overallscore.doubleValue)!/100.0
//            self.overallScoreArc.setNeedsDisplay()
//            
//            speedingScoreArc.foreGroundArcWidth = 4
//            speedingScoreArc.backGroundArcWidth = 4
//            speedingScoreArc.ringLayer.strokeColor = UIColor(range: (self.notificationDetailsModel?.competition_speedscore.integerValue)!).CGColor
//            speedingScoreArc.animateScale = (self.notificationDetailsModel?.competition_speedscore.doubleValue)!/100.0
//            speedingScoreArc.setNeedsDisplay()
            
           // self.totalDistTravelledLabel.text = String("\(self.overallScores!.distanceTravelled) km")
            
        }
        
        //dummy view
//        self.drivingDummyView.foreGroundArcWidth = 0
//        self.drivingDummyView.backGroundArcWidth = 0
//        self.drivingDummyView.ringLayer.strokeColor = self.view.backgroundColor!.CGColor
//        self.drivingDummyView.animateScale = 0.0
//        self.drivingDummyView.setNeedsDisplay()
//        
//        //dummy view
//        self.drivingDummySecView.foreGroundArcWidth = 0
//        self.drivingDummySecView.backGroundArcWidth = 0
//        self.drivingDummySecView.ringLayer.strokeColor = self.view.backgroundColor!.CGColor
//        self.drivingDummySecView.animateScale = 0.0
//        self.drivingDummySecView.setNeedsDisplay()
    }
    @IBAction func didTapOnAccept(sender: AnyObject) {
        
        
    }
    @IBAction func didTapOnDecline(sender: AnyObject) {
        
        
    }
    @IBAction func didTapOnShareWithKBC(sender: AnyObject) {
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
