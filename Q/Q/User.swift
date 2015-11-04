//
//  User.swift
//  FInalProject
//
//  Created by Guillermo on 11/4/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import Foundation
import MapKit

struct User {
    
    let username: String
    let password: String
    let type: UserType
    var location: CLLocation?
    
    init(username: String, password: String, type: UserType, location: CLLocation?) {
        self.username = username
        self.password = password
        self.type = type
        self.location = location
    }
    
    init(username: String, password: String, type: UserType) {
        self.username = username
        self.password = password
        self.type = type
        self.location = nil
    }
}

enum UserType {
    case Professor, Student
}