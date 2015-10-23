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

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var classText: UITextField!
    
    @IBAction func send(sender: UIButton) {
        sendInfo()
        view.endEditing(true)
        name.text = ""
        classText.text = ""
    }
    
    
    func sendInfo(){
        if let name = name.text,
            classNameAndNumber = classText.text{
        let person = PFObject(className: "Person")
            person["name"] = name
            person["class"] = classNameAndNumber
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

