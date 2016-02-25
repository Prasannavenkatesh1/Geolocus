//Created by Insurance H3 Team
//
//GeoLocus App
//
import UIKit
import CoreData

enum Actions:String{
  case yes = "YES"
  case no = "NO"
}

enum LanguageCode : String{
  case English = "en_uk"
  case French = "fr_be"
  case Nederlands = "nl_be"
  case Duits = "de_be"
}

enum Language : String{
    case English = "English"
    case German = "German"
    case French = "French"
    case Dutch = " Dutch"
}

enum LocalizeLanguageCode: String {
    case English = "en"
    case French = "fr"
    case German = "de"
    case Nederlands = "nl"
}

@UIApplicationMain
class AppDelegateSwift: UIResponder, UIApplicationDelegate {
  

    var window: UIWindow?
    var vAlert : NSString?
    var globalAutoTrip : Bool
    var speedLimit : Float
    var deviceId : NSString?
    var countryCode : NSString?
    var setSettings : String
    var iPhoneSize : String
    var logoView:UIImageView?
    var bgView:UIImageView?
    var backgroundUpdateTask:UIBackgroundTaskIdentifier?


  
    override init() {
      
        vAlert = "Enabled"
        globalAutoTrip = false
        speedLimit = 0.0
        deviceId = nil
        countryCode = nil
        setSettings = "0"
        iPhoneSize = "iPhone5"
//        autoButtonChange = "Disabled"
      
//        let settings : GeolocusDashboard = GeolocusDashboard()
//        settings.setSettingsData()
    }


  
  
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      
      //    NSNotificationCenter.defaultCenter().postNotificationName("tipended", object: nil)
    
      //

    registerNotification()

    let defaults = NSUserDefaults.standardUserDefaults()
//    defaults.setBool(false, forKey: "isFirstTime")
    if( defaults.boolForKey("isFirstTime") == false){
      defaults.setBool(true, forKey: "isFirstTime")
      defaults.setBool(false, forKey: "isStarted")
      defaults.setInteger(1, forKey: "autoincr_tripid")
      defaults.setValue("", forKey: StringConstants.TOKEN_ID)
      defaults.setObject("", forKey: "motionlat")

      
      //  Insert Weightage values for testing
      
      defaults.setDouble(7, forKey: StringConstants.Thresholds_Brake)
      defaults.setDouble(5, forKey: StringConstants.Thresholds_Acceleration)
      defaults.setDouble(7, forKey: StringConstants.Thresholds_Autotrip)
      defaults.setDouble(40, forKey: StringConstants.Thresholds_Minimumspeed)
      defaults.setDouble(0.9, forKey: StringConstants.Weightage_Braking)
      defaults.setDouble(1.2, forKey: StringConstants.Weightage_Acceleration)
      defaults.setDouble(1.6, forKey: StringConstants.Weightage_Speed)
      defaults.setDouble(1.4, forKey: StringConstants.Weightage_Severevoilation)
      defaults.setDouble(0.5, forKey: StringConstants.Ecoweightage_Braking)
      defaults.setDouble(0.2, forKey: StringConstants.Ecoweightage_Acceleration)
      

    }
      


    self.loadInitialViewController()
      
//        // Push notification
//        let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType([.Alert, .Badge, .Sound]), categories: nil)
//        UIApplication.sharedApplication().registerUserNotificationSettings(settings);
//        UIApplication.sharedApplication().registerForRemoteNotifications();
      
