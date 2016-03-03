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
        return [LocalizationConstants.Settings.SettingsCell.Data_Upload_Title.localized(),LocalizationConstants.Settings.SettingsCell.Snooze_Title.localized(),LocalizationConstants.Settings.SettingsCell.AutoTrip_Start_Title.localized(),LocalizationConstants.Settings.SettingsCell.Notification_Title.localized(),LocalizationConstants.Settings.SettingsCell.ShareData_Title.localized(),LocalizationConstants.Settings.SettingsCell.Choose_Language_Title.localized(),LocalizationConstants.Settings.SettingsCell.Reset_Password_Title.localized(),LocalizationConstants.Settings.SettingsCell.Coach_Username_Title.localized()]
    }
}

enum popUpDataUploadFieldType : Int {
    
    case Cellular = 0
    case Wifi
    case CellularAndWifi
    
    static var popUpDataUploadFieldTypeTitles : [String]{
        return [LocalizationConstants.Settings.DataUploadType.Type_Cellular.localized(),LocalizationConstants.Settings.DataUploadType.Type_Wifi.localized(),LocalizationConstants.Settings.DataUploadType.Type_CellularWifi.localized()]
    }
    
}

enum popUpChooseLanguageFieldType : Int {
    
    case English = 0
    case German
    case French
    case Dutch
    
    static var popUpChooseLanguageFieldTypeTitles : [String]{
        return [LocalizationConstants.Language_English.localized(),LocalizationConstants.Language_German.localized(),LocalizationConstants.Language_French.localized(),LocalizationConstants.Language_Dutch.localized()]
    }
    
}

enum popUpLocalizeLanguageCode: String {
    case en
    case de
    case fr
    case nl
    
    static var popUpLocalizeChosenLanguageFieldTypeTitles : [String]{
        return ["en","de","fr","nl"]
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
    @IBOutlet weak var settingsNavigationItem: UINavigationItem!
    
    let settingsHeaderTitle = LocalizationConstants.Settings.Settings_Title.localized()
    let textCellIdentifier = "settingsCellIdentifier"
    let popUpCellIdentifier = "popUpCellIdentifier"
    
    var settingsFields :[settingsFieldType] = []
    var popUpType : popUpTypes = popUpTypes.ChooseLanguage
    let defaults = NSUserDefaults.standardUserDefaults()
    var snoozingViewController : UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItemSetUp()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        self.popUpTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        settingsFields = settingsFieldType.allFieldType
        popUpView.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableViewValues:", name: "snoozeValueChanged", object: nil)
        
    }
    
    //MARK: - Custom Methods
    
    /* reloads the settings table when snnoze view controller is dismissed */
    func reloadTableViewValues(notification: NSNotification) {
        self.settingsTableView.reloadData()
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
        
        self.settingsNavigationItem.setLeftBarButtonItems([backButtonItem,kbcIconItem], animated:true)
    }
    
