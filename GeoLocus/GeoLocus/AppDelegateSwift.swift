//Created by Insurance H3 Team
//
//GeoLocus App
//
import UIKit
import CoreData

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
//    var autoButtonChange : NSString?
    
    override init() {
      
      
//      // get your storyboard
//      let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
//      
//      // instantiate your desired ViewController
//      let rootController = storyboard.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
//      
//      // instantiate your desired ViewController
//      let languagecontroller = storyboard.instantiateViewControllerWithIdentifier("LanguageSelectionViewController") as! LanguageSelectionViewController
//      
//      // Because self.window is an optional you should check it's value first and assign your rootViewController
//      if let window = self.window {
//        window.rootViewController = languagecontroller
//      }
      
      
//      let tseries:Timeseries = Timeseries.init(ctime: "10",
//        lat: 101,
//        longt: 102,
//        speedval: 103,
//        tzone: "IST",
//        iseventval: 1,
//        evetype: 2,
//        eveval: 3)
//      FacadeLayer.sharedinstance.dbactions.tempsave(tseries)
      
        vAlert = "Enabled"
        globalAutoTrip = false
        speedLimit = 0.0
        deviceId = nil
        countryCode = nil
        setSettings = "0"
        iPhoneSize = "iPhone5"
//        autoButtonChange = "Disabled"
      
//      let det = NSLocalizedString("hello", comment: "hello comment")
//      print("qwqwq \(det)")
      
        print("Global Auto Trip : \(globalAutoTrip)")
        let settings : GeolocusDashboard = GeolocusDashboard()
        settings.setSettingsData()
        
//        var settingsData = settings.getSettingsData() as NSDictionary
    }
  
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(false, forKey: "isStarted")
        
        // Override point for customization after application launch.
        
//        self.checkStoryBoard()
      
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func checkStoryBoard() {
        
        let screenSize = UIScreen.mainScreen().bounds.size
        
        let isiPhone4 = CGSizeEqualToSize(screenSize, CGSizeMake(320, 480))
        let isiPhone5 = CGSizeEqualToSize(screenSize, CGSizeMake(320, 568))
        let isiPhone6 = CGSizeEqualToSize(screenSize, CGSizeMake(375, 667))
        var isiPhone6P = CGSizeEqualToSize(screenSize, CGSizeMake(414, 736))
        
        if (isiPhone4) {
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            let storyboard = UIStoryboard(name: "Main4s", bundle: nil)
            
            let geolocusDashboard : GeolocusDashboard = GeolocusDashboard()
            let checkUser : Bool = geolocusDashboard.checkUserDetails()
            
            print("checkUser :\(checkUser)")

            
            let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
            
            if (firstLaunch && checkUser)  {
                print("Not first launch.")
                let dashboardPage = storyboard.instantiateViewControllerWithIdentifier("Dashboard") as! DashBoardView
                self.window?.rootViewController = dashboardPage
                self.window?.makeKeyAndVisible()
                
            }
            else if (!checkUser) {
                print("First launch, setting NSUserDefault.")
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
                let loginPage = storyboard.instantiateViewControllerWithIdentifier("Login") as! ViewController
                self.window?.rootViewController = loginPage
                self.window?.makeKeyAndVisible()
            }
            
            iPhoneSize = "iPhone4"
        }
        else if (isiPhone5){
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let geolocusDashboard : GeolocusDashboard = GeolocusDashboard()
            let checkUser : Bool = geolocusDashboard.checkUserDetails()

            print("checkUser :\(checkUser)")
            
//            if(checkUser){
//                
//                var dashboardPage = storyboard.instantiateViewControllerWithIdentifier("Dashboard") as! DashBoardView
//                self.window?.rootViewController = dashboardPage
//                self.window?.makeKeyAndVisible()
//                
//            }else{
//                
//                var loginPage = storyboard.instantiateViewControllerWithIdentifier("Login") as! ViewController
//                self.window?.rootViewController = loginPage
//                self.window?.makeKeyAndVisible()
//                
//            }
            
            let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
            
            if (firstLaunch && checkUser)  {
                print("Not first launch.")
                let dashboardPage = storyboard.instantiateViewControllerWithIdentifier("Dashboard") as! DashBoardView
                self.window?.rootViewController = dashboardPage
                self.window?.makeKeyAndVisible()
                
            }
            else if (!checkUser) {
                print("First launch, setting NSUserDefault.")
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
                let loginPage = storyboard.instantiateViewControllerWithIdentifier("Login") as! ViewController
                self.window?.rootViewController = loginPage
                self.window?.makeKeyAndVisible()
            }

            iPhoneSize = "iPhone5"
            
        }
        else if (isiPhone6){
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            let storyboard = UIStoryboard(name: "Main6", bundle: nil)
            let geolocusDashboard : GeolocusDashboard = GeolocusDashboard()
            let checkUser : Bool = geolocusDashboard.checkUserDetails()
            
            print("checkUser :\(checkUser)")
            
            let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
            
            if (firstLaunch && checkUser)  {
                print("Not first launch.")
                let dashboardPage = storyboard.instantiateViewControllerWithIdentifier("Dashboard") as! DashBoardView
                self.window?.rootViewController = dashboardPage
                self.window?.makeKeyAndVisible()
                
            }
            else if (!checkUser) {
                print("First launch, setting NSUserDefault.")
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
                let loginPage = storyboard.instantiateViewControllerWithIdentifier("Login") as! ViewController
                self.window?.rootViewController = loginPage
                self.window?.makeKeyAndVisible()
            }

            iPhoneSize = "iPhone6"
            
        }
        
        else {
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let geolocusDashboard : GeolocusDashboard = GeolocusDashboard()
            let checkUser : Bool = geolocusDashboard.checkUserDetails()
            
            print("checkUser :\(checkUser)")

            let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
   
            if (firstLaunch && checkUser)  {
                print("Not first launch.")
                let dashboardPage = storyboard.instantiateViewControllerWithIdentifier("Dashboard") as! DashBoardView
                self.window?.rootViewController = dashboardPage
                self.window?.makeKeyAndVisible()
                
            }
            else if (!checkUser) {
                print("First launch, setting NSUserDefault.")
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
                let loginPage = storyboard.instantiateViewControllerWithIdentifier("Login") as! ViewController
                self.window?.rootViewController = loginPage
                self.window?.makeKeyAndVisible()
            }
            
            iPhoneSize = "iPhone5"
            
        }
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

