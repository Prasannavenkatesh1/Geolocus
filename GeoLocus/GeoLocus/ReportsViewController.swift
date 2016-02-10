//
//  ReportsViewController.swift
//  GeoLocus
//
//  Created by khan on 19/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class ReportsViewController: UIViewController {
    
    @IBOutlet weak var groupBarView: UIView!
    
    override func viewDidLoad() {
//        ReportsViewController
        
        let storyBoard = UIStoryboard(name: StringConstants.StoryBoardIdentifier, bundle: nil)
        let groupBarVC = storyBoard.instantiateViewControllerWithIdentifier(StringConstants.GroupBarViewController) as? GroupBarViewController
        self.addChildViewController(groupBarVC!)
        groupBarVC!.groupBarViewFrame = groupBarView.frame
        groupBarVC!.view.frame = groupBarView.frame
        groupBarView.addSubview((groupBarVC?.view!)!)
    }
    
    //MARK :- UIButton Actions
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        let storyBoard = UIStoryboard(name: StringConstants.StoryBoardIdentifier, bundle: nil)
        let rootView = storyBoard.instantiateViewControllerWithIdentifier(StringConstants.RootViewController)
        let navigationView = UINavigationController(rootViewController: rootView)
        self.revealViewController().setFrontViewController(navigationView, animated: true)
    }
 


}
