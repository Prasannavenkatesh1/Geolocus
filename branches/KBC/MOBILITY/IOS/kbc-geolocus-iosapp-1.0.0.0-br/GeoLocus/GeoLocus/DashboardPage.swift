//
//  DashboardPage.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit



 class DashboardPage: BaseViewController {

    
 //MARK: IBOutlets
    @IBOutlet weak var levelImage: UIImageView!
    @IBOutlet weak var levelName: UILabel!
    @IBOutlet weak var arcView: ArcGraphicsController!
    @IBOutlet weak var pointsAchievedProgressView: UIProgressView!
    @IBOutlet weak var distanceTravelledValue: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var contractsPointsEarnedValue: UILabel!
    @IBOutlet weak var distanceTravelledLabel: UILabel!
    
    var snoozingViewController : UIViewController!
    
    
    //MARK: System Delegates
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.handleGetDashboardDetails()
//        snoozingViewController = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewControllerWithIdentifier("SnoozingController")
//        //snoozeController.view.frame = CGRectMake(10, 40, 280, 295)
//        snoozingViewController.view.frame = CGRectMake(10, 40, 280, 295)
//        self.presentPopUpController(snoozingViewController)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleGetDashboardDetails(){
        
        FacadeLayer.sharedinstance.fetchDashboardData{ (status, data, error) -> Void in
            if(status == 1 && error == nil) {
                
                print(data)
                let dashboardData :DashboardModel = data!
                self.levelName.text = dashboardData.levelName
                 var score = Int(dashboardData.score)
                
                self.customiseProgressView()
                //  customColorAndFontSetup()
                self.startStopButton.layer.cornerRadius = 15.0
                // Do any additional setup after loading the view.
                self.arcView.ringLayer.strokeColor = UIColor.redColor().CGColor
                self.arcView.foreGroundArcWidth = 10.0
                self.arcView.animateScale = 0.75
                self.arcView.setNeedsDisplay()

            }else{
                //something went wrong
                
            }
            //self.hideActivityIndicator()
        }

        
        
        
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

//All internal methods are written inside dashboardpage extension
extension DashboardPage {
    
    func customiseProgressView(){
        pointsAchievedProgressView.transform = CGAffineTransformScale(pointsAchievedProgressView.transform, 1, 5)
    }

    func customColorAndFontSetup() {
    
        levelName.textColor = UIColor(netHex: 0x181f29)
        distanceTravelledLabel.textColor = UIColor(netHex: 0x181f29)
        distanceTravelledValue.textColor = UIColor(netHex: 0x00acef)
     //   pointsAchievedProgressView.backgroundColor = UIColor(netHex: 0xacbdcd)
        pointsAchievedProgressView.trackTintColor = UIColor(netHex: 0x00acef)
        
        
        
        let attributedTextColor1 =
            [NSForegroundColorAttributeName: UIColor(netHex: 0x181f29),
            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)!]
        let attributedTextColor2 = [NSForegroundColorAttributeName: UIColor(netHex: 0x00acef),
                                   NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 16)! ]
        let range1 = NSRange(location: 1, length: 23)
        let range2 = NSRange(location: 24, length: 4)
        
        
        let attributedString = NSMutableAttributedString(string: contractsPointsEarnedValue.text!, attributes: attributedTextColor1)
        attributedString.addAttributes(attributedTextColor1, range: range1)
        attributedString.addAttributes(attributedTextColor2, range: range2)
        contractsPointsEarnedValue.attributedText = attributedString
        
        //53b262
       // aeaeae
        let buttonTextAttribute = [ NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16.0)!,
            NSBackgroundColorAttributeName: UIColor(netHex: 0x53b262)]
        
        let finalButtonAttributes = NSMutableAttributedString(string: (startStopButton.titleLabel?.text)!, attributes: buttonTextAttribute)
        startStopButton.titleLabel?.attributedText = finalButtonAttributes
        startStopButton.backgroundColor = UIColor(netHex: 0xaeaeae)
        
    }
    
}
