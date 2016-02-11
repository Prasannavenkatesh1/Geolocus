//
//  NotificationDetailsViewController.swift
//  GeoLocus
//
//  Created by sathishkumar on 02/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class NotificationDetailsViewController: UIViewController {

    @IBOutlet weak var notificationDescription: UILabel!
    @IBOutlet weak var competitionAcceptanceView: UIView!
    @IBOutlet weak var competitionScoresView: UIView!
    @IBOutlet weak var baseScrollView: UIScrollView!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var ShareWithKBCButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationDescription.text = "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files , to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions"
        declineButton.layer.borderColor = UIColor(red:240/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).CGColor
        //competitionAcceptanceView.hidden = true
        competitionScoresView.hidden = true
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        baseScrollView.contentSize = CGSizeMake(baseScrollView.frame.size.width, competitionScoresView.frame.origin.y+competitionScoresView.frame.size.height);

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTapOnAccept(sender: AnyObject) {
        
        
    }
    @IBAction func didTapOnDecline(sender: AnyObject) {
        
        
    }
    @IBAction func didTapOnShareWithKBC(sender: AnyObject) {
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
