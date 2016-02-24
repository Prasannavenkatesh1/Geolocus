//
//  ArcGraphicsController.swift
//  GeoLocus
//
//  Created by khan on 20/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation
import UIKit


let π: CGFloat = CGFloat(M_PI)

@IBDesignable class ArcGraphicsController: UIView {
    
   
    @IBInspectable var ringBackgroundColour: UIColor = UIColor(netHex: 0xaba8a8)
    @IBInspectable var ringForegroundColour: UIColor = UIColor.greenColor()
    @IBInspectable var backgroundImage: UIImage?
    @IBInspectable var lowLevelColor: UIColor = UIColor.redColor()
    @IBInspectable var midLevelColor: UIColor = UIColor.orangeColor()
    @IBInspectable var highLevelColor: UIColor = UIColor.greenColor()
    @IBInspectable var foreGroundArcWidth: CGFloat = 20
    @IBInspectable var backGroundArcWidth: CGFloat = 8
    @IBInspectable var isThumbImageAvailable: Bool = false
    
    var arcMargin: CGFloat = 0
    var animateScale = 0.0      //must be between [0,1]
    let ringLayer = CAShapeLayer()
    let thumbLayer = CALayer()
    let imageView = UIImageView()
    var thumbImage = UIImageView()
    var arcPath = UIBezierPath()

    
    override func drawRect(rect: CGRect) {
       
 
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        backgroundArc()
        drawCenterImage()
        
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width - arcMargin, bounds.height - arcMargin)
        
        let startAngle: CGFloat = 2 * π / 3
        let endAngle: CGFloat = π / 3
        
         arcPath = UIBezierPath(
            arcCenter: center,
            radius: radius/2 - backGroundArcWidth/2,                    //changed here
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        ringLayer.path = arcPath.CGPath
        //ringLayer.strokeColor = ringForegroundColour.CGColor
        ringLayer.fillColor = UIColor.clearColor().CGColor
        ringLayer.lineWidth = foreGroundArcWidth
        ringLayer.strokeEnd = 0.0
        layer.addSublayer(ringLayer)
        animateArc(CGFloat(self.animateScale))                //changed here
        
    }
    
    private func backgroundArc() {
        
        //backGroundArcWidth = 5
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width - arcMargin, bounds.height - arcMargin)
        
        let startAngle: CGFloat = 2 * π / 3
        let endAngle: CGFloat = π / 3
        
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius/2 - backGroundArcWidth/2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        path.lineWidth = backGroundArcWidth
        ringBackgroundColour.setStroke()
        path.stroke()
    }
    
    func animateArc(loaderValue: CGFloat) {
        
        if isThumbImageAvailable {
            
//            thumbImage.image = UIImage(named: "meter_tip")
//            thumbLayer.contents = thumbImage.image?.CGImage
//            thumbLayer.anchorPoint = CGPoint(x: 0.5,y: 0.5)
//            thumbLayer.frame = CGRectMake(0.0, 0.0, thumbImage.image!.size.width, thumbImage.image!.size.height)
//            
//            layer.addSublayer(thumbLayer)
//            
//            let pathAnimation: CAKeyframeAnimation  = CAKeyframeAnimation(keyPath: "position")
//            pathAnimation.duration = 2.0
//            pathAnimation.path = arcPath.CGPath;
//             pathAnimation.removedOnCompletion = false
//     
//            pathAnimation.calculationMode = kCAAnimationLinear
//            thumbLayer.addAnimation(pathAnimation, forKey: "movingMeterTip")
//            
//
//            
//            UIView.animateWithDuration(2.0, animations: { () -> Void in
//                self.thumbImage.transform = CGAffineTransformMakeRotation(CGFloat(0.25 * M_PI))
//            })
            
        }
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 2
        animation.fromValue = 0
        animation.toValue = loaderValue                //changed here
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        ringLayer.strokeEnd = loaderValue
        ringLayer.addAnimation(animation, forKey: "animateArc")
    }
    
    func drawCenterImage() {
        
        if let bgImage = backgroundImage {
            imageView.image = bgImage
        }
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
        
       
        constraints.append(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        constraints.append(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100))
        
          constraints.append(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100))
                NSLayoutConstraint.activateConstraints(constraints)
    }
    
}
