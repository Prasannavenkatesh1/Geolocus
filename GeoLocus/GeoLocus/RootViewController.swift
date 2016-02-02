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
    var labelNotificationCount:UILabel!
  var categories = [String]()

  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      
        let notifyfullView=UIView(frame: CGRectMake(0, 0, 50, 40))
        notifyfullView.backgroundColor=UIColor.yellowColor()
        
        let redView=UIView(frame: CGRectMake(0, 0, 25, 25))
        redView.backgroundColor=UIColor.redColor()
        redView.layer.cornerRadius=12.5
        redView.layer.masksToBounds=true
        //DynamicView.layer.borderWidth=2
        
        labelNotificationCount = UILabel()
        labelNotificationCount.frame = CGRectMake(2, 0, 20, 20)
        labelNotificationCount.textAlignment = NSTextAlignment.Center;
        labelNotificationCount.text = "1"
        redView.addSubview(labelNotificationCount)
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "Selected"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 45, 45)
        button.addTarget(self, action: "pushToNotificationScreen:", forControlEvents: .TouchUpInside)
        
        notifyfullView.addSubview(redView)
        notifyfullView.addSubview(button)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = notifyfullView
        self.navigationItem.rightBarButtonItem = rightItem
        
        
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
            sideMenuButton.action = "revealToggle:"
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
 func  pushToNotificationScreen(sender: UIButton!) {
    self.performSegueWithIdentifier("Notificationsegue", sender: self);

    }
//    @IBAction func pushToNotificationScreen(sender: AnyObject) {
//        
//        print("got it")
//        //        let notificationViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("NotificationIdentifier"))! as UIViewController
//        //        self.navigationController?.pushViewController(notificationViewController, animated: true)
//        
//        self.performSegueWithIdentifier("Notificationsegue", sender: self);
//        
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Notificationsegue") {
            // pass data to next view
            let notify:NotificationViewController = segue.destinationViewController as! NotificationViewController
            //notify.razorSharpTeeth
        }
        
    }
}
