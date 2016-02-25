//
//  LanguageSelectionViewController.swift
//  GeoLocus
//
//  Created by CTS on 20/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

/* This view allows the user to select a language from the list of languages displayed */

class LanguageSelectionViewController: UIViewController{
    
    /* Variable declarations */
    let defaults = NSUserDefaults.standardUserDefaults()
    
    /* Outlets for the constraints in the view */
    @IBOutlet weak var layoutConstraintTop: NSLayoutConstraint!
    
    /* Outlets for buttons in the view */
    @IBOutlet weak var germanButton: UIButton!
    @IBOutlet weak var dutchButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var frenchButton: UIButton!
    
    /* button action for any of the language chosen */
    @IBAction func languageSelectedButton(sender: UIButton) {
        
        var selectedLanguage : String!
        var userSelectedLanguage: String = LocalizeLanguageCode.English.rawValue
        
        sender.backgroundColor = UIColor(red: 0, green: 174, blue: 239, alpha: 1.0)
        sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        switch(sender.tag){
        case 1 :
            selectedLanguage = LanguageCode.Duits.rawValue
            userSelectedLanguage = LocalizeLanguageCode.German.rawValue
        case 2 :
            selectedLanguage = LanguageCode.French.rawValue
            userSelectedLanguage = LocalizeLanguageCode.French.rawValue
        case 3 :
            selectedLanguage = LanguageCode.English.rawValue
            userSelectedLanguage = LocalizeLanguageCode.English.rawValue
        case 4 :
            selectedLanguage = LanguageCode.Nederlands.rawValue
            userSelectedLanguage = LocalizeLanguageCode.Nederlands.rawValue
        default:
            break
        }
        
        // storing the selected language in user defaults for further use
        defaults.setObject(selectedLanguage, forKey: StringConstants.SELECTED_LANGUAGE_USERDEFAULT_KEY)
        defaults.setObject(userSelectedLanguage, forKey: StringConstants.SELECTED_LOCALIZE_LANGUAGE_CODE)
        defaults.synchronize()
        
        performSegueWithIdentifier(StringConstants.LOGINVIEW_STORYBOARD_SEGUE, sender: self)
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        
        self.setTitleForButtons()
        
        /* setting constraint for device height less than 568 */
        if(StringConstants.SCREEN_HEIGHT < Resolution.height.iPhone5){
            layoutConstraintTop.constant = 121
        }
    }
    
    /* setting localized string for title of the buttons */
    func setTitleForButtons(){
        self.germanButton.setTitle(LocalizationConstants.Language_Dutch.localized(), forState: UIControlState.Normal)
        self.frenchButton.setTitle(LocalizationConstants.Language_French.localized(), forState: UIControlState.Normal)
        self.englishButton.setTitle(LocalizationConstants.Language_English.localized(), forState: UIControlState.Normal)
        self.dutchButton.setTitle(LocalizationConstants.Language_German.localized(), forState: UIControlState.Normal)
    }
}



