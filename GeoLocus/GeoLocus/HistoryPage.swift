//
//  HistoryPage.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class HistoryPage: UIViewController, UITableViewDataSource, UITableViewDelegate {

    enum MapZoneTab: Int{
        case MapSelected
        case ZoneSelected
    }
    
    @IBOutlet weak var HTableView: UITableView!

    var historyDataArray = NSMutableArray?()
    var historyScores = TripScore?()
    var historyMap = [Event]?()
    var historyZones = [SpeedZone]?()
    var historyData : [History]?
    var tripDetailRowSelected : Int?
    
    
    
    var tabSelected: MapZoneTab = MapZoneTab.MapSelected
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tabSelected = MapZoneTab.MapSelected
        self.tripDetailRowSelected = 0 // this may be nil if no trip detail data
          dataModals()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Tableview Delegate & Datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        var numOfRows = 0
        
        if section == 0 {
            numOfRows = 1
        }else if section == 1 {
            //depend upon the tab option
            
            if self.tabSelected == MapZoneTab.MapSelected {
                numOfRows = 1
            }else {
                numOfRows = (self.historyZones?.count)!      //change dynamically
            }
        }else if section == 2 {
            numOfRows = (self.historyData?.count)!
        }
        
        return numOfRows
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var headerHeight = 0
        
        if section == 0 {
            headerHeight = 1
        }else {
            headerHeight = 20
        }
        
        return CGFloat(headerHeight)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        print(historyMap)
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("HTSCell", forIndexPath: indexPath) as! HistoryTripScoreCell
            return cell
        }else if indexPath.section == 1{
            
            if self.tabSelected == MapZoneTab.MapSelected {
                let cell = tableView.dequeueReusableCellWithIdentifier("HMVCell", forIndexPath: indexPath) as! HistoryMapViewCell
                return cell
            }else {
                let cell = tableView.dequeueReusableCellWithIdentifier("HSZCell", forIndexPath: indexPath) as! HistoryZoneViewCell
                return cell
            }
        }else if indexPath.section == 2{     //section 2
            let cell = tableView.dequeueReusableCellWithIdentifier("HTDCell", forIndexPath: indexPath) as! HistoryTripDetailCell
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("HTDCell", forIndexPath: indexPath) as! HistoryTripDetailCell  //remove this
            return cell
        }
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return UIView(frame: CGRectZero)
        }else if section == 1{
            let tabView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 20))
            
            let mapButton = UIButton()
            mapButton.frame = CGRectMake(0, 0, tabView.frame.width/2, tabView.frame.height)
            mapButton.setTitle("By Map", forState: .Normal)
            mapButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            mapButton.titleLabel?.font = UIFont(name: "Helvetica Neue Regular", size: 15.0)
            mapButton.addTarget(self, action: "byMapButtonPressed:", forControlEvents: .TouchUpInside)
            tabView.addSubview(mapButton)
            
            let zoneButton = UIButton()
            zoneButton.frame = CGRectMake(tabView.frame.width/2, 0, tabView.frame.width/2, tabView.frame.height)
            zoneButton.setTitle("By Speeding Zone", forState: .Normal)
            zoneButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            zoneButton.addTarget(self, action: "bySpeedingZoneButtonPressed:", forControlEvents: .TouchUpInside)
            tabView.addSubview(zoneButton)
            
            //set the selected button here
            
            return tabView
        }else {
            let tabView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 20))
            let tripDetailLabel = UILabel()
            tripDetailLabel.frame = CGRectMake(0, 0, tabView.frame.width/2, tabView.frame.height)
            tripDetailLabel.text = "Trip Detail"
            tripDetailLabel.font = UIFont(name: "Helvetica Neue Regular", size: 15.0)
            tabView.addSubview(tripDetailLabel)
            return tabView
        }
        
    }
    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//       
