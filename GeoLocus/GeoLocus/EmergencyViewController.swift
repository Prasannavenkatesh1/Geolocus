//Created by Insurance H3 Team
//
//GeoLocus App
//
import Foundation
import UIKit

class EmergencyView: UIViewController {
   
    @IBOutlet weak var EmergencyNav: UINavigationBar!
    
    var MapValue : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation Bar
        EmergencyNav.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        let settingsButton = UIButton()
        settingsButton.setImage(UIImage(named: "FEZ-04-256.png"), forState: .Normal)
        settingsButton.frame = CGRectMake(0,0,20,20)
        //settingsButton.targetForAction(nil, withSender: self)
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
        
//        let towButton = UIButton()
//        towButton.frame = CGRectMake(45,438,90,95)
//        towButton.addTarget(self, action: "towMapValue", forControlEvents: .TouchUpInside)
        
        let geoLogo = UIButton()
        geoLogo.setImage(UIImage(named: "splash_logo.png"), forState: .Normal)
        geoLogo.frame = CGRectMake(0, 0, 80, 20)
        geoLogo.targetForAction(nil, withSender: self)
        
        let leftBarItem:UIBarButtonItem = UIBarButtonItem()
        leftBarItem.customView = geoLogo
        
        EmergencyNav.topItem?.setLeftBarButtonItem(leftBarItem, animated: true)
        
        EmergencyNav.topItem?.setRightBarButtonItems([settingsRightItem, callRightItem], animated: true)

        
    }
    
    func pushSettingsView() {
        self.performSegueWithIdentifier("EModal", sender:self)
    }
    
//    func towMapValue() {
//        self.performSegueWithIdentifier("tModal", sender:self)
//        MapValue = "Tow"
//    }
    
    func makeCall() {
        
        print("Calling")
        let phone = "tel://123456789"
        let url:NSURL = NSURL(string:phone)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func headsetCall(sender: AnyObject) {
        
        print("Calling Care")
        let phone = "tel://123456789"
        let url:NSURL = NSURL(string:phone)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func hospitalCall(sender: AnyObject) {
        
        print("Calling Hospital")
        let phone = "tel://123456789"
        let url:NSURL = NSURL(string:phone)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func mechanicCall(sender: AnyObject) {
        
        print("Calling Mechanic")
        let phone = "tel://123456789"
        let url:NSURL = NSURL(string:phone)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func towCall(sender: AnyObject) {
        
        print("Calling Tow")
        let phone = "tel://123456789"
        let url:NSURL = NSURL(string:phone)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func fuelCall(sender: AnyObject) {
        
        print("Calling Fuel Station")
        let phone = "tel://123456789"
        let url:NSURL = NSURL(string:phone)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func hpMap(sender: AnyObject) {
        
        MapValue = "Hospital"
        performSegueWithIdentifier("MapModal", sender:self)
        
    }
    
    @IBAction func garageMap(sender: AnyObject) {
        
         MapValue = "Garage"
        performSegueWithIdentifier("MapModal", sender:self)
    }
    
    @IBAction func towMap(sender: AnyObject) {
        
        MapValue = "Tow"
        performSegueWithIdentifier("MapModal", sender:self)
    }
    @IBAction func fuelMap(sender: AnyObject) {
        
         MapValue = "Fuel Station"
        performSegueWithIdentifier("MapModal", sender:self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "MapModal") {
            let mapView : MapView =  segue.destinationViewController as! MapView
            mapView.whichMap = MapValue
        }
        
    }

}