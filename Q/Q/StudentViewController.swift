//
//  StudentViewController.swift
//  FInalProject
//
//  Created by Archie on 11/16/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import UIKit
import Parse

var signInInfo:String?

class StudentViewController: UIViewController {
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var queueName: UILabel!
    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var long: UILabel!
    @IBOutlet weak var userNameToChange: UITextField!

    var queueToJoin:String?
    var userName:String?
    //var userName = "Smiley"
    
    @IBAction func changeName(sender: UIButton) {
        userName = userNameToChange.text
        print(userName)
    }
    
    func doSomething(info:String){
        print(info)
        var infoArray = info.componentsSeparatedByString("|")
        if infoArray[0] != "Q.0" {
            status.text = "Error: Not a Q.0 qr code."
            return
    }
        queueToJoin = infoArray[1]
        status.text = "Status: \(infoArray[0])"
        queueName.text = "queue Name: \(infoArray[1])"
        lat.text = "Latitude: \(infoArray[2])"
        long.text = "Longitude: \(infoArray[3])"
        sendInfo()
    }
    
    func sendInfo(){
        var uName = "smiley"  //default userName for testing
        if let tempName = userName{
            uName = tempName
        }
        if let q = queueToJoin {
            let person = PFObject(className: q)
            person["userName"] = uName
            person.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                print("Object has been saved.")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func back(segue:UIStoryboardSegue){
        if let source = segue.sourceViewController as? QRViewController{
            if let info = source.foundString{
                signInInfo = info
                doSomething(info)
            }
            else{
                print("QR not read correctly: from StudentViewController: back")
            }
        }
        
        
    }
}
