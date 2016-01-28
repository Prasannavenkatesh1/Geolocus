//
//  WelcomePageViewController.swift
//  GeoLocus
//
//  Created by Saranya on 22/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    
    let pageTitles = ["Welcome screen 1", "Welcome screen 2", "Welcome screen 3", "Welcome screen 4"]
    var images = ["back.png","loading.png","icon.png","emergency_call.png"]
    var count = 0
    
    var pageViewController : UIPageViewController!
    
    func reset() {
        /* Getting the page View controller */
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        
        let tap = UITapGestureRecognizer(target: self, action: "doubleTapped")
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doubleTapped() {
        self.pageViewController.view.removeFromSuperview()
        [self.pageViewController.removeFromParentViewController()]
        
        var revealViewController : SWRevealViewController!
        
        revealViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
        self.addChildViewController(revealViewController)
        self.view.addSubview(revealViewController.view)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentViewController).pageIndex!
        index++
        if(index == self.images.count){
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentViewController).pageIndex!
        if(index == 0){
            return nil
        }
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        if((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return nil
        }
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as! PageContentViewController
        
        pageContentViewController.imageName = self.images[index]
        pageContentViewController.titleString = self.pageTitles[index]
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

}