        return true
    }

    func application(application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //send this device token to server
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        print( deviceTokenString )
        
        
    }
    
    //Called if unable to register for APNS.
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        print(error)
        
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        print("Received: \(userInfo)")
        //Parsing userinfo:
        //var temp : NSDictionary = userInfo
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
        {
            var alertMsg = info["alert"] as! String
            var alert: UIAlertView!
            alert = UIAlertView(title: "push", message: alertMsg, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
  // Register notification settings
  func registerNotification() {
    
    // 1. Create the actions **************************************************
    
    // yes Action
    let yesAction = UIMutableUserNotificationAction()
    yesAction.identifier = Actions.yes.rawValue
    yesAction.title = "YES"
    yesAction.activationMode = UIUserNotificationActivationMode.Background
    yesAction.authenticationRequired = true
    yesAction.destructive = false
    
    // no Action
    let noAction = UIMutableUserNotificationAction()
    noAction.identifier = Actions.no.rawValue
    noAction.title = "NO"
    noAction.activationMode = UIUserNotificationActivationMode.Background
    noAction.authenticationRequired = true
    noAction.destructive = false
    
    
    // 2. Create the category ***********************************************
    
    // Category
    let counterCategory = UIMutableUserNotificationCategory()
    counterCategory.identifier = categoryID
    
    // A. Set actions for the default context
    counterCategory.setActions([yesAction, noAction],
      forContext: UIUserNotificationActionContext.Default)
    
    // B. Set actions for the minimal context
    counterCategory.setActions([yesAction, noAction],
      forContext: UIUserNotificationActionContext.Minimal)
    
    
    // 3. Notification Registration *****************************************
    
    let types: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Sound]
    let settings = UIUserNotificationSettings(forTypes: types, categories: NSSet(object: counterCategory) as? Set<UIUserNotificationCategory>)
    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    
    //      UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert , .Sound, .Badge], categories: nil))

  }
  
  
  
  func application(application: UIApplication,
    handleActionWithIdentifier identifier: String?,
    forLocalNotification notification: UILocalNotification,
    completionHandler: () -> Void) {
      
      // Handle notification action *****************************************
      if notification.category == categoryID {
        
        let action:Actions = Actions(rawValue: identifier!)!
        
      
        switch action{
          
        case Actions.yes:
          print("yes")
          if let userinfo = notification.userInfo {
            let triptype = userinfo["triptype"] as! Bool
            if(triptype == false){
              print("trip stoped")
              NSNotificationCenter.defaultCenter().postNotificationName("tipended", object: nil)

            }
          }
          
        case Actions.no:
          print("no")
          
        }
      }
      
      completionHandler()
  }
  
  /*
  * Adds background image to the splash screen
  */
  func addBackgroundImage() {
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    let bg = UIImage(named: "Anisplash")
    self.bgView = UIImageView(image: bg)
    
    self.bgView!.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
    self.window?.addSubview(self.bgView!)
  }
  
  /*
  * Adds logo to splash screen
  */
  func addLogo() {
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    let logo     = UIImage(named: "logo_home")
    self.logoView = UIImageView(image: logo)
    
    let w = logo?.size.width
    let h = logo?.size.height
    
    self.logoView!.frame = CGRectMake( (screenSize.width/2) - (w!/2), 5, w!, h! )
    self.window?.addSubview(self.logoView!)
    
    UIView.animateWithDuration(0.9, delay: 0.4,
      options: [.CurveEaseIn], animations: {
        self.logoView!.center.y += self.window!.bounds.width - self.logoView!.bounds.height - 20
      }, completion: {_ in
        self.logoView!.hidden = true
        self.bgView!.hidden = true
    })
  }
  
  
    /* function to navigate to respective view controller on first launch/succesive login */
    func loadInitialViewController(){
      
        let storyboard: UIStoryboard = UIStoryboard(name: "Storyboard", bundle: NSBundle.mainBundle())
        let checkUserLogin : Bool = self.checkUserDetails()
        //checkUserLogin = false
        if(!checkUserLogin){
            FacadeLayer.sharedinstance.corelocation.initLocationManager()

            let dashboardPage = storyboard.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
            self.window?.rootViewController = dashboardPage
            self.window?.makeKeyAndVisible()
        }
        else{
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
            let languageSelectionPage = storyboard.instantiateViewControllerWithIdentifier(StringConstants.LanguageSelectionViewController) as! LanguageSelectionViewController
            self.window?.rootViewController = languageSelectionPage
            self.window?.makeKeyAndVisible()
        }
      
      addBackgroundImage()
      addLogo()
    }
    
    /* check if the user is logged in to the app for the first time or not */
    
    func checkUserDetails() -> Bool{
        let tokenID : String = NSUserDefaults.standardUserDefaults().stringForKey(StringConstants.TOKEN_ID)!
        var isFirstTimeLogin : Bool
        
        if(tokenID.isEmpty){
            isFirstTimeLogin = true
        }
        else{
            isFirstTimeLogin = false
        }
        return isFirstTimeLogin
    }
    func notificationCountURL(){
        //self.showActivityIndicator()
        FacadeLayer.sharedinstance.fetchNotificationCount { (status, data, error) -> Void in
            if(status == 1) {
                
                let nc = NSNotificationCenter.defaultCenter()
                nc.postNotificationName("UPDATE_NOTIFICATION_COUNT", object: nil)
            }
            //self.hideActivityIndicator()
            
        }
    }
    
    //MARK: - HTTP & Database
    
    func requestAndSaveAppData(){
        
        var serviceError: NSError!
        var dbStatus = false
        
        var badgeData = [Badge]()
        var historyData = [History]()
        var overallScore = OverallScores?()
        var contractData = ContractModel?()
        var reportData = Report?()
        var dashboardData = DashboardModel?()
        
        let webServiceGroup = dispatch_group_create();
        let operationQueue = NSOperationQueue()
        
        let serviceOperation = NSBlockOperation{        //TODO: uncomment this and below save method
            /* dispatch_group_enter(webServiceGroup)
            FacadeLayer.sharedinstance.requestBadgesData { (status, data, error) -> Void in
            
            if status == 1 && error == nil {
            badgeData = data!
            }else{
            serviceError = error
            }
            print("badge service finished...")
            dispatch_group_leave(webServiceGroup)
            }*/
            
            /* Contract Service */
             dispatch_group_enter(webServiceGroup)
            FacadeLayer.sharedinstance.requestContractData({ (status, data, error) -> Void in
                if status == 1 && error == nil {
                    contractData = data!
                }else{
                    serviceError = error
                }
                print("contract service completed")
                dispatch_group_leave(webServiceGroup)
            })
            
            dispatch_group_enter(webServiceGroup)
            FacadeLayer.sharedinstance.requestDashboardData({ (status, data, error) -> Void in
                if status == 1 && error == nil {
                    dashboardData = data!
                }else{
                    serviceError = error
                }
                print("Dashboard service finished...")
                dispatch_group_leave(webServiceGroup)
                
            })


            dispatch_group_enter(webServiceGroup)
            FacadeLayer.sharedinstance.requestRecentTripData({ (status, data, error) -> Void in
                if status == 1 && error == nil {
                    historyData = data!
                }else{
                    serviceError = error
                }
                print("history service finished...")
                dispatch_group_leave(webServiceGroup)
            })
            
            dispatch_group_enter(webServiceGroup)
            FacadeLayer.sharedinstance.requestOverallScoreData({ (status, data, error) -> Void in
                if status == 1 && error == nil {
                    overallScore  = data!
                }else{
                    serviceError = error
                }
                print("overall score service finished...")
                dispatch_group_leave(webServiceGroup)
            })
            
            dispatch_group_enter(webServiceGroup)
            FacadeLayer.sharedinstance.requestInitialReportData(timeFrame: ReportDetails.TimeFrameType.weekly, scoreType: ReportDetails.ScoreType.speed, completionHandler: { (success, error, result) -> Void in
                if success && error == nil {
                    reportData = result
                }
                dispatch_group_leave(webServiceGroup)
            })
            dispatch_group_wait(webServiceGroup, DISPATCH_TIME_FOREVER)
        }
        
        let dbOperation = NSBlockOperation {
            
            if serviceError == nil {
                /* dispatch_group_enter(webServiceGroup)
                FacadeLayer.sharedinstance.removeData("Trip_Badge")
                FacadeLayer.sharedinstance.saveBadge(badgeData) { (status) -> Void in
                if status {
                dbStatus = true
                }else{
                dbStatus = false
                }
                print("badgeData save finished...")
                dispatch_group_leave(webServiceGroup)
                }
                dispatch_group_wait(webServiceGroup, DISPATCH_TIME_FOREVER)
                */
                dispatch_group_enter(webServiceGroup)
                FacadeLayer.sharedinstance.removeData("Trip_Detail")
                FacadeLayer.sharedinstance.saveTripDetail(historyData, completionhandler: { (status) -> Void in
                    if status {
                        dbStatus = true
                    }else{
                        dbStatus = false
                    }
                    print("historyData save finished...")
                    dispatch_group_leave(webServiceGroup)
                })
                dispatch_group_wait(webServiceGroup, DISPATCH_TIME_FOREVER)
                
                dispatch_group_enter(webServiceGroup)
                FacadeLayer.sharedinstance.removeData("Dashboard")
                FacadeLayer.sharedinstance.saveDashBoardData(dashboardData!, completionhandler: { (status) -> Void in
                    if status{
                        dbStatus = true
                    }else{
                        dbStatus = false
                    }
                    print("Dashboard Save finished")
                    dispatch_group_leave(webServiceGroup)
                })

                
                dispatch_group_enter(webServiceGroup)
                FacadeLayer.sharedinstance.removeData("Contract")
                FacadeLayer.sharedinstance.saveContractData(contractData!, completionHandler: { (status) -> Void in
                    if status {
                        dbStatus = true
                    }else{
                        dbStatus = false
                    }
                    print("contract save finished...")
                    dispatch_group_leave(webServiceGroup)
                })

                dispatch_group_enter(webServiceGroup)
                FacadeLayer.sharedinstance.removeData("OverallScore")
                FacadeLayer.sharedinstance.saveOverallScore(overallScore!, completionhandler: { (status) -> Void in
                    if status {
                        dbStatus = true
                    }else{
                        dbStatus = false
                    }
                    print("overallScore save finished...")
                    dispatch_group_leave(webServiceGroup)
                })
                
                dispatch_group_enter(webServiceGroup)
                FacadeLayer.sharedinstance.removeData("Reports")
                if let reportData = reportData {
                    FacadeLayer.sharedinstance.saveInitialReportData(reportData, completionHandler: { (status) -> Void in
                        dbStatus = status
                        print("report data finished")
                        dispatch_group_leave(webServiceGroup)
                    })
                }
                dispatch_group_wait(webServiceGroup, DISPATCH_TIME_FOREVER)
            }
        }
        
        let completionOperation = NSBlockOperation {
            
            if ((dbStatus) && (serviceError == nil)) {
                print("success...")
            }else{
                print("failure")
            }
            
        }
        
        // configuring interoperation dependencies
        dbOperation.addDependency(serviceOperation)
        completionOperation.addDependency(dbOperation)
        
        operationQueue.addOperations([serviceOperation, dbOperation, completionOperation], waitUntilFinished: false)
    }
    
    
  
  //  MARK: - Background Task Identifier
  func applicationDidEnterBackground(application: UIApplication) {
//    doBackgroundTask()
   
  }
    func applicationWillEnterForeground(application: UIApplication) {
        notificationCountURL()
    }
    
  func applicationDidBecomeActive(application: UIApplication) {
    // End the background task.
    self.endBackgroundUpdateTask()
    requestAndSaveAppData()
  }
  
  
  func beginBackgroundUpdateTask() {
    self.backgroundUpdateTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
//      self.endBackgroundUpdateTask()
    })
  }

  func endBackgroundUpdateTask() {
    if let bgtsk = self.backgroundUpdateTask {
      UIApplication.sharedApplication().endBackgroundTask(self.backgroundUpdateTask!)
      self.backgroundUpdateTask = UIBackgroundTaskInvalid
    }
  }
  
  func doBackgroundTask() {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
      self.beginBackgroundUpdateTask()
      
      // Do something with the result.
      let temp:DetectingVechile = DetectingVechile()
      temp.startDetectingVechile()
      
      
    })
  }
  
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cognizantenterprisemobility.DemoSwiftApp1.IPL_Alarm" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("GeoLocusModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("GeoLocusModel.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
}

