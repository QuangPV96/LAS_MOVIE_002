//
//  PView.swift
//
//  Created by VancedPlayer on 8/9/18.
//

import UIKit

@IBDesignable
class PView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0

    @IBInspectable var isRoundConner: Bool = false
        {
            didSet {
                layer.cornerRadius = cornerRadius
                layer.masksToBounds = true
                setNeedsDisplay()
            }
        }
    
    @IBInspectable var cornerCircle: Bool = false {
        didSet {
            layer.cornerRadius = cornerCircle ? self.frame.size.height / 2 : 0
            layer.masksToBounds = cornerCircle
            setNeedsDisplay()
        }
    }
    @IBInspectable var topRound: Bool = false {
        didSet {
            if(topRound) {
                let maskPath1 = UIBezierPath(roundedRect: bounds,
                                             byRoundingCorners: [.topLeft , .topRight],
                                             cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
                let maskLayer1 = CAShapeLayer()
                maskLayer1.frame = bounds
                maskLayer1.path = maskPath1.cgPath
                layer.mask = maskLayer1
                setNeedsDisplay()
            }
          
        }
    }
    @IBInspectable var bottomRound: Bool = false {
        didSet {
            if(bottomRound) {
                let maskPath1 = UIBezierPath(roundedRect: bounds,
                                             byRoundingCorners: [.bottomLeft , .bottomRight],
                                             cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
                let maskLayer1 = CAShapeLayer()
                maskLayer1.frame = bounds
                maskLayer1.path = maskPath1.cgPath
                layer.mask = maskLayer1
                setNeedsDisplay()
            }
          
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var colorOpacity: CGFloat = 0 {
        didSet {
            backgroundColor = backgroundColor?.withAlphaComponent(colorOpacity)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 3)
    @IBInspectable var isShadow: Bool = false {
        didSet {
            if isShadow {
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOpacity = 0.16
                self.layer.shadowRadius = 4.0
                self.layer.shadowOffset = shadowOffset
                //self.layer.shouldRasterize = true
            }
            setNeedsDisplay()
        }
    }
}







