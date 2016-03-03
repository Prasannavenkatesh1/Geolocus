//
//  TermsAndConditionViewController.swift
//  GeoLocus
//
//  Created by khan on 19/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class TermsAndConditionViewController: BaseViewController {

    @IBOutlet weak var termsNavigationItem: UINavigationItem!
    @IBOutlet weak var termsAndConditionsWebView: UIWebView!
    
    var termsAndConditionsString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItemSetUp()
        
        if let termsAndConditionsContent = NSUserDefaults.standardUserDefaults().stringForKey(StringConstants.TERMS_AND_CONDITIONS_STRING){
            self.termsAndConditionsString = termsAndConditionsContent
            self.termsAndConditionsWebView.loadHTMLString(self.termsAndConditionsString, baseURL: nil)
        }
    }
    
    //MARK: - Custom Methods
    
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
        
        self.termsNavigationItem.setLeftBarButtonItems([backButtonItem,kbcIconItem], animated:true)
    }

    func backButtonTapped(sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: StringConstants.StoryBoardIdentifier, bundle: nil)
        let rootView = storyBoard.instantiateViewControllerWithIdentifier(StringConstants.RootViewController)
        let navigationView = UINavigationController(rootViewController: rootView)
        self.revealViewController().setFrontViewController(navigationView, animated: true)
    }
}
