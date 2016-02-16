//
//  HistoryPage.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit
import MapKit

protocol ScoreCellDelegate {
    func scoreViewTapped(tag : Int)
}

protocol MapViewDelegate {
    func mapView(mapView: MKMapView!, didSelectAnnotation annotation: EventAnnotation)
}


protocol SpeedZoneCellDelegate {
    func severeViolationViewTapped()
}

protocol TripDetailCellDelegate {
    func shareButtonTapped(cell: HistoryTripDetailCell)
}

class HistoryPage: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    enum MapZoneTab: Int{
        case MapSelected
        case ZoneSelected
    }
    
    @IBOutlet weak var tripHistoryTableView: UITableView!

    var tripScores       = [TripScore]?()          //trip scores info
    var tripMapEvents    = [Event]?()            //trip events info
    var tripZones        = [SpeedZone]?()        //trip zones info
    var tripAnnotation   = [EventAnnotation]?()  //annotation array
    var historyData      = [History]?()          //recent trips info
    
    var tripDetailRowSelected : Int?
    var zoneSelectedIndexPath: NSIndexPath?
    var recentTripSelectedIndexPath: NSIndexPath?
    var tabSelected: MapZoneTab = MapZoneTab.MapSelected
    
    var mapButton : UIButton?
    var mapBorder : UIView?
    var zoneButton: UIButton?
    var zoneBorder: UIView?

    var scoreRefreshRequired    = true
    var mapRefreshRequired    = true
    var zoneRefreshRequired     = true
    
    let NUM_OF_SECTION = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.scoreRefreshRequired    = true
        self.mapRefreshRequired    = true
        self.zoneRefreshRequired     = true
        
        tabSelected = MapZoneTab.MapSelected
        self.tripDetailRowSelected = 0 // this may be nil if no trip detail data
        self.zoneSelectedIndexPath = nil
        dataModals()
        //loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Tableview Delegate & Datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return NUM_OF_SECTION
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        var numOfRows = 0
        
        if section == 0 {
            numOfRows = 1
        }else if section == 1 {         //depend upon the tab option
            if self.tabSelected == MapZoneTab.MapSelected {
                numOfRows = 1
            }else {
                if self.tripZones?.count > 0{
                    numOfRows = (self.tripZones?.count)!      //change dynamically
                }
            }
        }else if section == 2 {
            if self.historyData?.count > 0{
                numOfRows = (self.historyData?.count)!      //change dynamically
            }
        }
        
        return numOfRows
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var headerHeight = 40
        
        if section == 0 {
            headerHeight = 40
        }else {
            headerHeight = 37
        }
        
        return CGFloat(headerHeight)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        //print(tripMapEvents)
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("HTSCell", forIndexPath: indexPath) as! HistoryTripScoreCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.delegate = self
            
            cell.speedingView.foreGroundArcWidth = 8
            cell.speedingView.backGroundArcWidth = 8
                      //changes dynamically
            if self.tripScores?.count > 0 {
                cell.speedingView.ringLayer.strokeColor = UIColor(range: (self.tripScores?[indexPath.row].speedScore.integerValue)!).CGColor
                cell.speedingView.animateScale = (self.tripScores?[indexPath.row].speedScore.doubleValue)!/100.0
            }
            if self.scoreRefreshRequired {
                cell.speedingView.setNeedsDisplay()
            }
            
            cell.ecoView.foreGroundArcWidth = 8
            cell.ecoView.backGroundArcWidth = 8
            
            if self.tripScores?.count > 0 {
                cell.ecoView.ringLayer.strokeColor = UIColor(range: (self.tripScores?[indexPath.row].ecoScore.integerValue)!).CGColor
                cell.ecoView.animateScale = (self.tripScores?[indexPath.row].ecoScore.doubleValue)!/100.0
            }
            if self.scoreRefreshRequired {
                cell.ecoView.setNeedsDisplay()
            }
            
            self.scoreRefreshRequired = false
            
            return cell
        }else if indexPath.section == 1{
            
            if self.tabSelected == MapZoneTab.MapSelected {
                let cell = tableView.dequeueReusableCellWithIdentifier("HMVCell", forIndexPath: indexPath) as! HistoryMapViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.delegate = self
                if self.mapRefreshRequired {
                    if self.tripAnnotation?.count > 0 {
                        cell.showMapAnnotations(self.tripAnnotation!)
                    }
                }
                self.mapRefreshRequired = false
                return cell
            }else {
                let cell = tableView.dequeueReusableCellWithIdentifier("HSZCell", forIndexPath: indexPath) as! HistoryZoneViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                
                cell.speedingView.foreGroundArcWidth = 8
                cell.speedingView.backGroundArcWidth = 8
                
                if self.tripZones?.count > 0 {
                    cell.speedingView.ringLayer.strokeColor = UIColor(range: (self.tripZones?[indexPath.row].speedBehaviour.integerValue)!).CGColor
                     cell.speedingView.animateScale = (self.tripZones?[indexPath.row].speedBehaviour.doubleValue)!/100.0
                }
                
                if self.zoneRefreshRequired {
                    cell.speedingView.setNeedsDisplay()
                }
                if tripZones?.count > 0 {
                    cell.severeViolationLabel.text = String(self.tripZones![indexPath.row].violationCount)
                    cell.distanceLabel.text =  String("\(self.tripZones![indexPath.row].distanceTravelled) km")
                    cell.maxSpeedLimit.text =  String("\(self.tripZones![indexPath.row].maxSpeed) km/h")
                    cell.withinMaxSpeedLabel.text =  String("\(self.tripZones![indexPath.row].withinSpeed) km")
                    cell.aboveMaxSpeedLabel.text =  String("\(self.tripZones![indexPath.row].aboveSpeed) km")
                }
                
                cell.indicatorButton.selected = false
                self.zoneRefreshRequired = false
                return cell
            }
        }else if indexPath.section == 2{     //section 2
            let cell = tableView.dequeueReusableCellWithIdentifier("HTDCell", forIndexPath: indexPath) as! HistoryTripDetailCell
            cell.delegate = self
            print("date from DB: \(self.historyData![indexPath.row].tripdDate)")
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let tripDate = dateFormatter.dateFromString(self.historyData![indexPath.row].tripdDate)
            let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
            let components = NSCalendar.currentCalendar().components(unitFlags, fromDate: tripDate!)
            
            cell.tripDateLabel.text = String("\(components.day)th \(Helper.getMonthString(components.month)) \(components.year)")
            cell.tripDurationLabel.text = String("\(self.historyData![indexPath.row].tripDuration) Hrs")
            cell.tripDistanceLabel.text = String("\(self.historyData![indexPath.row].distance) km")
            cell.tripPointsLabel.text = String(self.historyData![indexPath.row].tripPoints)
            
            
            //TO DO:
            /*
            If overall score or speeding score or eco score or attention score(for android device) is red color against any trip 
            then the sharing icon will be disabled for that trip.
            
            */
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("HTDCell", forIndexPath: indexPath) as! HistoryTripDetailCell  //remove this
            return cell
        }
        
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
    
            let titleView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 40))
            titleView.backgroundColor = UIColor(netHex: 0xF6F8FA)
            
            let titleLabel = UILabel()
            titleLabel.frame = CGRectMake(20, 7, tableView.frame.width, 20)
            titleLabel.backgroundColor = UIColor.clearColor()
            titleLabel.text = "Trip Score"
            titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
            titleLabel.textColor = UIColor(netHex: 0x003665)
            titleView.addSubview(titleLabel)
            return titleView
            
        }else if section == 1{
            let tabView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 37))
            tabView.backgroundColor = UIColor(netHex: 0xF6F8FA)
            
            self.mapButton = nil
            self.mapButton = UIButton()
            self.mapButton?.frame = CGRectMake(0, 0, tabView.frame.width/2, tabView.frame.height - 5/*bottom border padding*/)
            self.mapButton?.setTitle("By Map", forState: .Normal)
            self.mapButton?.addTarget(self, action: "byMapButtonPressed:", forControlEvents: .TouchUpInside)
            self.mapButton?.backgroundColor = UIColor.clearColor()
            tabView.addSubview(self.mapButton!)
            
            self.mapBorder = nil
            self.mapBorder = UIView()
            self.mapBorder?.frame = CGRectMake((self.mapBorder?.frame.origin.x)!, self.mapButton!.frame.size.height, self.mapButton!.frame.width, 5)
            tabView.addSubview(self.mapBorder!)
            
            self.zoneButton = nil
            self.zoneButton = UIButton()
            self.zoneButton?.frame = CGRectMake(tabView.frame.width/2, 0, tabView.frame.width/2, tabView.frame.height - 5/*bottom border padding*/)
            self.zoneButton?.setTitle("By Speeding Zone", forState: .Normal)
            self.zoneButton?.addTarget(self, action: "bySpeedingZoneButtonPressed:", forControlEvents: .TouchUpInside)
            self.zoneButton?.backgroundColor = UIColor.clearColor()
            tabView.addSubview(self.zoneButton!)
            
            self.zoneBorder = nil
            self.zoneBorder = UIView()
            self.zoneBorder?.frame = CGRectMake(tabView.frame.width/2, self.zoneButton!.frame.size.height, self.zoneButton!.frame.width, 5)
            tabView.addSubview(self.zoneBorder!)
            
            //set the selected button here
            
            if self.tabSelected == MapZoneTab.MapSelected {
                self.mapButton?.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
                self.mapButton?.setTitleColor(UIColor(netHex: 0x003665), forState: .Normal)
                self.mapBorder?.backgroundColor = UIColor(netHex: 0x00AEEF)
                
                self.zoneButton?.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 16.0)
                self.zoneButton?.setTitleColor(UIColor(netHex: 0x4C7394), forState: .Normal)
                self.zoneBorder?.backgroundColor = UIColor(netHex: 0xBBBDBE)

            }else{
                self.mapButton?.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 16.0)
                self.mapButton?.setTitleColor(UIColor(netHex: 0x4C7394), forState: .Normal)
                self.mapBorder?.backgroundColor = UIColor(netHex: 0xBBBDBE)
                self.mapBorder?.setNeedsDisplay()
                
                self.zoneButton?.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
                self.zoneButton?.setTitleColor(UIColor(netHex: 0x003665), forState: .Normal)
                self.zoneBorder?.backgroundColor = UIColor(netHex: 0x00AEEF)
            }
            
            
            return tabView
        }else {
            let sectionView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 37))
            sectionView.backgroundColor = UIColor(netHex: 0xF6F8FA)
            let tripDetailLabel = UILabel()
            tripDetailLabel.frame = CGRectMake(20, 0, sectionView.frame.width/2, sectionView.frame.height)
            tripDetailLabel.text = "Trip Details"
            tripDetailLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
            tripDetailLabel.textColor = UIColor(netHex: 0x003665)
            sectionView.addSubview(tripDetailLabel)
            return sectionView
        }
        
    }
    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//       
