//
//  NotificationViewController.swift
//  GeoLocus
//
//  Created by sathishkumar on 22/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    var notificationListDict = [String: String]()
    var notificationListArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationListDict = ["key1": "value1", "key2": "value2"]
        notificationListArray.append("hello")
        notificationListArray.append("hello")
        notificationListArray.append("hello")
        notificationListArray.append("hello")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
