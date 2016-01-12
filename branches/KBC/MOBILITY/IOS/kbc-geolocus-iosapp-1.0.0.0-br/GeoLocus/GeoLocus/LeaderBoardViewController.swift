//Created by Insurance H3 Team
//
//GeoLocus App
//
import Foundation
import UIKit

class LeaderBoardView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var leaderBoardScoreWebView: UIWebView!
    
    @IBOutlet weak var LeaderBoardNav: UINavigationBar!
    
    @IBOutlet weak var lbDistDrvn: UITextField!
    
    @IBOutlet weak var lbRank: UITextField!
   
    @IBOutlet weak var LBTableView: UITableView!
    
    @IBOutlet weak var unitsValue: UILabel!
    
    @IBOutlet weak var rankOne: UILabel!
    
    @IBOutlet weak var rankTwo: UILabel!
    
    @IBOutlet weak var rankThree: UILabel!
 
    
    var insuredId : String?
    var deviceId : String?
    var countryCode : String?
    var token : String?
    var accountId : String?
    var accountCode : String?
    
    var topperData: NSArray?
    var historyData: NSMutableArray?
    
    var topperDataCount : Int?
    var historyDataCount : Int?
    
    //Topper Data and History Data
    var firstRank : NSString?
    var secondRank : NSString?
    var thirdRank : NSString?
    var insuredRank : NSString?
    
    var firstScore : NSString?
    var secondScore : NSString?
    var thirdScore : NSString?
    var insuredScore : NSString?
    
    var lbresultantDict : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation Bar
        LeaderBoardNav.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
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
        
        LeaderBoardNav.topItem?.setLeftBarButtonItem(leftBarItem, animated: true)
        
        LeaderBoardNav.topItem?.setRightBarButtonItems([settingsRightItem, callRightItem], animated: true)

        //Leader Board Main View Code
        leaderBoardScoreWebView.backgroundColor = UIColor.clearColor()
        leaderBoardScoreWebView.opaque = false
        
        LBTableView.backgroundColor = UIColor.clearColor()
        LBTableView.opaque = false
        
        //Service Calls
        var registrationDatabase: RegistrationDatabase = RegistrationDatabase()
        self.insuredId = registrationDatabase.fetchLastInsuredID()
        
        deviceId = registrationDatabase.fetchLastDeviceID()
        countryCode = registrationDatabase.fetchCountryCodeByDeviceID(deviceId)
        token = registrationDatabase.fetchTokenByInsuredID(insuredId)
        accountId = registrationDatabase.fetchAccountIdByInsuredID(insuredId)
        accountCode = registrationDatabase.fetchAccountCodeByInsuredID(insuredId)
        
        //Actual Code
        var leaderBoardController : LeaderBoardController = LeaderBoardController()
        var leaderBoardEntity : LeaderBoardEntity = LeaderBoardEntity()
        
        historyData?.removeAllObjects()
        
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate: String = formatter.stringFromDate(NSDate())
        
        var leaderBoardDataBase : LeaderBoardDatabase = LeaderBoardDatabase()
        
        topperData  = leaderBoardDataBase.fetchLeaderBoardLastData(currentDate) as NSArray
        historyData = leaderBoardDataBase.fetchLeaderBoardHistoryLastData(currentDate,countryCode) as NSMutableArray
        
        topperDataCount = topperData!.count
        historyDataCount = historyData!.count
        
        if (topperDataCount == 0 && historyDataCount == 0)
        {
            
            let leaderBoardValue = leaderBoardController.getLeaderBoardData(insuredId, token, countryCode, accountId)
        
            topperData = leaderBoardValue.valueForKey("topperData") as! NSMutableArray
            
            topperDataCount = topperData!.count
            
            historyData = (leaderBoardValue.valueForKey("historyData") as? NSMutableArray)!
            
            historyDataCount = historyData!.count
            
        }
        
        if (topperDataCount == 1) {
            firstRank = topperData![0] ["topperCurrentRank"] as? String
            firstScore = topperData![0] ["topperDriverScore"] as! String
        }
        else if (topperDataCount == 2) {
            firstRank = topperData![0] ["topperCurrentRank"] as! String
            firstScore = topperData![0] ["topperDriverScore"] as! String
            
            secondRank = topperData![1] ["topperCurrentRank"] as! String
            secondScore = topperData![1] ["topperDriverScore"] as! String
            
        }
        else if (topperDataCount == 3) {
            firstRank = topperData![0] ["topperCurrentRank"] as! String
            firstScore = topperData![0] ["topperDriverScore"] as! String
            
            secondRank = topperData![1] ["topperCurrentRank"] as! String
            secondScore = topperData![1] ["topperDriverScore"] as! String
            
            thirdRank = topperData![2] ["topperCurrentRank"] as! String
            thirdScore = topperData![2] ["topperDriverScore"] as! String

        }
        else if (topperDataCount == 4) {
            firstRank = topperData![0] ["topperCurrentRank"] as! String
            firstScore = topperData![0] ["topperDriverScore"] as! String
            
            secondRank = topperData![1] ["topperCurrentRank"] as! String
            secondScore = topperData![1] ["topperDriverScore"] as! String
            
            thirdRank = topperData![2] ["topperCurrentRank"] as! String
            thirdScore = topperData![2] ["topperDriverScore"] as! String
            
            insuredScore = topperData![3] ["topperDriverScore"] as! String
        }

        //Topper Ranks
        if (firstScore == "0" || firstScore == "<null>" || firstScore == nil) {
            rankOne.text = "0"
        } else if (secondScore == "0" || secondScore == "<null>" || secondScore == nil) {
            rankTwo.text = "0"
        } else if (thirdScore == "0" || thirdScore == "<null>" || thirdScore == nil) {
            rankThree.text = "0"
        } else {
            rankOne.text = String(firstScore!)
            rankTwo.text = String(secondScore!)
            rankThree.text = String(thirdScore!)
        }
        
        
        //LB Score
        var lbScore = "0"
        
        if (insuredScore == "<null>" || insuredScore == nil || insuredScore == 0) {
          lbScore = "0"
        } else {
            lbScore = insuredScore as! String
        }

        
