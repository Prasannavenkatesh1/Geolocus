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
    var hoursArray :[Int] = (1...24).map { $0 }
    var minutesArray : [Int] = (1...60).map{$0}
    var daysArray : [Int] = (1...30).map{$0}
    var timeArray = ["Hours","Minutes","Days"]
    var snoozingPickerLeftComponentDataSource : [AnyObject] = [AnyObject]()
    var snoozingPickerLeftComponentDictionary : Dictionary<String,[AnyObject]> =  Dictionary<String, [AnyObject]>()
    
    //var pickerDataSource  = [["1","2","3"],["Hours","Minutes","Days"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        snoozingPickerLeftComponentDictionary["Hours"] = hoursArray
        snoozingPickerLeftComponentDictionary["Minutes"] = minutesArray
        snoozingPickerLeftComponentDictionary["Days"] = daysArray
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
    
    
}
