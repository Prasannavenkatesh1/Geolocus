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
    @IBOutlet weak var tripStatusImage: UIImageView!
    
    var plistLevelArray     = []
    var snoozingViewController : UIViewController!
    var scoreMessage :String = String()
    var nextLevelMessage :String = String()
    
    @IBAction func startStopButtonTapped(sender: AnyObject) {
        
        if(sender.currentTitle == "Start" ){
            self.createAlertView(StringConstants.START_TRIP_MESSAGE, firstButtonTitle: StringConstants.YES, secondButtonTitle: StringConstants.NO, thirdButtonTitle: "")
        }
        else{
            self.createAlertView(StringConstants.STOP_TRIP_MESSAGE, firstButtonTitle: StringConstants.STOP, secondButtonTitle: StringConstants.CANCEL, thirdButtonTitle: StringConstants.CONTINUE)
        }
    }
    
    /* passing button titles and alert title to alertview */
    func createAlertView(alertTitle : String, firstButtonTitle : String, secondButtonTitle : String, thirdButtonTitle : String){
        
        let alertView = UIAlertController(title: "", message: alertTitle , preferredStyle: UIAlertControllerStyle.Alert)
        alertView.addAction(UIAlertAction(title: firstButtonTitle, style: UIAlertActionStyle.Default, handler: nil))
        alertView.addAction(UIAlertAction(title: secondButtonTitle, style: UIAlertActionStyle.Default, handler: nil))
        
        if(thirdButtonTitle != ""){
            alertView.addAction(UIAlertAction(title: thirdButtonTitle, style: UIAlertActionStyle.Default, handler: nil))
        }
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    
    
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
       // self.startLoading()
        
        FacadeLayer.sharedinstance.fetchDashboardData { (status, data, error) -> Void in
            if (status == 1 && error == nil){
               //  self.stopLoading()
                let dashboardData :DashboardModel = data!
                self.levelName.text = dashboardData.levelName
                self.distanceTravelledValue.text = dashboardData.distanceTravelled
                var score = Int(dashboardData.score)
                self.scoreMessage = dashboardData.scoreMessage
                self.nextLevelMessage = dashboardData.levelMessage
                
                var tripStatus = dashboardData.tripStatus
                
                switch tripStatus {
                case "EQUAL", "equal":
                    self.tripStatusImage.hidden = true
                case "UP", "up", "Up":
                    self.tripStatusImage.hidden = false
                    self.tripStatusImage.image = UIImage(named:"thumb_up.png")
                case "DOWN","down","Down":
                    self.tripStatusImage.hidden = false
                    self.tripStatusImage.image = UIImage(named:"thumb_down.png")
                default:
                    self.tripStatusImage.hidden = true
                }
                
//                                let arcViewTap = UITapGestureRecognizer(target: self, action: Selector("handleTapOnArcView:"))
//                                arcViewTap.delegate = self
//                                self.arcView.addGestureRecognizer(arcViewTap)
//                
//                                let levelMessageTap = UITapGestureRecognizer(target: self, action: Selector("handleTapOnLevelMessage:"))
//                                levelMessageTap.delegate = self
//                                self.levelName.addGestureRecognizer(levelMessageTap)
                
                var attributedString : NSMutableAttributedString = NSMutableAttributedString(string: "Contracts points earned:"+dashboardData.pointsAchieved, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Medium",size: 16.0)!])
                attributedString.addAttribute(NSForegroundColorAttributeName,value: UIColor(netHex: 0x181F29),
                    range: NSRange(location:0,length:24))
                attributedString.addAttribute(NSForegroundColorAttributeName,value: UIColor(netHex: 0x00ACEF),
                    range: NSRange(location:25,length:attributedString.length - 25))
                self.contractsPointsEarnedValue.attributedText = attributedString

                
                //1. Get data from plist
                let path                = NSBundle.mainBundle().pathForResource("BadgesDetails", ofType: "plist")
                let dataDict            = NSDictionary(contentsOfFile: path!)
                self.plistLevelArray    = (dataDict?.valueForKey("level"))! as! NSArray
                
                for levelDict in self.plistLevelArray {
                    let levelName = levelDict.objectForKey("title")
                    if levelName?.lowercaseString == dashboardData.levelName.lowercaseString{
                        let levelImageName = levelDict.objectForKey("icon_not_earned") as! String
                        self.levelImage.image = UIImage(named:levelImageName)
                        break
                    }
                }
                
                if !(dashboardData.totalPoints.isEmpty) && !(dashboardData.pointsAchieved.isEmpty){
                    let totalPoints = Float(dashboardData.totalPoints)
                    let pointsAchieved = Float(dashboardData.pointsAchieved)
                    let progressFraction = Float(totalPoints!/pointsAchieved!)
                    self.pointsAchievedProgressView.setProgress(1/progressFraction, animated: false)
                }

                self.customiseProgressView()
                //  customColorAndFontSetup()
                //self.startStopButton.layer.cornerRadius = 15.0
                // Do any additional setup after loading the view.
                if let dashboardScore = score{
                     self.arcView.ringLayer.strokeColor = UIColor(range: dashboardScore).CGColor
                }
                self.arcView.foreGroundArcWidth = 10.0
                if let dashboardScore = score{
                    self.arcView.animateScale = Double(dashboardScore)/100
                }
                self.arcView.setNeedsDisplay()
            }else{
                //something went bad
            }
        }

        
        
//        FacadeLayer.sharedinstance.fetchDashboardData{ (status, data, error) -> Void in
//            if(status == 1 && error == nil) {
//                self.stopLoading()
//                print(data)
//                let dashboardData :DashboardModel = data!
//                self.levelName.text = dashboardData.levelName
//                self.distanceTravelledValue.text = dashboardData.distanceTravelled
//                 var score = Int(dashboardData.score)
//                
//                self.customiseProgressView()
//                //  customColorAndFontSetup()
//                self.startStopButton.layer.cornerRadius = 15.0
//                // Do any additional setup after loading the view.
//                self.arcView.ringLayer.strokeColor = UIColor.redColor().CGColor
//                self.arcView.foreGroundArcWidth = 10.0
//                if let dashboardScore = score{
//                    self.arcView.animateScale = Double(dashboardScore)/100
//                }
//                self.arcView.setNeedsDisplay()
//
//            }else{
//                //something went wrong
//                self.stopLoading()
//                
//            }
//            //self.hideActivityIndicator()
//        }

    }
    
    func handleTapOnArcView(sender:AnyObject){
        self.createAlertView(self.scoreMessage, firstButtonTitle: StringConstants.OK, secondButtonTitle: "", thirdButtonTitle: "")
    }
    
    func handleTapOnLevelMessage(sender:AnyObject){
        self.createAlertView(self.nextLevelMessage, firstButtonTitle: StringConstants.OK, secondButtonTitle: "", thirdButtonTitle: "")
    }
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
