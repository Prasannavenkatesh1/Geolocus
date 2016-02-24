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
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var totalPoints: UILabel!
    @IBOutlet weak var totalTrips: UILabel!
    @IBOutlet weak var reportsNavigationItem: UINavigationItem!

    var groupBarVC: GroupBarViewController?
    var report: Report?
    var chartData = [(title: String, [(min: Double, max: Double)])]()
    var timeFrameType: ReportDetails.TimeFrameType = ReportDetails.TimeFrameType.weekly
    var scoreType: ReportDetails.ScoreType = ReportDetails.ScoreType.speed
    
    override func viewDidLoad() {
        
        self.navigationItemSetUp()
        self.startLoading()
        FacadeLayer.sharedinstance.fetchInitialReportData(timeFrame: ReportDetails.TimeFrameType.weekly, scoreType: ReportDetails.ScoreType.speed) { (success, error, result) -> Void in
            if success == true {
                if let resultObj = result {
                    self.report = resultObj
                    self.reportInformation(self.report!.reportDetail)
                    self.groupBarVC?.showChart(horizontal: false, barChartData: self.chartData)
                }
            }
            self.stopLoading()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
            groupBarVC?.showChart(horizontal: false, barChartData: self.chartData)
        }
    }
    
    //MARK:- Custom Methods
    
    func reportInformation(chartPoints: [ReportDetails]) {
        
        var i: Int = 1
        var title: String = ""
        for reportDetailObj in chartPoints {
            title = reportDetailObj.timeFrame.rawValue == 0 ? "W" + "\(i)" : "M" + "\(i)"
            i++
            chartData.append((title, [(0, Double(reportDetailObj.myScore)), (0, Double(reportDetailObj.poolAverage))]))
        }
        
        if let distance = self.report?.distanceTravelled {
            self.distance.text = "\(distance) km"
        }
        if let totalPts = self.report?.totalPoints {
            self.totalPoints.text = "\(totalPts)"
        }
        if let trips = self.report?.totalTrips {
            self.totalTrips.text = "\(trips)"
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
        
        self.reportsNavigationItem.setLeftBarButtonItems([backButtonItem,kbcIconItem], animated:true)
    }
    
    func backButtonTapped(sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: StringConstants.StoryBoardIdentifier, bundle: nil)
        let rootView = storyBoard.instantiateViewControllerWithIdentifier(StringConstants.RootViewController)
        let navigationView = UINavigationController(rootViewController: rootView)
        self.revealViewController().setFrontViewController(navigationView, animated: true)
    }

    //MARK:- UIButton Actions
    
    @IBAction func didTapOnFilterBtn(sender: UIButton) {
        okBtn.layer.cornerRadius = 15.0
        filterPopUpView.hidden = false
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: StringConstants.REPORT_SYNCHRONISATION)
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
            timeFrameType = ReportDetails.TimeFrameType.weekly
            break
        case 101:
            weeklyBtn.selected = false
            timeFrameType = ReportDetails.TimeFrameType.monthly
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
            scoreType = ReportDetails.ScoreType.speed
            break
        case 1001:
            speedBtn.selected = false
            attentionBtn.selected = false
            overallScoreBtn.selected = false
            scoreType = ReportDetails.ScoreType.eco
            break
        case 1002:
            speedBtn.selected = false
            EcoScoreBtn.selected = false
            overallScoreBtn.selected = false
            scoreType = ReportDetails.ScoreType.attention
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
    
    @IBAction func didTapOnConfirmBtn(sender: UIButton) {
        if groupBarVC != nil {
            chartData.removeAll()
            self.filterPopUpView.hidden = true
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: StringConstants.REPORT_SYNCHRONISATION)
            self.startLoading()
            FacadeLayer.sharedinstance.fetchReportData(timeFrame: timeFrameType, scoreType: scoreType, completionHandler: { (success, error, result) -> Void in
                if success == true {
                    if let resultObj = result {
                        self.report = resultObj
                        self.reportInformation(self.report!.reportDetail)
                        self.groupBarVC?.showChart(horizontal: false, barChartData: self.chartData)
                    }
                }
                self.stopLoading()
            })
        }
    }
    
}
