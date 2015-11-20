//
//  VisitReasonViewController.swift
//  FInalProject
//
//  Created by Archie on 11/18/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import UIKit

class VisitReasonViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var reasonText: UITextView!

    @IBOutlet weak var reasonTextBottom: NSLayoutConstraint!
   
    @IBAction func submit(sender: UIBarButtonItem) {
            reason = reasonText.text
        performSegueWithIdentifier("backToLogInInfo", sender: self)
    }
    
    var bottomDistance:CGFloat!
    
    var reason = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reasonText.layer.borderWidth = 1
        reasonText.layer.borderColor = UIColor.blackColor().CGColor
            bottomDistance = reasonTextBottom.constant
        reasonText.delegate = self
        
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
// MARK: - Text Methods
    
    //this allows the done button to relase the keyboard
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        print(reasonTextBottom.constant)
        if let userInfo = sender.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                reasonTextBottom.constant = keyboardHeight - 20
                UIView.animateWithDuration(0.25, animations: { () -> Void in self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        reasonTextBottom.constant = bottomDistance
        UIView.animateWithDuration(0.25, animations: { () -> Void in self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func touchBackground(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
}
