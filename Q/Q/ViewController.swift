//
//  ViewController.swift
//  Q
//
//  Created by Archie on 10/23/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    //var table:PFObject?
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var classText: UITextField!
    
    @IBAction func send(sender: UIButton) {
        sendInfo()
        view.endEditing(true)
        name.text = ""
        classText.text = ""
    }
    
    @IBAction func getQ(sender: UIButton) {
        let query = PFQuery(className:"Person")
        query.selectKeys(["name"])
        query.orderByAscending("createdAt");
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                //print(objects);
                print(objects![0]["name"])
                print("")
                print("Printing all people in queue in dequeue order")
                for x in objects!{
                    print(x["name"])
                }
            } else {
                // Log details of the failure
                print("Error: \(error)")
            }
        }
        
    
//need to get user signed in AND store ScreenName locally for later queries
//ScreenName needs to be unique (query users for username, if returns size 0, good to go
//No need to store query object when app quit or goto background. 
//Have the app query again when move to foreground OR viewDidLoad
        
    }
    
    @IBAction func DeQ(sender: UIButton) {
        let query = PFQuery(className:"Person")
        query.selectKeys(["name"])
        query.orderByAscending("createdAt");
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                let name = objects![0]["name"]
                print("Successfully retrieved \(objects!.count) scores.")
                print("Removing \(name) from the Q")
                objects![0].deleteInBackground()
                
                let query2 = PFQuery(className:"Person")
                query2.whereKey("name", equalTo:"\(name)")
                query2.findObjectsInBackgroundWithBlock {
                    (objectss: [PFObject]?, error: NSError?) -> Void in
                    if error == nil{
                        if objectss!.count == 0{
                            print("Successfully removed \(name) from the Q!")
                        }
                        else{
                            print("WHAT THE FUCK!!")
                        }
                        
                    }
                    else{
                        print("Error: \(error)")
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error)")
            }
        }
        }
    
    
    
    
    
    func sendInfo(){
        if let n = name.text, c = classText.text{
        let person = PFObject(className: "Person")
            person["name"] = n
            person["class"] = c
        person.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been saved.")
        }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