    func backButtonTapped(sender: UIButton) {
        
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
            
            cell.primaryTextLabel.text = settingsFieldType.fieldTypeTitles[row]
            switch(row){
            case 0 :
                cell.settingsSwitch.hidden = true
                
                if let labelString = defaults.objectForKey(StringConstants.DATA_UPLOAD_TYPE) as? String{
                    cell.secondaryTextLabel.text = labelString
                }
            case 1 :
                cell.settingsSwitch.hidden = true
                
                if let labelKeyString = defaults.valueForKey(StringConstants.PICKER_LEFT_VALUE){
                    if let labelValueString = defaults.objectForKey(StringConstants.PICKER_RIGHT_VALUE) as? String{
                        cell.secondaryTextLabel.text = String(labelKeyString) + " " + labelValueString
                    }
                }
            case 2 :
                let switchState : Bool = defaults.boolForKey(StringConstants.AUTO_TRIP_START)
                cell.settingsSwitch.on = switchState
                cell.secondaryTextLabel.text = switchState == true ? StringConstants.ENABLED : StringConstants.DISABLED
            case 3 :
                let switchState : Bool = defaults.boolForKey(StringConstants.NOTIFICATION)
                cell.settingsSwitch.on = switchState
                cell.secondaryTextLabel.text = switchState == true ? StringConstants.ENABLED : StringConstants.DISABLED
            case 4 :
                let switchState : Bool = defaults.boolForKey(StringConstants.SHARE_DATA_WITH_PARENT)
                cell.settingsSwitch.on = switchState
                cell.secondaryTextLabel.text = switchState == true ? StringConstants.ENABLED : StringConstants.DISABLED
            case 5 :
                cell.settingsSwitch.hidden = true
                
                if let labelString = defaults.objectForKey(StringConstants.SETTINGS_LANGUAGE_CHOSEN) as? String{
                    cell.secondaryTextLabel.text = labelString
                }
            case 6 :
                cell.settingsSwitch.hidden = true
                cell.secondaryTextLabel.hidden = true
            case 7 :
                cell.settingsSwitch.hidden = true
                if let labelString = defaults.valueForKey(StringConstants.PARENT_USERNAME) as? String{
                    cell.secondaryTextLabel.text = labelString
                }
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
            
            return cell
            
        }
        else if tableView == popUpTableView{
            
            let cell = tableView.dequeueReusableCellWithIdentifier(popUpCellIdentifier, forIndexPath: indexPath) as! popUpCustomCell
            if popUpType == popUpTypes.ChooseLanguage{
                cell.popUpDataUploadOrLanguageTypeLabel.text = popUpChooseLanguageFieldType.popUpChooseLanguageFieldTypeTitles[indexPath.row]
                cell.popUpDataUploadOrLanguageTypeButton.tag = row
                let selectedLanguage = defaults.objectForKey(StringConstants.SETTINGS_LANGUAGE_CHOSEN) as? String
                if selectedLanguage == popUpChooseLanguageFieldType.popUpChooseLanguageFieldTypeTitles[indexPath.row]{
                    if let image = UIImage(named: StringConstants.RADIO_BUTTON_SELECTED) {
                        cell.popUpDataUploadOrLanguageTypeButton.setImage(image, forState: .Normal)
                    }
                }else {
                    if let image = UIImage(named: StringConstants.RADIO_BUTTON_UNSELECTED) {
                        cell.popUpDataUploadOrLanguageTypeButton.setImage(image, forState: .Normal)
                    }
                }
                cell.popUpDataUploadOrLanguageTypeButton .addTarget(self, action: "chooseLanguageValueChanged:", forControlEvents: .TouchUpInside)
                
            }else if popUpType == popUpTypes.DataUpload {
                cell.popUpDataUploadOrLanguageTypeLabel.text = popUpDataUploadFieldType.popUpDataUploadFieldTypeTitles[indexPath.row]
                cell.popUpDataUploadOrLanguageTypeButton.tag = row
                let selectedDataUploadType = defaults.objectForKey(StringConstants.DATA_UPLOAD_TYPE) as? String
                if selectedDataUploadType == popUpDataUploadFieldType.popUpDataUploadFieldTypeTitles[indexPath.row]{
                    if let image = UIImage(named: StringConstants.RADIO_BUTTON_SELECTED) {
                        cell.popUpDataUploadOrLanguageTypeButton.setImage(image, forState: .Normal)
                    }
                }else {
                    if let image = UIImage(named: StringConstants.RADIO_BUTTON_UNSELECTED) {
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
                self.popUpTitleLabel.text = LocalizationConstants.Settings.DataUploadType.DataUploadType_Title.localized()
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
                self.popUpTitleLabel.text = LocalizationConstants.Settings.SettingsCell.Choose_Language_Title.localized()
                self.popUpTableView.tableFooterView = UIView(frame: CGRectZero)
                
            }else if row == settingsFieldType.ResetPassword.rawValue{
                
            }
        }else if tableView == popUpTableView{
            
            if popUpType == popUpTypes.DataUpload{
                let selectedDataUpload = popUpDataUploadFieldType.popUpDataUploadFieldTypeTitles[indexPath.row]
                defaults.setObject(selectedDataUpload, forKey: StringConstants.DATA_UPLOAD_TYPE)
                self.popUpTableView.reloadData()
                self.settingsTableView.reloadData()
                
            }else if popUpType == popUpTypes.ChooseLanguage{
                let selectedLanguage = popUpChooseLanguageFieldType.popUpChooseLanguageFieldTypeTitles[indexPath.row]
                let userSelectedLanguage = popUpLocalizeLanguageCode.popUpLocalizeChosenLanguageFieldTypeTitles[indexPath.row]
                defaults.setObject(selectedLanguage, forKey: StringConstants.SETTINGS_LANGUAGE_CHOSEN)
                defaults.setObject(userSelectedLanguage, forKey: StringConstants.SELECTED_LOCALIZE_LANGUAGE_CODE)
                self.popUpTableView.reloadData()
                self.settingsTableView.reloadData()
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
        
        var switchStateValue : Bool = false
        
        switch(settingsSwitch.tag){
        case 2 :
            switchStateValue = settingsSwitch.on
            defaults.setBool(switchStateValue, forKey: StringConstants.AUTO_TRIP_START)
        case 3 :
            switchStateValue = settingsSwitch.on
            defaults.setBool(switchStateValue, forKey: StringConstants.NOTIFICATION)
        case 4 :
            switchStateValue = settingsSwitch.on
            defaults.setBool(switchStateValue, forKey: StringConstants.SHARE_DATA_WITH_PARENT)
        default:
            break
        }
        self.settingsTableView.reloadData()
    }
}
