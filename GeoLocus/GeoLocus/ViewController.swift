//Created by Insurance H3 Team
//
//GeoLocus App
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var token : NSString = ""
    var passwordNew : NSString = ""
    var usernameNew : NSString = ""
    var statusCode : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        
        let username:NSString = usernameTextField.text!
        let password:NSString = passwordTextField.text!
        
        if (username.isEqualToString("") || password.isEqualToString("") ) {
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            
            passwordNew = password
            usernameNew = username
            
            let post:NSString = "j_password=\(password)&j_username=\(username)&_spring_security_remember_me=on"
            
            
            NSLog("PostData: %@",post);
            
            
            let url:NSURL = NSURL(string:"https://54.193.31.22/sei/j_spring_security_check")!
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength:NSString = String( postData.length )
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            print(request)
            let connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)!
            connection.start()
        }
    }
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!){
        print("response = %@", response)
        
        if let httpUrlResponse = response as? NSHTTPURLResponse
        {
            let statusResponse = httpUrlResponse.statusCode
            
            statusCode = statusResponse
            
            print("The value of Status Code is : \(statusCode)")
            
            if (statusCode == 200){
                
                print("\(httpUrlResponse.allHeaderFields)") // Error
                
                let jsonResponse: NSDictionary = httpUrlResponse.allHeaderFields
                
                token = jsonResponse.valueForKey("SPRING_SECURITY_REMEMBER_ME_COOKIE") as! NSString
                
                print(token)
                
            } else{
                print("Error Occurred")
            }
        }
    }
    
  func connection(connection: NSURLConnection,
    willSendRequestForAuthenticationChallenge challenge: NSURLAuthenticationChallenge)
  {
    challenge.sender!.useCredential(NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!), forAuthenticationChallenge: challenge)
    
  }
  
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        NSLog("Response data ==> %@", data);
        
        var err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
        let jsonResult: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
        
        NSLog("jsonResult = %@", jsonResult);
        
        print(jsonResult.valueForKey("accountCd"))
        print(jsonResult.valueForKey("accountId"))
        
        let registrationEntity: RegistrationEntity = RegistrationEntity()
        
        if data != nil {
            
            let accountID : NSInteger = jsonResult.valueForKey("accountId") as! NSInteger
            let isActive : NSInteger = jsonResult.valueForKey("active") as! NSInteger
            let agreementNumber : NSString = jsonResult.valueForKey("agreementNo") as! NSString
            let countryCode : NSString = jsonResult.valueForKey("countryCode") as! NSString
            let isDeleted : NSInteger = jsonResult.valueForKey("deleted") as! NSInteger
            let deviceID : NSString = jsonResult.valueForKey("deviceNumber") as! NSString
            let endDate : NSInteger = jsonResult.valueForKey("endDate") as! NSInteger
            let insuredID : NSInteger = jsonResult.valueForKey("insuredId") as! NSInteger
            let insuredType : NSString = jsonResult.valueForKey("insuredType") as! NSString
            let issueDate : NSInteger = jsonResult.valueForKey("issueDate") as! NSInteger
            let languageCode : NSString = jsonResult.valueForKey("languageCode") as! NSString
            let phoneNumber : NSString = jsonResult.valueForKey("phone") as! NSString
            let profileName : NSString = jsonResult.valueForKey("profileName") as! NSString
            let uomCategoryID : NSInteger = jsonResult.valueForKey("uomCategoryId") as! NSInteger
            let userID : NSInteger = jsonResult.valueForKey("userId") as! NSInteger
            var userName : NSString = jsonResult.valueForKey("userName") as! NSString
            let accountCode : NSString = jsonResult.valueForKey("accountCd") as! NSString
            
            
            
            registrationEntity.accountID = String(accountID)
            registrationEntity.isActive = String(isActive)
            registrationEntity.agreementNumber = agreementNumber as String
            registrationEntity.countryCode = countryCode as String
            registrationEntity.isDeleted = String(isDeleted)
            registrationEntity.deviceID = String(deviceID)
            registrationEntity.endDate = String(endDate)
            registrationEntity.insuredID = String(insuredID)
            registrationEntity.insuredType = insuredType as String
            registrationEntity.issueDate = String(issueDate)
            registrationEntity.languageCode = languageCode as String
            registrationEntity.phoneNumber = phoneNumber as String
            registrationEntity.profileName = profileName as String
            registrationEntity.uomCategoryID = String(uomCategoryID)
            registrationEntity.userID = String(userID)
            registrationEntity.userName = usernameNew as String
            registrationEntity.password = passwordNew as String
            registrationEntity.serviceToken = token as String
            registrationEntity.accountCode = accountCode as String
            
            let registrationDatabase: RegistrationDatabase = RegistrationDatabase()
            registrationDatabase.insertLoginDatabase(registrationEntity)
            
        }
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        print("The value of Status Code is : \(statusCode)")
        
        if (statusCode == 200) {
            
            NSLog("Response : connectionDidFinishLoading ");
            
            
            print("Login SUCCESS")
            
            let credentials:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            credentials.setObject(usernameNew, forKey: "USERNAME")
            credentials.setObject(passwordNew, forKey: "PASSWORD")
            credentials.setInteger(1, forKey: "ISLOGGEDIN")
            credentials.synchronize()
            
            performSegueWithIdentifier("DashboardSegueID", sender: self)
            
        } else {
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter a valid Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   
        textField.resignFirstResponder()
        return true
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!){
        
        print("Connection failed with error: \(error.localizedDescription)")
    
    }

    
}

