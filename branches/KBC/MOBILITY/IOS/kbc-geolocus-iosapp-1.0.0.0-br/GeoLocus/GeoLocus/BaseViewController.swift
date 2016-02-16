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
    
    
    func displayActivityView(title: String, detail: String, imageInfo: Dictionary<String, String>, shareOption: ShareTemplate.ShareOption){
        
        let shareTemplate = ShareTemplate()
        
        shareTemplate.createShareTemplateImage(title, detail: detail, imageInfo: imageInfo, shareOption: shareOption) { (image) -> Void in
            
            let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
            
            
            activityViewController.completionWithItemsHandler = { activity, success, items, error in
                if success {
                    
                    let messageString = "Successfully shared"
                    let alert = UIAlertController(title: nil, message:messageString , preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    
                    let imageView = UIImageView(frame: CGRectMake(30, 20, 20, 20))
                    imageView.image = UIImage(named: StringConstants.CHECK_BOX_SELECTED)
                    alert.view.addSubview(imageView)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            }
        }
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
