//
//  ViewController.swift
//  EnrollmentApp
//
//  Created by Arpit Singh on 24/10/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var segemetMenu: SegmentControlView!
    @IBOutlet var collectionView: UICollectionView!
    let cellID = "ViewerCellID"
    lazy var sections: [UIView] = {
        let profilePage = ProfileDataSource()
        let formPage = FormPage().load()
        formPage.setTextFiledBorder()
        formPage.presentationController = self
        return [profilePage, formPage]
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ViewerCell.self, forCellWithReuseIdentifier: cellID)
        bindingSegementControl()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func bindingSegementControl() {
        segemetMenu.selectedMenuAction = { [weak self] index in
            guard let self = self else { return }
            self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        segemetMenu.menuSelected(index: Int(index))
    }
    
}

//MARK:- Data Source
extension ViewController:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ViewerCell
        cell.addChildView(view: sections[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
}
