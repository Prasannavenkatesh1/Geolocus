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
    
    let myImageName = "ContractImage.png"
    var imagePath = String()

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
    @IBOutlet weak var contractView: UIView!
    
    @IBOutlet weak var noContractLabel: UILabel!
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
            
        imagePath = fileInDocumentsDirectory(myImageName)
        
        self.setTitleForLabels()
        self.setConstraintsForDifferentDevices()
        self.customiseProgressView()
        self.addDashedBorderToImageView()
        self.addViewBorder()
        self.loadImageInView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        self.imageView.userInteractionEnabled = true
        self.imageView.addGestureRecognizer(tapGestureRecognizer)
    }
  
    override func viewWillAppear(animated: Bool) {
        self.fetchContractDataFromDatabase()
    }
    
    override func viewWillLayoutSubviews() {
        self.imageViewBorder.path = UIBezierPath(roundedRect: self.imageView.bounds, cornerRadius:2).CGPath
        self.imageViewBorder.frame = self.imageView.bounds
        bottomBorder.frame = CGRect(x: self.speedPointsView.bounds.origin.x, y: self.speedPointsView.bounds.height, width: self.speedPointsView.bounds.width , height: 1.0)
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
        self.noContractLabel.text = LocalizationConstants.No_Contract.localized()
    }
    
    /*set constraints for different device screen size */
    func setConstraintsForDifferentDevices(){
        if(StringConstants.SCREEN_HEIGHT < Resolution.height.iPhone5){
            self.layoutConstraintBonusPointsTop.constant = 10
            self.layoutConstraintEcoPointsViewHeight.constant = 35
            self.layoutConstraintSpeedPointsViewHeight.constant = 35
            self.layoutConstraintBonusPointsViewHeight.constant = 40
            self.layoutConstraintPointsViewHeight.constant = 70
            self.layoutConstraintPlusImageLeading.constant = 15
        }
        if(StringConstants.SCREEN_HEIGHT == Resolution.height.iPhone5){
            self.layoutConstraintEcoPointsViewHeight.constant = 55
            self.layoutConstraintSpeedPointsViewHeight.constant = 55
            self.layoutConstraintPointsViewHeight.constant = 110
            self.layoutConstraintPlusImageLeading.constant = 15
        }
    }
    
    /* customize progress view */
    func customiseProgressView(){
        self.progressView.transform = CGAffineTransformScale(progressView.transform, 1, 5)
        
    }
    
    /* load image in the view */
    func loadImageInView(){
        if let loadedImage = loadImageFromPath(imagePath) {
            self.imageView.image = loadedImage
            self.hideImageViewBorder()
        }
        else {
            print("Error in loading image")
        }
    }
    
    /* get documents path where the image is stored */
    func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    /* get name of the file from the Documents Directory */
    func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
    }
    
    /* save the image in png format and writing to the documents directory with a file name */
    func saveImage (image: UIImage, path: String ) -> Bool{
        let pngImageData = UIImagePNGRepresentation(image)
        let result = pngImageData!.writeToFile(path, atomically: true)
        return result
    }
    
    /* load image from the documents directory */
    func loadImageFromPath(path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            print("Missing image at: \(path)")
        }
        return image
    }
    
    /* hides imageview border, camera icon and label if image is present in the imageview */
    func hideImageViewBorder(){
        self.imageViewBorder.strokeColor = UIColor.clearColor().CGColor
        self.messageLabel.hidden = true
        self.cameraButton.hidden = true
        self.transparentView.hidden = false
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
        self.imageViewBorder = CAShapeLayer()
        
        self.imageViewBorder.strokeColor = UIColor(red: 76.0/255.0, green: 115.0/255.0, blue: 148.0/255.0, alpha: 1.0).CGColor
        self.imageViewBorder.fillColor = nil
        self.imageViewBorder.lineDashPattern = [6, 6]
        self.imageView.layer.addSublayer(imageViewBorder)
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
                
                if(self.contractPointsAchieved == "" && self.totalContractPoints == ""){
                    self.contractView.hidden = false
                }
                
                self.speedPointsLabel.text = contractData.speedPoints
                self.totalContractPointsLabel.text = self.totalContractPoints
                self.ecoPointsLabel.text = contractData.ecoPoints
                self.contractPointsAchievedLabel.text = self.contractPointsAchieved
                self.bonusPointsLabel.text = contractData.bonusPoints
                
                let contractAchievedDate = contractData.contractAchievedDate
                
                let contractAchievedMessage = String(format: LocalizationConstants.CONTRACT_POINTS_ACHIEVED_MESSAGE.localized(), contractAchievedDate)
                let pointsAchieved = (self.contractPointsAchieved as NSString).floatValue
                let totalPoints = (self.totalContractPoints as NSString).floatValue
                let progressValue = (pointsAchieved/totalPoints)
                
                if !(isnan(progressValue)){
                    self.progressView.setProgress(progressValue, animated: true)
                    
                    if (pointsAchieved == totalPoints){
                        let alertView = UIAlertController(title: "", message: contractAchievedMessage, preferredStyle: UIAlertControllerStyle.Alert)
                        alertView.addAction(UIAlertAction(title: LocalizationConstants.Ok_title.localized(), style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertView, animated: true, completion: nil)
                    }
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
        self.imageView.image = resizeImage(image, imageSize: CGSizeMake(self.imageView.bounds.width, self.imageView.bounds.height))
        
        // Save image to Document directory
        if let image = imageView.image {
            saveImage(image, path: imagePath)
        }
        else {
            print("Error in saving image..")
        }
        
        self.hideImageViewBorder()
    }
}
