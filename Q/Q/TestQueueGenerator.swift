//
//  TestQueueGenerator.swift
//  FInalProject
//
//  Created by Guillermo on 11/19/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import Foundation
import UIKit
import Parse

class TestQueueGenerator {
    
    static func getStudentListFromJSONFileNamed(fileName:String, success: (data:NSData) -> Void ) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            guard let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "json") else {
                print("Could not get file path")
                return
            }
            
            do {
                let data = try NSData(contentsOfFile: filePath,
                    options: .DataReadingUncached)
                success(data: data)
            } catch let error as NSError {
                print("Error: \(error)")
            } catch {
                fatalError()
            }
        }
    }
    
//    let queueId = "0BPUdcE3ro"
    
    static func createNewUsersFromJSONFileNamed(fileName:String) {
        getStudentListFromJSONFileNamed(fileName) { (data) -> Void in
            let parsedObject:AnyObject?
            do {
                parsedObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
            } catch let error as NSError {
                print("Error: \(error)")
                parsedObject = nil
            } catch {
                fatalError()
            }
            
            if let studentList = parsedObject as? [Dictionary<String,String>] {
                
                for student in studentList {
                    let user = PFUser()
                    user["firstName"] = student["firstName"]
                    user["lastName"] = student["lastName"]
                    user.username = student["userName"]
                    user.password = student["password"]
                    user["type"] = student["type"]
                    user.signUpInBackgroundWithBlock { (success, error) -> Void in
                        
                        guard error == nil else {
                            if let errorString = error!.userInfo["error"] as? String {
                                print("Error: \(errorString)")
                            } else {
                                print("Error: \(error)")
                            }
                            return
                        }
                        
                        print("Signing up users was successful: \(success)")
                    }
                }
            }
        }
    }
    
    static func uploadStudentsFromJSONFileNamed(fileName:String, intoQueueWithId queueId: String) {
        getStudentListFromJSONFileNamed(fileName) { (data) -> Void in
            let parsedObject:AnyObject?
            do {
                parsedObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
            } catch let error as NSError {
                print("Error: \(error)")
                parsedObject = nil
            } catch {
                fatalError()
            }
            
            if let studentList = parsedObject as? [Dictionary<String,AnyObject>] {
                    let query = PFQuery(className: "Queue")
                    query.getObjectInBackgroundWithId(queueId) { queue, error  in
                        
                        guard let queue = queue else {
                            print("It appears there is no queue")
                            return
                        }
                        
                        for student in studentList {
                            let parseStudent = PFObject(className: "Person")
                            parseStudent["firstName"] = student["firstName"]
                            parseStudent["lastName"] = student["lastName"]
                            parseStudent["userName"] = student["userName"]
                            parseStudent["password"] = student["password"]
                            parseStudent["type"] = student["type"]
                            
                        }
                        
                        
                    }

                
            }
        }
    }
    
}