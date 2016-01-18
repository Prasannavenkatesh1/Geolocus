//
//  RootViewController.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
  
  var categories = [String]()

    @IBOutlet var sidemenuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
      
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
            sidemenuButton.target = revealViewController()
            sidemenuButton.action = "rightRevealToggle:"
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
    
//    if let val = vcindex.userInfo!["getindex"] as? String {
//      
//    }

  }

}
