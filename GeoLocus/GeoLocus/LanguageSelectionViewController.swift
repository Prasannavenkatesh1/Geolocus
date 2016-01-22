//
//  LanguageSelectionViewController.swift
//  GeoLocus
//
//  Created by Saranya on 20/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class LanguageSelectionViewController: UIViewController{
    @IBAction func languageSelectedButton(sender: AnyObject){
        print("Language Selected")
        performSegueWithIdentifier("login", sender: self)
    }
}


