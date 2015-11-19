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

    let user = PFUser.currentUser()!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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