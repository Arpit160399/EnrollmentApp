//
//  ProfileCell.swift
//  EnrollmentApp
//
//  Created by Arpit Singh on 25/10/20.
//

import UIKit

class ProfileCell: UITableViewCell {
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var subtitleTextLabel: UILabel!
    @IBOutlet var titleTextLabel: UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.backgroundColor = UIColor(named: "SecondaryColor")
    }
    
    func countAge(date: String) -> String {
        let formate = DateFormatter()
        formate.dateStyle = .short
        guard let date = formate.date(from: date) else {
            return ""
        }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: date, to: Date())
        return String(ageComponents.year ?? 0)
    }
    
    func bindingdata(usedata: UserModel) {
        profileImage.loadImagesIntoCaches(url: usedata.profileImageUrl)
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.masksToBounds = false
        profileImage.clipsToBounds = true
        titleTextLabel.text = "\(usedata.firstName) \(usedata.LastName)"
        subtitleTextLabel.text = "\(usedata.gender) | \(countAge(date: usedata.DoB)) | \(usedata.state)"
    }
}
