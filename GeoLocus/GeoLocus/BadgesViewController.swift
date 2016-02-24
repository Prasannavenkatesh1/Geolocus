//
//  BadgesViewController.swift
//  GeoLocus
//
//  Created by khan on 19/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

protocol BadgesDelegate {
    func shareButtonTapped(sender: UIButton!)
}


class BadgesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var badgeTableView: UITableView!
    @IBOutlet weak var badgesNavigationItem: UINavigationItem!
    
    var myActivityIndicator : UIActivityIndicatorView?
    var badgeNotEarnedArray = [Badge]()
    var badgeEarnedArray    = [Badge]()
    var levelArray          = [Badge]()
    var plistBadgeArray     = []
    var plistLevelArray     = []
    var badgesSpecification = [LocalizationConstants.Badge.Badges_to_be_Earned.localized(),LocalizationConstants.Badge.Badges_Earned.localized(), LocalizationConstants.Badge.Levels.localized()]  //consider Localization
    var sahredObject        = FacadeLayer()
    let NUM_OF_SECTION = 3
    
    //MARK: - Viewcontroller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItemSetUp()
        self.badgeTableView.backgroundColor = UIColor.clearColor()
        reloadDataSource()
    }
    
    
    //MARK: - Tableview Datasource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return NUM_OF_SECTION
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID.BADGE_CELL, forIndexPath: indexPath) as! BadgeCell
        cell.delegate = self
        
        var dataArray = [Badge]()
        if indexPath.section == 0 {
            dataArray = self.badgeNotEarnedArray
        }else if indexPath.section == 1 {
            dataArray = self.badgeEarnedArray
        }else if indexPath.section == 2 {
            dataArray = self.levelArray
        }
        
        cell.configure(dataArray[indexPath.row])
        
        return cell
    }
    
    //MARK: - Tableview Datasource methods
    
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
        
        let stringHeight = descString.heightWithConstrainedWidth(tableView.frame.size.width - 20 - 10 - 84 - 30 - 20, font: UIFont(name: Font.HELVETICA_NEUE, size: 15.0)!)
        
        if StringConstants.SCREEN_HEIGHT >= 568 {
            otherContentHeight -= 5
        }
        
        return max(CGFloat(otherContentHeight + stringHeight), CGFloat(114))
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var titleView = UIView(frame: CGRectZero)
        
        if (section == 0 && self.badgeNotEarnedArray.count != 0) || (section == 1 && self.badgeEarnedArray.count != 0) || (section == 2 && self.levelArray.count != 0){
            
            titleView                   = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 35))
            titleView.backgroundColor   = UIColor(netHex: 0xF6F8FA)
            
            let titleLabel              = UILabel()
            titleLabel.frame            = CGRectMake(20, 7, tableView.frame.width, 20)
            titleLabel.backgroundColor  = UIColor.clearColor()
            titleLabel.text             = self.badgesSpecification[section]
            titleLabel.font             = UIFont(name: Font.HELVETICA_NEUE_MEDIUM, size: 15.0)
            titleLabel.textColor        = UIColor(netHex: 0x003665)
            titleView.addSubview(titleLabel)
        }
            return titleView
    }
    
    //MARK:- Navigation methods
    
    func backButtonTapped(sender: UIButton) {
        
        let storyBoard      = UIStoryboard(name: StringConstants.StoryBoardIdentifier, bundle: nil)
        let rootView        = storyBoard.instantiateViewControllerWithIdentifier(StringConstants.RootViewController)
        let navigationView  = UINavigationController(rootViewController: rootView)
        self.revealViewController().setFrontViewController(navigationView, animated: true)
         
    }
    
    //MARK:- Custom Methods
    
    func reloadDataSource(){
        
        //self.startLoading()
        
        //1. Get data from plist
        let path                = NSBundle.mainBundle().pathForResource("BadgesDetails", ofType: "plist")
        let dataDict            = NSDictionary(contentsOfFile: path!)
        self.plistBadgeArray    = (dataDict?.valueForKey("badge"))! as! NSArray
        self.plistLevelArray    = (dataDict?.valueForKey("level"))! as! NSArray
        
        //filtering each array
        
        self.badgeNotEarnedArray    = []
        self.badgeEarnedArray       = []
        self.levelArray             = []
        
        FacadeLayer.sharedinstance.fetchBadgeData { (status, data, error) -> Void in
            if(status == 1 && error == nil) {
            
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
                
                //mapping icons
                
                for var index = 0; index < self.badgeNotEarnedArray.count; index++ {
                    
                    let title = self.badgeNotEarnedArray[index].badgeTitle.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    
                    for var pIndex = 0; pIndex < self.plistBadgeArray.count; pIndex++ {
                        if title.compare(self.plistBadgeArray[pIndex]["title"] as! String) == .OrderedSame {
                            
                            let isEarned = self.badgeNotEarnedArray[index].isEarned
                            
                            self.badgeNotEarnedArray[index].badgeIcon = isEarned ? self.plistBadgeArray[pIndex]["icon"] as! String: self.plistBadgeArray[pIndex]["icon_not_earned"] as! String
                            
                            self.badgeNotEarnedArray[index].orderIndex = Int(self.plistBadgeArray[pIndex]["index"] as! String)!
                            self.badgeNotEarnedArray[index].additionalMsg = self.plistBadgeArray[pIndex]["message"] as? String
                        }
                    }
                }
                
                for var index = 0; index < self.badgeEarnedArray.count; index++ {
                    
                    let title = self.badgeEarnedArray[index].badgeTitle.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet())

                    for var pIndex = 0; pIndex < self.plistBadgeArray.count; pIndex++ {
            
                        if title.compare(self.plistBadgeArray[pIndex]["title"] as! String) == .OrderedSame {
                            
                            let isEarned = self.badgeEarnedArray[index].isEarned
                            
                            self.badgeEarnedArray[index].badgeIcon = isEarned ? self.plistBadgeArray[pIndex]["icon"] as! String: self.plistBadgeArray[pIndex]["icon_not_earned"] as! String
                            
                            self.badgeEarnedArray[index].orderIndex = Int(self.plistBadgeArray[pIndex]["index"] as! String)!
                            self.badgeEarnedArray[index].additionalMsg = self.plistBadgeArray[pIndex]["message"] as? String
                        }
                    }
                }
                
                for var index = 0; index < self.levelArray.count; index++ {
                    
                    let title = self.levelArray[index].badgeTitle.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet())

                    for var pIndex = 0; pIndex < self.plistLevelArray.count; pIndex++ {
                        if title.compare(self.plistLevelArray[pIndex]["title"] as! String) == .OrderedSame {
                            
                            let isEarned = self.levelArray[index].isEarned
                            
                            self.levelArray[index].badgeIcon = isEarned ? self.plistLevelArray[pIndex]["icon"] as! String: self.plistLevelArray[pIndex]["icon_not_earned"] as! String
                            
                            self.levelArray[index].orderIndex = Int(self.plistLevelArray[pIndex]["index"] as! String)!
                            self.levelArray[index].additionalMsg = self.plistBadgeArray[pIndex]["message"] as? String
                        }
                    }
                }
                
                //ordering arrays
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
                //something went wrong...or...first time
                
                for var index = 0; index < self.plistBadgeArray.count; index++ {
                    
                    let badge = Badge(withIcon: self.plistBadgeArray[index]["icon_not_earned"] as! String, badgeTitle: self.plistBadgeArray[index]["title"] as! String, badgeDescription: self.plistBadgeArray[index]["criteria"] as! String, isEarned: false, orderIndex: Int(self.plistBadgeArray[index]["index"] as! String)!, badgeType: Badge.BadgesType.Badge, additionalMsg: " ")
                    
                    self.badgeNotEarnedArray.append(badge)
                }
                
                for var index = 0; index < self.plistLevelArray.count; index++ {
                    
                    let level = Badge(withIcon: self.plistLevelArray[index]["icon_not_earned"] as! String, badgeTitle: self.plistLevelArray[index]["title"] as! String, badgeDescription: self.plistLevelArray[index]["criteria"] as! String, isEarned: false, orderIndex: Int(self.plistLevelArray[index]["index"] as! String)!, badgeType: Badge.BadgesType.Level, additionalMsg: " ")
                    
                    self.levelArray.append(level)
                }
                self.badgeTableView.reloadData()
            }
            //self.stopLoading()
        }
    }
    
    func navigationItemSetUp() {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "BackButton"), forState: .Normal)
        backButton.frame = CGRectMake(0, 0, 12, 21)
        backButton.addTarget(self, action: Selector("backButtonTapped:"), forControlEvents: .TouchUpInside)
        
        let kbcicon = UIImageView()
        kbcicon.image=UIImage(named: "KBCIcon")
        kbcicon.frame = CGRectMake(0, 0, 35, 32)
        let backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        let kbcIconItem:UIBarButtonItem = UIBarButtonItem(customView: kbcicon)
        
        self.badgesNavigationItem.setLeftBarButtonItems([backButtonItem,kbcIconItem], animated:true)
    }
}

