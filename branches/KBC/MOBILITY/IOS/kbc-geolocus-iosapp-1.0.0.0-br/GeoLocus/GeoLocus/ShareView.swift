//
//  ShareView.swift
//  GeoLocus
//
//  Created by CTS MAC on 15/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation
import UIKit

class ShareTemplate {
    
    var shareimage: UIImage?
    
    func createShareTemplateImage(){
        
        let drawingRect = CGRectMake(0, 0, 485, 180)
        
        //image config
        let iconImage = UIImage(named: "king.png")
        let imageRect = CGRectMake(20, 20, 140, 140)
        
        //title text
        // select a font
        let titleFont = UIFont(name: "HelveticaNeue-Medium", size: 16)
        
        //paragraph
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .Left
        
        // setting attr: font name, color...etc.
        let titleAttr = [NSFontAttributeName: titleFont!, NSParagraphStyleAttributeName: titleParagraphStyle, NSForegroundColorAttributeName:UIColor.blueColor()]
        
        let titleText:NSString = "King of the City"
        // getting size
        //let sizeOfText = showText.sizeWithAttributes(titleAttr)
        
        
        //para text
        // select a font
        let font = UIFont(name: "HelveticaNeue", size: 15)
        
        //paragraph
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Left
        
        // setting attr: font name, color...etc.
        let attr = [NSFontAttributeName: font!, NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName:UIColor.blackColor()]
        
        let showText:NSString = "I travelled 500KM with in 50km/hr zone and just earned the King of the City Badge"
        // getting size
        //let sizeOfText = showText.sizeWithAttributes(attr)
        
        
        UIGraphicsBeginImageContextWithOptions(drawingRect.size, false, 20)
        
        //set color
        let context = UIGraphicsGetCurrentContext()
        
        //backgroung
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, drawingRect)
        
        //line vertical
        CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextFillRect(context, CGRectMake(180, 20, 1, 140))
        
        // drawing our image to the graphics context
        iconImage?.drawInRect(imageRect)
        // drawing text
        titleText.drawWithRect(CGRectMake(200, 25, 265, 20), options: .UsesLineFragmentOrigin, attributes: titleAttr, context: nil)
        
        showText.drawWithRect(CGRectMake(200, 50, 265, 80), options: .UsesLineFragmentOrigin, attributes: attr, context: nil)
        
        
        // getting an image from it
        self.shareimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        
    }
    
}