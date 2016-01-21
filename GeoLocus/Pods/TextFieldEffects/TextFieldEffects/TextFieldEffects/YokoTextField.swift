//
//  YokoTextField.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 30/01/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

/**
 A YokoTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable 3D visual effect on the background of the control.
 */
@IBDesignable public class YokoTextField: TextFieldEffects {
    
    /**
     The color of the placeholder text.
     
     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    @IBInspectable dynamic public var placeholderColor: UIColor? {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The scale of the placeholder font.
     
     This property determines the size of the placeholder label relative to the font size of the text field.
     */
    @IBInspectable dynamic public var placeholderFontScale: CGFloat = 0.7 {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The view’s foreground color.
     
     The default value for this property is a clear color.
     */
    @IBInspectable dynamic public var foregroundColor: UIColor = UIColor.blackColor() {
        didSet {
            updateForeground()
        }
    }
    
    override public var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override public var bounds: CGRect {
        didSet {
            updateForeground()
            updatePlaceholder()
        }
    }
    
    private let foregroundView = UIView()
    private let foregroundLayer = CALayer()
    private let borderThickness: CGFloat = 3
    private let placeholderInsets = CGPoint(x: 6, y: 6)
    private let textFieldInsets = CGPoint(x: 6, y: 6)
    
    // MARK: - TextFieldsEffects
    
    override public func drawViewsForRect(rect: CGRect) {
        updateForeground()
        updatePlaceholder()
        
        addSubview(foregroundView)
        addSubview(placeholderLabel)
        layer.addSublayer(foregroundLayer)        
    }
    
    override public func animateViewsForTextEntry() {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.6, options: .BeginFromCurrentState, animations: {
            
            self.foregroundView.layer.transform = CATransform3DIdentity
            
            }, completion: nil)
        
        foregroundLayer.frame = rectForBorder(foregroundView.frame, isFilled: false)
    }
    
    override public func animateViewsForTextDisplay() {
        if text!.isEmpty {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.6, options: .BeginFromCurrentState, animations: {
                
                self.foregroundLayer.frame = self.rectForBorder(self.foregroundView.frame, isFilled: true)
                self.foregroundView.layer.transform = self.rotationAndPerspectiveTransformForView(self.foregroundView)
                }, completion: nil)
        }
    }
    
    // MARK: - Private
    
    private func updateForeground() {
        foregroundView.frame = rectForForeground(frame)
        foregroundView.userInteractionEnabled = false
        foregroundView.layer.transform = rotationAndPerspectiveTransformForView(foregroundView)
        foregroundView.backgroundColor = foregroundColor
        
        foregroundLayer.borderWidth = borderThickness
        foregroundLayer.borderColor = colorWithBrightnessFactor(foregroundColor, factor: 0.8).CGColor
        foregroundLayer.frame = rectForBorder(foregroundView.frame, isFilled: true)
    }
    
    private func updatePlaceholder() {
        placeholderLabel.font = placeholderFontFromFont(font!)
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder() || text!.isNotEmpty {
            animateViewsForTextEntry()
        }
    }
    
    private func placeholderFontFromFont(font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }
    
    private func rectForForeground(bounds: CGRect) -> CGRect {
        let newRect = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height - font!.lineHeight + textFieldInsets.y - borderThickness)
        
        return newRect
    }
    
    private func rectForBorder(bounds: CGRect, isFilled: Bool) -> CGRect {
        var newRect = CGRect(x: 0, y: bounds.size.height, width: bounds.size.width, height: isFilled ? borderThickness : 0)
        
        if !CATransform3DIsIdentity(foregroundView.layer.transform) {
            newRect.origin = CGPoint(x: 0, y: bounds.origin.y)
        }
        
        return newRect
    }
    
    private func layoutPlaceholderInTextRect() {
        let textRect = textRectForBounds(bounds)
        var originX = textRect.origin.x
        switch textAlignment {
        case .Center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .Right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        placeholderLabel.frame = CGRect(x: originX, y: bounds.height - placeholderLabel.frame.height,
            width: placeholderLabel.frame.size.width, height: placeholderLabel.frame.size.height)
    }
    
    // MARK: -
    
    private func setAnchorPoint(anchorPoint:CGPoint, forView view:UIView) {
        var newPoint:CGPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint:CGPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position = view.layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    private func colorWithBrightnessFactor(color: UIColor, factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        if color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return color;
        }
    }
    
    private func rotationAndPerspectiveTransformForView(view: UIView) -> CATransform3D {
        setAnchorPoint(CGPoint(x: 0.5, y: 1.0), forView:view)
        
        var rotationAndPerspectiveTransform = CATransform3DIdentity
        rotationAndPerspectiveTransform.m34 = 1.0/800
        let radians = ((-90) / 180.0 * CGFloat(M_PI))
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, radians, 1.0, 0.0, 0.0)
        return rotationAndPerspectiveTransform
    }
    
    // MARK: - Overrides
        
    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        let newBounds = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height - font!.lineHeight + textFieldInsets.y)
        return CGRectInset(newBounds, textFieldInsets.x, 0)
    }
    
    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        let newBounds = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height - font!.lineHeight + textFieldInsets.y)
        
        return CGRectInset(newBounds, textFieldInsets.x, 0)
    }
    
}
