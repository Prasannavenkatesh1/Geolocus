//
//  BadgesViewController.swift
//  GeoLocus
//
//  Created by khan on 19/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class BadgesViewController: UIViewController {

    @IBAction func backButtonTapped(sender: AnyObject) {
        
        let storyBoard = UIStoryboard(name: StringConstants.StoryBoardIdentifier, bundle: nil)
        let rootView = storyBoard.instantiateViewControllerWithIdentifier(StringConstants.RootViewController)
        let navigationView = UINavigationController(rootViewController: rootView)
        self.revealViewController().setFrontViewController(navigationView, animated: true)
         
        
    
    }
}
