//
//  BaseViewController.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 12/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
    
    
    func displayActivityView(){
        let firstActivityItem = "my text"
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        self.navigationController!.presentViewController(activityViewController, animated: true, completion: nil)
    }
    

  func showSnoozingPop(){
    let storyboard: UIStoryboard = UIStoryboard(name: "Storyboard", bundle: NSBundle.mainBundle())
    let snoozing = storyboard.instantiateViewControllerWithIdentifier("SnoozingController") as! SnoozingController
    UIApplication.sharedApplication().keyWindow?.addSubview(snoozing.view)
  }

}