//        println("First : \(rankOne.text) Second : \(rankTwo.text) Third : \(rankThree.text) insuredScore : \(lbScore) insuredRank : \(lbRank.text) ")
        
        //User Distance Driven
        if (historyDataCount != 0) {
            
            var modifiedCount : Int = historyDataCount! - 1
            
            print("modifiedCount : \(modifiedCount)")
            
            insuredRank = historyData? [modifiedCount] ["historyCurrentRank"] as? NSString
            
            if (insuredRank == 0 || insuredRank == "<null>" || insuredRank == nil) {
                
                lbRank.text = "0"
                
            } else {
            
                lbRank.text = String(insuredRank!)
            }
            var lbtotalDistanceDriven = historyData! [modifiedCount] ["historyDistanceCovered"] as! String
            
            if (lbtotalDistanceDriven == "0" || lbtotalDistanceDriven == "<null>") {
                
                lbDistDrvn.text = "0"
                
            } else {
                
                lbDistDrvn.text = lbtotalDistanceDriven
            }
        }
        
        //Dynamic Loaders LB Score
        let path = NSBundle.mainBundle().pathForResource("LBScore", ofType: "html")
        let targetURL = NSURL(fileURLWithPath: path!)
        let targetURLString = targetURL.absoluteString
        let param = NSString(format:"?LBScore=\(lbScore)")
        let finalURLString = targetURLString.stringByAppendingString(param as String)
        let finalURL = NSURL(string: finalURLString)
        
        let request = NSURLRequest(URL: finalURL!)
        leaderBoardScoreWebView.loadRequest(request)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return historyData!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let mainDelegate = UIApplication.sharedApplication().delegate as! AppDelegateSwift
        
        let iPhoneSize = mainDelegate.iPhoneSize
        print("iPhoneSize : \(iPhoneSize)")
        
        if (iPhoneSize == "iPhone6") {

            let identifier = "LBCustomCellPh6"
            var cell: LBCustomCellPh6! = tableView.dequeueReusableCellWithIdentifier(identifier) as? LBCustomCellPh6
            if cell == nil {
                tableView.registerNib(UINib(nibName: "LBCustomCellPh6", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? LBCustomCellPh6
            }
        
            cell.lapLabel.text  = historyData! [indexPath.row] ["historyID"]  as? String
            cell.processDateLabel.text  = historyData! [indexPath.row] ["historyProcessDate"]  as? String
            cell.distanceDrivenLabel.text  = historyData! [indexPath.row] ["historyDistanceCovered"]  as? String
            cell.rankLabel.text  = historyData! [indexPath.row] ["historyCurrentRank"]  as? String
        
            cell.backgroundColor = UIColor.clearColor()
            cell.opaque = false
        
            cell.lapLabel.font = UIFont(name: "Digital-7", size: 14)
            cell.lapLabel.textColor = UIColor.whiteColor()
        
            cell.processDateLabel.font = UIFont(name: "Digital-7", size: 14)
            cell.processDateLabel.textColor = UIColor.whiteColor()
        
            cell.distanceDrivenLabel.font = UIFont(name: "Digital-7", size: 14)
            cell.distanceDrivenLabel.textColor = UIColor.whiteColor()
        
            cell.rankLabel.font = UIFont(name: "Digital-7", size: 14)
            cell.rankLabel.textColor = UIColor.whiteColor()
        
            return cell
            
        } else {
            
            let identifier = "LBCustomCell"
            var cell: LBCustomCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? LBCustomCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "LBCustomCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? LBCustomCell
            }
            
            cell.lapLabel.text  = historyData! [indexPath.row] ["historyID"]  as? String
            cell.processDateLabel.text  = historyData! [indexPath.row] ["historyProcessDate"]  as? String
            cell.distanceDrivenLabel.text  = historyData! [indexPath.row] ["historyDistanceCovered"]  as? String
            cell.rankLabel.text  = historyData! [indexPath.row] ["historyCurrentRank"]  as? String
            
            cell.backgroundColor = UIColor.clearColor()
            cell.opaque = false
            
            cell.lapLabel.font = UIFont(name: "Digital-7", size: 12)
            cell.lapLabel.textColor = UIColor.whiteColor()
            
            cell.processDateLabel.font = UIFont(name: "Digital-7", size: 12)
            cell.processDateLabel.textColor = UIColor.whiteColor()
            
            cell.distanceDrivenLabel.font = UIFont(name: "Digital-7", size: 12)
            cell.distanceDrivenLabel.textColor = UIColor.whiteColor()
            
            cell.rankLabel.font = UIFont(name: "Digital-7", size: 12)
            cell.rankLabel.textColor = UIColor.whiteColor()
            
            return cell

        }
        
    }
    
    func pushSettingsView() {
    
        self.performSegueWithIdentifier("LBModal", sender:self)
    }
    
    func makeCall() {
        let phone = "tel://123456789"
        let url:NSURL = NSURL(string:phone)!
        UIApplication.sharedApplication().openURL(url)
    }
    
}

