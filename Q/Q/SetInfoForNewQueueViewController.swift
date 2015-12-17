//
//  SetInfoForNewQueueViewController.swift
//  FInalProject
//
//  Created by Archie on 11/22/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import UIKit
import Parse

class SetInfoForNewQueueViewController: UIViewController {

    var beginWasSet:Bool = false
    var endWasSet:Bool = false
    //var timeWasSet = false
    var queueID:String?
    
    @IBAction func setTime(sender: UIBarButtonItem) {
        if !beginWasSet || !endWasSet{
            return
        }
        createQueue()
//        performSegueWithIdentifier("toQrFromDate", sender: self)
    }
    
    @IBAction func setStart(sender: UIButton) {
        
        startTime.text = dateTime
        startDateTime = dateTime
        beginWasSet = true
    }
    
    @IBAction func setEnd(sender: UIButton) {
        
        endTime.text = dateTime
        endDateTime = dateTime
        endWasSet = true
    }
    
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    

    
    @IBOutlet weak var datePicker: UIDatePicker!
   
    var dateTime = "Please Select a Time"
    var startDateTime:String?
    var endDateTime:String?
    
    @IBAction func datePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        let locale = NSLocale.currentLocale()
        
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("j", options: 0, locale: locale)!
        
        if dateFormat.rangeOfString("a") != nil {
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        }
        else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        }
        let strDate = dateFormatter.stringFromDate(datePicker.date)
       dateTime = strDate
    }
    
 
    
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? QRGenViewController{
            //destination.delegate = self
            if let queueIDForQR = queueID{
                destination.queueID = queueIDForQR
            }
            else{
                print("queueIDFromParse nil in DatePick")
            }
            guard let qStart = startDateTime, qEnd = endDateTime else{
                print("start or end time not set in dateTime")
                return
            }
            destination.begDate = qStart
            destination.endDate = qEnd
        }
    }
    
    var professor = PFUser.currentUser()!
    //var queueIDFromParse:String?
    func createQueue() {
        let newQueue = PFObject(className: "Queue")
        newQueue["createdBy"] = professor
        newQueue["waitlist"] = [PFObject]()
        newQueue.saveInBackgroundWithBlock { (success, error) -> Void in
            guard error == nil else {
                self.displayErrorString(error,messageTitle: "Failed to create Queue")
                return
            }
            
            if success {
                print("Created queue successfully: \(success)")
                guard let objectId = newQueue.objectId else {
                    print("Created queue but did not get an id back")
                    return
                }
                
                self.professor.addObject(newQueue, forKey: "queues")
                self.queueID = objectId
                //self.performSegueWithIdentifier("toDatePick", sender: self)
                self.performSegueWithIdentifier("toQrFromDate", sender: self)
            }
        }
    }
    
    
    
    
}
