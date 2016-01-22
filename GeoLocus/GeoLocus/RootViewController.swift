//
//  RootViewController.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
  
    @IBOutlet var sideMenuButton: UIBarButtonItem!
  var categories = [String]()

  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      let a = {print("aaa")}
      a()
//
      let multiply = {(val1: Int, val2:Int) -> Int in
        return val1+val2
      }
      let ggg = multiply(10,20)
      print("ggg\(ggg)")
      
      categories.append("Contract")
      categories.append("Dashboard")
      categories.append("History")
      categories.append("HistoryScore")

        // Do any additional setup after loading the view.
      NSNotificationCenter.defaultCenter().addObserver(
        self,
        selector: "getSelectedIndex:",
        name: "pageviewcontrollerindexchanged",
        object: nil)
        
        //attributes for SWrevealController framework
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            sideMenuButton.target = revealViewController()
            sideMenuButton.action = "rightRevealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
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
  
  func getSelectedIndex(vcindex:NSNotification) {
//    print("index \(vcindex.userInfo)")
    var getindex = vcindex.userInfo!["getindex"]
    print(getindex);

  }

    @IBAction func pushToNotificationScreen(sender: AnyObject) {
        
        print("got it")
        //        let notificationViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("NotificationIdentifier"))! as UIViewController
        //        self.navigationController?.pushViewController(notificationViewController, animated: true)
        
        self.performSegueWithIdentifier("Notificationsegue", sender: self);
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Notificationsegue") {
            // pass data to next view
            let notify:NotificationViewController = segue.destinationViewController as! NotificationViewController
            //notify.razorSharpTeeth
        }
        
    }
}
