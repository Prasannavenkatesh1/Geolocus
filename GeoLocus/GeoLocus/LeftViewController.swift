//
//  LeftViewController.swift
//  GeoLocus
//
//  Created by khan on 28/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit


class LeftViewController: UIViewController {
    
    @IBOutlet var menuTableView: UITableView!
    let menuCellIdentifier = "MenuCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None;
        self.extendedLayoutIncludesOpaqueBars = false;
        self.automaticallyAdjustsScrollViewInsets = false;
        self.menuTableView.tableFooterView = UIView(frame: CGRectZero)

    }

}

//Code for Delegates and Data Source
extension LeftViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let rowCount = ArrayConstants.MenuList?.count else {
            return 1
        }
        return rowCount
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let identifier = StringConstants.MenuCellIdentifier
        let cell = tableView.dequeueReusableCellWithIdentifier(menuCellIdentifier, forIndexPath: indexPath) as! MenuCustomCell
        //let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        guard let menuText = ArrayConstants.MenuList?[indexPath.row] else {
            //cell.textLabel?.text = StringConstants.MenuCellIdentifier
            cell.titleLabel.text = StringConstants.MenuCellIdentifier
            return cell
        }
//        print(menuText.localized())
//        cell.titleLabel.text = "ewrw"
        cell.titleLabel.text =  menuText.localized()  //NSLocalizedString(menuText, comment: "Text for menu item")
        //cell.textLabel?.text = NSLocalizedString(menuText, comment: "Text for menu item")
        //cell.textLabel?.textAlignment = .Left
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let selectedMenuItem = ArrayConstants.MenuList?[indexPath.row] else {
            return
        }
        
        guard let item = ArrayConstants.MenuItems(rawValue: selectedMenuItem) else {
            return
        }
        let storyBoard = UIStoryboard(name: StringConstants.StoryBoardIdentifier, bundle: nil)
        
        switch  item {
            
        case .Badges:
            let badgesView = storyBoard.instantiateViewControllerWithIdentifier(StringConstants.BadgesViewController)
            self.revealViewController().pushFrontViewController(badgesView, animated: true)
        case .Settings:
            let settingsView = storyBoard.instantiateViewControllerWithIdentifier(StringConstants.SettingsViewController)
            self.revealViewController().pushFrontViewController(settingsView, animated: true)
        case .Reports:
            let reportsView = storyBoard.instantiateViewControllerWithIdentifier(StringConstants.ReportsViewController)
            self.revealViewController().pushFrontViewController(reportsView, animated: true)
        case .Terms:
            let termsView = storyBoard.instantiateViewControllerWithIdentifier(StringConstants.TermsAndConditionViewController)
            self.revealViewController().pushFrontViewController(termsView, animated: true)
//        case .Exit:
//            print("Logout or kill Application?")
          
        }
        
    }
    
}