//    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var rowHeight:CGFloat = 75.0       //row height for recent trips by default
        
        if indexPath.section == 0{
            if StringConstants.SCREEN_HEIGHT == 480 {
                rowHeight = 140
            }else if StringConstants.SCREEN_HEIGHT == 568 {
                rowHeight = 135
            }else if StringConstants.SCREEN_HEIGHT == 667 {
                rowHeight = 160
            }else {
                rowHeight = 170
            }
        }else if indexPath.section == 1 {
            //depend upon the tab selected
            if self.tabSelected == MapZoneTab.MapSelected {
                
                if StringConstants.SCREEN_HEIGHT == 480 {
                    rowHeight = UIScreen.mainScreen().bounds.size.width - 5
                }else if StringConstants.SCREEN_HEIGHT == 568 {
                    rowHeight = UIScreen.mainScreen().bounds.size.width - 5
                }else if StringConstants.SCREEN_HEIGHT == 667 {
                    rowHeight = 315
                }else {
                    rowHeight = 315
                }
                
            }else {
                //change if row is expanded
                if self.zoneSelectedIndexPath != nil && indexPath.compare(self.zoneSelectedIndexPath!) == .OrderedSame {
                    rowHeight = 320
                }else{
                    rowHeight = 30
                }
            }
        }
        
        return CGFloat(rowHeight)
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.section == 1 {
            if self.tabSelected == MapZoneTab.ZoneSelected {
             animateZoneRow(indexPath)
            }
        }else if indexPath.section == 2 {
            //handle last 5 trips here
            if self.tripDetailRowSelected == indexPath.row {
                return
            }
            
            self.tripDetailRowSelected = indexPath.row
            
            reload()
        }
    }
    
    //MARK: - Custom Methods
    
    func byMapButtonPressed(sender: UIButton!) {
        
        if self.tabSelected == MapZoneTab.MapSelected {
            return
        }
        
        self.tabSelected = MapZoneTab.MapSelected
        reload()
        
    }
    
    func bySpeedingZoneButtonPressed(sender: UIButton!) {
        
        if self.tabSelected == MapZoneTab.ZoneSelected {
            return
        }
        
        self.tabSelected = MapZoneTab.ZoneSelected
        reload()
    }
    
    func reload() {
        reloadTableViewData(self.tripDetailRowSelected!)
        [self.tripHistoryTableView.reloadData()]
    }
    
    func loadData() {
        /*
        //see if data is updated
        //if no new update then get data from DB
        //if new update then Get data from service and store in DB
        */
        //
        
        self.historyData = []
        
        FacadeLayer.sharedinstance.fetchtripDetailData { (status, data, error) -> Void in
            self.historyData = []
            if(status == 1 && error == nil){
                self.historyData = data
                self.reload()
            }
            
        }
        
        
        
        
        
        
        

    }
    
    func dataModals() {
        
        
        
        //***************************** need to remove once actual data provided ***********************************
        
        
        let tripScore11 = TripScore(speedScore: 60, ecoScore: 50, attentionScore: nil)
        
        let eloc11 = EventLocation(latitude: 20.5, longitude: 25.5)
        let eloc12 = EventLocation(latitude: 21.5, longitude: 55.5)
        let eloc13 = EventLocation(latitude: 30.5, longitude: 45.5)
        let eloc14 = EventLocation(latitude: 33.5, longitude: 35.5)
        let eloc15 = EventLocation(latitude: 22.5, longitude: 15.5)
        let eloc16 = EventLocation(latitude: 45.5, longitude: 75.5)
        
        
        let e11 = Event(location: eloc11, type: EventType.Speeding, message: "......event11.....test message......long message")
        
        let e12 = Event(location: eloc12, type: EventType.Speeding, message: "......event11.....test message......long message")
        
        let e13 = Event(location: eloc13, type: EventType.Speeding, message: "......event11.....test message......long message")
        
        let e14 = Event(location: eloc14, type: EventType.Speeding, message: "......event11.....test message......long message")
        
        let e15 = Event(location: eloc15, type: EventType.Speeding, message: "......event11.....test message......long message")
        
        let e16 = Event(location: eloc16, type: EventType.Speeding, message: "......event11.....test message......long message")
        
        let events1 = [e11, e12, e13, e14, e15, e16]
        
        
        // init speedScore here... its not initialize
        let sz11 = SpeedZone(speedScore: 567, maxSpeed: 50, aboveSpeed: 12, withinSpeed: 13, violationCount: 1, speedBehaviour: 75, distanceTravelled: 123)
        
        // init speedScore here... its not initialize
        let sz12 = SpeedZone(speedScore: 568, maxSpeed: 60, aboveSpeed: 122, withinSpeed: 24, violationCount: 2, speedBehaviour: 45, distanceTravelled: 153)
        
        // init speedScore here... its not initialize
        let sz13 = SpeedZone(speedScore: 569, maxSpeed: 70, aboveSpeed: 22, withinSpeed: 2, violationCount: 12, speedBehaviour: 49, distanceTravelled: 13)
        
        let speedZones1 = [sz11, sz12, sz13]
        
        
      //"dd-MM-yyyy'T'HH':'mm':'ss'Z'"
        
        let history1 = History(tripid: "123", tripDate: "12-11-2016", distance: 25, tripPoints: 36, tripDuration: 5, dataUsageMessage:"datausagemessage", tripScore:tripScore11 ,events: events1, speedZones: speedZones1)
        
        self.historyData?.append(history1)
        //------------------------------------------------------------------------------------------//
        
        let tripScore12 = TripScore(speedScore: 20, ecoScore: 80, attentionScore: nil)
        
        let eloc21 = EventLocation(latitude: 60.5, longitude: 95.5)
        let eloc22 = EventLocation(latitude: 61.5, longitude: 65.5)
        let eloc23 = EventLocation(latitude: 60.5, longitude: 25.5)
        let eloc24 = EventLocation(latitude: 73.5, longitude: 45.5)
        let eloc25 = EventLocation(latitude: 62.5, longitude: 75.5)
        let eloc26 = EventLocation(latitude: 45.5, longitude: 75.5)
        
        
        let e21 = Event(location: eloc21, type: EventType.Speeding, message: "......event11.....test message......long message")
        
        let e22 = Event(location: eloc22, type: EventType.Speeding, message: "......event11.....test message......long message")
        
        let e23 = Event(location: eloc23, type: EventType.Speeding, message: "......event11.....test message......long message")
        
        let e24 = Event(location: eloc24, type: EventType.Speeding, message: "......event11.....test message......long message")
        
        let e25 = Event(location: eloc25, type: EventType.Speeding, message: "......event11.....test message......long message")
        
        let e26 = Event(location: eloc26, type: EventType.Speeding, message: "......event11.....test message......long message")
        
        let events2 = [e21, e22, e23, e24, e25, e26]
        
        
        let sz21 = SpeedZone(speedScore: 570, maxSpeed: 3, aboveSpeed: 2, withinSpeed: 3, violationCount: 10, speedBehaviour: 55, distanceTravelled: 123)
      
        let sz22 = SpeedZone(speedScore: 571, maxSpeed: 50, aboveSpeed: 12, withinSpeed: 4, violationCount: 20, speedBehaviour: 90, distanceTravelled: 153)
        
        //let sz23 = SpeedZone(speedScore: 567, maxSpeed: 70, aboveSpeed: 22, withinSpeed: 2, violationCount: 2, speedBehaviour: 10, distanceTravelled: 13)
        
        let speedZones2 = [sz21, sz22]
        
        //"dd-MM-yyyy'T'HH':'mm':'ss'Z'"
        
        let history2 = History(tripid: "124", tripDate: "13-11-2016", distance: 44, tripPoints: 90, tripDuration: 8, dataUsageMessage: "test",tripScore: tripScore12, events: events2, speedZones: speedZones2)
        
        self.historyData?.append(history2)
        
        let hisArr = [history1, history2]
        
        FacadeLayer.sharedinstance.dbactions.removeData("Trip_Detail")
        FacadeLayer.sharedinstance.dbactions.saveTripDetail(hisArr) { (status) -> Void in
            FacadeLayer.sharedinstance.fetchtripDetailData { (status, data, error) -> Void in
                self.historyData = []
                if(status == 1 && error == nil){
                    self.historyData = data
                    self.reload()
                }
                
            }
        }
    }
    
    
    func reloadTableViewData(index: Int){
        
        self.tripScores     = []
        self.tripMapEvents  = []
        self.tripZones      = []
        self.tripAnnotation = []
        self.zoneSelectedIndexPath = nil
        
        self.scoreRefreshRequired    = true
        self.mapRefreshRequired    = true
        self.zoneRefreshRequired     = true
        
        if self.historyData != nil && index < self.historyData?.count {
            
            let data = self.historyData![index] as History
            //1
            self.tripScores?.append(TripScore(speedScore: data.tripScore.speedScore, ecoScore: data.tripScore.ecoScore, attentionScore: nil))
            //2
            if self.tabSelected == MapZoneTab.MapSelected {
                self.tripMapEvents = data.events!
                
                if self.tripMapEvents != nil {
                    for var index = 0; index < tripMapEvents?.count; index++ {
                        let eventObj = tripMapEvents![index] as Event
                        let eventAnnotation = EventAnnotation(coordinate: CLLocationCoordinate2D(latitude: eventObj.location.latitude, longitude: eventObj
                            .location.longitude), annotationID: index)
                        self.tripAnnotation?.append(eventAnnotation)
                    }
                }
                
                
            }else{
                self.tripZones = data.speedZones
            }
            //3
        }
    }
    
    
    func fetchTripDetailsData(completionHandler:(status : Int, response: [History]?, error: NSError?) -> Void) -> Void{
        
        FacadeLayer.sharedinstance.dbactions.fetchtripDetailData { (status, response, error) -> Void in
            completionHandler(status: status, response: response, error: error)
        }
        
    }
    
    func animateZoneRow(indexPath: NSIndexPath) {
        
        if self.zoneSelectedIndexPath != nil && self.zoneSelectedIndexPath == indexPath {
           
            let cell = self.tripHistoryTableView.cellForRowAtIndexPath(self.zoneSelectedIndexPath!) as! HistoryZoneViewCell
            cell.indicatorButton.selected = false
            self.zoneSelectedIndexPath = nil
    
            self.tripHistoryTableView.beginUpdates()
            self.tripHistoryTableView.endUpdates()
        } else {
            
            if let previousIndexPath = self.zoneSelectedIndexPath {
                let cell = self.tripHistoryTableView.cellForRowAtIndexPath(previousIndexPath) as! HistoryZoneViewCell
                cell.indicatorButton.selected = false
            }
            
            let cell = self.tripHistoryTableView.cellForRowAtIndexPath(indexPath) as! HistoryZoneViewCell
            cell.indicatorButton.selected = true
            self.zoneSelectedIndexPath = indexPath
            
            self.tripHistoryTableView.beginUpdates()
            self.tripHistoryTableView.endUpdates()
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

extension HistoryPage: MapViewDelegate {
    func mapView(mapView: MKMapView!, didSelectAnnotation annotation: EventAnnotation) {
        
        let annotationID = annotation.annotationID
        //procced further for message alert
         var messageString = String()    //get message from config file on basis of annotation
        messageString = "Message as per annoatation ID: \(annotationID)"
        let alert = UIAlertController(title: nil, message:messageString , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
}


extension HistoryPage: ScoreCellDelegate {
    
    func scoreViewTapped(tag: Int) {
        
        var messageString = String()    //get message from config file
        
        switch tag {
        case 1 :
            print("speeding tapped")
            messageString = "<Speeding message based on the trip>"
        case 2:
            print("eco tapped")
            messageString = "<Eco message based on the trip>"
        case 3:
            print("attention tapped")
             messageString = "<Data usage message based on the trip>"
        default:
            print("default in cell")
        }
        
        let alert = UIAlertController(title: nil, message:messageString , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

extension HistoryPage: SpeedZoneCellDelegate {
    
    func severeViolationViewTapped() {
        var messageString = String()    //get message from config file
        
        messageString = "<Severe Violation message for the trip>"
        
        let alert = UIAlertController(title: nil, message:messageString , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

extension HistoryPage: TripDetailCellDelegate {
    
    func shareButtonTapped(cell: HistoryTripDetailCell) {
        let indexpath = self.tripHistoryTableView.indexPathForCell(cell)
        print(indexpath?.row)
//        super.displayActivityView()
    }
}



