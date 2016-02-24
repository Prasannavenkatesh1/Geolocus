//
//  RootViewController.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit
import CoreMotion

class RootViewController: BaseViewController {
  
    @IBOutlet var segmentControl: HMSegmentedControl!
    var labelNotificationCount:UILabel?
    var categories = [String]()
    let activitymanager = CMMotionActivityManager()
    var currentSelectedIndex : NSNumber!
    var menuBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.edgesForExtendedLayout = .None;
      self.extendedLayoutIncludesOpaqueBars = false;
      self.automaticallyAdjustsScrollViewInsets = false;
      self.navigationItemSetUp()
        
        currentSelectedIndex = 1
        self.getCustomizedSegmentedControl(self.segmentControl)
        self.segmentControl.addTarget(self, action: "segmentedControlChangedValue:", forControlEvents: UIControlEvents.ValueChanged)
       // self.segmentControl .addTarget(self, action:"segmentedControlChangedValue:", forControlEvents: )
        self.segmentControl.sectionTitles = [StringConstants.categoryTypeContract ,StringConstants.categoryTypeDashboard, StringConstants.categoryTypeHistory,StringConstants.categoryTypeOverall]
        self.segmentControl.reloadInputViews()

     
        
      
        let notifyfullView=UIView(frame: CGRectMake(0, 0, 50, 40))
        notifyfullView.backgroundColor=UIColor.clearColor()
        
        let redView=UIView(frame: CGRectMake(1, 1, 16, 16))
        redView.backgroundColor=UIColor.redColor()
        redView.layer.cornerRadius=8
        redView.layer.masksToBounds=true
        //DynamicView.layer.borderWidth=2
        
        labelNotificationCount = UILabel()
        labelNotificationCount!.frame = CGRectMake(1, 1, 15, 15)
        labelNotificationCount!.textColor = UIColor.whiteColor()
        labelNotificationCount!.textAlignment = NSTextAlignment.Center
       // labelNotificationCount!.text = "2"
        labelNotificationCount!.text = FacadeLayer.sharedinstance.notificationCount
        labelNotificationCount!.font = UIFont(name: labelNotificationCount!.font.fontName, size: 10)
        redView.addSubview(labelNotificationCount!)
        
        let bgImage: UIImageView!
        let image: UIImage = UIImage(named: "NotificationIcon")!
        bgImage = UIImageView(image: image)
        bgImage.frame = CGRectMake(10,9,30,22)
        
        let button: UIButton = UIButton()
       // button.setImage(UIImage(named: "NotificationIcon"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 50, 40)
        button.addTarget(self, action: "pushToNotificationScreen:", forControlEvents: .TouchUpInside)
        
        notifyfullView.addSubview(button)
        notifyfullView.addSubview(bgImage)

        notifyfullView.addSubview(redView)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = notifyfullView
        self.navigationItem.rightBarButtonItem = rightItem
        
      
      categories.append("Contract")
      categories.append("Dashboard")
      categories.append("History")
      categories.append("HistoryScore")

        // Do any additional setup after loading the view.
//      NSNotificationCenter.defaultCenter().addObserver(
//        self,
//        selector: "getSelectedIndex:",
//        name: NotificationKey.PageViewControllerIndexchangedNotification,
//        object: nil)
      
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "currentPageIndex:",
            name: NotificationKey.CurrentPageControlIndexNotification,
            object: nil)
        
        //attributes for SWrevealController framework
//        if revealViewController() != nil {
//            //            revealViewController().rearViewRevealWidth = 62
//            sideMenuButton.target = revealViewController()
//            sideMenuButton.action = "revealToggle:"
//            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//            
//        }
        notificationCountURL()
        
        NSNotificationCenter.defaultCenter().addObserver(
        self,
        selector: "updateNotificationCount",
        name: "UPDATE_NOTIFICATION_COUNT",
        object: nil)
        
      //Motion detect
//       self.showSnoozingPop()
    }
    
    //MARK:- Custom Methods
    
    func navigationItemSetUp() {

        if menuBtn == nil && revealViewController() != nil {
            menuBtn = UIButton()
            menuBtn!.setImage(UIImage(named: "menu"), forState: .Normal)
            menuBtn!.frame = CGRectMake(0, 0, 20, 20)
            menuBtn!.addTarget(revealViewController(), action: Selector("revealToggle:"), forControlEvents: .TouchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let kbcicon = UIImageView()
        kbcicon.image=UIImage(named: "KBCIcon")
        kbcicon.frame = CGRectMake(0, 0, 35, 32)
        let backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: menuBtn!)
        let kbcIconItem:UIBarButtonItem = UIBarButtonItem(customView: kbcicon)
        
        self.navigationItem.setLeftBarButtonItems([backButtonItem,kbcIconItem], animated:true)
    }
    
    func notificationCountURL(){
        //self.showActivityIndicator()
        FacadeLayer.sharedinstance.fetchNotificationCount { (status, data, error) -> Void in
            self.labelNotificationCount!.text = FacadeLayer.sharedinstance.notificationCount
            if(status == 1) {
                self.updateNotificationCount()
            }
            //self.hideActivityIndicator()
            
        }
    }
    func updateNotificationCount() {
        
        labelNotificationCount?.text = FacadeLayer.sharedinstance.notificationCount
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categories.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("categorycell", forIndexPath: indexPath) as! CategoryCell
    cell.caption?.text = categories[indexPath.row]
    return cell
  }
    
   func currentPageIndex(vcindex:NSNotification){
    
        var gg:String =  vcindex.userInfo!["currentIndex"] as! String
        print(gg)
        var idx = Int(gg)
        print(idx)
        currentSelectedIndex = idx
        segmentControl.setSelectedSegmentIndex(UInt(currentSelectedIndex), animated: true)
    
   }
  
  func getSelectedIndex(vcindex:NSNotification) {

//    var gg:String =  vcindex.userInfo!["getindex"] as! String
//    print(gg)
//    var idx = Int(gg)
//    print(idx)    
//    currentSelectedIndex = idx
//    segmentControl.setSelectedSegmentIndex(UInt(currentSelectedIndex), animated: true)
    
  }
    
 func  pushToNotificationScreen(sender: UIButton!) {
    self.performSegueWithIdentifier("Notificationsegue", sender: self);

    }
  
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Notificationsegue") {
            // pass data to next view
            let notify:NotificationViewController = segue.destinationViewController as! NotificationViewController
            //notify.razorSharpTeeth
            
        }
        
    }
    
    func getCustomizedSegmentedControl (segmentControl :HMSegmentedControl) -> HMSegmentedControl {
            segmentControl.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin
            segmentControl.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10)
            segmentControl.font =  UIFont (name: "HelveticaNeue", size: 16)
            if #available(iOS 8.2, *) {
                segmentControl.font = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)
            } else {
                // Fallback on earlier versions
            }
            segmentControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic
            segmentControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe
            segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
            segmentControl.backgroundColor = UIColor.whiteColor()
            segmentControl.textColor = UIColor(netHex:  0x4c7394)
            segmentControl.selectedTextColor = UIColor(netHex: 0x003665)
            segmentControl.selectionIndicatorColor = UIColor(netHex: 0x02abf2)
            segmentControl.selectionIndicatorHeight = 5.0
        return segmentControl
    }
    
    func segmentedControlChangedValue(segmentControl :HMSegmentedControl) -> Void{
        currentSelectedIndex = segmentControl.selectedSegmentIndex
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.SegmentIndexChangedNotification,
            object:nil,
            userInfo:["getindex":currentSelectedIndex!])
    }
    
}
