//
//  RoundShadowView.swift
//  GB-Vkontakte
//
//  Created by Vitaly_Shishlyannikov on 28.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

final class RoundShadowVIew: UIImageView {
   
   var shadowColor: UIColor = .cyan
   var shadowOpacity: Float = 0.5
   var shadowRadius: CGFloat = 8
   var shadowOffset: CGSize = .zero
   
    var cornerRadius: CGFloat {
        return frame.width/2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setShadow(radius: cornerRadius)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setShadow(radius: cornerRadius)
    }
    
    override func prepareForInterfaceBuilder() {
        setShadow(radius: cornerRadius)
    }
    
    private func setShadow(radius: CGFloat) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
}
