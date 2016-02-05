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
        customiseProgressView()
        addDashedBorderToImageView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillLayoutSubviews() {
        imageViewBorder.path = UIBezierPath(roundedRect: imageView.bounds, cornerRadius:2).CGPath
        imageViewBorder.frame = imageView.bounds
    }
    
    //MARK: Custom Methods
    
    /* customize progress view */
    func customiseProgressView(){
        progressView.transform = CGAffineTransformScale(progressView.transform, 1, 10)
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
    
    //MARK : Image Picker Delegate Methods
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        imageView.image = image
        imageViewBorder.strokeColor = UIColor.clearColor().CGColor
        messageLabel.hidden = true
        cameraButton.hidden = true
        transparentView.hidden = false
    }
}
