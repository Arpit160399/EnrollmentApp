//
//  ProfileDataSource.swift
//  EnrollmentApp
//
//  Created by Arpit Singh on 26/10/20.
//

import UIKit
import Firebase

class ProfileDataSource: UIView{
    
    let tableView = UITableView(frame: .zero)
    let cellID = "ProfileCell"
    var profile: [UserModel] = []
    lazy var message = ErrorMessage(parent: self, type: .normal)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTableView()
        fetchUserData()
    }

    fileprivate func setUpTableView() {
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        addSubview(tableView)
        tableView.backgroundColor = UIColor(named: "SecondaryColor")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: cellID)
        tableView.rowHeight = UITableView.automaticDimension
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK:- FireBase Actions
extension ProfileDataSource {
    
    fileprivate func fetchUserData(){
        let users =  Database.database().reference().child("users")
        users.observe(.value) { (spanshot) in
            self.profile = []
            for child in spanshot.children {
                guard let span = child as? DataSnapshot else {
                    return
                }
                if let dic = span.value as? [String: AnyObject] {
                    var model = UserModel(user: dic)
                    model.key = span.key
                    self.profile.append(model)
                }
            }
            
            self.profile = self.profile.sorted { (left, right) -> Bool in
                return left.creationTime.intValue > right.creationTime.intValue
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func deleteRef(_ key: String) {
        let userRef =  Database.database().reference().child("users").child(key)
        userRef.removeValue { (error, dataRef) in
            if error != nil {
                self.message.show(message: error.debugDescription, type: .error)
                return
            }
            self.message.show(message: "Profile deleted", type: .succes)
        }
    }
    
}

//MARK:- Data Source
extension ProfileDataSource: UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! ProfileCell
        cell.bindingdata(usedata: profile[indexPath.row])
        cell.deleteButton.addTarget(self, action: #selector(removeData(sender:)) , for: .touchUpInside)
        return cell
    }
    
    @objc  func removeData(sender: UIButton){
    var superview = sender.superview
    while let view = superview, !(superview is UITableViewCell) { superview = view.superview}
        guard let cell = superview as? UITableViewCell else {return}
        guard let indexPath = tableView.indexPath(for: cell) else{return}
        guard let key = profile[indexPath.row].key else {return}
        deleteRef(key)
    }
    
}
