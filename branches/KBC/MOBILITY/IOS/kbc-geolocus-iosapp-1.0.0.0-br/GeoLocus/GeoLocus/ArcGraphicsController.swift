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
    
   
    @IBInspectable var ringBackgroundColour: UIColor = UIColor.grayColor()
    @IBInspectable var ringForegroundColour: UIColor = UIColor.greenColor()
    @IBInspectable var backgroundImage: UIImage?
    @IBInspectable var lowLevelColor: UIColor = UIColor.redColor()
    @IBInspectable var midLevelColor: UIColor = UIColor.orangeColor()
    @IBInspectable var highLevelColor: UIColor = UIColor.greenColor()
    @IBInspectable var foreGroundArcWidth: CGFloat = 20
    @IBInspectable var backGroundArcWidth: CGFloat = 5
   
    let ringLayer = CAShapeLayer()
    let imageView = UIImageView()



    
    override func drawRect(rect: CGRect) {
       
 
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        backgroundArc()
        drawCenterImage()
        
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width - 20, bounds.height - 20)
        
        let startAngle: CGFloat = 2 * π / 3
        let endAngle: CGFloat = 5 * π / 3
        
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius/2 - foreGroundArcWidth/2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        ringLayer.path = path.CGPath
        ringLayer.strokeColor = ringForegroundColour.CGColor
        ringLayer.fillColor = UIColor.clearColor().CGColor
        ringLayer.lineWidth = foreGroundArcWidth
        ringLayer.strokeEnd = 0.0
        layer.addSublayer(ringLayer)
        animateArc(56.0)
        
    }
    
    private func backgroundArc() {
        
        backGroundArcWidth = 5
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width - 45, bounds.height - 45)
        
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
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 2
        animation.fromValue = 0
        animation.toValue = 1.0
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
