//
//  BaseViewController.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 12/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var activityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addActivityIndicator()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* adding Activity Indicator to view */
    func addActivityIndicator(){
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
    }
    
    /* start animating */
    func startLoading(){
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidden = false
    }
    
    /* stop animating */
    func stopLoading(){
        activityIndicatorView.stopAnimating()
        activityIndicatorView.hidden = true
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