extension BadgesViewController: BadgesDelegate {
    
    func shareButtonTapped(sender: UIButton!){
        
        let touchPoint = sender?.convertPoint(CGPointZero, toView: self.badgeTableView)
        let clickedRowIndexPath = self.badgeTableView.indexPathForRowAtPoint(touchPoint!)
        
        print("clicked share button data: \(clickedRowIndexPath!.row)")
        //add logic to get data and share them
        
        var title = String()
        var details = String()
        var icon = String()
        
        if clickedRowIndexPath?.section == 0 {    //badges earned
            //TODO: revert this and change section 0 to 1 above
            /*
            title = self.badgeEarnedArray[clickedRowIndexPath!.row].badgeTitle
            details = self.badgeEarnedArray[clickedRowIndexPath!.row].badgeDescription
            icon = self.badgeEarnedArray[clickedRowIndexPath!.row].badgeIcon
            */
            
            //TODO: Delete this
            title = self.badgeNotEarnedArray[clickedRowIndexPath!.row].badgeTitle
            details = self.badgeNotEarnedArray[clickedRowIndexPath!.row].additionalMsg!
            icon = self.badgeNotEarnedArray[clickedRowIndexPath!.row].badgeIcon
        }else if clickedRowIndexPath?.section == 2 {     //levels
            title = self.levelArray[clickedRowIndexPath!.row].badgeTitle
            details = self.levelArray[clickedRowIndexPath!.row].badgeDescription
            icon = self.levelArray[clickedRowIndexPath!.row].badgeIcon
        }
        
        super.displayActivityView(title, detail: details, imageInfo: ["icon":icon], shareOption: ShareTemplate.ShareOption.BADGES)
    }
}
