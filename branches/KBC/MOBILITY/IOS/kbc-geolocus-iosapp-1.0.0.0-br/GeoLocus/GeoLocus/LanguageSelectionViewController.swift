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
        selectedLanguage = sender.titleLabel?.text
        
        switch(sender.tag){
        case 1:
            break
        case 2,3,4:
            performSegueWithIdentifier(StringConstants.LOGINVIEW_STORYBOARD_SEGUE, sender: self)
            break
        default:
            break
        }
        
        NSUserDefaults.standardUserDefaults().setValue(selectedLanguage, forKey: StringConstants.SELECTED_LANGUAGE_USERDEFAULT_KEY)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    override func viewDidLoad() {
        if(UIScreen.mainScreen().bounds.size.height < 568){
            layoutConstraintTop.constant = 121
        }
    }
}



