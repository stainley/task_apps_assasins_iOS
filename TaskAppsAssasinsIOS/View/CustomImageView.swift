//
//  CustomImageView.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-15.
//

import UIKit

@IBDesignable
class CustomImageView: UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerCurve = .continuous
            
        }
    }
}
