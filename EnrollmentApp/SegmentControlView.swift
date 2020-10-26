//
//  SegmentControlView.swift
//  EnrollmentApp
//
//  Created by Arpit Singh on 25/10/20.
//

import UIKit

class SegmentControlView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "primaryColor")
        return view
    }()

    var item = ["User", "Enoll"]
    var cellID = "cellID"
    var selectedMenuAnchor: NSLayoutConstraint?
    var selectedMenuAction: (Int) -> () = { _ in
    }
    
    fileprivate func addedSegementView() {
        addSubview(collectionView)
        addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        selectedMenuAnchor = lineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
        
        selectedMenuAnchor?.isActive = true
        NSLayoutConstraint.activate([
            lineView.widthAnchor.constraint(equalToConstant: frame.width / 2),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 2),
            lineView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.layoutIfNeeded()
        lineView.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addedSegementView()
        collectionView.backgroundColor = .white
        collectionView.register(cellView.self, forCellWithReuseIdentifier: cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
//        fatalError("init(coder:) has not been implemented")
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.count
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! cellView
        cell.textLabel.text = item[indexPath.row]
        return cell
    }
    
    fileprivate func animatedBar(index: Int) {
        let offSet = (CGFloat(index) * (frame.width / 2))
        selectedMenuAnchor?.isActive = false
        selectedMenuAnchor?.constant = offSet
        selectedMenuAnchor?.isActive = true
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func menuSelected(index: Int) {
        collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        animatedBar(index: index)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        animatedBar(index: indexPath.row)
        selectedMenuAction(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: frame.width / 2 - 5, height: 48)
    }
}

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
