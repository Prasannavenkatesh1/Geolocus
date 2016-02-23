//
//  BaseViewController.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 12/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

public extension String {
    
    func localized() -> String {
        let languageCodeStr = NSUserDefaults.standardUserDefaults().stringForKey(StringConstants.SELECTED_LOCALIZE_LANGUAGE_CODE)
        if let path = NSBundle.mainBundle().pathForResource(languageCodeStr?.characters.count > 0 ? languageCodeStr : "en", ofType: "lproj"), bundle = NSBundle(path: path) {
            return bundle.localizedStringForKey(self, value: nil, table: nil)
        }
        return self
    }
}

class BaseViewController: UIViewController {

    var activityIndicatorView = UIActivityIndicatorView()
    var activityView: UIView?
  

//  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//    super.init(nibName: nil, bundle: nil)
//    FacadeLayer.sharedinstance.corelocation.initLocationManager()
//  }
//
//  required init?(coder aDecoder: NSCoder) {
//      fatalError("init(coder:) has not been implemented")
//  }

  

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* adding Activity Indicator to view */
    func addActivityIndicator() {
        if activityView == nil {
            activityView = UIView(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 64))
            activityView!.backgroundColor = UIColor.blackColor()
            activityView!.alpha = 0.5
        }
        
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        activityView!.addSubview(activityIndicatorView)
        self.view.addSubview(activityView!)
        activityView?.hidden = true
        self.view.bringSubviewToFront(activityIndicatorView)
    }
    
    func shouldShowActivtyOnView(show: Bool) {
        activityView?.hidden = !show
        self.view.bringSubviewToFront(activityView!)
    }
    
    /* start animating */
    func startLoading(){
        self.addActivityIndicator()
        self.shouldShowActivtyOnView(true)
    }
    
    /* stop animating */
    func stopLoading(){
        self.shouldShowActivtyOnView(false)
    }

    func isConnectedToNetwork() -> Bool{
        var reachability: Reachability = Reachability.reachabilityForInternetConnection()
        var networkStatus : NetworkStatus = reachability.currentReachabilityStatus()
        return !(networkStatus == NotReachable);
    }
    
    
    func displayActivityView(title: String, detail: String, imageInfo: Dictionary<String, String>, shareOption: ShareTemplate.ShareOption){
        
        let shareTemplate = ShareTemplate()
        
        shareTemplate.createShareTemplateImage(title, detail: detail, imageInfo: imageInfo, shareOption: shareOption) { (image) -> Void in
            
            let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
           // activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAirDrop]
            self.presentViewController(activityViewController, animated: true, completion: nil)
            
            
            activityViewController.completionWithItemsHandler = { activity, success, items, error in
                if success {
                    
                    let messageString = "Successfully shared"
                    let alert = UIAlertController(title: nil, message:messageString , preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    
                    let imageView   = UIImageView(frame: CGRectMake(30, 20, 20, 20))
                    imageView.image = UIImage(named: StringConstants.CHECK_BOX_SELECTED)
                    alert.view.addSubview(imageView)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    //MARK - PopUp
    func presentPopUpController(popUp:UIViewController){
        let sourceView : UIView = self.topView()
        let popUpView : UIView = popUp.view
        if sourceView.subviews .contains(popUpView) {
            return
        }
        
        // Add overlay
        let overLayView : UIView = UIView(frame: sourceView.bounds)
        overLayView.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        overLayView.backgroundColor = UIColor.clearColor()
        overLayView.tag = 111
        
        // Add Blured View
        let bluredView : UIView = UIView(frame: overLayView.bounds)
        bluredView.autoresizingMask = [.FlexibleWidth , .FlexibleHeight]
        bluredView.tag = 222
        bluredView.alpha = 0.6
        bluredView.backgroundColor = UIColor.blackColor()
        overLayView.addSubview(bluredView)
        
        
        //Customize popUpView
        popUpView.layer.cornerRadius = 3.5
        popUpView.layer.masksToBounds = true
        popUpView.layer.zPosition = 99
        popUpView.tag = 333
        popUpView.center = overLayView.center
        popUpView.setNeedsDisplay()
        popUpView.setNeedsLayout()
        
        
        overLayView.addSubview(popUpView)
        sourceView.addSubview(overLayView)
        sourceView.bringSubviewToFront(popUpView)
        
    }
    
    func topView() -> UIView{
        return (((UIApplication.sharedApplication().delegate)?.window)!)!
    }
    
    func dismissPopUpController(){
        let sourceView = self.topView()
        let overLayView = sourceView.viewWithTag(111)
        let bluredView = sourceView.viewWithTag(222)
        let popUpView = sourceView.viewWithTag(333)
        
        popUpView?.removeFromSuperview()
        bluredView?.removeFromSuperview()
        overLayView?.removeFromSuperview()
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
