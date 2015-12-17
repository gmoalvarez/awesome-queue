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
    @IBOutlet weak var redX: UIImageView!
    @IBOutlet weak var joinQueueButton: UIButton!
    @IBOutlet weak var exitQueueButton: UIButton!
    @IBOutlet weak var placeInQueue: UILabel!
    @IBOutlet weak var smiley: UIImageView!
    @IBOutlet weak var removeAlert: UITextView!
    
    var currentVisitId:String?
    var currentQueueId:String?
    let currentUser = PFUser.currentUser()!
    
    var beginTime:NSDate?
    var endTime:NSDate?
    var queueToJoin:String?
    let userName = PFUser.currentUser()!.username!
    var reason = "none"
    
    var timer1:NSTimer?
    var currentTimerTime = 0
    var firstInLine = false
    var joinedQ = false
    
    func allUnhide(){
        smiley.hidden = false
        redX.hidden = false
        smiley.hidden = false
        removeAlert.hidden = false
        joinQueueButton.hidden = false
        exitQueueButton.hidden = false
        
    }
    
    func allHide(){
        smiley.hidden = true
        redX.hidden = true
        smiley.hidden = true
        removeAlert.hidden = true
        joinQueueButton.hidden = true
        exitQueueButton.hidden = true
        placeInQueue.hidden = true
    }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        PFUser.logOut()
        if let timer1 = timer1{
          timer1.invalidate()  
        }
        print("logout")
            PFQuery.clearAllCachedResults()
        //performSegueWithIdentifier("logoutStudent", sender: self)
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
        
        guard let currentVisitId = currentVisitId else {
            print("Could not get current visit id")
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
                if let timer1 = self.timer1 {
                    timer1.invalidate()
                }
                self.allHide()
                self.joinedQ = false
                self.joinQueueButton.hidden = false
                self.placeInQueue.hidden = true
//                self.firstInLine = false
            }
        }
    }
    
    override func viewDidLoad() {
        status.hidden = true
        super.viewDidLoad()
        print(currentUser)
        allHide()
        joinQueueButton.hidden = false
        joinedQ = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        //1. Check for the first visit where user appears
        let visitQuery = PFQuery(className: "Visit").whereKey("user", equalTo: currentUser)
        visitQuery.orderByDescending("updatedAt")
        visitQuery.getFirstObjectInBackgroundWithBlock { (visit, error) -> Void in
            guard let visit = visit else {
                print("Could not find user in a visit")
                return
            }
            //2. Save visit as current visit
            self.currentVisitId = visit.objectId
            //3. User was found in a Visit class. Now we query the queues to see if that visit is found
            let waitlistQuery = PFQuery(className: "Queue").whereKey("waitlist", containsAllObjectsInArray: [visit])
            waitlistQuery.getFirstObjectInBackgroundWithBlock({ (queue, error) -> Void in
                guard let queue = queue else {
                    print("Did not find user in the Queue")
                    return
                }
                
                print(queue.objectId)
                self.currentQueueId = queue.objectId
                self.joinQueueButton.hidden = true
                self.exitQueueButton.hidden = false
                self.joinedQ = true
                if self.timer1 == nil {
                    self.startTimer()
                }
                self.updatePlace()
                self.removeAlert.hidden = true
            })
        }
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
   
    
    @IBAction func joinQ(sender: UIButton) {
        //adding alert
        redX.hidden = true
        status.hidden = true
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
            status.hidden = false
            return
        }
        
        currentQueueId = infoArray[1]
        status.text = "Status: \(infoArray[0])"
//        queueName.text = "queue id: \(infoArray[1])"
//        lat.text = "Begin Time: \(infoArray[2])"
//        long.text = "End Time: \(infoArray[3])"
        let beginDT = makeDate(infoArray[2])
        let endDT = makeDate(infoArray[3])
        if (checkTime(beginDT, endDate: endDT)){
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
        dateFmt.dateFormat = "yyyy-MM-dd h:mm a"
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
        if let picture = currentUser["picture"] {
            visit["picture"] = picture
        }
        
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
                //need to check and see if user currently has another visit in this queue before entering
                //this could actually be the outer part and make the visit here if there is no user/vist in queue
                
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
                if self.timer1 == nil {
                    self.startTimer()
                }
                self.joinQueueButton.hidden = true
                self.exitQueueButton.hidden = false
                self.joinedQ = true
                self.smiley.hidden = true
                self.updatePlace()
                self.removeAlert.hidden = true
            }

        }
    }
    
    func startTimer() {
        self.timer1 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "updatePlace", userInfo: nil, repeats: true)
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
                    if(self.joinedQ == false){
                        print("unable to find place in queue")
                    }
                    else if (self.firstInLine == false){
                        self.removeAlert.hidden = false
                    }
                    else{
                        self.placeInQueue.hidden = true
                        self.smiley.hidden = false
                    }
                    self.placeInQueue.hidden = true
                    self.joinedQ = false
                    self.joinQueueButton.hidden = false
                    self.firstInLine = false
                    self.exitQueueButton.hidden = true
                    if let timer1 = self.timer1 {
                        timer1.invalidate()
                    }
                    
                    return
                }
                if(index == 0){
                    self.firstInLine = true
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
