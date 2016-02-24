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
    func scoreCellRefreshRequired() -> Bool
    func localizeTripScore(cell: HistoryTripScoreCell)
}

protocol MapViewDelegate {
    func mapView(mapView: MKMapView!, didSelectAnnotation annotation: EventAnnotation)
    func mapCellRefreshRequired() -> Bool
}

protocol SpeedZoneCellDelegate {
    func severeViolationViewTapped()
    func zoneCellRefreshRequired() -> Bool
    func localizeMapZone(cell: HistoryZoneViewCell)
}

protocol TripDetailCellDelegate {
    func shareButtonTapped(cell: HistoryTripDetailCell)
    func localizeTripDetails(cell: HistoryTripDetailCell)
}

class HistoryPage: BaseViewController {

    enum MapZoneTab: Int{
        case MapSelected
        case ZoneSelected
    }
    
    @IBOutlet weak var tripHistoryTableView: UITableView!

    var tripScores       = [TripScore]?()        //trip scores info
    var tripMapEvents    = [Event]?()            //trip events info
    var tripZones        = [SpeedZone]?()        //trip zones info
    var tripAnnotation   = [EventAnnotation]?()  //annotation array
    var historyData      = [History]?()          //recent trips info
    var tabSelected: MapZoneTab = MapZoneTab.MapSelected
    
    var tripDetailRowSelected       : Int?
    var zoneSelectedIndexPath       : NSIndexPath?
    var recentTripSelectedIndexPath : NSIndexPath?
    var mapButton                   : UIButton?
    var mapBorder                   : UIView?
    var zoneButton                  : UIButton?
    var zoneBorder                  : UIView?

    var scoreRefreshRequired    = true
    var mapRefreshRequired      = true
    var zoneRefreshRequired     = true
    
    let NUM_OF_SECTION = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Viewcontroller Delegate Methods
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.scoreRefreshRequired = true
        self.mapRefreshRequired   = true
        self.zoneRefreshRequired  = true
        
        tabSelected = MapZoneTab.MapSelected
        self.tripDetailRowSelected = 0
        self.zoneSelectedIndexPath = nil
    
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Custom Methods
    
    /**
        called when 'By Map' tab is pressed
    
        - Parameter sender:   UIButton type
    */
    func byMapButtonPressed(sender: UIButton!) {
        
        if self.tabSelected == MapZoneTab.MapSelected {
            return
        }
        
        self.tabSelected = MapZoneTab.MapSelected
        
        self.tripHistoryTableView.beginUpdates()
        let range = NSMakeRange(1, 1)
        let section = NSIndexSet(indexesInRange: range)
        self.tripHistoryTableView.reloadSections(section, withRowAnimation: .Automatic)
        self.tripHistoryTableView.endUpdates()
    }
    
    /**
        Called when 'By Speeding Zone' tab is pressed
     
        - Parameter sender:   UIButton type
     */
    func bySpeedingZoneButtonPressed(sender: UIButton!) {
        
        if self.tabSelected == MapZoneTab.ZoneSelected {
            return
        }
        
        self.tabSelected = MapZoneTab.ZoneSelected
        
        self.tripHistoryTableView.beginUpdates()
        let range = NSMakeRange(1, 1)
        let section = NSIndexSet(indexesInRange: range)
        self.tripHistoryTableView.reloadSections(section, withRowAnimation: .Automatic)
        self.tripHistoryTableView.endUpdates()
    }
    /**
     Reload the data source and reload page
     */
    
    func reload() {
        reloadTableViewData(self.tripDetailRowSelected!)
        [self.tripHistoryTableView.reloadData()]
    }
    
    /**
        Get data form the DB and reload the page
     */
    func loadData() {

        FacadeLayer.sharedinstance.fetchtripDetailData { (status, data, error) -> Void in
            self.historyData = []
            if(status == 1 && error == nil){
                self.historyData = data
                self.reload()
            }
        }
    }
    
