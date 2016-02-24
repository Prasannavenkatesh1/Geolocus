//
//  LoginViewController.swift
//  GeoLocus
//
//  Created by Saranya on 20/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

/* This view allows the user to enter their login information or navigate to register page or need help page in the portal */

class LoginViewController: BaseViewController,UITextFieldDelegate {
    
    /* Outlets for the constraints */
    @IBOutlet weak var layoutConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintVerticalUserNameTop: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintLoginTop: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintCheckBoxTop: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintNeedHelpTop: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintViewBottom: NSLayoutConstraint!
    
    /* Outlets for the controls defined in the view */
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var needHelpButton: UIButton!
    @IBOutlet weak var registerNowButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var termsAndConditionsLabel: UILabel!
    
    /* Variable declarations */
    var isChecked = false
    let passwordShowButton = UIButton()
    var selectedLanguageCode : String!
    var termsAndConditionsString = String()
    
    // MARK: - Button Actions

    /* Register Now button action */
    @IBAction func registerNowButtonTapped(sender: AnyObject) {
        var registerNowURL : String!
        registerNowURL = FacadeLayer.sharedinstance.webService.registrationServiceURL! + "\(self.selectedLanguageCode)"
        UIApplication.sharedApplication().openURL(NSURL(string:registerNowURL)!)
    }
    
