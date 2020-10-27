//
//  UserModel.swift
//  EnrollmentApp
//
//  Created by Arpit Singh on 26/10/20.
//

import Foundation

struct UserModel {
    var key: String?
    var firstName: String
    var LastName: String
    var phoneNumber: String
    var telPhone: String
    var DoB: String
    var state: String
    var profileImageUrl: String
    var country: String
    var gender: String
    var Home: String
    var creationTime: NSNumber
    
    init(firstName: String, LastName: String, phoneNumber: String, telPhone: String, DoB: String, state: String, profileImageUrl: String, country: String, gender: String, Home: String, creationTime: NSNumber) {
        self.firstName = firstName
        self.LastName = LastName
        self.phoneNumber = phoneNumber
        self.telPhone = telPhone
        self.DoB = DoB
        self.state = state
        self.profileImageUrl = profileImageUrl
        self.country = country
        self.gender = gender
        self.Home = Home
        self.creationTime = creationTime
    }
    
    init(user: [String: Any]) {
        firstName = user["firstName"] as? String ?? ""
        LastName = user["LastName"] as? String ?? ""
        phoneNumber = user[" phoneNumber"] as? String ?? ""
        DoB = user["DoB"] as? String ?? ""
        profileImageUrl = user["profileImageUrl"] as? String ?? ""
        country = user["country"] as? String ?? ""
        gender = user["gender"] as? String ?? ""
        Home = user["Home"] as? String ?? ""
        state = user["state"] as? String ?? ""
        telPhone = user["telPhone"] as? String ?? ""
        creationTime = user["creationTime"] as? NSNumber ?? NSNumber(0)
    }
    
    func mapdata() -> [String: Any] {
        return ["firstName": firstName,
                "LastName": LastName,
                "phoneNumber": phoneNumber,
                "telPhone": telPhone,
                "DoB": DoB,
                "state": state,
                "profileImageUrl": profileImageUrl,
                "country": country,
                "gender": gender,
                "Home": Home,
                "creationTime": creationTime]
    }
}
