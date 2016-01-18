//
//  Pageviewcontroller.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit


class Pageviewcontroller: UIPageViewController,UIPageViewControllerDataSource {
  
  var pages:Int = 2
  var views = [UIViewController]()
  var contract:ContractPage!
  var dashboard:DashboardPage!
  var history:HistoryPage!
  var historyscore:HistoryScorePage!
  

  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self;
      contract = self.storyboard?.instantiateViewControllerWithIdentifier("ContractPage") as! ContractPage
      dashboard = self.storyboard?.instantiateViewControllerWithIdentifier("DashboardPage") as! DashboardPage
      history = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryPage") as! HistoryPage
      historyscore = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryScorePage") as! HistoryScorePage

      views.append(contract)
      views.append(dashboard)
      views.append(history)
      views.append(historyscore)
      
      self.setViewControllers([views[0]], direction: .Forward, animated:false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    let vcIndex = views.indexOf(viewController);
    if (vcIndex < views.count-1) {

      NSNotificationCenter.defaultCenter().postNotificationName("pageviewcontrollerindexchanged",
        object:nil,
        userInfo:["getindex":"\(vcIndex!+1)"])
      return views[vcIndex!+1];
    }
    print("after \(vcIndex)")
    
    return nil;
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    let vcIndex = views.indexOf(viewController);
    if (vcIndex > 0) {
      NSNotificationCenter.defaultCenter().postNotificationName("pageviewcontrollerindexchanged",
        object:nil,
        userInfo:["getindex":"\(vcIndex!-1)"])
      return views[vcIndex!-1];
    }
    print("before \(vcIndex)")
    return nil
  }
  

}
