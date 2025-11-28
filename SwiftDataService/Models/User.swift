//
//  User.swift
//  SwiftDataService
//
//  Created by Fabio Dantas on 27/11/2025.
//

import Foundation
import SwiftData

@Model
class User: Identifiable {
    @Attribute(.unique) var _id : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var age: Int = 0
    var profilePicture : String = ""
    
    init(_id: String = UUID().uuidString, firstName: String, lastName: String, age: Int, profilePicture: String = "") {
        self._id = _id
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.profilePicture = profilePicture
    }
}