    /* Need help button action */
    @IBAction func needHelpButtonTapped(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: FacadeLayer.sharedinstance.webService.needHelpServiceURL!)!)
    }
    
    /* Login button action */
    @IBAction func loginTapped(sender: UIButton) {
        self.startLoading()
        loginButton.backgroundColor = UIColor(red: 83.0/255.0, green: 178.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        loginButton.setTitleColor(UIColor(red: 174.0/255.0, green: 174.0/255.0, blue: 174.0/255.0, alpha: 1.0),forState: UIControlState.Normal)
        
        let userNameString =  self.userNameText.text
        let passwordString =  self.passwordText.text
        
        let parameterString = String(format: StringConstants.LOGIN_PARAMETERS, passwordString!, userNameString!, self.selectedLanguageCode)
        
        self.requestLoginData(parameterString){ (status, response, error) -> Void in
            self.stopLoading()
            //navigate to onboarding screen,if the login is valid, else display an alert
            if(error == nil){
              FacadeLayer.sharedinstance.corelocation.initLocationManager()
                let welcomeScreenViewController = self.storyboard!.instantiateViewControllerWithIdentifier(StringConstants.WelcomePageViewController) as! WelcomePageViewController
                self.presentViewController(welcomeScreenViewController, animated: true, completion: nil)
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegateSwift
                appDelegate.requestAndSaveAppData()
            }
            else{
                let alertView = UIAlertController(title: StringConstants.ERROR, message: error?.domain, preferredStyle: UIAlertControllerStyle.Alert)
                alertView.addAction(UIAlertAction(title: StringConstants.OK, style: UIAlertActionStyle.Default) {(alertAction) in
                    if(error?.domain == ErrorConstants.InvalidLogin){
                        self.userNameText.text = ""
                        self.passwordText.text = ""
                        self.checkButton.setImage(UIImage(named:StringConstants.CHECK_BOX_UNSELECTED), forState: UIControlState.Normal)
                        self.loginButton.enabled = false
                        self.loginButton.backgroundColor = UIColor(red: 247.0/255.0, green: 249.0/255.0, blue: 251.0/255.0, alpha: 1.0)
                        self.loginButton.setTitleColor(UIColor.lightGrayColor(),forState: UIControlState.Normal)
                    }
                })
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }
    }
    
    /* Check box button action */
    @IBAction func checkButtonTapped(sender: UIButton) {
        if(!isChecked){
            self.showModal()
            self.view.backgroundColor = UIColor.clearColor()
            [sender.setImage(UIImage(named:StringConstants.CHECK_BOX_SELECTED), forState: UIControlState.Normal)]
            isChecked = true
        }
        else{
            [sender.setImage(UIImage(named:StringConstants.CHECK_BOX_UNSELECTED), forState: UIControlState.Normal)]
            isChecked = false
        }
        
        self.validate()
    }
    
    // MARK: - View Methods
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedLanguageCode = NSUserDefaults.standardUserDefaults().stringForKey(StringConstants.SELECTED_LANGUAGE_USERDEFAULT_KEY)
        
        userNameText.delegate = self
        passwordText.delegate = self
        
        self.setTitlesForButtonsAndTextFields()
        self.registerForKeyboardNotifications()
        self.setConstraintsForDevice()
        self.customizeTextField()
        self.customizeButton()
        self.termsAndConditionsURL()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.deregisterFromKeyboardNotifications()
    }
  
    // MARK: - Custom Methods

    /* set titles for Buttons and textfields to localize */
    func setTitlesForButtonsAndTextFields(){
        self.userNameText.attributedPlaceholder = NSAttributedString(string:LocalizationConstants.Username_PlaceholderText.localized(),
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.passwordText.attributedPlaceholder = NSAttributedString(string:LocalizationConstants.Password_PlaceholderText.localized(),
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.termsAndConditionsLabel.text = LocalizationConstants.Terms_And_Conditions_Title.localized()
        self.loginButton.setTitle(LocalizationConstants.Login_Title.localized(), forState: UIControlState.Normal)
        self.registerNowButton.setTitle(LocalizationConstants.RegisterNow_Title.localized(), forState: UIControlState.Normal)
        self.needHelpButton.setTitle(LocalizationConstants.NeedHelp_Title.localized(), forState: UIControlState.Normal)
    }
    
    /* function to validate for required fields */
    func validate(){
        if !(userNameText.text!.isEmpty) && !(passwordText.text!.isEmpty) && (isChecked == true) {
            loginButton.enabled = true
        }
    }
    
    /* set URL for Terms and Conditions content */
    func termsAndConditionsURL(){
        
        self.requestTermsAndConditionsData{ (status,response,error) -> Void in
            if(error == nil){
                self.termsAndConditionsString = NSString(data: response!, encoding: NSUTF8StringEncoding) as String!
            }
            else{
                let alertView = UIAlertController(title: StringConstants.ERROR.localized(), message: error?.description.localized(), preferredStyle: UIAlertControllerStyle.Alert)
                alertView.addAction(UIAlertAction(title: StringConstants.OK, style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }
    }
    
    /* Facade layer call for Terms and Conditions */
    func requestTermsAndConditionsData(completionHandler:(status : Int, response : NSData?, error : NSError?) -> Void) -> Void{
        FacadeLayer.sharedinstance.requestTermsAndConditionsData{ (status, data, error) -> Void in
            completionHandler(status: status, response: data, error: error)
        }
    }
    
    /* Facade layer call for Login */

    func requestLoginData(parameterString : String, completionHandler :(status : Int, response : NSData?, error : NSError?) -> Void) -> Void{
        FacadeLayer.sharedinstance.requestLoginData(parameterString){ (status, data, error) -> Void in
            completionHandler(status: status, response: data, error: error)
        }
    }
    
    /* create modal dialog view controller for displaying terms and conditions */
    func showModal() {
        let modalViewController = storyboard!.instantiateViewControllerWithIdentifier(StringConstants.TermsAndConditionsViewController) as! TermsAndConditionsViewController
        modalViewController.termsAndConditionsContent = self.termsAndConditionsString
        modalViewController.modalPresentationStyle = .OverCurrentContext
        presentViewController(modalViewController, animated: true, completion: nil)
    }
    
    /* setting constraints based on device height */
    func setConstraintsForDevice(){
        if(StringConstants.SCREEN_HEIGHT < Resolution.height.iPhone5){
            layoutConstraintTop.constant = 40
            layoutConstraintVerticalUserNameTop.constant = 10
            layoutConstraintLoginTop.constant = 10
            layoutConstraintCheckBoxTop.constant = 10
            layoutConstraintNeedHelpTop.constant = 5
        }
        if(StringConstants.SCREEN_HEIGHT == Resolution.height.iPhone5){
            layoutConstraintTop.constant = 80
            layoutConstraintLoginTop.constant = 30
        }
    }
    
    /* customize text field */
    func customizeTextField(){
        
        /* adding username image to textfield */
        let userNameImageView = UIImageView()
        let userNameImage = UIImage(named: StringConstants.USERNAME_IMAGE)
        userNameImageView.image = userNameImage
        userNameImageView.frame = CGRectMake(userNameText.bounds.origin.x + 10,userNameText.bounds.origin.y + 15, 25, 25)
        userNameImageView.contentMode = UIViewContentMode.Center
        
        userNameText.leftViewMode = UITextFieldViewMode.Always
        userNameText.leftView = userNameImageView
        
        /* adding password image to textfield */
        let passwordImageView = UIImageView()
        let passwordImage = UIImage(named: StringConstants.PASSWORD_IMAGE)
        passwordImageView.image = passwordImage
        passwordImageView.frame = CGRectMake(passwordText.bounds.origin.x + 10,passwordText.bounds.origin.y + 15, 25, 25)
        passwordImageView.contentMode = UIViewContentMode.Center
        
        passwordText.leftViewMode = UITextFieldViewMode.Always
        passwordText.leftView = passwordImageView
        
        /* adding border to username uitextfield */
        let bottomBorder = CALayer()
        bottomBorder.borderColor = UIColor.whiteColor().CGColor
        bottomBorder.frame = CGRect(x: userNameText.bounds.origin.x, y: userNameText.frame.size.height + 15, width: userNameText.frame.size.width + 250 , height: 1.0)
        bottomBorder.borderWidth = CGFloat(1.0)
        userNameText.layer.addSublayer(bottomBorder)
        userNameText.layer.masksToBounds = true
        
        /* adding border to password uitextfield */
        let passwordBorder = CALayer()
        passwordBorder.borderColor = UIColor.whiteColor().CGColor
        passwordBorder.frame = CGRect(x: passwordText.bounds.origin.x, y: passwordText.frame.size.height + 15, width: passwordText.frame.size.width + 250, height: 1.0)
        
        passwordBorder.borderWidth = CGFloat(1.0)
        passwordText.layer.addSublayer(passwordBorder)
        passwordText.layer.masksToBounds = true
        
        /* adding eye image to textfield */
        passwordShowButton.setImage(UIImage(named: StringConstants.PASSWORD_EYE_IMAGE), forState: UIControlState.Normal)
        passwordShowButton.frame = CGRectMake(passwordBorder.frame.size.width - 50, passwordText.bounds.origin.y, 20, 20)
        passwordShowButton.addTarget(self, action:"eyeButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        passwordShowButton.contentMode = UIViewContentMode.Center
        passwordText.rightViewMode = UITextFieldViewMode.WhileEditing
        passwordText.rightView = passwordShowButton
    }
    
    /* adding border to need help button */
    func customizeButton(){
        let attributes = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let attributedText = NSAttributedString(string: needHelpButton.currentTitle!, attributes: attributes)
        
        needHelpButton.titleLabel?.attributedText = attributedText
    }
    
    /* method action when password show/hide button pressed */
    func eyeButtonTapped(){
        if(passwordText.secureTextEntry == true){
            passwordText.secureTextEntry = false
        }
        else{
            passwordText.secureTextEntry = true
        }
    }
    
    
    //MARK: Notification methods on Keyboard pop up/dismissal
    
    /* Register for notifications when keyboard appears */
    func registerForKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /* Deregister for notifications when keyboard dismiss */
    func deregisterFromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /* set view constraints when keyboard is shown */
    func keyboardWasShown(notification: NSNotification) {
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            
            if(StringConstants.SCREEN_HEIGHT < 568){
                self.layoutConstraintVerticalUserNameTop.constant = 5
                self.layoutConstraintTop.constant = 10
            }
            if(StringConstants.SCREEN_HEIGHT == 568){
                self.layoutConstraintTop.constant = 60
            }
        })
    }

    /* set view constraints when keyboard is hidden */
    func keyboardWillBeHidden(notification:NSNotification){
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            if(StringConstants.SCREEN_HEIGHT < 568){
                self.layoutConstraintVerticalUserNameTop.constant = 10
                self.layoutConstraintTop.constant = 40
            }
            if(StringConstants.SCREEN_HEIGHT == 568){
                self.layoutConstraintTop.constant = 80
            }
            
        })
    }
    // MARK: Textfield Delegates Implementation
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.validate()
        return true
    }
}
