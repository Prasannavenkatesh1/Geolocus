//Created by Insurance H3 Team
//
//GeoLocus App

import Foundation
import UIKit

class ScorePageView: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var accelerateWebView: UIWebView!
    @IBOutlet weak var brakeWebView: UIWebView!
    @IBOutlet weak var speedWebView: UIWebView!
    @IBOutlet weak var timeWebView: UIWebView!
    
    @IBOutlet weak var scoreProgress: UIWebView!
    
    @IBOutlet weak var ScorePageNav: UINavigationBar!
    
    @IBOutlet weak var scoreText: UITextView!

    @IBOutlet weak var weeklyGraph: UIWebView!

    @IBOutlet weak var closeGraph: UIButton!
    
    var insuredId : String?
    var deviceId : String?
    var countryCode : String?
    var token : String?
    var accountId : String?
    var accountCode : String?
    
    var requestAccelerate : NSURLRequest?
    var requestWeeklyAcceleration : NSURLRequest?
    var requestWeeklyBraking : NSURLRequest?
    var requestWeeklySpeeding : NSURLRequest?
    var requestWeeklyTiming : NSURLRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation Bar
        ScorePageNav.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        let settingsButton = UIButton()
        settingsButton.setImage(UIImage(named: "FEZ-04-256.png"), forState: .Normal)
        settingsButton.frame = CGRectMake(0,0,20,20)
        //settingsButton.targetForAction(nil, withSender: self)
        settingsButton.addTarget(self, action: "pushSettingsView", forControlEvents: .TouchUpInside)
        
        var settingsRightItem:UIBarButtonItem = UIBarButtonItem()
        settingsRightItem.customView = settingsButton
        
        let callButton = UIButton()
        callButton.setImage(UIImage(named: "ic_action_call.png"), forState: .Normal)
        callButton.frame = CGRectMake(0,0,20,20)
//        callButton.targetForAction(nil, withSender: self)
        callButton.addTarget(self, action: "makeCall", forControlEvents: .TouchUpInside)
        
        var callRightItem:UIBarButtonItem = UIBarButtonItem()
        callRightItem.customView = callButton
        
        let geoLogo = UIButton()
        geoLogo.setImage(UIImage(named: "splash_logo.png"), forState: .Normal)
        geoLogo.frame = CGRectMake(0, 0, 80, 20)
        geoLogo.targetForAction(nil, withSender: self)
        
        var leftBarItem:UIBarButtonItem = UIBarButtonItem()
        leftBarItem.customView = geoLogo
        
        ScorePageNav.topItem?.setLeftBarButtonItem(leftBarItem, animated: true)
        
        ScorePageNav.topItem?.setRightBarButtonItems([settingsRightItem, callRightItem], animated: true)
        
        accelerateWebView.backgroundColor = UIColor.clearColor()
        accelerateWebView.opaque = false
        
        brakeWebView.backgroundColor = UIColor.clearColor()
        brakeWebView.opaque = false
        
        speedWebView.backgroundColor = UIColor.clearColor()
        speedWebView.opaque = false
        
        timeWebView.backgroundColor = UIColor.clearColor()
        timeWebView.opaque = false
        
        scoreProgress.backgroundColor = UIColor.clearColor()
        scoreProgress.opaque = false
        
        weeklyGraph.backgroundColor = UIColor(white: 0, alpha: 0.5)
        weeklyGraph.opaque = false
        
        //Service Calls
        var registrationDatabase: RegistrationDatabase = RegistrationDatabase()
        self.insuredId = registrationDatabase.fetchLastInsuredID()
        
        deviceId = registrationDatabase.fetchLastDeviceID()
        countryCode = registrationDatabase.fetchCountryCodeByDeviceID(deviceId)
        token = registrationDatabase.fetchTokenByInsuredID(insuredId)
        accountId = registrationDatabase.fetchAccountIdByInsuredID(insuredId)
        accountCode = registrationDatabase.fetchAccountCodeByInsuredID(insuredId)
        
        var dashboardController: DashboardController = DashboardController()
        var dashboardEntity: DashboardEntity = DashboardEntity()
        
        // Do any additional setup after loading the view.
        
        dashboardEntity = dashboardController.displayDashboard(insuredId, token, countryCode, accountId, accountCode)
        
        //Fetching the Data for the Dash Board from the DashBoardDatabase - fetchLastData
        
        var dashboardDatabase : DashboardDatabase = DashboardDatabase()
