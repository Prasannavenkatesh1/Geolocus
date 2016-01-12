//
//  arcProgressView.swift
//  GeoLocus
//
//  Created by macuser on 24/08/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

import Foundation
import UIKit

class arcProgressView : UIView {
    
    let arclayer = CAShapeLayer()
    let innerloader = CAShapeLayer()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()

        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: (frame.size.width / 2), y: (frame.size.height - 40)), radius: 90, startAngle: CGFloat(3 * (M_PI / 4.0)), endAngle: CGFloat(M_PI / 4.0), clockwise: true)
        
        let outerPath = UIBezierPath(arcCenter: CGPoint(x: (frame.size.width / 2), y: (frame.size.height - 40)), radius: 90, startAngle: CGFloat(3 * (M_PI / 4.0)), endAngle: CGFloat(M_PI / 4.0), clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        arclayer.path = circlePath.CGPath
        arclayer.fillColor = UIColor.clearColor().CGColor
        arclayer.strokeColor = UIColor.whiteColor().CGColor
        arclayer.lineWidth = 26.0;
        
        // Setup the Outer layer with the path, colors, and line width
        innerloader.path = outerPath.CGPath
        innerloader.fillColor = UIColor.clearColor().CGColor
        innerloader.strokeColor = UIColor.blueColor().CGColor
        innerloader.lineWidth = 27.0;
        
        //Draw the outer layer initially
        innerloader.strokeEnd = 0.0
        
        // Don't draw the circle initially
        arclayer.strokeStart = 0.0
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(arclayer)
        layer.addSublayer(innerloader)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        let viewController : ViewController = ViewController()
        super.init(coder: aDecoder)
    }
    
    
    func animateCircle(scoreValue : String) {
        
        var dbValue : UILabel?
        
        let screenSize = UIScreen.mainScreen().bounds.size
        let isiPhone6 = CGSizeEqualToSize(screenSize, CGSizeMake(375, 667))
        
        if (isiPhone6) {
            
            dbValue = UILabel(frame: CGRectMake(82, 100, 50, 50))
            
        } else {
            
            dbValue = UILabel(frame: CGRectMake(50, 80, 50, 50))
            
        }
        
        dbValue!.textAlignment = NSTextAlignment.Center
        dbValue!.text = scoreValue
        dbValue!.font = UIFont(name: "Digital-7", size: 50)
        dbValue!.textColor = UIColor.whiteColor()
        dbValue!.backgroundColor = UIColor.clearColor()
        self.addSubview(dbValue!)
        
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = 2
        
        //Calculate the value to be loaded
        let score = scoreValue as NSString
        print("The score is : \(score)")
        let param = score.doubleValue
        let loaderValue = param / 100
        print("The loaderValue is : \(loaderValue)")
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = loaderValue
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        innerloader.strokeEnd = CGFloat(loaderValue)
        
        // Do the actual animation
        innerloader.addAnimation(animation, forKey: "animateCircle")
    }
    
}

