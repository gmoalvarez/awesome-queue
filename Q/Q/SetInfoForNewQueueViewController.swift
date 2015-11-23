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
    var timeWasSet = false
    var queueID:String?
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        performSegueWithIdentifier("toProfFromTime", sender: self)
    }
  
    @IBAction func setTime(sender: UIBarButtonItem) {
        if beginWasSet && endWasSet{
            timeWasSet = true
        }
        performSegueWithIdentifier("toProfFromTime", sender: self)
    }
    
    @IBAction func setStart(sender: UIButton) {
        
        startTime.text = dateTime
        startDateTime = dateTime
        startCheck.hidden = false
        beginWasSet = true
    }
    
    @IBAction func setEnd(sender: UIButton) {
        
        endTime.text = dateTime
        endDateTime = dateTime
        endCheck.hidden = false
        endWasSet = true
    }
    
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var startCheck: UIImageView!
    
    @IBOutlet weak var endCheck: UIImageView!
    
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
        startCheck.hidden = true
        endCheck.hidden = true
        
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

}
