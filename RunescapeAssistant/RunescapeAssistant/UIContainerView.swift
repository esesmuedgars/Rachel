//
//  UIContainerView.swift
//  RunescapeAssistant
//
//  Created by Edgars Vanags on 01/06/2018.
//  Copyright © 2018 Edgars Vanags. All rights reserved.
//

import UIKit

class UIContainerView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: -5, height: 5)
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: CGRect(origin: bounds.origin, size: CGSize(width: bounds.width + 10, height: bounds.height)), cornerRadius: 0).cgPath
    }
}
