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
    var myActivityIndicator: UIActivityIndicatorView?
    var selectedRow :NSIndexPath?
    @IBOutlet weak var notificationListTableView: UITableView!
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
        
        //notificationCountURL()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedRow = notificationListTableView.indexPathForSelectedRow as NSIndexPath!
        if selectedRow != nil {
           print (selectedRow!.row)
           notificationListTableView.reloadData()
        }

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
    //MARK: - IndicatorView methods
    func showActivityIndicator(){
        self.myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        
        self.myActivityIndicator!.center = self.view.center
        self.myActivityIndicator!.startAnimating()
        self.view.addSubview(self.myActivityIndicator!)
    }
    
    func hideActivityIndicator(){
        self.myActivityIndicator!.stopAnimating()
    }
    
    /* Facade layer call */
   
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
//        cell.notificationTitle.text = "Hai"
//        cell.notificationDate.text = ""
//        cell.notificationMessage.text  = ""
        //cell.notificationImageView.image =
        if selectedRow != nil && selectedRow == indexPath{
            cell.notificationTitle.textColor = UIColor(red:0/255.0, green:54/255.0, blue:101/255.0, alpha: 1.0)
            cell.notificationDate.textColor = UIColor(red:0/255.0, green:54/255.0, blue:101/255.0, alpha: 1.0)
            cell.notificationMessage.textColor = UIColor(red:0/255.0, green:54/255.0, blue:101/255.0, alpha: 1.0)
        }
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
        let alert = UIAlertController(title: "", message: "Are you sure want to delete?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
            self.showActivityIndicator()
            // call delete service
            print("Tapped yes")
            let userID = "7"
            let notificationId = "14"
            let type = "Promotion"
            
            
            let indexPath: NSIndexPath!
            let deleteRow : Int!
            if let button = sender as? UIButton {
                if let superview = button.superview {
                    if let cell = superview.superview as? NotificationTableViewCell {
                        indexPath = self.notificationListTableView.indexPathForCell(cell)
                        deleteRow = indexPath.row

                    }
                }
            }
            
            let parameterString = String(format: StringConstants.NOTIFICATION_DELETE_PARAMETERS, userID, notificationId, type)
            
            FacadeLayer.sharedinstance.postDeletedNotification { (status, data, error) -> Void in
                if(status == 1) {
                    self.notificationListTableView.reloadData()
                    
                }
                self.hideActivityIndicator()

            }
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { action in
            
            print ("Tapped No")

            
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