//        var dashboardDB : DashboardDB = DashboardDB()
        var dashboardData: DashboardEntity = DashboardEntity()
        
        dashboardData = dashboardDatabase.fetchLastData()
//        dashboardData = DashboardDB.sharedInstance().fetchLastData()

        var score = dashboardData.driverScores
        var acceleration = dashboardData.acceleration
        var braking = dashboardData.braking
        var speeding = dashboardData.speeding
        var timeOfDay = dashboardData.timeOfDay
        
        println("Score : \(score) Acceleration : \(acceleration) Braking : \(braking) Speeding : \(speeding) Time Of Day : \(timeOfDay) ")
        
        //Weekly Scoring Details
        var geolocusDashboard : GeolocusDashboard = GeolocusDashboard()
        var weeklyScoring = geolocusDashboard.weeklyScoringDetails(accountId, accountCode, insuredId, token) as NSDictionary
        
        var weeklyAcceleration = weeklyScoring.valueForKey("weeklyAcceleration") as? String
        var weeklyBraking = weeklyScoring.valueForKey("weeklyBraking") as? String
        var weeklySpeeding = weeklyScoring.valueForKey("weeklySpeeding") as? String
        var weeklyTimeOfDay = weeklyScoring.valueForKey("weeklyTimeOfDay") as? String
        
        weeklyAcceleration = weeklyAcceleration?.stringByReplacingOccurrencesOfString("\n", withString: "", options: nil, range: nil)
        weeklyAcceleration = weeklyAcceleration?.stringByReplacingOccurrencesOfString("(", withString: "", options: nil, range: nil)
        weeklyAcceleration = weeklyAcceleration?.stringByReplacingOccurrencesOfString(")", withString: "", options: nil, range: nil)
        weeklyAcceleration = weeklyAcceleration?.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        
        weeklyBraking = weeklyBraking?.stringByReplacingOccurrencesOfString("\n", withString: "", options: nil, range: nil)
        weeklyBraking = weeklyBraking?.stringByReplacingOccurrencesOfString("(", withString: "", options: nil, range: nil)
        weeklyBraking = weeklyBraking?.stringByReplacingOccurrencesOfString(")", withString: "", options: nil, range: nil)
        weeklyBraking = weeklyBraking?.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        
        weeklySpeeding = weeklySpeeding?.stringByReplacingOccurrencesOfString("\n", withString: "", options: nil, range: nil)
        weeklySpeeding = weeklySpeeding?.stringByReplacingOccurrencesOfString("(", withString: "", options: nil, range: nil)
        weeklySpeeding = weeklySpeeding?.stringByReplacingOccurrencesOfString(")", withString: "", options: nil, range: nil)
        weeklySpeeding = weeklySpeeding?.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        
        weeklyTimeOfDay = weeklyTimeOfDay?.stringByReplacingOccurrencesOfString("\n", withString: "", options: nil, range: nil)
        weeklyTimeOfDay = weeklyTimeOfDay?.stringByReplacingOccurrencesOfString("(", withString: "", options: nil, range: nil)
        weeklyTimeOfDay = weeklyTimeOfDay?.stringByReplacingOccurrencesOfString(")", withString: "", options: nil, range: nil)
        weeklyTimeOfDay = weeklyTimeOfDay?.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        
        var weeklyAccelerationArray : Array = weeklyAcceleration!.componentsSeparatedByString(",")
        var weeklyBrakingArray : Array = weeklyBraking!.componentsSeparatedByString(",")
        var weeklySpeedingArray : Array = weeklySpeeding!.componentsSeparatedByString(",")
        var weeklyTimeOfDayArray : Array = weeklyTimeOfDay!.componentsSeparatedByString(",")
        
        println("weeklyAccelerationArray is : \(weeklyAccelerationArray)")
        println("weeklyBrakingArray is : \(weeklyBrakingArray)")
        println("weeklySpeedingArray is : \(weeklySpeedingArray)")
        println("weeklyTimeOfDayArray is : \(weeklyTimeOfDayArray)")
        
        //Dynamic Loaders
        let pathAccelerate = NSBundle.mainBundle().pathForResource("AccelerationIndiactor", ofType: "html")
        var targetURLAccelerate = NSURL(fileURLWithPath: pathAccelerate!)
        let targetURLStringAccelerate = targetURLAccelerate!.absoluteString
        let paramAccelerate = NSString(format:"?Acceleration=\(acceleration)")
        let finalURLStringAccelerate = targetURLStringAccelerate?.stringByAppendingString(paramAccelerate as String)
        let finalURLAccelerate = NSURL(string: finalURLStringAccelerate!)
        
        requestAccelerate = NSURLRequest(URL: finalURLAccelerate!)
        accelerateWebView.loadRequest(requestAccelerate!)
        accelerateWebView.delegate = self
        
        
        let pathBrake = NSBundle.mainBundle().pathForResource("BrakingIndicator", ofType: "html")
        var targetURLBrake = NSURL(fileURLWithPath: pathBrake!)
        let targetURLStringBrake = targetURLBrake!.absoluteString
        let paramBrake = NSString(format:"?Braking=\(braking)")
        let finalURLStringBrake = targetURLStringBrake?.stringByAppendingString(paramBrake as String)
        let finalURLBrake = NSURL(string: finalURLStringBrake!)
        
        var requestBrake = NSURLRequest(URL: finalURLBrake!)
        brakeWebView.loadRequest(requestBrake)
        
        let pathSpeed = NSBundle.mainBundle().pathForResource("SpeedingIndicator", ofType: "html")
        var targetURLSpeed = NSURL(fileURLWithPath: pathSpeed!)
        let targetURLStringSpeed = targetURLSpeed!.absoluteString
        let paramSpeed = NSString(format:"?Speeding=\(speeding)")
        let finalURLStringSpeed = targetURLStringSpeed?.stringByAppendingString(paramSpeed as String)
        let finalURLSpeed = NSURL(string: finalURLStringSpeed!)
        
        var requestSpeed = NSURLRequest(URL: finalURLSpeed!)
        speedWebView.loadRequest(requestSpeed)
        
        let pathTime = NSBundle.mainBundle().pathForResource("TimeIndicator", ofType: "html")
        var targetURLTime = NSURL(fileURLWithPath: pathTime!)
        let targetURLStringTime = targetURLTime!.absoluteString
        let paramTime = NSString(format:"?TimeOfDay=\(timeOfDay)")
        let finalURLStringTime = targetURLStringTime?.stringByAppendingString(paramTime as String)
        let finalURLTime = NSURL(string: finalURLStringTime!)
        
        var requestTime = NSURLRequest(URL: finalURLTime!)
        timeWebView.loadRequest(requestTime)
        
        let pathScoreProgress = NSBundle.mainBundle().pathForResource("scoreProgressBar", ofType: "html")
        var targetURLScoreProgress = NSURL(fileURLWithPath: pathScoreProgress!)
        let targetURLStringScoreProgress = targetURLScoreProgress!.absoluteString
        let paramScoreProgress = NSString(format:"?Score=\(score)")
        let finalURLStringScoreProgress = targetURLStringScoreProgress?.stringByAppendingString(paramScoreProgress as String)
        let finalURLScoreProgress = NSURL(string: finalURLStringScoreProgress!)
        
        var requestScoreProgress = NSURLRequest(URL: finalURLScoreProgress!)
        scoreProgress.loadRequest(requestScoreProgress)
        
        //Weekly Report Code
        //URL
        let pathWeekly = NSBundle.mainBundle().pathForResource("weeklyReport", ofType: "html")
        var targetURLWeekly = NSURL(fileURLWithPath: pathWeekly!)
        let targetURLStringWeekly = targetURLWeekly!.absoluteString

        //Fetching the right values to append
        let accelerationString = NSString(format:"\(weeklyAccelerationArray)") as String
        var accelrationValue = accelerationString.stringByReplacingOccurrencesOfString("[", withString: "", options: nil, range: nil)
        accelrationValue = accelrationValue.stringByReplacingOccurrencesOfString("]", withString: "", options: nil, range: nil)
        
        let brakingString = NSString(format:"\(weeklyBrakingArray)") as String
        var brakingValue = brakingString.stringByReplacingOccurrencesOfString("[", withString: "", options: nil, range: nil)
        brakingValue = brakingValue.stringByReplacingOccurrencesOfString("]", withString: "", options: nil, range: nil)
        
        let speedingString = NSString(format:"\(weeklySpeedingArray)") as String
        var speedingValue = speedingString.stringByReplacingOccurrencesOfString("[", withString: "", options: nil, range: nil)
        speedingValue = speedingValue.stringByReplacingOccurrencesOfString("]", withString: "", options: nil, range: nil)
        
        let timeString = NSString(format:"\(weeklyTimeOfDayArray)") as String
        var timingValue = timeString.stringByReplacingOccurrencesOfString("[", withString: "", options: nil, range: nil)
        timingValue = timingValue.stringByReplacingOccurrencesOfString("]", withString: "", options: nil, range: nil)
        
        
        //Framing the URL for each event
        let paramAcceleration = NSString(format: "?weeklyAcceleration= %@", accelrationValue)
        let paramAccelerationString = targetURLStringWeekly?.stringByAppendingString(paramAcceleration as String)
        let accelerationEncoding = paramAccelerationString?.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
        let weeklyAccelerateURL = NSURL(string: accelerationEncoding!)
        
        let paramBraking = NSString(format: "?weeklyBraking= %@", brakingValue)
        let paramBrakingString = targetURLStringWeekly?.stringByAppendingString(paramBraking as String)
        let brakingEncoding = paramBrakingString?.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
        let weeklyBrakeURL = NSURL(string: brakingEncoding!)
        
        let paramSpeeding = NSString(format: "?weeklySpeeding= %@", speedingValue)
        let paramSpeedingString = targetURLStringWeekly?.stringByAppendingString(paramSpeeding as String)
        let speedingEncoding = paramSpeedingString?.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
        let weeklySpeedURL = NSURL(string: speedingEncoding!)
        
        let paramTiming = NSString(format: "?weeklyTiming= %@", timingValue)
        let paramTimingString = targetURLStringWeekly?.stringByAppendingString(paramTiming as String)
        let timingEncoding = paramTimingString?.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
        let weeklyTimeURL = NSURL(string: timingEncoding!)

        
        //url request with the url framed
        requestWeeklyAcceleration = NSURLRequest(URL: weeklyAccelerateURL!)
        requestWeeklyBraking = NSURLRequest(URL: weeklyBrakeURL!)
        requestWeeklySpeeding = NSURLRequest(URL: weeklySpeedURL!)
        requestWeeklyTiming = NSURLRequest(URL: weeklyTimeURL!)
    }
    
    func pushSettingsView() {
        self.performSegueWithIdentifier("ScoreModal", sender:self)
    }
    
    func makeCall() {
        let phone = "tel://123456789"
        let url:NSURL = NSURL(string:phone)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func weeklyAcceleration(sender: AnyObject) {

        var subview = weeklyGraph!
        subview.loadRequest(requestWeeklyAcceleration!)
        subview.hidden = false
        view.addSubview(subview)
        self.view.bringSubviewToFront(subview)
        
        closeGraph.addTarget(self, action: "closeTapped", forControlEvents: .TouchUpInside)
        closeGraph.hidden = false
    }
    
    @IBAction func weeklyBraking(sender: AnyObject) {
        
        var subview = weeklyGraph!
        subview.loadRequest(requestWeeklyBraking!)
        subview.hidden = false
        view.addSubview(subview)
        self.view.bringSubviewToFront(subview)
        
        closeGraph.addTarget(self, action: "closeTapped", forControlEvents: .TouchUpInside)
        closeGraph.hidden = false
    }
    
    @IBAction func weeklySpeeding(sender: AnyObject) {
        
        var subview = weeklyGraph!
        subview.loadRequest(requestWeeklySpeeding!)
        subview.hidden = false
        view.addSubview(subview)
        self.view.bringSubviewToFront(subview)
        
        closeGraph.addTarget(self, action: "closeTapped", forControlEvents: .TouchUpInside)
        closeGraph.hidden = false
    }
    

    @IBAction func weeklyTiming(sender: AnyObject) {
        
        var subview = weeklyGraph!
        subview.loadRequest(requestWeeklyTiming!)
        subview.hidden = false
        view.addSubview(subview)
        self.view.bringSubviewToFront(subview)
        
        closeGraph.addTarget(self, action: "closeTapped", forControlEvents: .TouchUpInside)
        closeGraph.hidden = false
    }
    
    func closeTapped() {
        var subview = weeklyGraph!
        subview.hidden = true
        closeGraph.hidden = true
    }
    
}
