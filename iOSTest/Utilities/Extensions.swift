//
//  Extensions.swift
//  iOSTest
//
//  Created by MacBook Pro on 29/04/24.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadiusValue: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