    /**
     Reload the data source
     */
    func reloadTableViewData(index: Int){
        
        self.tripScores     = []
        self.tripMapEvents  = []
        self.tripZones      = []
        self.tripAnnotation = []
        self.zoneSelectedIndexPath = nil
        
        self.scoreRefreshRequired    = true
        self.mapRefreshRequired      = true
        self.zoneRefreshRequired     = true
        
        if self.historyData != nil && index < self.historyData?.count {
            
            //1
            for item in self.historyData! {
                let tripItem = item as History
                self.tripScores?.append(tripItem.tripScore)
            }
            
            let data = self.historyData![index] as History
            //2
            //if self.tabSelected == MapZoneTab.MapSelected {
                self.tripMapEvents = data.events!
                
                if self.tripMapEvents != nil {
                    for var index = 0; index < tripMapEvents?.count; index++ {
                        let eventObj = tripMapEvents![index] as Event
                        let eventAnnotation = EventAnnotation(coordinate: CLLocationCoordinate2D(latitude: eventObj.location.latitude, longitude: eventObj
                            .location.longitude), annotationID: index)
                        self.tripAnnotation?.append(eventAnnotation)
                    }
                }
                
                
            //}else{
                self.tripZones = data.speedZones
            self.tripZones = self.tripZones!.sort({ (trip1, trip2) -> Bool in
                 trip1.maxSpeed.integerValue < trip2.maxSpeed.integerValue
            })
           // }
            //3
        }
    }
    
    /**
        Reload the Map view and Zone view
        - Parameter indexPath: Indexpath of the row to be loaded
     */
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
}

extension HistoryPage: UITableViewDataSource {
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return NUM_OF_SECTION
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        
        var numOfRows = 0
        
        if section == 0 {
            numOfRows = 1
        }else if section == 1 {
            if self.tabSelected == MapZoneTab.MapSelected {
                numOfRows = 1
            }else {
                if self.tripZones?.count > 0{
                    numOfRows = (self.tripZones?.count)!
                }
            }
        }else if section == 2 {
            if self.historyData?.count > 0{
                numOfRows = (self.historyData?.count)!
            }
        }
        return numOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellID.HISTORY_SCORE, forIndexPath: indexPath) as! HistoryTripScoreCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.delegate = self
            
            let rowIndex = self.tripDetailRowSelected
            
            self.tripScores?.count > 0 ? cell.configure(self.tripScores?[rowIndex!]) : cell.configure(nil)
            self.scoreRefreshRequired = false
            
            return cell
        }else if indexPath.section == 1{
            
            if self.tabSelected == MapZoneTab.MapSelected {
                let cell = tableView.dequeueReusableCellWithIdentifier(CellID.HISTORY_MAP, forIndexPath: indexPath) as! HistoryMapViewCell
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
                let cell = tableView.dequeueReusableCellWithIdentifier(CellID.HISTORY_ZONE, forIndexPath: indexPath) as! HistoryZoneViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                
                self.tripScores?.count > 0 ? cell.configure(self.self.tripZones![indexPath.row]) : cell.configure(nil)
                self.zoneRefreshRequired = false
                
                return cell
            }
        }else if indexPath.section == 2{     //section 2
            let cell = tableView.dequeueReusableCellWithIdentifier(CellID.HISTORY_DETAIL, forIndexPath: indexPath) as! HistoryTripDetailCell
            cell.delegate = self
            cell.configure(self.historyData![indexPath.row])
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellID.HISTORY_DETAIL, forIndexPath: indexPath) as! HistoryTripDetailCell
            return cell
        }
    }
}

