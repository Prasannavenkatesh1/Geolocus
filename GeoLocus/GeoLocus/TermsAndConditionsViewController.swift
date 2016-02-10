//
//  TermsAndConditionsViewController.swift
//  GeoLocus
//
//  Created by Saranya on 05/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation
import UIKit

class TermsAndConditionsViewController : UIViewController{

    var termsAndConditionsContent : String!
    
    @IBOutlet weak var termsAndConditionsWebView: UIWebView!
    @IBOutlet weak var okButton: UIButton!
    
    @IBAction func okButtonTapped(sender: AnyObject) {
        [self.dismissViewControllerAnimated(true, completion: nil)]
    }
    
    override func viewDidLoad() {
        termsAndConditionsWebView.loadHTMLString(termsAndConditionsContent, baseURL: nil)
        [self.termsAndConditionsWebView.bringSubviewToFront(okButton)]
    }
}