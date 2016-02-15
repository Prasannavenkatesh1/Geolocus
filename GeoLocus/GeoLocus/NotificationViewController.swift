//
//  NotificationViewController.swift
//  GeoLocus
//
//  Created by sathishkumar on 22/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController,UITableViewDataSource, UITableViewDelegate{
    var notificationListDict = [String: String]()
    var notificationListArray = [String]()
    var notificationListModel = NotificationListModel?()

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationListDict = ["key1": "value1", "key2": "value2"]
        notificationListArray.append("hello")
        notificationListArray.append("hello")
        notificationListArray.append("hello")
        notificationListArray.append("hello")
        notificationListArray.append("hello")
        notificationListArray.append("hello")
        
        self.navigationItem.title = "Notification"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:0/255.0, green:54/255.0, blue:101/255.0, alpha: 1.0),NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 18)!]
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "BackButton"), forState: .Normal)
        backButton.frame = CGRectMake(0, 0, 12, 21)
        backButton.addTarget(self, action: Selector("backButtonPressed:"), forControlEvents: .TouchUpInside)
        
        let kbcicon = UIImageView()
        kbcicon.image=UIImage(named: "KBCIcon")
        kbcicon.frame = CGRectMake(0, 0, 35, 32)
        let backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        let kbcIconItem:UIBarButtonItem = UIBarButtonItem(customView: kbcicon)

        self.navigationItem.setLeftBarButtonItems([backButtonItem,kbcIconItem], animated:true)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func backButtonPressed(sender:UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func reloadView() {
        if self.notificationListModel != nil {
            
        }
        
       
    }
    //MARK: - Tableview Delegate & Datasource
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return notificationListArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath) as! NotificationTableViewCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.performSegueWithIdentifier("NotificationDetailssegue", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "NotificationDetailssegue") {
            // pass data to next view
            //let notify:NotificationViewController = segue.destinationViewController as! NotificationViewController
            //notify.razorSharpTeeth
        }
        
    }
  
    func  pushToNotificationScreen(sender: UIButton!) {
        self.performSegueWithIdentifier("Notificationsegue", sender: self);
        
    }
    @IBAction func didTapOnDelete(sender: AnyObject) {
        print("Delete tapped")
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: { action in
            
            // call delete service
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func requestNotificationListData(completionHandler:(status: Int, data: NotificationListModel?, error: NSError?) -> Void) -> Void{
        
        FacadeLayer.sharedinstance.requestNotificationListData { (status, data, error) -> Void in
            completionHandler(status: status, data: data, error: error)
        }
    }
    func requestNotificationDetailsData(completionHandler:(status: Int, data: NotificationDetailsModel?, error: NSError?) -> Void) -> Void{
        
        FacadeLayer.sharedinstance.requestNotificationDetailsData { (status, data, error) -> Void in
            completionHandler(status: status, data: data, error: error)
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
