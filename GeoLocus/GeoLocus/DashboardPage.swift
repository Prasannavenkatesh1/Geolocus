//
//  DashboardPage.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

 class DashboardPage: UIViewController {

    @IBOutlet var needle: UIImageView!
    
    @IBOutlet weak var arcView: ArcGraphicsController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.arcView.ringLayer.strokeColor = UIColor.redColor().CGColor
        self.arcView.foreGroundArcWidth = 10.0
        self.arcView.animateScale = 0.75
        self.arcView.setNeedsDisplay()
          
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
