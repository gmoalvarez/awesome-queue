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
    
    var beginTime:NSDate?
    var endTime:NSDate?
    var queueToJoin:String?
    var userName = PFUser.currentUser()!.username
    
    
    
    
    
    //creates new timer
    var timer1:NSTimer!
    var currentTimerTime = 0
    
    //change the name for testing
    @IBAction func changeName(sender: UIButton) {
        userName = userNameToChange.text
        print(userName)
    }
    
    func doSomething(info:String,reason:String){
        print(info)
        print(reason)
        var infoArray = info.componentsSeparatedByString("|")
        if infoArray[0] != "Q.0" {
            status.text = "Error: Not a Q.0 qr code."
            return
        }
        queueToJoin = infoArray[1]
        status.text = "Status: \(infoArray[0])"
        queueName.text = "queue id: \(infoArray[1])"
        lat.text = "Begin Time: \(infoArray[2])"
        long.text = "End Time: \(infoArray[3])"
        let beginDT = makeDate(infoArray[2])
        let endDT = makeDate(infoArray[3])
        if (checkTime(beginDT, endDate: endDT)){
            check.hidden = false
            sendInfo()
        }
        else{
            redX.hidden = false
            return
        }
        sendInfo()
        
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
        var uName = "smiley"  //default userName for testing
        if let tempName = userName{
            uName = tempName
        }
        if let q = queueToJoin {
            let person = PFObject(className: q)
            person["userName"] = uName
            person.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                print("Object has been saved.")
                //testing the timer when entering queue
                
                self.timer1 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "testTimer", userInfo: nil, repeats: true)
            }
            
        }
    }
    
    
    //next two methods are for testing timer
    func testTimer(){
        print(currentTimerTime++)
    }
    
    @IBAction func stopTimer(sender: UIButton) {
        timer1.invalidate()
    }
    /////
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        check.hidden = true
        redX.hidden = true
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
 
    
    @IBAction func back(segue:UIStoryboardSegue){
        var reason = "none"
        if let source = segue.sourceViewController as? QRViewController{
            guard let info = source.foundString,
                reasonTmp = source.reason else{
            print("Error in back() from StudentViewController: back")
                    return
            }
            if reasonTmp != ""{
            reason = reasonTmp
            }
            doSomething(info, reason: reason)
        }
        
        
        }
}
