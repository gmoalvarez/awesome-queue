//
//  ParseUtility.swift
//  FInalProject
//
//  Created by Guillermo on 11/19/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//  A variety of utility methods that we can use throughout the app

import Foundation
import UIKit
import Parse

class ParseUtility {
    
    static func userNamesOfQueueWithObjectId(objectId: String) -> [String]? {
        let query = PFQuery(className: "Queue").whereKey("objectId", equalTo: objectId).includeKey("waitlist")
        var userNames:[String]?
        
        query.findObjectsInBackgroundWithBlock { queueWaitlist, error  in
            
            guard error == nil else {
                print(error)
                return
            }
            
            guard let selectedQueue = queueWaitlist?.first else {
                print("Could not get queue for some reason")
                return
            }
            
            guard let waitlist = selectedQueue["waitlist"] as? [String] else {
                print("Could not get waitlist from selected queue")
                return
            }
            
            userNames = waitlist
        }
        
        return userNames
    }
    
    static func getPeopleWithUsernames(usernames: [String]) -> [Person]? {
        var userList = [Person]()
        
        for username in usernames {
            
            let userQuery = PFUser.query()?.whereKey("username", equalTo: username)
            userQuery?.findObjectsInBackgroundWithBlock { user, error in
                
                guard error == nil else {
                    print(error)
                    return
                }
                
                guard let user = user?.first else {
                    print("User not found")
                    return
                }
                
                let person = Person(lastName: user["lastName"] as! String,
                    firstName: user["firstName"] as! String,
                    userName: user["username"] as! String)
                
                userList.append(person)
            }
        }
        
    }
}