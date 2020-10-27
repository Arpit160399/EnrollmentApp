//
//  SegmentCell.swift
//  EnrollmentApp
//
//  Created by Arpit Singh on 27/10/20.
//

import UIKit

class cellView: UICollectionViewCell {
   
   let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    override var isSelected: Bool {
        didSet {
            textLabel.textColor = isSelected ? UIColor(named: "primaryColor") : .secondaryLabel
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
