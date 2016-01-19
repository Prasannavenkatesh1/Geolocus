//Created by Insurance H3 Team
//
//GeoLocus App
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bkBtn: UIButton!
    
    @IBOutlet weak var settingsTable: UITableView!
    
    @IBOutlet weak var settingsNav: UINavigationBar!
    
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
        return settingsTitle.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "SettingsCustomCell"
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
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
  
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