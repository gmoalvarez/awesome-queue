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
    
    var queueList = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQueueList()

    }
    
    func loadQueueList() {
        
        guard let usernames = ParseUtility.userNamesOfQueueWithObjectId(queueId) else {
            print("Error getting usernames")
            return
        }
            
        //Iterate through all users and create the Model queueList for the TableView
                
    }
        
    }


extension ProfessorQueueViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return queueList.count
    }
    
}