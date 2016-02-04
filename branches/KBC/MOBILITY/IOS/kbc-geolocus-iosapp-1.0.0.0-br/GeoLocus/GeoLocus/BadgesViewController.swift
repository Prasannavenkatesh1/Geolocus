//
//  BadgesViewController.swift
//  GeoLocus
//
//  Created by khan on 19/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class BadgesViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var badgeTableView: UITableView!
    
    var badgeEarnedArray = [Badge]()
    var badgeNotEarnedArray = [Badge]()
    var levelArray = [Badge]()
    var badgesSpecification = ["badges earned","Badges to be earned","Levels"]
    
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
        
        //need to check condition if what happes if there is NO earned badges or same is the case with badges not earned
        /*
        var numOfSection = 0;
        
        if self.badgeEarnedArray.count > 0 {
            numOfSection++
        }
        
        if self.badgeNotEarnedArray.count > 0 {
            numOfSection++
        }
        
        if self.levelArray.count > 0 {
            numOfSection++
        }
    
        return numOfSection
        
        */
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //need to check using the filter in array
        
        var numOfRows = 0
        
        if section == 0 {
            numOfRows = self.badgeEarnedArray.count > 0 ? self.badgeEarnedArray.count : 0
        }else if section == 1 {
            numOfRows = self.badgeNotEarnedArray.count > 0 ? self.badgeNotEarnedArray.count : 0
        }else if section == 2 {
            numOfRows = self.levelArray.count > 0 ? self.levelArray.count : 0
        }
        
        return numOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BADGE_CELL_ID, forIndexPath: indexPath) as! BadgeCell
        
        var dataArray = [Badge]()
        if indexPath.section == 0 {
            dataArray = self.badgeEarnedArray
        }else if indexPath.section == 1 {
            dataArray = self.badgeNotEarnedArray
        }else if indexPath.section == 2 {
            dataArray = self.levelArray
        }
        
        let badge = dataArray[indexPath.row]

//        if badge.isEarned {
//            cell.shareButton.hidden = false
//        }else {
//            cell.shareButton.hidden = true
//        }
        
       // cell.badgeIcon.image = UIImage(data: NSData(contentsOfURL:badge.badgeIcon)!)
        cell.badgeTitle.text = badge.badgeTitle
        cell.badgeDescription.text = badge.badgeDescription
        
        return cell
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
        //see if data is updated
        //if no new update then get data from DB
        //if new update then Get data from service and store in DB
        */
        
        let badge1 = Badge(withIconURL:"https://" , badgeTitle: "king of the route", badgeDescription: "No speed violation for 300km on the highways", isEarned: true, orderIndex: 1, badgeType: Badge.BadgesType.Badge)
        self.badgeEarnedArray.append(badge1)
        
        
        let badge2 = Badge(withIconURL:"https://" , badgeTitle: "king of the city", badgeDescription: "No speed violation for 300km on the highways", isEarned: false, orderIndex: 2, badgeType: Badge.BadgesType.Badge)
        self.badgeNotEarnedArray.append(badge2)
        
        let badge3 = Badge(withIconURL:"https://" , badgeTitle: "Perfect trip", badgeDescription: "No speed violation for 300km on the highways", isEarned: false, orderIndex: 4, badgeType: Badge.BadgesType.Badge)
        self.badgeNotEarnedArray.append(badge3)
        
        let badge4 = Badge(withIconURL:"https://" , badgeTitle: "Eco Driver", badgeDescription: "No speed violation for 300km on the highways", isEarned: false, orderIndex: 3, badgeType: Badge.BadgesType.Badge)
        self.badgeNotEarnedArray.append(badge4)
        
        let badge5 = Badge(withIconURL:"https://" , badgeTitle: "king", badgeDescription: "No speed violation for 300km on the highways", isEarned: false, orderIndex: 5, badgeType: Badge.BadgesType.Badge)
        self.badgeNotEarnedArray.append(badge5)
        
        
        let level1 = Badge(withIconURL:"https://" , badgeTitle: "Beginner", badgeDescription: "No speed violation for 300km on the highways", isEarned: true, orderIndex: 6, badgeType: Badge.BadgesType.Level)
        self.levelArray.append(level1)
        
        let level2 = Badge(withIconURL:"https://" , badgeTitle: "Driver", badgeDescription: "No speed violation for 300km on the highways", isEarned: false, orderIndex: 7, badgeType: Badge.BadgesType.Level)
        self.levelArray.append(level2)
        
        let level3 = Badge(withIconURL:"https://" , badgeTitle: "Expert", badgeDescription: "No speed violation for 300km on the highways", isEarned: false, orderIndex: 8, badgeType: Badge.BadgesType.Level)
        self.levelArray.append(level3)
        
        let level4 = Badge(withIconURL:"https://" , badgeTitle: "Coach", badgeDescription: "No speed violation for 300km on the highways", isEarned: false, orderIndex: 9, badgeType: Badge.BadgesType.Level)
        self.levelArray.append(level4)
        

    }
    
    
//    func requestBadgeData(completionHandler:(status : Int, response: Badge?, error: NSError?) -> Void) -> Void{
//        
//        //get URL from config file
//        
////        FacadeLayer.sharedinstance.httpClient.requestBadgeData("ur") { (status, response, error) -> Void in
//        
//        }
//    }
//    
//    func parsebadgeData(responseData: NSData, complitionhandler:(response: Badge, error: NSError?)->Void) -> Void {
//        
//        
//        }
//    }
}
