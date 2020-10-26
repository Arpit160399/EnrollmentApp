//
//  Anchor.swift
//  EnrollmentApp
//
//  Created by Arpit Singh on 26/10/20.
//

import UIKit

// MARK: - Image downloading

let imageCahce = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func loadImagesIntoCaches(url: String) {
        self.image = UIImage(named: "placeholder")
        if let cacheImage = imageCahce.object(forKey: url as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }
        guard let url = URL(string: url) else {
            return
        }
        let data = URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                    if let downloadData = UIImage(data: data!) {
                    imageCahce.setObject(downloadData, forKey: url as AnyObject)
                    self.image = downloadData
                }
            }
        }
        data.resume()
    }
}

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
