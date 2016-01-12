//Created by Insurance H3 Team
//
//GeoLocus App
//
import Foundation
import UIKit

class LastTripView : UIViewController {
    
    @IBOutlet weak var LastTripNav: UINavigationBar!
    
    @IBOutlet weak var accelerationValue: UILabel!
    
    @IBOutlet weak var brakingValue: UILabel!
    
    @IBOutlet weak var speedingValue: UILabel!
    
    @IBOutlet weak var incomingCallValue: UILabel!
    
    @IBOutlet weak var outgoingCallValue: UILabel!
    
    @IBOutlet weak var distanceCoveredValue: UILabel!
    
    @IBOutlet weak var tripDurationValue: UILabel!
    
    var insuredId : String?
    var deviceId : String?
    var countryCode : String?
    var token : String?
    var accountId : String?
    var accountCode : String?
    var fetchedText : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation Bar
        LastTripNav.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        let settingsButton = UIButton()
        settingsButton.setImage(UIImage(named: "FEZ-04-256.png"), forState: .Normal)
        settingsButton.frame = CGRectMake(0,0,20,20)
        settingsButton.addTarget(self, action: "pushSettingsView", forControlEvents: .TouchUpInside)
        
        let settingsRightItem:UIBarButtonItem = UIBarButtonItem()
        settingsRightItem.customView = settingsButton
        
        let callButton = UIButton()
        callButton.setImage(UIImage(named: "ic_action_call.png"), forState: .Normal)
        callButton.frame = CGRectMake(0,0,20,20)
//        callButton.targetForAction(nil, withSender: self)
        callButton.addTarget(self, action: "makeCall", forControlEvents: .TouchUpInside)
        
        let callRightItem:UIBarButtonItem = UIBarButtonItem()
        callRightItem.customView = callButton
        
        let geoLogo = UIButton()
        geoLogo.setImage(UIImage(named: "splash_logo.png"), forState: .Normal)
        geoLogo.frame = CGRectMake(0, 0, 80, 20)
        geoLogo.targetForAction(nil, withSender: self)
        
        let leftBarItem:UIBarButtonItem = UIBarButtonItem()
        leftBarItem.customView = geoLogo
        
        LastTripNav.topItem?.setLeftBarButtonItem(leftBarItem, animated: true)
        
        LastTripNav.topItem?.setRightBarButtonItems([settingsRightItem, callRightItem], animated: true)
        
        //Service Calls
        let registrationDatabase: RegistrationDatabase = RegistrationDatabase()
        self.insuredId = registrationDatabase.fetchLastInsuredID()
        
        deviceId = registrationDatabase.fetchLastDeviceID()
        countryCode = registrationDatabase.fetchCountryCodeByDeviceID(deviceId)
        token = registrationDatabase.fetchTokenByInsuredID(insuredId)
        accountId = registrationDatabase.fetchAccountIdByInsuredID(insuredId)
        accountCode = registrationDatabase.fetchAccountCodeByInsuredID(insuredId)
        
        var dashboardController: DashboardController = DashboardController()
        var dashboardEntity: DashboardEntity = DashboardEntity()
        
        // Do any additional setup after loading the view.
        
//        dashboardEntity = dashboardController.displayDashboard(insuredId, token, countryCode, accountId, accountCode)
        
        let geolocusDashboard : GeolocusDashboard = GeolocusDashboard()
        let tripSummaryResult = geolocusDashboard.tripSummaryDetails() as NSDictionary
        
        let acceleration = tripSummaryResult.valueForKey("tripAcceleration") as! NSString
        let braking = tripSummaryResult.valueForKey("tripBraking") as! NSString
        let speeding = tripSummaryResult.valueForKey("tripOverspeed") as! NSString
        let incomingCall = tripSummaryResult.valueForKey("tripIncomingCall") as! NSString
        let outgoingCall = tripSummaryResult.valueForKey("tripOutgoingCall") as! NSString
        let totalDistanceDriven = tripSummaryResult.valueForKey("tripTotalDistCovered") as! NSString
        let tripDuration = tripSummaryResult.valueForKey("tripTotalDuration") as! NSString

        print("Acceleration : \(acceleration) Braking : \(braking) Speeding : \(speeding) Incoming : \(incomingCall) Outgoing : \(outgoingCall) Distance Covered : \(totalDistanceDriven) Duration : \(tripDuration)")

        let tripDistanceFinal = self.getDistanceWithUnits(totalDistanceDriven, countryName : countryCode!) as NSString
        let tripDurationFinal = self.getTimeFormatted(tripDuration) as NSString
        
        self.getDistanceWithUnits(totalDistanceDriven, countryName : countryCode!)
        
        accelerationValue.text = String(acceleration)
        brakingValue.text = String(braking)
        speedingValue.text = String(speeding)
        incomingCallValue.text = String(incomingCall)
        outgoingCallValue.text = String(outgoingCall)
        distanceCoveredValue.text = String(tripDistanceFinal)
        tripDurationValue.text = String(tripDurationFinal)
    }
    
    func pushSettingsView() {
        self.performSegueWithIdentifier("LTModal", sender:self)
    }
    
    func makeCall() {
        let phone = "tel://123456789"
        let url:NSURL = NSURL(string:phone)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    func getDistanceWithUnits (totalDistanceCovered : NSString, countryName : String) -> NSString {
        
        let resultantDistance : NSString?
        let resultantDistanceCovered : NSString?
        
        let totalDistCoveredDouble = (totalDistanceCovered as NSString).doubleValue
        
        if(countryName == "US"||countryName == "GB") {
            
            let roundValue = round(totalDistCoveredDouble * 0.00062137)
            resultantDistance = "\(roundValue)"
            
//            resultantDistance = NSString (format: "%d", totalDistCoveredDouble * 0.00062137)
            resultantDistanceCovered = resultantDistance!.stringByAppendingPathExtension("mile")
            
        }else {
            
            let roundValue = round(totalDistCoveredDouble / 1000)
            resultantDistance = "\(roundValue)"
            
//            resultantDistance = NSString (format: "%.01f", totalDistCoveredDouble / 1000)
            
            resultantDistanceCovered = resultantDistance?.stringByAppendingString(" km")
        }
        
        return resultantDistanceCovered!

    }
    
    func getTimeFormatted (totalDuration : NSString) -> NSString {
    
        let resultantDuration : NSString?
        
        let seconds = (totalDuration.integerValue) % 60
        let minutes = ((totalDuration.integerValue) / 60) % 60
        let hours = (totalDuration.integerValue) / 3600
        
        resultantDuration = NSString (format: "%02d:%02d:%02d", hours, minutes, seconds)
        
        return resultantDuration!
    
    }
    
}