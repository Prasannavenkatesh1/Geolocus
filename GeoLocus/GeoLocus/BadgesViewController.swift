//
//  BadgesViewController.swift
//  GeoLocus
//
//  Created by khan on 19/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class BadgesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var badgeTableView: UITableView!

    var badgeNotEarnedArray = [Badge]()
    var badgeEarnedArray = [Badge]()
    var levelArray = [Badge]()
    var plistBadgeArray = []
    var plistLevelArray = []
    var badgesSpecification = ["Badges to be Earned", "Badges Earned", "Levels"]
    
    let BADGE_CELL_ID = "BadgeCell"
    
    var sahredObject = FacadeLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        reloadDataSource()
    }
    
    
    //MARK: - Tableview Datasource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //need to check using the filter in array
        
        var numOfRows = 0
        
        if section == 0 {
            numOfRows = self.badgeNotEarnedArray.count > 0 ? self.badgeNotEarnedArray.count : 0
        }else if section == 1 {
            numOfRows = self.badgeEarnedArray.count > 0 ? self.badgeEarnedArray.count : 0
        }else if section == 2 {
            numOfRows = self.levelArray.count > 0 ? self.levelArray.count : 0
        }
        
        return numOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BADGE_CELL_ID, forIndexPath: indexPath) as! BadgeCell
        
        var dataArray = [Badge]()
        if indexPath.section == 0 {
            dataArray = self.badgeNotEarnedArray
        }else if indexPath.section == 1 {
            dataArray = self.badgeEarnedArray
        }else if indexPath.section == 2 {
            dataArray = self.levelArray
        }
        
        let badge = dataArray[indexPath.row]

        if badge.isEarned {
            cell.shareButton.hidden = false
            
            cell.badgeTitle.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
            cell.badgeTitle.textColor = UIColor(netHex: 0x003665)
            
            cell.badgeDescription.textColor = UIColor(netHex: 0x181F29)
            
        }else {
            cell.shareButton.hidden = true
            cell.badgeTitle.font = UIFont(name: "Helvetica Neue", size: 15.0)
            cell.badgeTitle.textColor = UIColor(netHex: 0x003665)
            
            cell.badgeDescription.textColor = UIColor(netHex: 0x4c7394)
        }
        
        
        cell.badgeIcon.image = UIImage(named: dataArray[indexPath.row].badgeIcon)
        cell.badgeTitle.text = badge.badgeTitle
        cell.badgeDescription.text = badge.badgeDescription
        
        let attributes = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let attributedText = NSAttributedString(string: cell.shareButton.currentTitle!, attributes: attributes)
        cell.shareButton.titleLabel?.attributedText = attributedText
        
        cell.shareButton.addTarget(self, action: "shareButtonClicked:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var headerHeight = 35
        
        if (section == 0 && self.badgeNotEarnedArray.count == 0) || (section == 1 && self.badgeEarnedArray.count == 0) || (section == 2 && self.levelArray.count == 0) {
            headerHeight = 1
        }
    
        return CGFloat(headerHeight)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var otherContentHeight:CGFloat = 80.0       //4s/5/5s
        var descString = ""
        
        if indexPath.section == 0 {
            descString = self.badgeNotEarnedArray[indexPath.row].badgeDescription
        }else if indexPath.section == 1 {
            descString = self.badgeEarnedArray[indexPath.row].badgeDescription
        }else {
            descString = self.levelArray[indexPath.row].badgeDescription
        }
        
        let stringHeight = descString.heightWithConstrainedWidth(tableView.frame.size.width - 20 - 10 - 84 - 30 - 20, font: UIFont(name: "Helvetica Neue", size: 15.0)!)
        
        //print("section: \(indexPath.section)...row:\(indexPath.row)...height:\(stringHeight)...rowheight:\(stringHeight+otherContentHeight)")
        
        if StringConstants.SCREEN_HEIGHT >= 568 {
            otherContentHeight -= 5
        }
        
        return max(CGFloat(otherContentHeight + stringHeight), CGFloat(114))
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var titleView = UIView(frame: CGRectZero)
        
        if (section == 0 && self.badgeNotEarnedArray.count != 0) || (section == 1 && self.badgeEarnedArray.count != 0) || (section == 2 && self.levelArray.count != 0){
            
            titleView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 35))
            titleView.backgroundColor = UIColor(netHex: 0xF6F8FA)
            
            let titleLabel = UILabel()
            titleLabel.frame = CGRectMake(20, 7, tableView.frame.width, 20)
            titleLabel.backgroundColor = UIColor.clearColor()
            titleLabel.text = self.badgesSpecification[section]
            titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
            //titleLabel.font.bold()
            titleLabel.textColor = UIColor(netHex: 0x003665)
            
            titleView.addSubview(titleLabel)

        }
            return titleView
    }
    
    //MARK:- Navigation methods
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        let storyBoard = UIStoryboard(name: StringConstants.StoryBoardIdentifier, bundle: nil)
        let rootView = storyBoard.instantiateViewControllerWithIdentifier(StringConstants.RootViewController)
        let navigationView = UINavigationController(rootViewController: rootView)
        self.revealViewController().setFrontViewController(navigationView, animated: true)
         
    }
    
    
    func reloadDataSource(){
        
        /*
        //get plist file for image names
        //see if data is updated
        //if no new update then get data from DB
        //if new update then Get data from service and store in DB
        */
        //
        
        //1. Get data from plist
        let path = NSBundle.mainBundle().pathForResource("BadgesDetails", ofType: "plist")
        let dataDict = NSDictionary(contentsOfFile: path!)
        self.plistBadgeArray = (dataDict?.valueForKey("badge"))! as! NSArray
        self.plistLevelArray = (dataDict?.valueForKey("level"))! as! NSArray
        
        
        if StringConstants.appDataSynced {
            //get from DB and reload table
            
            fetchBadgeData({ (status, response, error) -> Void in
                if(status == 1 && error == nil) {
                    
                    //filtering then ordering each array
                    
                    self.badgeNotEarnedArray = []
                    self.badgeEarnedArray = []
                    self.levelArray = []
                    
                    self.badgeNotEarnedArray = response!.filter({ (badge) -> Bool in
                        badge.isEarned == false && badge.badgeType == Badge.BadgesType.Badge
                    }).sort({ (badge1, badge2) -> Bool in
                        badge1.orderIndex < badge2.orderIndex
                    })
                    
                    self.badgeEarnedArray = response!.filter({ (badge) -> Bool in
                        badge.isEarned == true && badge.badgeType == Badge.BadgesType.Badge
                    }).sort({ (badge1, badge2) -> Bool in
                        badge1.orderIndex < badge2.orderIndex
                    })
                    
                    self.levelArray = response!.filter({ (badge) -> Bool in
                        badge.badgeType == Badge.BadgesType.Level
                    }).sort({ (badge1, badge2) -> Bool in
                        badge1.orderIndex < badge2.orderIndex
                    })
                    
                    
                    for var index = 0; index < self.badgeNotEarnedArray.count; index++ {
                        
                        let title = self.badgeNotEarnedArray[index].badgeTitle
                        
                        for var pIndex = 0; pIndex < self.plistBadgeArray.count; pIndex++ {
                            if self.plistBadgeArray[pIndex]["title"] as! String == title {
                    
                                let isEarned = self.badgeNotEarnedArray[index].isEarned
                                
                                self.badgeNotEarnedArray[index].badgeIcon = isEarned ? self.plistBadgeArray[pIndex]["icon"] as! String: self.plistBadgeArray[pIndex]["icon_not_earned"] as! String
                            }
                        }
                    }
                    
                    for var index = 0; index < self.badgeEarnedArray.count; index++ {
                        
                        let title = self.badgeEarnedArray[index].badgeTitle
                        
                        for var pIndex = 0; pIndex < self.plistBadgeArray.count; pIndex++ {
                            if self.plistBadgeArray[pIndex]["title"] as! String == title {
                                
                                let isEarned = self.badgeEarnedArray[index].isEarned
                                
                                self.badgeEarnedArray[index].badgeIcon = isEarned ? self.plistBadgeArray[pIndex]["icon"] as! String: self.plistBadgeArray[pIndex]["icon_not_earned"] as! String
                            }
                        }
                    }
                    
                    for var index = 0; index < self.levelArray.count; index++ {
                        
                        let title = self.levelArray[index].badgeTitle
                        
                        for var pIndex = 0; pIndex < self.plistLevelArray.count; pIndex++ {
                            if self.plistLevelArray[pIndex]["title"] as! String == title {
                                
                                let isEarned = self.levelArray[index].isEarned
                                
                                self.levelArray[index].badgeIcon = isEarned ? self.plistLevelArray[pIndex]["icon"] as! String: self.plistLevelArray[pIndex]["icon_not_earned"] as! String
                            }
                        }
                    }
                    
                    
                    self.badgeTableView.reloadData()
                    
                    
                }else{
                    //something went wrong
                    print("error while fetching badge data from DB")
                }
            })
            
        }else{
            //call services...get data...parse
            //store data in DB
            //reload table
            
            
            self.requestBadgeData({ (status, response, error) -> Void in
                
            })
        }
        
        
        //badges
        
        for var index = 0; index < self.plistBadgeArray.count - 2; index++ {
            
            let badge = Badge(withIcon:"" , badgeTitle: self.plistBadgeArray[index]["title"] as! String, badgeDescription: self.plistBadgeArray[index]["criteria"] as! String, isEarned: true, orderIndex: index + 1, badgeType: Badge.BadgesType.Badge, additionalMsg: nil)
            
           // sahredObject.dbactions.saveBadge(badge)
        }
        
        for var index = self.plistBadgeArray.count - 2; index < self.plistBadgeArray.count; index++ {
            
            let badge = Badge(withIcon:"" , badgeTitle: self.plistBadgeArray[index]["title"] as! String, badgeDescription: self.plistBadgeArray[index]["criteria"] as! String, isEarned: false, orderIndex: index + 1, badgeType: Badge.BadgesType.Badge, additionalMsg: nil)
            
           // sahredObject.dbactions.saveBadge(badge)
        }
        
        //level
        
        for var index = 0; index < self.plistLevelArray.count - 2; index++ {
            
            let badge = Badge(withIcon:"" , badgeTitle: self.plistLevelArray[index]["title"] as! String, badgeDescription: self.plistLevelArray[index]["criteria"] as! String, isEarned: true, orderIndex: index + 1, badgeType: Badge.BadgesType.Level, additionalMsg: nil)
            
           // sahredObject.dbactions.saveBadge(badge)
        }
        
        for var index = self.plistLevelArray.count - 2; index < self.plistLevelArray.count; index++ {
            
            let badge = Badge(withIcon:"" , badgeTitle: self.plistLevelArray[index]["title"] as! String, badgeDescription: self.plistLevelArray[index]["criteria"] as! String, isEarned: false, orderIndex: index + 1, badgeType: Badge.BadgesType.Level, additionalMsg: nil)
            
          //  sahredObject.dbactions.saveBadge(badge)
        }

    }
    
    
    //MARK:- Custom Methods
    
    func shareButtonClicked(sender: UIButton!){
        
        let touchPoint = sender?.convertPoint(CGPointZero, toView: self.badgeTableView)
        let clickedRowIndexPath = self.badgeTableView.indexPathForRowAtPoint(touchPoint!)
        
        print("clicked share button data: \(clickedRowIndexPath!.row)")
        //add logic to get data and share them
        
    }
    
    
    
    func fetchBadgeData(completionHandler:(status : Int, response: [Badge]?, error: NSError?) -> Void) -> Void{
            FacadeLayer.sharedinstance.dbactions.fetchBadgeData { (status, response, error) -> Void in
                completionHandler(status: status, response: response, error: error)
        }
    }
    
    
    
    func requestBadgeData(completionHandler:(status : Int, response: [Badge]?, error: NSError?) -> Void) -> Void{
        
        FacadeLayer.sharedinstance.requestBadgesData { (status, data, error) -> Void in
            completionHandler(status: status, response: data, error: error)
        }
        
    }
    

}
