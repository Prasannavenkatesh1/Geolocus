//Created by Insurance H3 Team
//
//GeoLocus App
//
import UIKit

class Drawings: UIView {
    
    override func drawRect(rect: CGRect)
    {
        //Context
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1.0)
        CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
        
        let context1 = UIGraphicsGetCurrentContext()
        
        let context2 = UIGraphicsGetCurrentContext()
        
        let contextBox = UIGraphicsGetCurrentContext()
        let contextBox1 = UIGraphicsGetCurrentContext()
        let contextBox2 = UIGraphicsGetCurrentContext()
        
        //Draw Rectangle
        let rectangle = CGRectMake(10, 60, 35, 70)
        CGContextAddRect(context, rectangle)
        
        let box = CGRectMake(10, 130, 35, 2)
        CGContextAddRect(contextBox, box)
        
        let rectangle1 = CGRectMake(48, 35, 35, 95)
        CGContextAddRect(context1, rectangle1)
        
        let box1 = CGRectMake(48, 130, 35, 2)
        CGContextAddRect(contextBox1, box1)
        
        let rectangle2 = CGRectMake(86, 45, 35, 85)
        CGContextAddRect(context2, rectangle2)
        
        let box2 = CGRectMake(86, 130, 35, 2)
        CGContextAddRect(contextBox2, box2)
        
        
        //Inner Color Fill
        CGContextSetFillColorWithColor(context, UIColor.greenColor().CGColor)
        CGContextFillRect(context, rectangle)
        
        CGContextSetFillColorWithColor(contextBox, UIColor.whiteColor().CGColor)
        CGContextFillRect(contextBox, box)

        
        CGContextSetFillColorWithColor(context1, UIColor.redColor().CGColor)
        CGContextFillRect(context1, rectangle1)
        
        CGContextSetFillColorWithColor(contextBox1, UIColor.whiteColor().CGColor)
        CGContextFillRect(contextBox1, box1)
        
        CGContextSetFillColorWithColor(context2, UIColor.purpleColor().CGColor)
        CGContextFillRect(context2, rectangle2)
        
        CGContextSetFillColorWithColor(contextBox2, UIColor.whiteColor().CGColor)
        CGContextFillRect(contextBox2, box2)
        
    }
    
    
    

}
