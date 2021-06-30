//
//  UIView+CornerRadius.swift
//  Racing
//
//  Created by Pavel Akulenak on 20.05.21.
//

import UIKit

extension UIView {
    func applyCornerRadius(_ radius: CGFloat = 10) {
        clipsToBounds = true
        layer.cornerRadius = radius
    }

    func addShadow(color: UIColor, opacity: Float, offSet: CGSize, radius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }

    func addBorderWidth(_ width: CGFloat) {
        layer.borderWidth = width
    }
}
