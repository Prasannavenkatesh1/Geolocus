//
//  ContractPage.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

/* This view loads the contract points for the user based on the values from the server */

class ContractPage: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    /* Variable Declarations */
    var imageViewBorder:CAShapeLayer!
    var imagePicker = UIImagePickerController()
    let bottomBorder = CALayer()
    var contractPointsAchieved = String()
    var totalContractPoints = String()
    
    /* Outlets for the constraints created in the view */
    @IBOutlet weak var layoutConstraintPlusImageLeading: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintBonusPointsTop: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintEcoPointsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintSpeedPointsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintBonusPointsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintPointsViewHeight: NSLayoutConstraint!
    
    /* Outlets for the label and other controls in the view */
    @IBOutlet weak var speedPointsView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var transparentView: UIView!
    
    @IBOutlet weak var contractPointsAchievedLabel: UILabel!
    @IBOutlet weak var totalContractPointsLabel: UILabel!
    @IBOutlet weak var bonusPointsLabel: UILabel!
    @IBOutlet weak var ecoPointsLabel: UILabel!
    @IBOutlet weak var speedPointsLabel: UILabel!
    @IBOutlet weak var yourGoalLabel: UILabel!
    
    @IBOutlet weak var bonusPointsTitleLabel: UILabel!
    @IBOutlet weak var ecoPointsTitleLabel: UILabel!
    @IBOutlet weak var speedPointsTitleLabel: UILabel!
    @IBOutlet weak var totalPointsTitleLabel: UILabel!
    //MARK: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FacadeLayer.sharedinstance.requestContractData{ (status, data, error) -> Void in
        }
        
        self.setTitleForLabels()
        self.fetchContractDataFromDatabase()
        self.setConstraintsForDifferentDevices()
        self.customiseProgressView()
        self.addDashedBorderToImageView()
        self.addViewBorder()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillLayoutSubviews() {
        imageViewBorder.path = UIBezierPath(roundedRect: imageView.bounds, cornerRadius:2).CGPath
        imageViewBorder.frame = imageView.bounds
        bottomBorder.frame = CGRect(x: speedPointsView.bounds.origin.x, y: speedPointsView.bounds.height, width: speedPointsView.bounds.width , height: 1.0)
    }
    
    //MARK: Custom Methods
    
    /* setting localized string for title of the labels */
    func setTitleForLabels(){
        self.yourGoalLabel.text = LocalizationConstants.YourGoal_Title.localized()
        self.messageLabel.text = LocalizationConstants.AddPicture_Title.localized()
        self.totalPointsTitleLabel.text = LocalizationConstants.TotalPoints_Title.localized()
        self.speedPointsTitleLabel.text = LocalizationConstants.SpeedPoints_Title.localized()
        self.ecoPointsTitleLabel.text = LocalizationConstants.EcoPoints_Title.localized()
        self.bonusPointsTitleLabel.text = LocalizationConstants.BonusPoints_Title.localized()
    }
    
    /*set constraints for different device screen size */
    func setConstraintsForDifferentDevices(){
        if(StringConstants.SCREEN_HEIGHT < 568){
            self.layoutConstraintBonusPointsTop.constant = 10
            self.layoutConstraintEcoPointsViewHeight.constant = 35
            self.layoutConstraintSpeedPointsViewHeight.constant = 35
            self.layoutConstraintBonusPointsViewHeight.constant = 40
            self.layoutConstraintPointsViewHeight.constant = 70
            self.layoutConstraintPlusImageLeading.constant = 15
        }
        if(StringConstants.SCREEN_HEIGHT == 568){
            self.layoutConstraintEcoPointsViewHeight.constant = 55
            self.layoutConstraintSpeedPointsViewHeight.constant = 55
            self.layoutConstraintPointsViewHeight.constant = 110
            self.layoutConstraintPlusImageLeading.constant = 15
        }
    }
    
    /* customize progress view */
    func customiseProgressView(){
        progressView.transform = CGAffineTransformScale(progressView.transform, 1, 5)
        
    }
    
    /* adding border between the points view */
    func addViewBorder(){
        bottomBorder.borderColor = UIColor(red: 163.0/255.0, green: 162.0/255.0, blue: 162.0/255.0, alpha: 1.0).CGColor
        bottomBorder.borderWidth = CGFloat(1.0)
        bottomBorder.opaque = true
        speedPointsView.layer.addSublayer(bottomBorder)
        speedPointsView.layer.masksToBounds = true
    }
    
    /* Adding Border to ImageView */
    func addDashedBorderToImageView(){
        imageViewBorder = CAShapeLayer()
        
        imageViewBorder.strokeColor = UIColor(red: 76.0/255.0, green: 115.0/255.0, blue: 148.0/255.0, alpha: 1.0).CGColor
        imageViewBorder.fillColor = nil
        imageViewBorder.lineDashPattern = [6, 6]
        imageView.layer.addSublayer(imageViewBorder)
    }
    
    /* image tapped action - open the device gallery */
    func imageTapped(img:AnyObject){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    /* resize image to fit the imageview */
    func resizeImage(image: UIImage, imageSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(imageSize)
        image.drawInRect(CGRectMake(0, 0, imageSize.width, imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /* fetch data from the database */
    func fetchContractDataFromDatabase(){
        FacadeLayer.sharedinstance.dbactions.fetchContractData{ (status, data, error) -> Void in
            if(status == 1 && error == nil) {
                let contractData : ContractModel = data!
                
                self.contractPointsAchieved = contractData.contractPointsAchieved
                self.totalContractPoints = contractData.totalContractPoints
                
                self.speedPointsLabel.text = contractData.speedPoints
                self.totalContractPointsLabel.text = self.totalContractPoints
                self.ecoPointsLabel.text = contractData.ecoPoints
                self.contractPointsAchievedLabel.text = self.contractPointsAchieved
                self.bonusPointsLabel.text = contractData.bonusPoints
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let contractAchievedDate = dateFormatter.dateFromString(contractData.contractAchievedDate)
                
                let contractAchievedMessage = contractAchievedDate != nil ? String(format: LocalizationConstants.CONTRACT_POINTS_ACHIEVED_MESSAGE.localized(), contractAchievedDate!) : ""
                let pointsAchieved = (self.contractPointsAchieved as NSString).floatValue
                let totalPoints = (self.totalContractPoints as NSString).floatValue
                let progressValue = (pointsAchieved/totalPoints)
                
                self.progressView.setProgress(progressValue, animated: true)
                
                if(pointsAchieved == totalPoints){
                    let alertView = UIAlertController(title: "", message: contractAchievedMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    alertView.addAction(UIAlertAction(title: LocalizationConstants.Ok_title.localized(), style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
            }
            else{
                print("Error is:\(error)")
            }
        }
    }
    
    //MARK : Image Picker Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion:nil)
        imageView.image = resizeImage(image, imageSize: CGSizeMake(imageView.bounds.width, imageView.bounds.height))
        imageViewBorder.strokeColor = UIColor.clearColor().CGColor
        messageLabel.hidden = true
        cameraButton.hidden = true
        transparentView.hidden = false
    }
}
