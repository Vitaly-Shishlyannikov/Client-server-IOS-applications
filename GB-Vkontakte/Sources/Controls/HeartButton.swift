//
//  HeartButton.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 28.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

class HeartButton: UIButton {
    
    @IBInspectable var filled: Bool = true
    @IBInspectable var strokeWidth: CGFloat = 2.0
    @IBInspectable var strokeColor: UIColor = UIColor.gray
    
    var liked: Bool = false
    
    override func draw(_ rect: CGRect) {
        let bezFig = drawHeart(heartHeight: self.bounds.height)
        
        if !liked {
            strokeColor = UIColor.gray
            self.strokeColor.setStroke()
            self.filled = false
        } else {
            strokeColor = UIColor.red
            self.tintColor = UIColor.red
            self.strokeColor.setStroke()
            self.tintColor.setFill()
            bezFig.fill()
        }
        bezFig.lineWidth = self.strokeWidth
        bezFig.stroke()
    }
    
   func drawHeart(heartHeight rectHeight: CGFloat) -> UIBezierPath {
    
        let heart = UIBezierPath()
    
        //Calculate Radius of Arcs using Pythagoras
        let sideOne = rectHeight * 0.4
        let sideTwo = rectHeight * 0.3
        let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/2
        
        //Left Hand Curve
        heart.addArc(withCenter: CGPoint(x: rectHeight * 0.3, y: rectHeight * 0.35), radius: arcRadius, startAngle: 135.degreesToRadians, endAngle: 315.degreesToRadians, clockwise: true)
        
        //Right Hand Curve
        heart.addArc(withCenter: CGPoint(x: rectHeight * 0.7, y: rectHeight * 0.35), radius: arcRadius, startAngle: 225.degreesToRadians, endAngle: 45.degreesToRadians, clockwise: true)
        
        //Right Bottom Line
        heart.addLine(to: CGPoint(x: rectHeight * 0.5, y: rectHeight * 0.95))
        
        //Left Bottom Line
        heart.close()
    
        return heart
    }
}

