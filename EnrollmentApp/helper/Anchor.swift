//
//  Anchor.swift
//  EnrollmentApp
//
//  Created by Arpit Singh on 26/10/20.
//

import UIKit



// MARK: - anchor

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, size: CGSize = .zero, padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: padding.left).isActive = true
        }
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: padding.right).isActive = true
        }
        if size.width > 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height > 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }

    func DPI(size: CGFloat) -> CGFloat {
        return (size / 320) * UIScreen.main.bounds.width
    }
}
