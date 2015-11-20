//
//  ProfessorQueueViewController.swift
//  FInalProject
//
//  Created by Guillermo on 11/18/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import UIKit
import Parse

class ProfessorQueueViewController: UIViewController {
    
    let queueId = "Hlcn2AlVOa"

    let user = PFUser.currentUser()!
    
    var queueList = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQueueList()

    }
    
    func loadQueueList() {
        let query = PFQuery(className: "Queue").whereKey("objectId", equalTo: queueId).includeKey("waitlist")
        query.findObjectsInBackgroundWithBlock { queueWaitlist, error  in
            
            guard error == nil else {
                if let errorString = error!.userInfo["error"] as? String {
                    print("Error: \(errorString)")
                } else {
                    print("Error: \(error)")
                }
                return
            }
            
            if let selectedQueue = queueWaitlist {
                for person in selectedQueue {
                    print(person)
                }
            }
        }
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

extension ProfessorCreateOrViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
}