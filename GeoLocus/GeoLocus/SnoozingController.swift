//
//  SnoozingController.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 15/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class SnoozingController: UIViewController {
  
  var numerics = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      for count in 1...30{
        numerics.append("\(count)")
      }
      
      print(numerics)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SnoozingController{
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 2
  }
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if component == 0{
      
    }
    return 10
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "hi"
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
  }
}
