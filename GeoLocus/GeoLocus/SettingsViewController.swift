//Created by Insurance H3 Team
//
//GeoLocus App
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var bkBtn: UIButton!
    
    @IBOutlet weak var settingsTable: UITableView!
    
    @IBOutlet weak var settingsNav: UINavigationBar!
    
    
    let settingsCellTitles = ["Data Upload Type","Snooze the start","Auto trip Start","Notification","Share data with parent","Choose your Language","Reset Password","Coach's Username"]
    let settingsHeaderTitle = "Customer Settings"
    let textCellIdentifier = "TextCell"
    
    let settingsTitle = ["Voice Alert"]
    let settingsValues = ["Enabled"]
    let settingsValuesChanged = ["Disabled"]
    
    var checkboxArray:[String] = ["Enabled"]
    
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
        
//        settingsNav.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        
//        bkBtn.addTarget(self, action: "backBtnTapped", forControlEvents: .TouchUpInside)
//        
//        settingsTable.backgroundColor = UIColor.clearColor()
//        settingsTable.opaque = false
//        
//        let mainDelegate = UIApplication.sharedApplication().delegate as! AppDelegateSwift
//        checkboxArray[0] = (mainDelegate.vAlert as! String)

    }
    
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = settingsCellTitles[row]
        
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        /*let identifier = "SettingsCustomCell"
        var cell: SettingsCustomCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? SettingsCustomCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "SettingsCustomCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? SettingsCustomCell
        }
        
        cell.settingsValues.text = settingsTitle[indexPath.row]
        
        cell.backgroundColor = UIColor.clearColor()
        cell.opaque = false
        
        cell.settingsValues.textColor = UIColor.whiteColor()
        cell.settingsValuesSub.textColor = UIColor.greenColor()

        cell.settingsSwitch.tag = indexPath.row
        cell.settingsSwitch.transform = CGAffineTransformMakeScale(0.5, 0.5);
        cell.settingsSwitch .addTarget(self, action: Selector("settingsSwitchClicked:"), forControlEvents: UIControlEvents.ValueChanged)

        if checkboxArray[indexPath.row] == "Enabled" {
            
            cell.settingsValuesSub.text = settingsValues[indexPath.row]
            cell.settingsSwitch.on = true

        }
        else {

            cell.settingsValuesSub.text = settingsValuesChanged[indexPath.row]
            cell.settingsSwitch.on = false

        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None*/
  
        return cell
    }


    func backBtnTapped() {
       
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func settingsSwitchClicked(mySwitch : UISwitch){
        
        let mainDelegate = UIApplication.sharedApplication().delegate as! AppDelegateSwift
        
        if mySwitch.on {
            
            checkboxArray[mySwitch.tag] = "Enabled"
            mainDelegate.vAlert = "Enabled"
            
        } else {
            
            checkboxArray[mySwitch.tag] = "Disabled"
            mainDelegate.vAlert = "Disabled"
        }
        
        settingsTable.reloadData()
    }
}