extension HistoryPage: UITableViewDelegate {

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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let titleView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 40))
            titleView.backgroundColor = UIColor(netHex: 0xF6F8FA)
            
            let titleLabel              = UILabel()
            titleLabel.frame            = CGRectMake(20, 7, tableView.frame.width, 20)
            titleLabel.backgroundColor  = UIColor.clearColor()
            titleLabel.text             = LocalizationConstants.History.Score.ScoreTitle.localized()
            titleLabel.font             = UIFont(name: Font.HELVETICA_NEUE_MEDIUM, size: 15.0)
            titleLabel.textColor        = UIColor(netHex: 0x003665)
            titleView.addSubview(titleLabel)
            return titleView
            
        }else if section == 1{
            let tabView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 37))
            tabView.backgroundColor = UIColor(netHex: 0xF6F8FA)
            
            self.mapButton                  = nil
            self.mapButton                  = UIButton()
            self.mapButton?.frame           = CGRectMake(0, 0, tabView.frame.width/2, tabView.frame.height - 5/*bottom border padding*/)
            self.mapButton?.setTitle(LocalizationConstants.History.View.Map.localized(), forState: .Normal)
            self.mapButton?.addTarget(self, action: "byMapButtonPressed:", forControlEvents: .TouchUpInside)
            self.mapButton?.backgroundColor = UIColor.clearColor()
            tabView.addSubview(self.mapButton!)
            
            self.mapBorder          = nil
            self.mapBorder          = UIView()
            self.mapBorder?.frame   = CGRectMake((self.mapBorder?.frame.origin.x)!, self.mapButton!.frame.size.height, self.mapButton!.frame.width, 5)
            tabView.addSubview(self.mapBorder!)
            
            self.zoneButton                 = nil
            self.zoneButton                 = UIButton()
            self.zoneButton?.frame          = CGRectMake(tabView.frame.width/2, 0, tabView.frame.width/2, tabView.frame.height - 5/*bottom border padding*/)
            self.zoneButton?.setTitle(LocalizationConstants.History.View.Speeding_Zone.localized(), forState: .Normal)
            self.zoneButton?.addTarget(self, action: "bySpeedingZoneButtonPressed:", forControlEvents: .TouchUpInside)
            self.zoneButton?.backgroundColor = UIColor.clearColor()
            tabView.addSubview(self.zoneButton!)
            
            self.zoneBorder         = nil
            self.zoneBorder         = UIView()
            self.zoneBorder?.frame  = CGRectMake(tabView.frame.width/2, self.zoneButton!.frame.size.height, self.zoneButton!.frame.width, 5)
            tabView.addSubview(self.zoneBorder!)
            
            //set the selected button here
            
            if self.tabSelected == MapZoneTab.MapSelected {
                self.mapButton?.titleLabel?.font = UIFont(name: Font.HELVETICA_NEUE_MEDIUM, size: 16.0)
                self.mapButton?.setTitleColor(UIColor(netHex: 0x003665), forState: .Normal)
                self.mapBorder?.backgroundColor = UIColor(netHex: 0x00AEEF)
                
                self.zoneButton?.titleLabel?.font = UIFont(name: Font.HELVETICA_NEUE, size: 16.0)
                self.zoneButton?.setTitleColor(UIColor(netHex: 0x4C7394), forState: .Normal)
                self.zoneBorder?.backgroundColor = UIColor(netHex: 0xBBBDBE)
                
            }else{
                self.mapButton?.titleLabel?.font = UIFont(name: Font.HELVETICA_NEUE, size: 16.0)
                self.mapButton?.setTitleColor(UIColor(netHex: 0x4C7394), forState: .Normal)
                self.mapBorder?.backgroundColor = UIColor(netHex: 0xBBBDBE)
                self.mapBorder?.setNeedsDisplay()
                
                self.zoneButton?.titleLabel?.font = UIFont(name: Font.HELVETICA_NEUE_MEDIUM, size: 16.0)
                self.zoneButton?.setTitleColor(UIColor(netHex: 0x003665), forState: .Normal)
                self.zoneBorder?.backgroundColor = UIColor(netHex: 0x00AEEF)
            }
            return tabView
        }else {
            let sectionView             = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 37))
            sectionView.backgroundColor = UIColor(netHex: 0xF6F8FA)
            let tripDetailLabel         = UILabel()
            tripDetailLabel.frame       = CGRectMake(20, 0, sectionView.frame.width/2, sectionView.frame.height)
            tripDetailLabel.text        = LocalizationConstants.History.TripDetails.Trip_Details.localized()
            tripDetailLabel.font        = UIFont(name: Font.HELVETICA_NEUE_MEDIUM, size: 15.0)
            tripDetailLabel.textColor   = UIColor(netHex: 0x003665)
            sectionView.addSubview(tripDetailLabel)
            return sectionView
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var rowHeight:CGFloat = 75.0       //default
        
        if indexPath.section == 0{
            if StringConstants.SCREEN_HEIGHT <= Resolution.height.iPhone4 {
                rowHeight = 160
            }else if StringConstants.SCREEN_HEIGHT == Resolution.height.iPhone5 {
                rowHeight = 155
            }else if StringConstants.SCREEN_HEIGHT >= Resolution.height.iPhone6 {
                rowHeight = 185
            }else {
                rowHeight = 185
            }
        }else if indexPath.section == 1 {
            if self.tabSelected == MapZoneTab.MapSelected {
                
                if StringConstants.SCREEN_HEIGHT <= Resolution.height.iPhone4 {
                    rowHeight = UIScreen.mainScreen().bounds.size.width - 5
                }else if StringConstants.SCREEN_HEIGHT == Resolution.height.iPhone5 {
                    rowHeight = UIScreen.mainScreen().bounds.size.width - 5
                }else if StringConstants.SCREEN_HEIGHT >= Resolution.height.iPhone6 {
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
            if self.tripDetailRowSelected == indexPath.row {
                return
            }
            self.tripDetailRowSelected = indexPath.row
            reload()
        }
    }
}

extension HistoryPage: ScoreCellDelegate {
    
