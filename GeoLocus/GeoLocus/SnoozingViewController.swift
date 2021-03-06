//
//  snoozingViewController.swift
//  GeoLocus
//
//  Created by Harsh on 2/17/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class SnoozingViewController : BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    //MARK: IBOutlets
    @IBOutlet weak var snoozeDateTimePicker: UIPickerView!
    @IBOutlet weak var snoozePickerTitleLabel: UILabel!
   
    var hoursArray :[Int] = (1...24).map { $0 }
    var minutesArray : [Int] = (1...60).map{$0}
    var daysArray : [Int] = (1...30).map{$0}
    var timeArray = [LocalizationConstants.Settings.Snooze.Hours.localized(),LocalizationConstants.Settings.Snooze.Minutes.localized(),LocalizationConstants.Settings.Snooze.Days.localized()]
    var snoozingPickerLeftComponentDataSource : [AnyObject] = [AnyObject]()
    var snoozingPickerLeftComponentDictionary : Dictionary<String,[AnyObject]> =  Dictionary<String, [AnyObject]>()
    
    //var pickerDataSource  = [["1","2","3"],["Hours","Minutes","Days"]]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        snoozePickerTitleLabel.text = LocalizationConstants.Settings.Snooze.AskMeAgain_Title.localized()
        snoozingPickerLeftComponentDictionary[LocalizationConstants.Settings.Snooze.Hours.localized()] = hoursArray
        snoozingPickerLeftComponentDictionary[LocalizationConstants.Settings.Snooze.Minutes.localized()] = minutesArray
        snoozingPickerLeftComponentDictionary[LocalizationConstants.Settings.Snooze.Days.localized()] = daysArray
        snoozingPickerLeftComponentDataSource = hoursArray
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return snoozingPickerLeftComponentDataSource.count
        }else if component == 1{
            return timeArray.count
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(snoozingPickerLeftComponentDataSource[row])
        }
        else if component == 1{
            return timeArray[row]
        }
        return nil
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1{
            if row == 0{
                snoozingPickerLeftComponentDataSource = hoursArray
                
            }else if row == 1{
                snoozingPickerLeftComponentDataSource = minutesArray
                
            }else if row == 2{
                snoozingPickerLeftComponentDataSource = daysArray
            }
            snoozeDateTimePicker.reloadComponent(0)
        }
    }
    
    @IBAction func closeButtonClicked(sender: AnyObject) {
        self.dismissPopUpController()
    }
    
    @IBAction func okTapped(sender: AnyObject) {
        
        let firstval = snoozingPickerLeftComponentDataSource[snoozeDateTimePicker.selectedRowInComponent(0)]
        let secondval = timeArray[snoozeDateTimePicker.selectedRowInComponent(1)] as String
        
        NSUserDefaults.standardUserDefaults().setValue(firstval, forKey: "LeftPickerValue")
        NSUserDefaults.standardUserDefaults().setObject(secondval, forKey: "RightPickerValue")
        
        print(firstval)
        print(secondval)
        
        self.dismissPopUpController()
        
        //3 * 24 * 60 * 60  -> Days
        //3 * 60 * 60       -> Hours
        //3 * 60            -> Minutes
        let indexofTimeArr  = timeArray.indexOf(secondval)
        var snoozingSeconds:NSTimeInterval = 0
        
        if let selval = firstval as? Double {
            
            if indexofTimeArr == 0{
                snoozingSeconds = selval * 60 * 60        // Hours
            }else if indexofTimeArr == 1{
                snoozingSeconds = selval * 60             // Minutes
            }else if indexofTimeArr == 2{
                snoozingSeconds = selval * 24 * 60 * 60   // Days
            }
            
        }
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: StringConstants.isSnoozeEnabled)
        self.performSelector("triggersnooze", withObject: nil, afterDelay: snoozingSeconds)
        
        NSNotificationCenter.defaultCenter().postNotificationName("snoozeValueChanged", object: nil, userInfo: nil)
    }
    
    func triggersnooze(){
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: StringConstants.isSnoozeEnabled)
    }
    
    
}
