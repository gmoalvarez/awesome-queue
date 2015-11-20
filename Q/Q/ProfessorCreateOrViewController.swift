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
        newQueue["createdBy"] = professor
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
    
    let queueId = "Hlcn2AlVOa"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        TestQueueGenerator.addAllStudentsToQueueWithId(queueId)
//        loadQueueWithTestUsers()
    }
    
        
    override func viewWillAppear(animated: Bool) {

    }

}
