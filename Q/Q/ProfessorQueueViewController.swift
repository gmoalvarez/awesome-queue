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
    
    let queueId = "Hlcn2AlVOa" //The Queue Id is hardcoded now but it will be fetched when the queue is created

    let user = PFUser.currentUser()!
    
    @IBOutlet weak var tableView: UITableView!
    
    var queueList = [Person]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQueueList()

    }
    
    func loadQueueList() {
        let query = PFQuery(className: "Queue").whereKey("objectId", equalTo: queueId).includeKey("waitlist")
        query.findObjectsInBackgroundWithBlock { queueWaitlist, error  in
            
            guard error == nil else {
                self.displayErrorString(error)
                return
            }
            
            guard let selectedQueue = queueWaitlist?.first else {
                self.displayAlert("Error", message: "Could not get queue for some reason")
                return
            }
            
            guard let waitlist = selectedQueue["waitlist"] as? [String] else {
                self.displayAlert("Error", message: "Could not get waitlist from selected queue")
                return
            }
            
            //Iterate through all users and create the Model queueList for the TableView
            for username in waitlist {
                
                let userQuery = PFUser.query()?.whereKey("username", equalTo: username)
                userQuery?.findObjectsInBackgroundWithBlock { user, error in
                    
                    guard error == nil else {
                        self.displayErrorString(error)
                        return
                    }

                    
                    guard let user = user?.first else {
                        self.displayAlert("Error", message: "User not found")
                        return
                    }
                    
                    self.queueList.append(Person(lastName: user["lastName"] as! String,
                        firstName: user["firstName"] as! String,
                        userName: user["username"] as! String))
                }
            }
        }
    }
}

extension ProfessorQueueViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let person = queueList[indexPath.row]
        cell.textLabel?.text = "\(person.firstName) \(person.lastName)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return queueList.count
    }
    
}