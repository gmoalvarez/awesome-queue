//
//  ProfessorCreateOrViewController.swift
//  FInalProject
//
//  Created by Guillermo on 11/4/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import UIKit
import Parse

class ProfessorCreateOrViewController: UIViewController {
    
    var professor = PFUser.currentUser()!
    
    @IBAction func createQueueButtonPressed(sender: AnyObject) {
        createQueue()
        
    }
    
    func createQueue() {
        let newQueue = PFObject(className: "Queue")
        newQueue.saveInBackgroundWithBlock(saveQueue)
    }
    
    func saveQueue(success:Bool, error:NSError?) {
        guard error == nil else {
            if let errorString = error!.userInfo["error"] as? String {
                self.displayAlert("Failed to create Queue", message: errorString)
            } else {
                self.displayAlert("Failed to create Queue", message: "Try again later")
            }
            return
        }
        
        if success {
            print("Created queue successfully: \(success)")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TestQueueGenerator.createNewUsersFromJSONFileNamed("testStudentList")

//        loadQueueWithTestUsers()
    }
    
//    func loadQueueWithTestUsers() {
//        let queue = PFObject(className: "Queue")
//        let query = PFUser.query()
//        query?.findObjectsInBackgroundWithBlock { students, error in
//            
//            guard error == nil else {
//                if let errorString = error!.userInfo["error"] as? String {
//                    self.displayAlert("Failed to get users", message: errorString)
//                } else {
//                    self.displayAlert("Failed to get users", message: "Try again later")
//                }
//                return
//            }
//            
//            guard let students = students else {
//                print("It appears there are no users")
//                return
//            }
//
//            for student in students {
//                print("\(student)")
//            }
//            
//            
//            let query = PFQuery(className: "Queue")
//            query.getObjectInBackgroundWithId("0BPUdcE3ro") { queue, error  in
//                
//                guard let queue = queue else {
//                    print("It appears there is no queue")
//                    return
//                }
//                
//                //this saves the users in a weird way but it is ok for now.
//                queue.addUniqueObjectsFromArray(students, forKey: "waitlist")
//                queue.saveInBackground()
//            }
//            
//            
//            
//        }
//    }
    
let queueId = "0BPUdcE3ro" //queue Id used for testing
    
    override func viewWillAppear(animated: Bool) {
        print("Attempting to create new users")
    }

    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
