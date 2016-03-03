//
//  DashboardPage.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit


 class DashboardPage: BaseViewController, UIGestureRecognizerDelegate {

    
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
    
    @IBOutlet weak var levelView: UIView!
    @IBOutlet weak var distanceTravelledTitle : UILabel!
    
    
    var plistLevelArray     = []
    var snoozingViewController : UIViewController!
    var scoreMessage :String = String()
    var nextLevelMessage :String = String()
    var pointsEarnedString :String = String()
    
  @IBAction func startStopButtonTapped(sender: AnyObject) {
    if(sender.currentTitle == "Start" ){
      
      self.createAlertView(StringConstants.START_TRIP_MESSAGE, firstButtonTitle: StringConstants.YES, secondButtonTitle: StringConstants.NO, thirdButtonTitle: "", alerttag:100)
    }
    else{
      
      self.createAlertView(StringConstants.STOP_TRIP_MESSAGE, firstButtonTitle: StringConstants.STOP, secondButtonTitle: StringConstants.CANCEL, thirdButtonTitle: StringConstants.CONTINUE, alerttag:101)
    }
  }
  

    
    /* passing button titles and alert title to alertview */
  func createAlertView(alertTitle : String, firstButtonTitle : String, secondButtonTitle : String, thirdButtonTitle : String , alerttag:Int){
    
    let alertView = UIAlertController(title: "", message: alertTitle , preferredStyle: UIAlertControllerStyle.Alert)
    
    alertView.addAction(UIAlertAction(title: firstButtonTitle, style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
      if alerttag == 101
      {
        // stop and save trip in db
        //          NSNotificationCenter.defaultCenter().postNotificationName("tipended", object: nil)
        FacadeLayer.sharedinstance.isMannualTrip = false
        self.startStopButton.setTitle("Start", forState: .Normal)
        
      }
      else if alerttag == 100
      {
        FacadeLayer.sharedinstance.isMannualTrip = true
        FacadeLayer.sharedinstance.corelocation.generateTipID()
        self.startStopButton.setTitle("Stop", forState: .Normal)
      }
      
    }))
    
    if secondButtonTitle != "" {
    alertView.addAction(UIAlertAction(title: secondButtonTitle, style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
      if alerttag == 101
      {
        FacadeLayer.sharedinstance.isMannualTrip = false
        self.startStopButton.setTitle("Start", forState: .Normal)
        
        // cancel the trip and delete the trip details in db
        FacadeLayer.sharedinstance.corelocation.deleteTripDatas()
        
      }
      else if alerttag == 100
      {
        
        //No Tapped - present snooze
        //          FacadeLayer.sharedinstance.isMannualTrip = true
        //          FacadeLayer.sharedinstance.corelocation.generateTipID()
        //          self.startStopButton.setTitle("Stop", forState: .Normal)
        
      }
      
      
    })) }
    
    if(thirdButtonTitle != ""){
      alertView.addAction(UIAlertAction(title: thirdButtonTitle, style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
        print(thirdButtonTitle);
        FacadeLayer.sharedinstance.isMannualTrip = true
      }))
      
        }
    self.presentViewController(alertView, animated: true, completion: nil)
  }
  
    
    
    
    //MARK: System Delegates
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.setTitleForLabels()
      self.handleGetDashboardDetails()
      self.customiseProgressView()
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTitleForLabels(){
        pointsEarnedString = LocalizationConstants.Contracts_Points_Earned.localized()
      
        let attributedString : NSMutableAttributedString = NSMutableAttributedString(string: pointsEarnedString)
        attributedString.addAttribute(NSForegroundColorAttributeName,value: UIColor(netHex: 0x181F29),
            range: NSRange(location:0,length:attributedString.length))
      
      if pointsEarnedString == "" { self.contractsPointsEarnedValue.text = StringConstants.NO_CONTRACT }
      else { self.contractsPointsEarnedValue.attributedText = attributedString }
        self.distanceTravelledTitle.text = LocalizationConstants.Distance_Travelled.localized()
        
    }
    
    func handleGetDashboardDetails(){
       // self.startLoading()
        
        FacadeLayer.sharedinstance.fetchDashboardData { (status, data, error) -> Void in
            if (status == 1 && error == nil){
               //  self.stopLoading()
                let dashboardData :DashboardModel = data!
                self.levelName.text = dashboardData.levelName
                self.distanceTravelledValue.text = dashboardData.distanceTravelled + " km"
                let score = Int(dashboardData.score)
                self.scoreMessage = dashboardData.scoreMessage
                self.nextLevelMessage = dashboardData.levelMessage
                
                let tripStatus = dashboardData.tripStatus
                
                switch tripStatus.lowercaseString {
                case "equal"://case "EQUAL", "equal":
                  self.tripStatusImage.hidden = true
                case "up"://case "UP", "up", "Up":
                  self.tripStatusImage.hidden = false
                  self.tripStatusImage.image = UIImage(named:"thumb_up.png")
                case "down"://case "DOWN","down","Down":
                  self.tripStatusImage.hidden = false
                  self.tripStatusImage.image = UIImage(named:"thumb_down.png")
                default:
                  self.tripStatusImage.hidden = true
              }
                
                                let arcViewTap = UITapGestureRecognizer(target: self, action: Selector("handleTapOnArcView:"))
                                arcViewTap.delegate = self
                                self.arcView.addGestureRecognizer(arcViewTap)
                
                                let levelMessageTap = UITapGestureRecognizer(target: self, action: Selector("handleTapOnLevelMessage:"))
                                levelMessageTap.delegate = self
                                self.levelView.addGestureRecognizer(levelMessageTap)
                
                let contractPointsString = self.pointsEarnedString + ":" + dashboardData.pointsAchieved as NSString
                let attributedString : NSMutableAttributedString = NSMutableAttributedString(string: contractPointsString as String, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Medium",size: 16.0)!])
                
                attributedString.addAttribute(NSForegroundColorAttributeName,value: UIColor(netHex: 0x181F29),
                    range: contractPointsString.rangeOfString("\(self.pointsEarnedString )"))
                
                attributedString.addAttribute(NSForegroundColorAttributeName,value: UIColor(netHex: 0x00ACEF),
                    range:contractPointsString.rangeOfString("\(dashboardData.pointsAchieved)"))
              
              if dashboardData.pointsAchieved == "" { self.contractsPointsEarnedValue.text = StringConstants.NO_CONTRACT  }
              else {self.contractsPointsEarnedValue.attributedText = attributedString}

                
                //1. Get data from plist
                let path                = NSBundle.mainBundle().pathForResource("BadgesDetails", ofType: "plist")
                let dataDict            = NSDictionary(contentsOfFile: path!)
                
                
                if let validDict = dataDict![NSUserDefaults.standardUserDefaults().objectForKey(StringConstants.SELECTED_LOCALIZE_LANGUAGE_CODE) as! String] {
                    
                    self.plistLevelArray    = (validDict.valueForKey("level"))! as! NSArray
                    
                    for levelDict in self.plistLevelArray {
                        let levelName = levelDict.objectForKey("title")
                        if levelName?.lowercaseString == dashboardData.levelName.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()){
                            let levelImageName = levelDict.objectForKey("icon") as! String
                            self.levelImage.image = UIImage(named:levelImageName)
                            break
                        }
                    }
                }
                

                
          
                
                if !(dashboardData.totalPoints.isEmpty) && !(dashboardData.pointsAchieved.isEmpty){
                    let totalPoints = Float(dashboardData.totalPoints)
                    let pointsAchieved = Float(dashboardData.pointsAchieved)
                    let progressFraction = Float(totalPoints!/pointsAchieved!)
                    self.pointsAchievedProgressView.setProgress(1/progressFraction, animated: false)
                }

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
    self.createAlertView(self.scoreMessage, firstButtonTitle: StringConstants.OK, secondButtonTitle: "", thirdButtonTitle: "", alerttag:103)
  }
  
  func handleTapOnLevelMessage(sender:AnyObject){
    self.createAlertView(self.nextLevelMessage, firstButtonTitle: StringConstants.OK, secondButtonTitle: "", thirdButtonTitle: "", alerttag:103)
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
