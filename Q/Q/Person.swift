//
//  User.swift
//  FInalProject
//
//  Created by Guillermo on 11/18/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import Foundation
import MapKit

class Person {
    
    var lastName:String
    var firstName:String
    var userName:String
    var location:CLLocation?
    
    init(lastName:String, firstName:String, userName: String) {
        self.lastName = lastName
        self.firstName = firstName
        self.userName = userName
    }
}