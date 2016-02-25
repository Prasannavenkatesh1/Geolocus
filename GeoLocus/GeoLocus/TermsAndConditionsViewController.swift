//
//  TermsAndConditionsViewController.swift
//  GeoLocus
//
//  Created by Saranya on 05/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation
import UIKit

/* This view loads the web view with Terms and Conditions Content */

class TermsAndConditionsViewController : UIViewController{

    var termsAndConditionsContent : String!
    
    @IBOutlet weak var termsAndConditionsWebView: UIWebView!
    @IBOutlet weak var okButton: UIButton!
    
    /* dismiss the modal web view on button tap */
    @IBAction func okButtonTapped(sender: AnyObject) {
        [self.dismissViewControllerAnimated(true, completion: nil)]
    }
    
    //MARK: View Methods
    override func viewDidLoad() {
        self.termsAndConditionsWebView.layer.cornerRadius = 10
        self.termsAndConditionsWebView.clipsToBounds = true
        
        self.okButton.setTitle(LocalizationConstants.Ok_title.localized(), forState: UIControlState.Normal)
        self.okButton.layer.cornerRadius = 10
        self.okButton.clipsToBounds = true
        
        termsAndConditionsWebView.loadHTMLString(termsAndConditionsContent, baseURL: nil)
        [self.termsAndConditionsWebView.bringSubviewToFront(okButton)]
    }
}