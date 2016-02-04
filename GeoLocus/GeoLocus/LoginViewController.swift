//
//  LoginViewController.swift
//  GeoLocus
//
//  Created by Saranya on 20/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    var isChecked = false
    
    @IBOutlet weak var layoutConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintVerticalUserNameTop: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintLoginTop: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintCheckBoxTop: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintNeedHelpTop: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var needHelpButton: UIButton!
    @IBOutlet weak var registerNowButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    
    let passwordShowButton = UIButton()
    
    // MARK: - Button Actions

    /* Register Now button action */
    @IBAction func registerNowButtonTapped(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:StringConstants.REGISTER_NOW_URL)!)
    }
    
    /* Need help button action */
    @IBAction func needHelpButtonTapped(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:StringConstants.NEED_HELP_URL)!)
    }
    
    /* Login button action */
    @IBAction func loginTapped(sender: UIButton) {     
        loginButton.backgroundColor = UIColor(red: 83.0/255.0, green: 178.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        loginButton.setTitleColor(UIColor(red: 174.0/255.0, green: 174.0/255.0, blue: 174.0/255.0, alpha: 1.0),forState: UIControlState.Normal)
    }
    
    /* Check box button action */
    @IBAction func checkButtonTapped(sender: UIButton) {
        if(!isChecked){
            [sender.setImage(UIImage(named:StringConstants.CHECK_BOX_SELECTED), forState: UIControlState.Normal)]
            isChecked = true
        }
        else{
            [sender.setImage(UIImage(named:StringConstants.CHECK_BOX_UNSELECTED), forState: UIControlState.Normal)]
            isChecked = false
        }
        
        validate()
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameText.delegate = self
        passwordText.delegate = self
        
        registerForKeyboardNotifications()
        setConstraintsForDevice()
        customizeTextField()
        customizeButton()
    }
    
    override func viewWillDisappear(animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    /* setting constraints based on device height */
    func setConstraintsForDevice(){
        if(StringConstants.SCREEN_HEIGHT < 568){
            layoutConstraintTop.constant = 40
            layoutConstraintVerticalUserNameTop.constant = 10
            layoutConstraintLoginTop.constant = 10
            layoutConstraintCheckBoxTop.constant = 10
            layoutConstraintNeedHelpTop.constant = 5
        }
        if(StringConstants.SCREEN_HEIGHT == 568){
            layoutConstraintTop.constant = 80
            layoutConstraintLoginTop.constant = 30
        }
    }
    
    // MARK: - Custom Methods

    /* function to validate for required fields */
    func validate(){
        if !(userNameText.text!.isEmpty) && !(passwordText.text!.isEmpty) && (isChecked == true) {
            loginButton.enabled = true
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
    
    /* clear the values of the textfield when navigated back from Register or Need Help page */
    func clearButtonValues(){
        userNameText.text = ""
        passwordText.text = ""
        checkButton.setImage(UIImage(named:StringConstants.CHECK_BOX_UNSELECTED), forState: UIControlState.Normal)
        loginButton.enabled = false
        loginButton.backgroundColor = UIColor(red: 247.0/255.0, green: 249.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        loginButton.setTitleColor(UIColor.lightGrayColor(),forState: UIControlState.Normal)
    }
    
    func checkUserDetails() -> Bool{
        var tokenID : String
        var firstTimeLogin = true
        
        tokenID = ""
        
        if(tokenID.isEmpty){
            firstTimeLogin = true
        }
        else{
            firstTimeLogin = false
        }
        return firstTimeLogin
    }
    
    //MARK : Notification methods on Keyboard pop up
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
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
    
}
