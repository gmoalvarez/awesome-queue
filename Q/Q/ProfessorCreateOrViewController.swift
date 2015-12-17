//
//  ProfessorCreateOrViewController.swift
//  FInalProject
//
//  Created by Guillermo on 11/4/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import UIKit
import Parse

class ProfessorCreateOrViewController: UIViewController {
    
//    var professor = PFUser.currentUser()!
//
//    var queueIDFromParse:String?
    //    var qrImageForParse:UIImage?
//    var startVar:String?
//    var endVar:String?
    
    
    @IBAction func logout(sender: UIBarButtonItem) {
        PFUser.logOut()
        PFQuery.clearAllCachedResults()
        performSegueWithIdentifier("logoutProfessor", sender: self)
    }

    @IBAction func createQueueButtonPressed(sender: AnyObject) {
//        createQueue()
        performSegueWithIdentifier("toDatePick", sender: self)
    }
    

//    func createQueue() {
//        let newQueue = PFObject(className: "Queue")
//        newQueue["createdBy"] = professor
//        newQueue["waitlist"] = [PFObject]()
//        newQueue.saveInBackgroundWithBlock { (success, error) -> Void in
//            guard error == nil else {
//                self.displayErrorString(error,messageTitle: "Failed to create Queue")
//                return
//            }
//            
//            if success {
//                print("Created queue successfully: \(success)")
//                guard let objectId = newQueue.objectId else {
//                    print("Created queue but did not get an id back")
//                    return
//                }
//                
//                self.professor.addObject(newQueue, forKey: "queues")
//                self.queueIDFromParse = objectId
//                self.performSegueWithIdentifier("toDatePick", sender: self)
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {

    }
    
//    func setQR(qrImage: UIImage, queueId: String) {
//        
//        let query = PFQuery(className: "Queue").whereKey("objectId", equalTo: queueId)
//        query.findObjectsInBackgroundWithBlock { queue, error in
//            guard error == nil else {
//                self.displayErrorString(error, messageTitle: "Error when finding current queue")
//                return
//            }
//            
//            guard let currentQueue = queue?.first else {
//                print("Could not get queue")
//                return
//            }
//            
//            self.addImageToQueue(currentQueue, image: qrImage)
//        }
//        
//    }
    
//    let compression:CGFloat = 0.8
//    func addImageToQueue(queue: PFObject, image: UIImage) {
//        guard let imageData = UIImagePNGRepresentation(image) else {
//            print("Could not convert image into data")
//            return
//        }
//        
//        guard let imageFile = PFFile(data: imageData) else {
//            print("Could not convert image file to Parse File")
//            return
//        }
//        
//        imageFile.saveInBackgroundWithBlock{ (success, error) -> Void in
//            
//            guard error == nil else {
//                self.displayErrorString(error, messageTitle: "Failed to upload QR image")
//                return
//            }
//            
//            if success {
//                print("Successfully saved QR image")
//                queue.setObject(imageFile, forKey: "qrImage")
//            }
//        }
//    }
    
    @IBAction func profBack(segue:UIStoryboardSegue){
//        if let source = segue.sourceViewController as? QRGenViewController{
//            guard let qrFromGen = source.qr.image else{
//                print("No qr")
//                return
//            }
//            self.qrImageForParse = qrFromGen
//            return
//        }
        
        
            if let source = segue.sourceViewController as? ProfessorQueueViewController{
                        source.timer.invalidate()
                return
            }
    }

    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
////        if let destination = segue.destinationViewController as? QRGenViewController{
////            //destination.delegate = self
////            if let queueIDFromParse = queueIDFromParse{
////                destination.queueID = queueIDFromParse
////            }
////            else{
////                print("queueIDFromParse nil while unwrapping in prepareForSegue() in ProfessorCreateOrViewController")
////            }
//////            print("Start: \(startVar) End: \(endVar)")
////        }
//        if let destination = segue.destinationViewController as? SetInfoForNewQueueViewController{
//            if let queueIDFromParse = queueIDFromParse{
//                destination.queueID = queueIDFromParse
//            }
//            else{
//                print("queueIDFromParse nil while unwrapping in prepareForSegue() in ProfessorCreateOrViewController")
//            }
//        }
//        
//    }
    
    

}
