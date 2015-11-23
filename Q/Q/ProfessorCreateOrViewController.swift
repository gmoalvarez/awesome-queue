//
//  ProfessorCreateOrViewController.swift
//  FInalProject
//
//  Created by Guillermo on 11/4/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import UIKit
import Parse

class ProfessorCreateOrViewController: UIViewController,QRViewDelegate {
    
    var professor = PFUser.currentUser()!
//    var qrImageForParse:UIImage?
    var queueIDFromParse:String?
    var startVar:String?
    var endVar:String?

    
    @IBAction func logout(sender: UIBarButtonItem) {
        PFUser.logOut()
        performSegueWithIdentifier("logoutProfessor", sender: self)
        
        
    }

    @IBAction func createQueueButtonPressed(sender: AnyObject) {
        createQueue()
    }
    

    func createQueue() {
        let newQueue = PFObject(className: "Queue")
        newQueue["createdBy"] = professor
        //newQueue["waitlist"] = [String]() //blank queue
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
                self.queueIDFromParse = objectId
                
                ///// ------- Automatically add students upon creating the queue for testing purposes
                TestQueueGenerator.addAllStudentsToQueueWithId(objectId)
                ///// -------                        --------- /////////////////////////////////////
                self.performSegueWithIdentifier("toQRgen", sender: self)
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {

    }
    
    func setQR(qrImage: UIImage, queueId: String) {
        
        let query = PFQuery(className: "Queue").whereKey("objectId", equalTo: queueId)
        query.findObjectsInBackgroundWithBlock { queue, error in
            guard error == nil else {
                self.displayErrorString(error, messageTitle: "Error when finding current queue")
                return
            }
            
            guard let currentQueue = queue?.first else {
                print("Could not get queue")
                return
            }
            
            self.addImageToQueue(currentQueue, image: qrImage)
        }
        
    }
    
    let compression:CGFloat = 0.8
    func addImageToQueue(queue: PFObject, image: UIImage) {
        guard let imageData = UIImagePNGRepresentation(image) else {
            print("Could not convert image into data")
            return
        }
        
        guard let imageFile = PFFile(data: imageData) else {
            print("Could not convert image file to Parse File")
            return
        }
        
        imageFile.saveInBackgroundWithBlock{ (success, error) -> Void in
            
            guard error == nil else {
                self.displayErrorString(error, messageTitle: "Failed to upload QR image")
                return
            }
            
            if success {
                print("Successfully saved QR image")
                queue.setObject(imageFile, forKey: "qrImage")
            }
        }
        
        
    }
    
    @IBAction func back(segue:UIStoryboardSegue){
//        if let source = segue.sourceViewController as? SetInfoForNewQueueViewController{
//            if !source.timeWasSet{
//                return
//            }else{
//                guard let start = source.startDateTime,
//                    end = source.endDateTime else{
//                        print("Start and End could not be unwrapped")
//                        return
//                    }
//                self.startVar = start
//                self.endVar = end
//            }
//        }
        
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? QRGenViewController{
            destination.delegate = self
            if let queueIDFromParse = queueIDFromParse{
                destination.queueID = queueIDFromParse
            }
            else{
                print("queueIDFromParse nil while unwrapping in prepareForSegue() in ProfessorCreateOrViewController")
            }
            print("Start: \(startVar) End: \(endVar)")
        }
        
    }
    
    

}
