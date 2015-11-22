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
    var qrImageForParse:UIImage?
    var queueIDFromParse:String?

    @IBAction func createQueueButtonPressed(sender: AnyObject) {
        createQueue()
        
    }
    
    func createQueue() {
        let newQueue = PFObject(className: "Queue")
        newQueue["createdBy"] = professor
        newQueue.saveInBackgroundWithBlock(saveQueue)
        
        //get ID from new queue here
        //re-write the one code line below
        queueIDFromParse = "Hlcn2AlVOa"

        
        performSegueWithIdentifier("toQRgen", sender: self)
    }
    
    func saveQueue(success:Bool, error:NSError?) {
        guard error == nil else {
            if let errorString = error!.userInfo["error"] as? String {
                self.displayAlert("Failed to create Queue", message: errorString)
            } else {
                self.displayAlert("Failed to create Queue", message: "Try again later")
            }
            return
        }
        
        if success {
            print("Created queue successfully: \(success)")
        }

    }
    
    //this is going to be replaced by queueIDFromParse
    let queueId = "Hlcn2AlVOa"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        TestQueueGenerator.addAllStudentsToQueueWithId(queueId)
//        loadQueueWithTestUsers()
    }
    
    override func viewWillAppear(animated: Bool) {

    }
    
    func setQR(qr: UIImage?) {
        guard let qrImage = qr else{
            print("UIImage failed to unwrap in the setQR() method in the ProfessorCreateOrViewController")
            return
        }
        qrImageForParse = qrImage
        print("Made it to setQR!!")
    }
    
//    @IBAction func back(segue:UIStoryboardSegue){
//        if let source = segue.sourceViewController as? QRGenViewController{
//            source.delegate = self
//        }
//    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        if let source = segue.destinationViewController as? QRGenViewController{
            source.delegate = self
            if let qID = queueIDFromParse{
                source.queueID = qID
            }
            else{
                print("queueIDFromParse nil while unwrapping in prepareForSegue() in ProfessorCreateOrViewController")
            }
        }
        else{
            print("Nope")
        }
    }
    

}
