//
//  User.swift
//  FInalProject
//
//  Created by Guillermo on 11/18/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import Foundation
import Parse
//import MapKit

class Visit {
    
    var user:PFUser
    var lastName:String
    var firstName:String
    var reason:String?
//    var location:CLLocation?
    
    init(user:PFUser, lastName:String, firstName:String, reason:String?) {
        self.user = user
        self.lastName = lastName
        self.firstName = firstName
        self.reason = reason
    }
    
}