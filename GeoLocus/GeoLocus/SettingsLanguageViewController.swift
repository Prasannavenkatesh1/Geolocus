//
//  SettingsLanguageViewController.swift
//  GeoLocus
//
//  Created by Saranya on 17/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation

protocol SettingsLanguageChosenDelegate{
    func selectedLanguage(var selectedLanguage : String)
}


class SettingsLanguageViewController : BaseViewController{
    
    var delegate : SettingsLanguageChosenDelegate? = nil
    var selectedLanguage : String!
    var isChecked = false

    @IBOutlet weak var selectedLanguageButton: UIButton!
    
    @IBAction func radiobuttonChecked(sender: UIButton) {
        
        if(!isChecked){
            [sender.setImage(UIImage(named:StringConstants.CHECK_BOX_SELECTED), forState: UIControlState.Normal)]
        }
        
        switch(sender.tag){
        case 1 :
            self.selectedLanguage = Language.English.rawValue
        case 2 :
            self.selectedLanguage = Language.German.rawValue
        case 3 :
            self.selectedLanguage = Language.French.rawValue
        case 4 :
            self.selectedLanguage = Language.Dutch.rawValue
        }
    }
    @IBAction func closeButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.delegate?.selectedLanguage(self.selectedLanguage)        
    }
}
