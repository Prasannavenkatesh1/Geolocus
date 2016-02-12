//
//  ReportsViewController.swift
//  GeoLocus
//
//  Created by khan on 19/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class ReportsViewController: BaseViewController {
    
    @IBOutlet weak var groupBarView: UIView!
    @IBOutlet weak var filterPopUpView: UIView!
    @IBOutlet weak var weeklyBtn: UIButton!
    @IBOutlet weak var monthlyBtn: UIButton!
    @IBOutlet weak var speedBtn: UIButton!
    @IBOutlet weak var EcoScoreBtn: UIButton!
    @IBOutlet weak var attentionBtn: UIButton!
    @IBOutlet weak var overallScoreBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var groupBarVC: GroupBarViewController?
    
    override func viewDidLoad() {
    }
    
    override func viewDidLayoutSubviews() {

        if UIScreen.mainScreen().bounds.size.height == 480 {
            heightConstraint.constant = 240
            bottomConstraint.constant = 20
            self.view.layoutIfNeeded()
        }

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
        okBtn.layer.cornerRadius = 15.0
        filterPopUpView.hidden = false
    }
    
    @IBAction func didTapOnCloseBtn(sender: UIButton) {
        filterPopUpView.hidden = true
    }
    
    @IBAction func didTapOnTimeFrameBtn(sender: UIButton) {
        
        let btn: UIButton = sender
        btn.selected = btn.selected ? false : true
        
        switch sender.tag {
        case 100:
            monthlyBtn.selected = false
            break
        case 101:
            weeklyBtn.selected = false
            break
        default:
            break
        }
    }
    
    @IBAction func didTapOnScoreOptionsBtn(sender: UIButton) {
        
        let btn: UIButton = sender
        btn.selected = btn.selected ? false : true
        
        switch sender.tag {
        case 1000:
            EcoScoreBtn.selected = false
            attentionBtn.selected = false
            overallScoreBtn.selected = false
            break
        case 1001:
            speedBtn.selected = false
            attentionBtn.selected = false
            overallScoreBtn.selected = false
            break
        case 1002:
            speedBtn.selected = false
            EcoScoreBtn.selected = false
            overallScoreBtn.selected = false
            break
        case 1003:
            speedBtn.selected = false
            EcoScoreBtn.selected = false
            attentionBtn.selected = false
            break
        default:
            break
        }
    }
}
