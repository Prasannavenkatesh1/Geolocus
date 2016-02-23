//Created by Insurance H3 Team
//
//GeoLocus App
//

import Foundation
import UIKit

enum settingsFieldType : Int {
    case DataUpload = 0
    case SnoozeStart
    case AutoTripStart
    case Notification
    case ShareDataWithParent
    case ChooseLanguage
    case ResetPassword
    case CoachUsername
    
    static var allFieldType: [settingsFieldType] {
        return [.DataUpload,.SnoozeStart,.AutoTripStart,.Notification,.ShareDataWithParent,.ChooseLanguage,.ResetPassword,.CoachUsername]
    }
    
    static var fieldTypeTitles : [String]{
        return ["Data Upload Type","Snooze the start","Auto trip Start","Notification","Share data with parent","Choose your Language","Reset Password","Coach's Username"]
    }
}

enum popUpDataUploadFieldType : Int {
    
    case Cellular = 0
    case Wifi
    case CellularAndWifi
    
    static var popUpDataUploadFieldTypeTitles : [String]{
        return ["Cellular","Wifi","Cellular and Wifi"]
    }
    
}

enum popUpChooseLanguageFieldType : Int {
    
    case English = 0
    case German
    case French
    case Dutch
    
    static var popUpChooseLanguageFieldTypeTitles : [String]{
        return ["English","German","French","Dutch"]
    }
    
}

enum popUpTypes{
    case ChooseLanguage
    case DataUpload
}


class SettingsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var popUpView : UIView!
    @IBOutlet weak var popUpTableView : UITableView!
    @IBOutlet weak var popUpTitleLabel : UILabel!
    

    let settingsCellTitles = ["Data Upload Type","Snooze the start","Auto trip Start","Notification","Share data with parent","Choose your Language","Reset Password","Coach's Username"]
    let settingsHeaderTitle = "Customer Settings"
    let textCellIdentifier = "settingsCellIdentifier"
    let popUpCellIdentifier = "popUpCellIdentifier"
    
    var settingsFields :[settingsFieldType] = []
    var popUpType : popUpTypes = popUpTypes.ChooseLanguage
    let defaults = NSUserDefaults.standardUserDefaults()
    var snoozingViewController : UIViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        self.popUpTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        settingsFields = settingsFieldType.allFieldType
        popUpView.hidden = true
        
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        let storyBoard = UIStoryboard(name: StringConstants.StoryBoardIdentifier, bundle: nil)
        let rootView = storyBoard.instantiateViewControllerWithIdentifier(StringConstants.RootViewController)
        let navigationView = UINavigationController(rootViewController: rootView)
        self.revealViewController().setFrontViewController(navigationView, animated: true)
    }
    
    @IBAction func popUpCloseButtonClicked(sender:AnyObject){
        
        popUpView.hidden = true
    }

    
    //MARK : Tableview delegate and datasource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == settingsTableView{
            return settingsFields.count
        }else if tableView == popUpTableView{
            if popUpType == popUpTypes.ChooseLanguage{
                return popUpChooseLanguageFieldType.popUpChooseLanguageFieldTypeTitles.count
            }else if popUpType == popUpTypes.DataUpload{
                return popUpDataUploadFieldType.popUpDataUploadFieldTypeTitles.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == settingsTableView{
            return settingsHeaderTitle
        }
        return nil
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        let row = indexPath.row
        if tableView == settingsTableView{
            let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! SettingsCustomViewCell
            
            
           // cell.primaryTextLabel.text = settingsCellTitles[row]
            cell.primaryTextLabel.text = settingsFieldType.fieldTypeTitles[row]
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
        else if tableView == popUpTableView{
            
            let cell = tableView.dequeueReusableCellWithIdentifier(popUpCellIdentifier, forIndexPath: indexPath) as! popUpCustomCell
            if popUpType == popUpTypes.ChooseLanguage{
                    cell.popUpDataUploadOrLanguageTypeLabel.text = popUpChooseLanguageFieldType.popUpChooseLanguageFieldTypeTitles[indexPath.row]
                    cell.popUpDataUploadOrLanguageTypeButton.tag = row
                let selectedLanguage = defaults.objectForKey("ChoosenLanguage") as? String
                if selectedLanguage == popUpChooseLanguageFieldType.popUpChooseLanguageFieldTypeTitles[indexPath.row]{
                    if let image = UIImage(named: "Radio-Button_Checked.png") {
                        cell.popUpDataUploadOrLanguageTypeButton.setImage(image, forState: .Normal)
                    }
                }else {
                    if let image = UIImage(named: "Radio-Button_Unchecked") {
                        cell.popUpDataUploadOrLanguageTypeButton.setImage(image, forState: .Normal)
                    }
                }
                cell.popUpDataUploadOrLanguageTypeButton .addTarget(self, action: "chooseLanguageValueChanged:", forControlEvents: .TouchUpInside)
                
            }else if popUpType == popUpTypes.DataUpload {
                    cell.popUpDataUploadOrLanguageTypeLabel.text = popUpDataUploadFieldType.popUpDataUploadFieldTypeTitles[indexPath.row]
                    cell.popUpDataUploadOrLanguageTypeButton.tag = row
                let selectedDataUploadType = defaults.objectForKey("DataUploadType") as? String
                if selectedDataUploadType == popUpDataUploadFieldType.popUpDataUploadFieldTypeTitles[indexPath.row]{
                    if let image = UIImage(named: "Radio-Button_Checked.png") {
                        cell.popUpDataUploadOrLanguageTypeButton.setImage(image, forState: .Normal)
                    }
                }else {
                    if let image = UIImage(named: "Radio-Button_Unchecked") {
                        cell.popUpDataUploadOrLanguageTypeButton.setImage(image, forState: .Normal)
                    }
                }
                cell.popUpDataUploadOrLanguageTypeButton .addTarget(self, action: "dataUploadValueChanged:", forControlEvents: .TouchUpInside)
            }
            return cell
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        if tableView == settingsTableView{
            
            if row == settingsFieldType.DataUpload.rawValue{
                popUpView.hidden = false
                popUpType = popUpTypes.DataUpload
                self.popUpTableView.delegate = self
                self.popUpTableView.dataSource = self
                self.popUpTableView.reloadData()
                self.popUpTitleLabel.text = "Choose Data Upload Type"
                self.popUpTableView.tableFooterView = UIView(frame: CGRectZero)
                
            }else if row == settingsFieldType.SnoozeStart.rawValue{
                snoozingViewController = UIStoryboard(name: StringConstants.StoryBoardIdentifier, bundle: nil).instantiateViewControllerWithIdentifier(StringConstants.SnoozingViewController)
                snoozingViewController.view.frame = CGRectMake(10, 40, 280, 295)
                self.presentPopUpController(snoozingViewController)
                
            }else if row == settingsFieldType.AutoTripStart.rawValue{
                
            }else if row == settingsFieldType.Notification.rawValue{
                
            }else if row == settingsFieldType.ShareDataWithParent.rawValue{
                
            }else if row == settingsFieldType.ChooseLanguage.rawValue{
                popUpView.hidden = false
                popUpType = popUpTypes.ChooseLanguage
                self.popUpTableView.delegate = self
                self.popUpTableView.dataSource = self
                self.popUpTableView.reloadData()
                self.popUpTitleLabel.text = "Choose your Language"
                self.popUpTableView.tableFooterView = UIView(frame: CGRectZero)

            }else if row == settingsFieldType.ResetPassword.rawValue{
                
            }
        }else if tableView == popUpTableView{
            
            if popUpType == popUpTypes.DataUpload{
                let selectedDataUpload = popUpDataUploadFieldType.popUpDataUploadFieldTypeTitles[indexPath.row]
                 defaults.setObject(selectedDataUpload, forKey: "DataUploadType")
                 self.popUpTableView.reloadData()

                
            }else if popUpType == popUpTypes.ChooseLanguage{
                let selectedLanguage = popUpChooseLanguageFieldType.popUpChooseLanguageFieldTypeTitles[indexPath.row]
                defaults.setObject(selectedLanguage, forKey: "ChoosenLanguage")
                self.popUpTableView.reloadData()

        }
    }
    }

    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if tableView == settingsTableView{
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = UIColor(netHex: 003665)
            header.textLabel?.font = UIFont.boldSystemFontOfSize(15)
            header.textLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        }
    }

    func backBtnTapped() {
       
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func dataUploadValueChanged(sender :AnyObject){
        let indexPath : NSIndexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        self.tableView(self.popUpTableView, didSelectRowAtIndexPath: indexPath)
    }
    
    func chooseLanguageValueChanged(sender:AnyObject){
        let indexPath : NSIndexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        self.tableView(self.popUpTableView, didSelectRowAtIndexPath: indexPath)
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
