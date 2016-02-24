//
//  ShareView.swift
//  GeoLocus
//
//  Created by CTS MAC on 15/02/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import Foundation
import UIKit

public class ShareTemplate {
    
    public enum ShareOption: Int {
        case NONE
        case TRIP_DETAIL
        case BADGES
    }
    
    func createShareTemplateImage(title: String, detail: String, imageInfo: Dictionary<String, String>, shareOption: ShareOption, complitionHandler:(image: UIImage)->Void)-> Void{
        
        let drawingRect = CGRectMake(0, 0, 485, 192)
        
        //---------------title text--------------------
        let titleFont                   = UIFont(name:Font.HELVETICA_NEUE_MEDIUM, size: 16)
        let titleParagraphStyle         = NSMutableParagraphStyle()
        titleParagraphStyle.alignment   = .Left
        let titleAttr                   = [NSFontAttributeName: titleFont!, NSParagraphStyleAttributeName: titleParagraphStyle, NSForegroundColorAttributeName:UIColor(netHex: 0x003665)]
        let titleText:String            =  title
        
        //-------------para text------------------
        let paraFont                    = UIFont(name: Font.HELVETICA_NEUE, size: 15)
        let paragraphStyle              = NSMutableParagraphStyle()
        paragraphStyle.alignment        = .Left
        let paraAttr                    = [NSFontAttributeName: paraFont!, NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName:UIColor(netHex: 0x181f29)]
        let paraText:String             = detail
        
        //-------------info text------------------
        let infoFont                    = UIFont(name: Font.HELVETICA_NEUE, size: 12)
        let infoParagraphStyle          = NSMutableParagraphStyle()
        infoParagraphStyle.alignment    = .Left
        let infoAttr                    = [NSFontAttributeName: infoFont!, NSParagraphStyleAttributeName: infoParagraphStyle, NSForegroundColorAttributeName:UIColor(netHex: 0x4c7394)]
        let infoText:String             = "Pssst...you can track your driving behaviour using the KBC 10,000 KM app! You can download it from the app store."
        
        //--------start context ----------
        UIGraphicsBeginImageContextWithOptions(drawingRect.size, false, 5.0)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, drawingRect)
        
        //--------- image -------
        switch shareOption {
        case ShareOption.TRIP_DETAIL:
            let scoreViewFrame = CGRectMake(0, 0, 78, 78)
            
            //--------speed score---------
            let speedScoreRect = CGRectMake(12, 65, 78, 78)
            
            let speedArcView = ArcGraphicsController(frame: scoreViewFrame)
            speedArcView.foreGroundArcWidth = 8
            speedArcView.backGroundArcWidth = 8
            speedArcView.ringLayer.strokeColor = UIColor(range: Int(imageInfo["speedScore"]!)!).CGColor
            speedArcView.animateScale = Double(imageInfo["speedScore"]!)!/100.0
            speedArcView.backgroundColor = UIColor.whiteColor()
            speedArcView.setNeedsDisplay()
            let speedImage = getImage(speedArcView)
            speedImage.drawInRect(speedScoreRect)
            
            let speedIcon = UIImage(named: "meter.png")            
            let speedIconRect = CGRectMake(12 + 20, 65 + 23, 38, 33)
            speedIcon!.drawInRect(speedIconRect)
            
            let speedTitleFont                   = UIFont(name:Font.HELVETICA_NEUE, size: 15)
            let speedTtileParaStyle         = NSMutableParagraphStyle()
            speedTtileParaStyle.alignment   = .Center
            let speedTitleAttr                   = [NSFontAttributeName: speedTitleFont!, NSParagraphStyleAttributeName: speedTtileParaStyle, NSForegroundColorAttributeName:UIColor(netHex: 0x181f29)]
            let speedTitleText:String            =  "Speeding"
            
            let speedTitleRect = CGRectMake(12, 145, 78, 21)
            speedTitleText.drawWithRect(speedTitleRect, options: .UsesLineFragmentOrigin, attributes: speedTitleAttr, context: nil)
            
            //--------eco score---------
            let ecoArcView = ArcGraphicsController(frame: scoreViewFrame)
            ecoArcView.foreGroundArcWidth = 8
            ecoArcView.backGroundArcWidth = 8
            ecoArcView.ringLayer.strokeColor = UIColor(range: Int(imageInfo["ecoScore"]!)!).CGColor
            ecoArcView.animateScale = Double(imageInfo["ecoScore"]!)!/100.0
            ecoArcView.backgroundColor = UIColor.whiteColor()
            ecoArcView.setNeedsDisplay()
            let ecoImage = getImage(ecoArcView)
            let ecoScoreRect = CGRectMake(speedScoreRect.size.width + 12 + 12, speedScoreRect.origin.y, speedScoreRect.size.width, speedScoreRect.size.height)
            ecoImage.drawInRect(ecoScoreRect)
            
            let ecoIcon = UIImage(named: "Eco.png")
            let ecoIconRect = CGRectMake(speedScoreRect.size.width + 12 + 12 + 22, 65 + 21, 33, 35)
            ecoIcon!.drawInRect(ecoIconRect)
            
            let ecoTitleFont                   = UIFont(name:Font.HELVETICA_NEUE, size: 15)
            let ecoTtileParaStyle         = NSMutableParagraphStyle()
            ecoTtileParaStyle.alignment   = .Center
            let ecoTitleAttr                   = [NSFontAttributeName: ecoTitleFont!, NSParagraphStyleAttributeName: ecoTtileParaStyle, NSForegroundColorAttributeName:UIColor(netHex: 0x181f29)]
            let ecoTitleText:String            =  "Eco"
            
            let ecoTitleRect = CGRectMake(speedScoreRect.size.width + 12 + 12, 145, 78, 21)
            ecoTitleText.drawWithRect(ecoTitleRect, options: .UsesLineFragmentOrigin, attributes: ecoTitleAttr, context: nil)
            
        case ShareOption.BADGES:
            let iconImage = UIImage(named: imageInfo["icon"]!)
            let imageRect = CGRectMake(18, 18, 156, 156)
            iconImage!.drawInRect(imageRect)
        default:
            print("none")
        }
        
        //-------separator line vertical--------
        CGContextSetFillColorWithColor(context, UIColor(netHex: 0x4c7394).CGColor)
        CGContextFillRect(context, CGRectMake(192, 19, 1, 161))
        
        //--------KBC Icon -------------
        let kbcIcon = UIImage(named: "KBCIcon.png")
        let kbcIconRect = CGRectMake(440, 5, 35, 32)
        kbcIcon!.drawInRect(kbcIconRect)
        
        //----------drawing text-------------
        let titleTextRect = CGRectMake(204, 19, 269, 21)
        titleText.drawWithRect(titleTextRect, options: .UsesLineFragmentOrigin, attributes: titleAttr, context: nil)
        let paraHeight = CGFloat((shareOption == ShareOption.TRIP_DETAIL) ? 75.0 : 60.0)
        let paraTextRect = CGRectMake(204, titleTextRect.origin.y + titleTextRect.size.height + 8, 269, paraHeight)
        paraText.drawWithRect(paraTextRect, options: .UsesLineFragmentOrigin, attributes: paraAttr, context: nil)
        
        let infoTextRect = CGRectMake(204, paraTextRect.origin.y + paraTextRect.size.height + 5, 269, 80)
        infoText.drawWithRect(infoTextRect, options: .UsesLineFragmentOrigin, attributes: infoAttr, context: nil)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext()
        
        complitionHandler(image: image)
    }
    
    func getImage(view: UIView) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image
    }
}