    /**
     Localize the `HistoryTripScoreCell` cell
     - Parameter cell: cell instance of the tableview
     */
    func localizeTripScore(cell: HistoryTripScoreCell) {
        cell.speedingLabel.text = LocalizationConstants.History.Score.Speeding.localized()
        cell.ecoLabel.text  = LocalizationConstants.History.Score.Eco.localized()
        cell.attentionLabel.text = LocalizationConstants.History.Score.Attention.localized()
    }
    
    /**
     Called when score view is tapped. This will display the messages to user as per the score of the trip.
     - Parameter tag: Tag of the score view which is tapped
     */
    func scoreViewTapped(tag: Int) {
        
        if self.historyData?.count > 0 {
            var messageString = String()
            
            switch tag {
            case 1 :
                if let message = self.historyData![self.tripDetailRowSelected!].speedingMessage {
                    messageString = message
                }
            case 2:
                if let message = self.historyData![self.tripDetailRowSelected!].ecoMessage {
                    messageString = message
                }
            case 3:
                if let message = self.historyData![self.tripDetailRowSelected!].dataUsageMessage {
                     messageString = message
                }
            default:
                print("default in cell")
            }
            
            let alert = UIAlertController(title: nil, message:messageString , preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /**
     Check if score view need to be refreshed
        - Returns: Bool
     */
    func scoreCellRefreshRequired() -> Bool {
        return self.scoreRefreshRequired
    }
}

extension HistoryPage: MapViewDelegate {
    
    /**
     Tells the delegate that which annotation of map view has been tapped
     
     - Parameter:
        - mapView: Mapview instance
        - annotation: annotation instance which is tapped. 'annotationID' form the instance may bw used to know which annotation is tapped
    */
    func mapView(mapView: MKMapView!, didSelectAnnotation annotation: EventAnnotation) {
        
        let annotationID = annotation.annotationID
        var messageString = String()
        
        if let message = self.tripMapEvents![annotationID].message {
             messageString = message                                    //consider localization
        }else{
            messageString = "Message not available"                     //consider localization
        }
    
        let alert = UIAlertController(title: nil, message:messageString , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))        //consider localization
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func mapCellRefreshRequired() -> Bool {
        return self.mapRefreshRequired
    }
}

extension HistoryPage: SpeedZoneCellDelegate {
    
    /**
     Localize the `HistoryZoneViewCell` cell
     - Parameter cell: cell instance of the tableview
     */
    func localizeMapZone(cell: HistoryZoneViewCell) {
        cell.speedingLabel.text = LocalizationConstants.History.View.Speeding.localized()
        cell.severeViolationLabel.text = LocalizationConstants.History.View.Severe_Violation.localized()
        cell.distanceLabel.text = LocalizationConstants.History.View.Distance.localized()
        cell.withinMaxSpeedLabel.text = LocalizationConstants.History.View.Within_Max_Speed.localized()
        cell.aboveMaxSpeedLabel.text = LocalizationConstants.History.View.Above_Max_Limit.localized()
    }
    
    /**
     Called when Severe violation view is tapped. It displays the message for the severe violations during the trip
     */
    func severeViolationViewTapped() {
        var messageString = String()
        
        messageString = "<Severe Violation message for the trip>" //consider localization
        
        let alert = UIAlertController(title: nil, message:messageString, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))        //consider localization
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func zoneCellRefreshRequired() -> Bool {
        return self.zoneRefreshRequired
    }
}

extension HistoryPage: TripDetailCellDelegate {
    
    /**
     Localize the `HistoryTripDetailCell` cell
     - Parameter cell: cell instance of the tableview
     */
    func localizeTripDetails(cell: HistoryTripDetailCell) {
        cell.distanceLabel.text = LocalizationConstants.History.TripDetails.Distance.localized()
        cell.pointsLabel.text = LocalizationConstants.History.TripDetails.Trip_Points.localized()
    }
    
    /**
     Called when share button of the recent trip is tapped.
     - Parameter cell: this will get the information of the trip details
     */
    func shareButtonTapped(cell: HistoryTripDetailCell) {
        let indexpath   = self.tripHistoryTableView.indexPathForCell(cell)
        let speedScore  = (self.tripScores?[indexpath!.row].speedScore.integerValue)!
        let ecoScore    = (self.tripScores?[indexpath!.row].ecoScore.integerValue)!
        
        //consider localization
        super.displayActivityView("Trip Score", detail: "On \((cell.tripDateLabel.text)!), I travelled with distance of \((cell.tripDistanceLabel.text)!)’s over a period of \((cell.tripDurationLabel.text)!) and achieved above scores using my KBC First 10,000KM app.", imageInfo: ["speedScore":String(speedScore), "ecoScore":String(ecoScore)], shareOption: ShareTemplate.ShareOption.TRIP_DETAIL)
    }
}



