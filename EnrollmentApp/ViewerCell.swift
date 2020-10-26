//
//  ViewerCell.swift
//  EnrollmentApp
//
//  Created by Arpit Singh on 25/10/20.
//

import UIKit

class ViewerCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addChildView(view: UIView) {
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        ])
    }
}
