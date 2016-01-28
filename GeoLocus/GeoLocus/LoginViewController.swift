//
//  LoginViewController.swift
//  GeoLocus
//
//  Created by Saranya on 20/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var isChecked = false
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    /* Register Now button action */
    @IBAction func registerNowButtonTapped(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:"http://www.google.com")!)
    }
    
    /* Need help button action */
    @IBAction func needHelpButtonTapped(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:"http://www.google.com")!)
    }
    
    /* Sign In button action */
    @IBAction func signInButtonTapped(sender: AnyObject) {
        
    }
    
    /* Check box button action */
    @IBAction func checkButtonTapped(sender: AnyObject) {
        if(isChecked){
            [checkButton.setImage(UIImage(named:"Selected.png"), forState: UIControlState.Selected)]
        }
        else{
            [checkButton.setImage(UIImage(named:"Unselected.png"), forState: UIControlState.Normal)]
        }
        isChecked = true
        
        validate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /* function to validate for required fields */
    func validate(){
        if !(userNameText.text!.isEmpty) && !(passwordText.text!.isEmpty) && (checkButton.enabled == true) {
            // if(validateEmailAddress(userNameText.text!)){
            signInButton.enabled = true
            // }
        }
    }
    
    /* function to validate for valid email address */
    func validateEmailAddress(emailString:String) -> Bool{
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(emailString)
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
}
