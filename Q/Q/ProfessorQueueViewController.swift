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
    
    

    var queueId = String() {
        didSet {
            if queueId != "" {
                loadQueueList()
                startTimer()
            }
        }
    }
    
    var timer = NSTimer()
    let timerInterval:NSTimeInterval = 2 //update queue every 2 seconds
    func startTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(timerInterval,
            target: self,
            selector: "loadQueueList",
            userInfo: nil,
            repeats: true)
    }

    let professor = PFUser.currentUser()!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    var queueSize = 0
    var queueList = [PFObject]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getQueueId()
    }
    
    func getQueueId() {
        let queueQuery = PFQuery(className: "Queue")
        queueQuery.whereKey("createdBy", equalTo: professor)
        queueQuery.findObjectsInBackgroundWithBlock { (queues, error) -> Void in
            guard error == nil else {
                self.displayErrorString(error)
                return
            }
            
            guard let latestQueue = queues?.last else {
                self.displayAlert("Error", message: "Could not get latest queue")
                return
            }
            
            guard let latestQueueId = latestQueue.objectId else {
                print("Could not get latest queue Id")
                return
            }
            
            self.queueId = latestQueueId
        }
    }
    
    func loadQueueList() {
        
        let query = PFQuery(className: "Queue").whereKey("objectId", equalTo: queueId).includeKey("waitlist")
        query.findObjectsInBackgroundWithBlock { queue, error in
            
            
            guard let queue = queue?.first else {
                self.displayAlert("Error", message: "Could not get queue")
                return
            }
            
            guard let waitlist = queue["waitlist"] as? [PFObject] else {
                self.displayAlert("Error", message: "Could not get waitlist from selected queue")
                return
            }
            
            guard self.queueList.count != waitlist.count else {
                //print("No need to update queue. They are the same size")
                return
            }
            
            self.queueList = waitlist
//            self.queueSize = waitlist.count
//            self.queueList = [Person](count: self.queueSize, repeatedValue: Person())
//            
            
            //Iterate through all users and create the Model queueList for the TableView
//            for (index,username) in waitlist.enumerate() {
//                
//                let userQuery = PFUser.query()?.whereKey("username", equalTo: username)
//                userQuery?.findObjectsInBackgroundWithBlock { user, error in
//                    
//                    guard error == nil else {
//                        self.displayErrorString(error)
//                        return
//                    }
//                    
//                    guard let user = user?.first else {
//                        self.displayAlert("Error", message: "User not found")
//                        return
//                    }
//                    
//                    self.queueList[index] = (Person(lastName: user["lastName"] as! String,
//                        firstName: user["firstName"] as! String,
//                        userName: user["username"] as! String))
//                }
//            }
        }
    }

    @IBAction func nextButtonPressed(sender: UIButton) {
        
        PFQuery(className: "Queue").getObjectInBackgroundWithId(queueId) { (queue, error) -> Void in
            
            guard error == nil,
            let queue = queue else {
                self.displayErrorString(error, messageTitle: "Error retrieving queue with id: \(self.queueId)")
                return
            }
            
            guard let waitlist = queue["waitlist"] as? [PFObject] else {
                self.displayAlert("Error", message: "Could not get waitlist from queue")
                return
            }
            
            guard let firstStudentInQueue = waitlist.first else {
                self.displayAlert("Error", message: "Could not get first user in queue")
                return
            }
            
            queue.removeObject(firstStudentInQueue, forKey: "waitlist")
            queue.saveInBackground()
            self.queueList.removeFirst()
        }
    }
    
}

extension ProfessorQueueViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let person = queueList[indexPath.row]
        guard let firstName = person["firstName"] as? String,
            let lastName = person["lastName"] else {
                print("Could not obtain first name and last name")
                cell.textLabel?.text = ""
                return cell
        }
        
        cell.textLabel?.text = "\(firstName) \(lastName)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queueList.count
    }
    
}