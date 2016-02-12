//
//  LanguageSelectionViewController.swift
//  GeoLocus
//
//  Created by Saranya on 20/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class LanguageSelectionViewController: UIViewController{
    
    @IBOutlet weak var layoutConstraintTop: NSLayoutConstraint!
    
    @IBAction func languageSelectedButton(sender: UIButton){
        
        var selectedLanguage : String!
        
        sender.backgroundColor = UIColor(red: 0, green: 174, blue: 239, alpha: 1.0)
        sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        switch(sender.tag){
        case 1:
            selectedLanguage = LanguageCode.Nederlands.rawValue
        case 2:
            selectedLanguage = LanguageCode.French.rawValue
        case 3:
            selectedLanguage = LanguageCode.English.rawValue
        case 4:
            selectedLanguage = LanguageCode.Duits.rawValue
        default:
            break
        }
        
        NSUserDefaults.standardUserDefaults().setObject(selectedLanguage, forKey: StringConstants.SELECTED_LANGUAGE_USERDEFAULT_KEY)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        performSegueWithIdentifier(StringConstants.LOGINVIEW_STORYBOARD_SEGUE, sender: self)

    }
    
    override func viewDidLoad() {
        if(UIScreen.mainScreen().bounds.size.height < 568){
            layoutConstraintTop.constant = 121
        }
    }
}