//    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var rowHeight:CGFloat = 200.0
        
        if indexPath.section == 1 {
            //depend upon the tab selected
            if self.tabSelected == MapZoneTab.MapSelected {
                rowHeight = UIScreen.mainScreen().bounds.size.width
            }else {
                //change if row is expanded
                if self.selectedIndexPath != nil && indexPath.compare(self.selectedIndexPath!) == .OrderedSame {
                    rowHeight = 360
                }else{
                    rowHeight = 30
                }
            }
        }
        
        return CGFloat(rowHeight)
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.section == 1 {
            if self.tabSelected == MapZoneTab.ZoneSelected {
                if selectedIndexPath != nil && selectedIndexPath == indexPath {
                    selectedIndexPath = nil
                    HTableView.beginUpdates()
                    let hzCell = tableView.cellForRowAtIndexPath(indexPath) as! HistoryZoneViewCell
                    hzCell.indicatorImageView.image = UIImage(named:"HArrow.png")
                    HTableView.endUpdates()
                } else {
                    selectedIndexPath = indexPath
                    HTableView.beginUpdates()
                    let hzCell = tableView.cellForRowAtIndexPath(indexPath) as! HistoryZoneViewCell
                    hzCell.indicatorImageView.image = UIImage(named:"VArrow.png")
                    HTableView.endUpdates()
                }
                
            }
        }else if indexPath.section == 2 {
            //handle last 5 trips here
            reloadTableViewData(indexPath.row)
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
        [HTableView.reloadData()]
    }
    
    
    
    func dataModals() {
        
        historyData = []
        
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
        
        
        
        let sz11 = SpeedZone(maxSpeed: 50, aboveSpeed: 12, withinSpeed: 13, violationCount: 1, speedBehaviour: 75, distanceTravelled: 123)
        
        let sz12 = SpeedZone(maxSpeed: 60, aboveSpeed: 122, withinSpeed: 24, violationCount: 2, speedBehaviour: 45, distanceTravelled: 153)
        
        let sz13 = SpeedZone(maxSpeed: 70, aboveSpeed: 22, withinSpeed: 2, violationCount: 12, speedBehaviour: 49, distanceTravelled: 13)
        
        let speedZones1 = [sz11, sz12, sz13]
        
      //"dd-MM-yyyy'T'HH':'mm':'ss'Z'"
        
        let history1 = History(tripid: 123, tripDate: "12-11-2016", distance: 25, tripPoints: 36, tripDuration: 5,  tripScore:tripScore11 ,eventLocations: events1, speedZones: speedZones1)
        
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
        
        
        
        let sz21 = SpeedZone(maxSpeed: 3, aboveSpeed: 2, withinSpeed: 3, violationCount: 10, speedBehaviour: 55, distanceTravelled: 123)
        
        let sz22 = SpeedZone(maxSpeed: 50, aboveSpeed: 12, withinSpeed: 4, violationCount: 20, speedBehaviour: 90, distanceTravelled: 153)
        
        let sz23 = SpeedZone(maxSpeed: 70, aboveSpeed: 22, withinSpeed: 2, violationCount: 2, speedBehaviour: 10, distanceTravelled: 13)
        
        let speedZones2 = [sz21, sz22, sz23]
        
        //"dd-MM-yyyy'T'HH':'mm':'ss'Z'"
        
        let history2 = History(tripid: 124, tripDate: "13-11-2016", distance: 44, tripPoints: 90, tripDuration: 8, tripScore: tripScore12, eventLocations: events2, speedZones: speedZones2)
        
        self.historyData?.append(history2)
        
        
        //1st init of data
        reloadTableViewData(self.tripDetailRowSelected!)
    }
    
    
    func reloadTableViewData(index: Int){
        
        
        self.historyScores = TripScore?()
        self.historyMap = []
        self.historyZones = []
        
        if self.historyData != nil && index < self.historyData?.count {
            
            let data = self.historyData![index] as History
            //1
            self.historyScores = data.tripScore
            //2
            if self.tabSelected == MapZoneTab.MapSelected {
                self.historyMap = data.eventLocations!
            }else{
                self.historyZones = data.speedZones
            }
            //3
            
            self.HTableView.reloadData()
        }
        
        /*
        self.historyDataArray?.removeAllObjects()
        
        if self.historyData != nil && index < self.historyData?.count {
            
            let data = self.historyData![index] as History
            //1
            self.historyDataArray?.addObject(data.tripScore)
            //2
            if self.tabSelected == MapZoneTab.MapSelected {
                self.historyDataArray?.addObject(data.eventLocations!)
            }else{
                self.historyDataArray?.addObject(data.speedZones)
            }
            //3
            self.historyDataArray?.addObject(self.historyData!)
        }*/
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
