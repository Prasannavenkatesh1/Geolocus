//Created by Insurance H3 Team
//
//GeoLocus App
//
import Foundation
import UIKit

class DashBoardView: UIViewController {

//    @IBOutlet weak var DashBoardWebView: UIWebView!
    
    @IBOutlet weak var pointsLoad: UIWebView!
    
    @IBOutlet weak var DashBoardNav: UINavigationBar!
    
    @IBOutlet weak var startButton: UIButton!
  
    @IBOutlet weak var distDriven: UITextField!
    
    @IBOutlet weak var rwdPts: UITextField!
    
    @IBOutlet weak var unitsValue: UILabel!
     
    var insuredId : String?
    var deviceId : String?
    var countryCode : String?
    var token : String?
    var accountId : String?
    var accountCode : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation Bar
        DashBoardNav.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        let settingsButton = UIButton()
        settingsButton.setImage(UIImage(named: "FEZ-04-256.png"), forState: .Normal)
        settingsButton.frame = CGRectMake(0,0,20,20)
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
        
        DashBoardNav.topItem?.setLeftBarButtonItem(leftBarItem, animated: true)
        
        DashBoardNav.topItem?.setRightBarButtonItems([settingsRightItem, callRightItem], animated: true)
        
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
        
        println("deviceID : \(deviceId), countryCode : \(countryCode), token : \(token), accountId : \(accountId), accountCode : \(accountCode)")
        
        // Do any additional setup after loading the view.
        
        dashboardEntity = dashboardController.displayDashboard(insuredId, token, countryCode, accountId, accountCode)
        
        //Fetching the Data for the Dash Board from the DashBoardDatabase - fetchLastData
        
        var dashboardDatabase : DashboardDatabase = DashboardDatabase()
//        var dashboardDB : DashboardDB = DashboardDB()
        var dashboardData: DashboardEntity = DashboardEntity()
        
        dashboardData = dashboardDatabase.fetchLastData()
//        dashboardData = DashboardDB.sharedInstance().fetchLastData()
        
        var distanceDriven : Int = dashboardData.usedMiles as Int
        var rewardPoints = dashboardData.rewardsAvailable
        var driverScore = dashboardData.driverScores
        
        var convertedDistanceDriven : Double?
        
        //Location Update
        var geolocusDashboard : GeolocusDashboard = GeolocusDashboard()
        geolocusDashboard.callDashboard(deviceId, countryCode)
        
        let mainDelegate = UIApplication.sharedApplication().delegate as! AppDelegateSwift
        
        if (countryCode == "IN" || countryCode != nil) {
        
            convertedDistanceDriven = round(Double( distanceDriven) / 1000)
            unitsValue.text = "KM"
            mainDelegate.speedLimit = 60.0
            println("Value of Speed Limit IN : \(mainDelegate.speedLimit)")
            println("Distance Driven : \(convertedDistanceDriven)")
            
        } else if (countryCode == "US") {
            
            convertedDistanceDriven = round(Double(distanceDriven) * 0.000621371)
            unitsValue.text = "MI"
            mainDelegate.speedLimit = 89.0
            println("Value of Speed Limit US : \(mainDelegate.speedLimit)")
        
        }
        
        println(convertedDistanceDriven?.description)
        
        rwdPts.text = String(rewardPoints)
        if (convertedDistanceDriven == nil) {
            distDriven.text = "0.0"
        } else {
            distDriven.text = convertedDistanceDriven?.description
        }
        
        pointsLoad.backgroundColor = UIColor.clearColor()
        pointsLoad.opaque = false
        
        let pathPoints = NSBundle.mainBundle().pathForResource("PointsLoad", ofType: "html")
        let targetURLPoints = NSURL(fileURLWithPath: pathPoints!)
        let targetURLStringPoints = targetURLPoints!.absoluteString
        let paramPoints = NSString(format:"?driverScore=\(driverScore)")
        let finalURLStringPoints = targetURLStringPoints?.stringByAppendingString(paramPoints as String)
        let finalURLPoints = NSURL(string: finalURLStringPoints!)
        
        let requestPoints = NSURLRequest(URL: finalURLPoints!)
        pointsLoad.loadRequest(requestPoints)
        
        //Start Button
        startButton.addTarget(self, action: "buttonTapped", forControlEvents: .TouchUpInside)
        
        println("The value of driverScore is : \(driverScore)")
        self.addArcView(String(driverScore))
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        var checkStart = defaults.boolForKey("isStarted")
        
        if checkStart {
            startButton.backgroundColor = UIColor.redColor()
            startButton.setTitle("Stop", forState: .Normal)
        }
        else {
            startButton.backgroundColor = UIColor.greenColor()
            startButton.setTitle("Start", forState: .Normal)
        }

    }
    
    func buttonTapped(){
        
        let text = startButton.titleLabel?.text
        var geolocusDashboard : GeolocusDashboard = GeolocusDashboard()
        
        if (text == "Start") {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: "isStarted")
            
            startButton.backgroundColor = UIColor.redColor()
            startButton.setTitle("Stop", forState: .Normal)
            
            geolocusDashboard.startBGServices(text)
        }
        else if (text == "Stop") {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "isStarted")
            
            startButton.backgroundColor = UIColor.greenColor()
            startButton.setTitle("Start", forState: .Normal)
            
            geolocusDashboard.stopBGServices(text)
        }
        
    }
    
    func pushSettingsView() {
        self.performSegueWithIdentifier("DBModal", sender:self)
    }
    
    func makeCall() {
        let phone = "tel://123456789"
        let url:NSURL = NSURL(string:phone)!
        UIApplication.sharedApplication().openURL(url)
    }
 
    func addArcView(score : String) {
        
        let screenSize = UIScreen.mainScreen().bounds.size
        var isiPhone6 = CGSizeEqualToSize(screenSize, CGSizeMake(375, 667))
        
        println("Recieved Value of driverScore is : \(score)")
        var arcProgress : arcProgressView = arcProgressView()
        
        // Create a new ArcView
        
        if (isiPhone6) {

            arcProgress = arcProgressView(frame: CGRectMake(80, 80, 220, 170))
            
        } else {

            arcProgress = arcProgressView(frame: CGRectMake(80, 80, 156, 150))
            
        }
        
        view.addSubview(arcProgress)
        
        // Animate the drawing of the circle over the course of 1 second
        arcProgress.animateCircle(score)
    }

}
