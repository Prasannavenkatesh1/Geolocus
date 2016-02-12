//Created by Insurance H3 Team
//
//GeoLocus App
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    let settingsCellTitles = ["Data Upload Type","Snooze the start","Auto trip Start","Notification","Share data with parent","Choose your Language","Reset Password","Coach's Username"]
    let settingsHeaderTitle = "Customer Settings"
    let textCellIdentifier = "settingsCellIdentifier"
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        let storyBoard = UIStoryboard(name: StringConstants.StoryBoardIdentifier, bundle: nil)
        let rootView = storyBoard.instantiateViewControllerWithIdentifier(StringConstants.RootViewController)
        let navigationView = UINavigationController(rootViewController: rootView)
        self.revealViewController().setFrontViewController(navigationView, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }
    
    //MARK : Tableview delegate and datasource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsCellTitles.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsHeaderTitle
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! SettingsCustomViewCell
        
        let row = indexPath.row
        cell.primaryTextLabel.text = settingsCellTitles[row]
        
        switch(row){
        case 0,1,5,7:
            cell.settingsSwitch.hidden = true
        //case 2,3,4:
        case 6:
            cell.settingsSwitch.hidden = true
            cell.secondaryTextLabel.hidden = true
        default:
            break
        }
        
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        cell.settingsSwitch.tag = row
        cell.settingsSwitch.addTarget(self, action: Selector("switchValueChanged:"), forControlEvents:UIControlEvents.ValueChanged)
        
        /*if switchState[row] == "Enabled" {
            
            cell.secondaryTextLabel.text = switchStateEnabled[row]
            cell.settingsSwitch.on = true
            
        }
        else {
            
            cell.secondaryTextLabel.text = switchStateDisabled[row]
            cell.settingsSwitch.on = false
            
        }*/
        
        return cell
    }

    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(netHex: 003665)
        header.textLabel?.font = UIFont.boldSystemFontOfSize(15)
        header.textLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
    }

    func backBtnTapped() {
       
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func switchValueChanged(settingsSwitch : UISwitch){
        /*if(settingsSwitch.on){
            switchState[settingsSwitch.tag] = "Enabled"
        }
        else{
            switchState[settingsSwitch.tag] = "Disabled"
        }*/
    }
}