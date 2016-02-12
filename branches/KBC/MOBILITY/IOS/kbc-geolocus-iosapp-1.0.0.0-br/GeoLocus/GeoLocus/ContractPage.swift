//
//  ContractPage.swift
//  GeoLocus
//
//  Created by Wearables Mac Mini on 08/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit

class ContractPage: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var imageViewBorder:CAShapeLayer!
    var imagePicker = UIImagePickerController()
    let bottomBorder = CALayer()
    
    @IBOutlet weak var layoutConstraintPlusImageLeading: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintBonusPointsTop: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintEcoPointsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintSpeedPointsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintBonusPointsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintPointsViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var speedPointsView: UIView!
    @IBOutlet weak var totalPointsLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var transparentView: UIView!
    
    //MARK: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraintsForDifferentDevices()
        customiseProgressView()
        addDashedBorderToImageView()
        addViewBorder()
        
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
        progressView.transform = CGAffineTransformScale(progressView.transform, 1, 10)
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
