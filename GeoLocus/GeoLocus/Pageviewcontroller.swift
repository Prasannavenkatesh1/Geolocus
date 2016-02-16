//
//  Pageviewcontroller.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit


class Pageviewcontroller: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {
  
  var pages:Int = 2
  var views = [UIViewController]()
  var contract:ContractPage!
  var dashboard:DashboardPage!
  var history:HistoryPage!
  var historyscore:HistoryScorePage!
  

  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self;
        self.delegate = self;
      contract = self.storyboard?.instantiateViewControllerWithIdentifier("ContractPage") as! ContractPage
      dashboard = self.storyboard?.instantiateViewControllerWithIdentifier("DashboardPage") as! DashboardPage
      history = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryPage") as! HistoryPage
      historyscore = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryScorePage") as! HistoryScorePage

      views.append(contract)
      views.append(dashboard)
      views.append(history)
      views.append(historyscore)
      
      self.setViewControllers([views[0]], direction: .Forward, animated:false, completion: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "getSegmentIndex:",
            name: NotificationKey.SegmentIndexChangedNotification,
            object: nil)
    }
    
    func getSegmentIndex(vcindex:NSNotification) {
        
        var temp = vcindex.userInfo!["getindex"] as! Int
           print("index \(vcindex.userInfo!["getindex"])")
//        let getindex:NSNumber = vcindex.userInfo!["getindex"] as! NSNumber
//        print(getindex);
        self.setViewControllers([views[temp]], direction: .Forward, animated:false, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    let vcIndex = views.indexOf(viewController);
    if (vcIndex < views.count-1) {
      let getvcidx:String = String(format:"\(vcIndex!+1)")
//      NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.PageViewControllerIndexchangedNotification,
//        object:nil,
//        userInfo:["getindex":getvcidx])
      return views[vcIndex!+1];
    }
    print("after \(vcIndex)")
    
    return nil;
  }
  
  func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        let viewController :UIViewController = pageViewController.viewControllers![0]
         let vcIndex = views.indexOf(viewController);
        if (vcIndex < views.count) {
            let getvcidx:String = String(format:"\(vcIndex!)")
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.CurrentPageControlIndexNotification,
                object:nil,
                userInfo:["currentIndex":getvcidx])
        }

  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    let vcIndex = views.indexOf(viewController);
    if (vcIndex > 0) {
      let getvcidx:String = String(format:"\(vcIndex!-1)")
//      NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.PageViewControllerIndexchangedNotification,
//        object:nil,
//        userInfo:["getindex":getvcidx])
      return views[vcIndex!-1];
    }
    print("before \(vcIndex)")
    return nil
  }
  

}
