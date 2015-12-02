//
//  StudentViewController.swift
//  FInalProject
//
//  Created by Archie on 11/16/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import UIKit
import Parse

//var signInInfo:String?

class StudentViewController: UIViewController {
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var queueName: UILabel!
    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var long: UILabel!
    @IBOutlet weak var userNameToChange: UITextField!
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var redX: UIImageView!
    @IBOutlet weak var joinQueueButton: UIButton!
    @IBOutlet weak var exitQueueButton: UIButton!
    @IBOutlet weak var placeInQueue: UILabel!
    
    var beginTime:NSDate?
    var endTime:NSDate?
    var currentQueueId:String?
    let currentUser = PFUser.currentUser()!
    let userName = PFUser.currentUser()!.username!
    var reason = "none"
    var currentVisitId = String()
    
    @IBAction func logout(sender: UIBarButtonItem) {
        PFUser.logOut()
        if timer1 != nil{
          timer1.invalidate()  
        }
        PFQuery.clearAllCachedResults()
        performSegueWithIdentifier("logoutStudent", sender: self)
    }
    
    @IBAction func touchBackground(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
     // MARK: - REMOVING FROM QUEUE
    @IBAction func removeFromQueue(sender: UIButton) {
        let controller = UIAlertController(title: "REMOVE FROM QUEUE", message: "Are you sure that you want to remove yourself from the Queue?",
            preferredStyle: .ActionSheet)
        let yesAction = UIAlertAction(title: "Yes Remove", style: .Default, handler: {action in self.removeFromQueueMethod()})
        let cancelAction = UIAlertAction(title: "CANCEL", style: .Cancel, handler: nil)
        controller.addAction(cancelAction)
        controller.addAction(yesAction)
        self.presentViewController(controller, animated: true, completion: {print("Done")})
        
    }
    
    func removeFromQueueMethod(){

        guard let currentQueueId = currentQueueId else {
            print("Could not get current queue id")
            return
        }
        
        let visitQuery = PFQuery(className: "Visit")
        visitQuery.getObjectInBackgroundWithId(currentVisitId) { visit, error in
            
            guard let visit = visit else {
                print("Could not find visit")
                return
            }
            
            let queueQuery = PFQuery(className: "Queue")
            queueQuery.getObjectInBackgroundWithId(currentQueueId){ queue, error in
                guard let queue = queue else {
                    print("It appears there is no queue")
                    return
                }
                
                queue.removeObject(visit, forKey: "waitlist")
                queue.saveInBackground()
                self.timer1.invalidate()
                self.exitQueueButton.hidden = true
                self.joinQueueButton.hidden = false
                self.check.hidden = true
                self.redX.hidden = true
                self.placeInQueue.hidden = true
            }

        }
            
        
    }

    // MARK: - TESTING METHODS (SAFE TO DELETE)
    
    //next two methods are for testing timer
    func testTimer(){
        print(currentTimerTime++)
    }
    
    @IBAction func stopTimer(sender: UIButton) {
        timer1.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentUser)
        check.hidden = true
        redX.hidden = true
        exitQueueButton.hidden = true
        self.placeInQueue.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - METHODS TO JOIN QUEUE AND UPDATE SCREEN
    //creates new timer
    var timer1:NSTimer!
    var currentTimerTime = 0
    
    @IBAction func joinQ(sender: UIButton) {
        //adding alert
        redX.hidden = true
        check.hidden = true
        
        let controller = UIAlertController(title: "SUBMIT REASON", message: "Would you like to add a brief reason for your visit?",
            preferredStyle: .ActionSheet)
        let yesAction = UIAlertAction(title: "Add Reason", style: .Default, handler: {action in self.performSegueWithIdentifier("toReason", sender: self)})
        let noAction = UIAlertAction(title: "No Reason", style: .Default, handler:   {action in self.performSegueWithIdentifier("toQR", sender: self)})
        let cancelAction = UIAlertAction(title: "CANCEL", style: .Cancel, handler: nil)
        controller.addAction(cancelAction)
        controller.addAction(yesAction)
        controller.addAction(noAction)
        
        self.presentViewController(controller, animated: true, completion: {print("Done")})
    }
    
    func parseQRInformation(info:String, reason:String){
        print(info)
        print(reason)
        var infoArray = info.componentsSeparatedByString("|")
        
        if infoArray[0] != "Q.0" {
            status.text = "Error: Not a Q.0 qr code."
            return
        }
        
        currentQueueId = infoArray[1]
        status.text = "Status: \(infoArray[0])"
        queueName.text = "queue id: \(infoArray[1])"
        lat.text = "Begin Time: \(infoArray[2])"
        long.text = "End Time: \(infoArray[3])"
        let beginDT = makeDate(infoArray[2])
        let endDT = makeDate(infoArray[3])
        if (checkTime(beginDT, endDate: endDT)){
            //check.hidden = false
            
            sendInfo()
            
        }
        else{
            redX.hidden = false
            return
        }
    }
    
    //makes NSDates from Strings in form "yyyy-MM-dd h:mm a"
    func makeDate(dateInString:String)->NSDate {
        let dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = "yyyy-MM-dd h:mm"
        let returnDate = dateFmt.dateFromString(dateInString)!
        return returnDate
    }
    
    //ready to check that student is checking in within Office Hours (
    func checkTime(begDate:NSDate,endDate:NSDate)->Bool{
        if NSDate().compare(begDate) == NSComparisonResult.OrderedDescending && NSDate().compare(endDate) == NSComparisonResult.OrderedAscending{
            return true
        }
        else{
            return false
        }
    }
    
    func sendInfo(){
        
        guard let currentQueueId = currentQueueId else {
            print("No queue to join?")
            return
        }

        let visit = PFObject(className: "Visit")
        visit["user"] = self.currentUser
        visit["firstName"] = currentUser["firstName"]
        visit["lastName"] = currentUser["lastName"]
        if reason != "none" {
            visit["reason"] = reason
        }
        visit["picture"] = currentUser["picture"]
        visit.saveInBackgroundWithBlock{ success, error in
            
            guard error == nil else {
                self.displayErrorString(error, messageTitle: "Not able to save visit")
                return
            }
            
            let queueQuery = PFQuery(className: "Queue")
            queueQuery.getObjectInBackgroundWithId(currentQueueId){ queue, error in
                guard let queue = queue else {
                    print("It appears there is no queue")
                    return
                }
                
                queue.addUniqueObject(visit, forKey: "waitlist")
                queue.saveInBackgroundWithBlock({ (success, error) -> Void in
                    
                    if success {
                        print("Saved visit in queue successfully: \(success)")
                        
                        guard let objectId = visit.objectId else {
                            print("Added visit but did not get an id back")
                            return
                        }
                        
                        self.currentVisitId = objectId
                        
                        
                    }

                })
                self.timer1 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "updatePlace", userInfo: nil, repeats: true)
                self.joinQueueButton.hidden = true
                self.exitQueueButton.hidden = false
                self.updatePlace()
            }

        }
        
        
    }
    
    
    func updatePlace(){
        if let currentQueueId = currentQueueId {
            print(currentTimerTime++)
            let query = PFQuery(className: "Queue").whereKey("objectId", equalTo: currentQueueId).includeKey("waitlist")
            query.findObjectsInBackgroundWithBlock { queue, error in
                
                
                guard let queue = queue?.first else {
                    self.displayAlert("Error", message: "Could not get  queue")
                    return
                }
                
                guard let waitlist = queue["waitlist"] as? [PFObject] else {
                    self.displayAlert("Error", message: "Could not get waitlist from selected queue")
                    return
                }
                
                let users = waitlist.map{$0["user"]} as? [PFObject]
                
                guard let index = users?.indexOf(self.currentUser) else{
                    print("unable to find place in queue")
                    return
                }
                self.placeInQueue.text = "\(index + 1)"
                self.placeInQueue.hidden = false
                
            }
        }
    }
 
    
    @IBAction func back(segue:UIStoryboardSegue){
        
        if let source = segue.sourceViewController as? QRViewController{
            if !source.didScan{
                return
            }
            guard let info = source.foundString,
                reasonTmp = source.reason else{
            print("Error in back() from StudentViewController: back")
                    return
            }
            if reasonTmp != ""{
            reason = reasonTmp
            }
            parseQRInformation(info, reason: reason)
        }
        
        
    }
}
