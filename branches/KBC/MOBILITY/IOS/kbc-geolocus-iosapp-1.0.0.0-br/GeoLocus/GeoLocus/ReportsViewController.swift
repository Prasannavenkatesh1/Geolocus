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
    @IBOutlet weak var filterPopUpView: UIView!
    @IBOutlet weak var closePopUpBtn: UIButton!
    
    var groupBarVC: GroupBarViewController?
    
    override func viewDidLoad() {
    }
    
    override func viewDidLayoutSubviews() {
        
        if groupBarVC == nil {
            let storyBoard = UIStoryboard(name: StringConstants.StoryBoardIdentifier, bundle: nil)
            groupBarVC = (storyBoard.instantiateViewControllerWithIdentifier(StringConstants.GroupBarViewController) as? GroupBarViewController)!
            self.addChildViewController(groupBarVC!)
            groupBarVC!.groupBarViewFrame = groupBarView.frame
            groupBarView.addSubview(groupBarVC!.view!)
        }
    }
    
    //MARK :- UIButton Actions
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        let storyBoard = UIStoryboard(name: StringConstants.StoryBoardIdentifier, bundle: nil)
        let rootView = storyBoard.instantiateViewControllerWithIdentifier(StringConstants.RootViewController)
        let navigationView = UINavigationController(rootViewController: rootView)
        self.revealViewController().setFrontViewController(navigationView, animated: true)
    }
 
    @IBAction func didTapOnFilterBtn(sender: UIButton) {
        filterPopUpView.hidden = false
    }

    @IBAction func didTapOnCloseBtn(sender: UIButton) {
        filterPopUpView.hidden = true
    }
}
