//
//  BadgesViewController.swift
//  GeoLocus
//
//  Created by khan on 19/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class BadgesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var badgeTableView: UITableView!

    var badgeNotEarnedArray = [Badge]()
    var badgeEarnedArray = [Badge]()
    var levelArray = [Badge]()
    var plistBadgeArray = []
    var plistLevelArray = []
    var badgesSpecification = ["Badges to be Earned", "Badges Earned", "Levels"]
    
    let BADGE_CELL_ID = "BadgeCell"
    
    var sahredObject = FacadeLayer()
    var myActivityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.badgeTableView.backgroundColor = UIColor.clearColor()
        
        reloadDataSource()
        
        //storeBadge()
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
        
        self.showActivityIndicator()
        
        //1. Get data from plist
        let path = NSBundle.mainBundle().pathForResource("BadgesDetails", ofType: "plist")
        let dataDict = NSDictionary(contentsOfFile: path!)
        self.plistBadgeArray = (dataDict?.valueForKey("badge"))! as! NSArray
        self.plistLevelArray = (dataDict?.valueForKey("level"))! as! NSArray
        
        
        FacadeLayer.sharedinstance.fetchBadgeData { (status, data, error) -> Void in
            if(status == 1 && error == nil) {
                
                //filtering then ordering each array
                
                self.badgeNotEarnedArray = []
                self.badgeEarnedArray = []
                self.levelArray = []
                
                self.badgeNotEarnedArray = data!.filter({ (badge) -> Bool in
                    badge.isEarned == false && badge.badgeType == Badge.BadgesType.Badge
                }).sort({ (badge1, badge2) -> Bool in
                    badge1.orderIndex < badge2.orderIndex
                })
                
                self.badgeEarnedArray = data!.filter({ (badge) -> Bool in
                    badge.isEarned == true && badge.badgeType == Badge.BadgesType.Badge
                }).sort({ (badge1, badge2) -> Bool in
                    badge1.orderIndex < badge2.orderIndex
                })
                
                self.levelArray = data!.filter({ (badge) -> Bool in
                    badge.badgeType == Badge.BadgesType.Level
                }).sort({ (badge1, badge2) -> Bool in
                    badge1.orderIndex < badge2.orderIndex
                })
                
                
                for var index = 0; index < self.badgeNotEarnedArray.count; index++ {
                    
                    let title = self.badgeNotEarnedArray[index].badgeTitle.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet()
                    )
                    
                    for var pIndex = 0; pIndex < self.plistBadgeArray.count; pIndex++ {
                        if self.plistBadgeArray[pIndex]["title"] as! String == title {
                            
                            let isEarned = self.badgeNotEarnedArray[index].isEarned
                            
                            self.badgeNotEarnedArray[index].badgeIcon = isEarned ? self.plistBadgeArray[pIndex]["icon"] as! String: self.plistBadgeArray[pIndex]["icon_not_earned"] as! String
                            
                            self.badgeNotEarnedArray[index].orderIndex = Int(self.plistBadgeArray[pIndex]["index"] as! String)!
                        }
                    }
                }
                
                for var index = 0; index < self.badgeEarnedArray.count; index++ {
                    
                    let title = self.badgeEarnedArray[index].badgeTitle.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet()
                    )

                    
                    for var pIndex = 0; pIndex < self.plistBadgeArray.count; pIndex++ {
                        if self.plistBadgeArray[pIndex]["title"] as! String == title {
                            
                            let isEarned = self.badgeEarnedArray[index].isEarned
                            
                            self.badgeEarnedArray[index].badgeIcon = isEarned ? self.plistBadgeArray[pIndex]["icon"] as! String: self.plistBadgeArray[pIndex]["icon_not_earned"] as! String
                            
                            self.badgeEarnedArray[index].orderIndex = Int(self.plistBadgeArray[pIndex]["index"] as! String)!
                        }
                    }
                }
                
                for var index = 0; index < self.levelArray.count; index++ {
                    
                    let title = self.levelArray[index].badgeTitle.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet()
                    )

                    
                    for var pIndex = 0; pIndex < self.plistLevelArray.count; pIndex++ {
                        if self.plistLevelArray[pIndex]["title"] as! String == title {
                            
                            let isEarned = self.levelArray[index].isEarned
                            
                            self.levelArray[index].badgeIcon = isEarned ? self.plistLevelArray[pIndex]["icon"] as! String: self.plistLevelArray[pIndex]["icon_not_earned"] as! String
                            
                            self.levelArray[index].orderIndex = Int(self.plistLevelArray[pIndex]["index"] as! String)!
                        }
                    }
                }
                
                self.badgeNotEarnedArray = self.badgeNotEarnedArray.sort({ (badge1, badge2) -> Bool in
                    badge1.orderIndex < badge2.orderIndex
                })
                
                self.badgeEarnedArray = self.badgeEarnedArray.sort({ (badge1, badge2) -> Bool in
                    badge1.orderIndex < badge2.orderIndex
                })
                
                self.levelArray = self.levelArray.sort({ (badge1, badge2) -> Bool in
                    badge1.orderIndex < badge2.orderIndex
                })
                
                self.badgeTableView.reloadData()
                
            }else{
                //something went wrong
               // print("error while fetching badge data ")
                
            }
            self.hideActivityIndicator()
        }

    }
    
    
    //MARK:- Custom Methods
    
    func shareButtonClicked(sender: UIButton!){
        
        let touchPoint = sender?.convertPoint(CGPointZero, toView: self.badgeTableView)
        let clickedRowIndexPath = self.badgeTableView.indexPathForRowAtPoint(touchPoint!)
        
        print("clicked share button data: \(clickedRowIndexPath!.row)")
        //add logic to get data and share them
        
    }
    
    
    //MARK: - IndicatorView methods
    func showActivityIndicator(){
        self.myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        
        self.myActivityIndicator!.center = self.view.center
        self.myActivityIndicator!.startAnimating()
        self.view.addSubview(self.myActivityIndicator!)
    }
    
    func hideActivityIndicator(){
        self.myActivityIndicator!.stopAnimating()
    }
    
    
    //********************************** Mock using Local data...remove this *****************************************//
    //TO DO: remove this
    func storeBadge(){
        
        //1. Get data from plist
        let path = NSBundle.mainBundle().pathForResource("BadgesDetails", ofType: "plist")
        let dataDict = NSDictionary(contentsOfFile: path!)
        self.plistBadgeArray = (dataDict?.valueForKey("badge"))! as! NSArray
        self.plistLevelArray = (dataDict?.valueForKey("level"))! as! NSArray
        
        
        //badges
        var badges = [Badge]()
        
        for var index = 0; index < self.plistBadgeArray.count - 2; index++ {
            
            badges.append(Badge(withIcon:"" , badgeTitle: self.plistBadgeArray[index]["title"] as! String, badgeDescription: self.plistBadgeArray[index]["criteria"] as! String, isEarned: true, orderIndex: index + 1, badgeType: Badge.BadgesType.Badge, additionalMsg: nil))
        }
        
        for var index = self.plistBadgeArray.count - 2; index < self.plistBadgeArray.count; index++ {
            
            badges.append(Badge(withIcon:"" , badgeTitle: self.plistBadgeArray[index]["title"] as! String, badgeDescription: self.plistBadgeArray[index]["criteria"] as! String, isEarned: false, orderIndex: index + 1, badgeType: Badge.BadgesType.Badge, additionalMsg: nil))
        }
        
        //level
        
        for var index = 0; index < self.plistLevelArray.count - 2; index++ {
            
            badges.append(Badge(withIcon:"" , badgeTitle: self.plistLevelArray[index]["title"] as! String, badgeDescription: self.plistLevelArray[index]["criteria"] as! String, isEarned: true, orderIndex: index + 1, badgeType: Badge.BadgesType.Level, additionalMsg: nil))
        }
        
        for var index = self.plistLevelArray.count - 2; index < self.plistLevelArray.count; index++ {
            
            badges.append(Badge(withIcon:"" , badgeTitle: self.plistLevelArray[index]["title"] as! String, badgeDescription: self.plistLevelArray[index]["criteria"] as! String, isEarned: false, orderIndex: index + 1, badgeType: Badge.BadgesType.Level, additionalMsg: nil))
        }
        
        
        FacadeLayer.sharedinstance.dbactions.saveBadge(badges) { (status) -> Void in
            if status {
                FacadeLayer.sharedinstance.fetchBadgeData({ (status, data, error) -> Void in
                    if(status == 1 && error == nil) {
                        
                        //filtering then ordering each array
                        
                        self.badgeNotEarnedArray = []
                        self.badgeEarnedArray = []
                        self.levelArray = []
                        
                        self.badgeNotEarnedArray = data!.filter({ (badge) -> Bool in
                            badge.isEarned == false && badge.badgeType == Badge.BadgesType.Badge
                        }).sort({ (badge1, badge2) -> Bool in
                            badge1.orderIndex < badge2.orderIndex
                        })
                        
                        self.badgeEarnedArray = data!.filter({ (badge) -> Bool in
                            badge.isEarned == true && badge.badgeType == Badge.BadgesType.Badge
                        }).sort({ (badge1, badge2) -> Bool in
                            badge1.orderIndex < badge2.orderIndex
                        })
                        
                        self.levelArray = data!.filter({ (badge) -> Bool in
                            badge.badgeType == Badge.BadgesType.Level
                        }).sort({ (badge1, badge2) -> Bool in
                            badge1.orderIndex < badge2.orderIndex
                        })
                        
                        
                        for var index = 0; index < self.badgeNotEarnedArray.count; index++ {
                            
                            let title = self.badgeNotEarnedArray[index].badgeTitle.stringByTrimmingCharactersInSet(
                                NSCharacterSet.whitespaceAndNewlineCharacterSet()
                            )
                            
                            for var pIndex = 0; pIndex < self.plistBadgeArray.count; pIndex++ {
                                if self.plistBadgeArray[pIndex]["title"] as! String == title {
                                    
                                    let isEarned = self.badgeNotEarnedArray[index].isEarned
                                    
                                    self.badgeNotEarnedArray[index].badgeIcon = isEarned ? self.plistBadgeArray[pIndex]["icon"] as! String: self.plistBadgeArray[pIndex]["icon_not_earned"] as! String
                                }
                            }
                        }
                        
                        for var index = 0; index < self.badgeEarnedArray.count; index++ {
                            
                            let title = self.badgeEarnedArray[index].badgeTitle.stringByTrimmingCharactersInSet(
                                NSCharacterSet.whitespaceAndNewlineCharacterSet()
                            )
                            
                            for var pIndex = 0; pIndex < self.plistBadgeArray.count; pIndex++ {
                                if self.plistBadgeArray[pIndex]["title"] as! String == title {
                                    
                                    let isEarned = self.badgeEarnedArray[index].isEarned
                                    
                                    self.badgeEarnedArray[index].badgeIcon = isEarned ? self.plistBadgeArray[pIndex]["icon"] as! String: self.plistBadgeArray[pIndex]["icon_not_earned"] as! String
                                }
                            }
                        }
                        
                        for var index = 0; index < self.levelArray.count; index++ {
                            
                            let title = self.levelArray[index].badgeTitle.stringByTrimmingCharactersInSet(
                                NSCharacterSet.whitespaceAndNewlineCharacterSet()
                            )
                            
                            for var pIndex = 0; pIndex < self.plistLevelArray.count; pIndex++ {
                                if self.plistLevelArray[pIndex]["title"] as! String == title {
                                    
                                    let isEarned = self.levelArray[index].isEarned
                                    
                                    self.levelArray[index].badgeIcon = isEarned ? self.plistLevelArray[pIndex]["icon"] as! String: self.plistLevelArray[pIndex]["icon_not_earned"] as! String
                                }
                            }
                        }
                        
                        self.hideActivityIndicator()
                        self.badgeTableView.reloadData()
                        
                    }else{
                        //something went wrong
                        print("error while fetching badge data from DB")
                    }
                })
            }
            
        }
        
    }
    //****************************************************************************************************************//
}
