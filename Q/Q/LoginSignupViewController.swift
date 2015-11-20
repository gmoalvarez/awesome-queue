//
//  LoginSignupViewController.swift
//  FInalProject
//
//  Created by Guillermo on 11/3/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import UIKit
import Parse

class LoginSignupViewController: UIViewController {

    @IBOutlet weak var signupOrLoginSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    var timer1:NSTimer!
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func tapBackground(sender: UITapGestureRecognizer) {
        view.endEditing(true)   
    }
    @IBAction func signupModeChanged(sender: UISegmentedControl) {
        let signUpModeTitle = getSignUpModeTitle()
        
        if signUpModeTitle == "Log In" {
            userTypeSegmentedControl.hidden = true
        } else {
            userTypeSegmentedControl.hidden = false
        }
        
        signUpButton.setTitle(signUpModeTitle, forState: .Normal)
        
    }
    
    func getSignUpModeTitle() -> String{
        let selectedSignInModeIndex = signupOrLoginSegmentedControl.selectedSegmentIndex
        let signInMode = signupOrLoginSegmentedControl.titleForSegmentAtIndex(selectedSignInModeIndex)!
        return signInMode
    }
    
    @IBAction func signupPressed(sender: UIButton) {
        
        guard usernameTextField.text != "" &&
            passwordTextField.text != "" &&
        (userTypeSegmentedControl.selectedSegmentIndex != -1 ||
        userTypeSegmentedControl.hidden == true) else {
                
                displayAlert("Empty Field(s)",
                    message: "Please enter a username, password, and select user type (if signing up)")
                return
        }
        
        
        runActivityIndicator()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let signInMode = getSignUpModeTitle()
        
        if signInMode == "Sign Up" {
            let userType = userTypeSegmentedControl.titleForSegmentAtIndex(
                userTypeSegmentedControl.selectedSegmentIndex)!
            setUpNewUser(userType)
        } else if signInMode == "Log In" {
            loginExistingUser()
        } else {
            print("Spelling error in code, should be title of segmented control")
        }
    }
    
    func setUpNewUser(userType: String) {
        let user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user["type"] = userType
        
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            guard error == nil else {
                if let errorString = error!.userInfo["error"] as? String {
                    self.displayAlert("Failed to sign up", message: errorString)
                } else {
                    self.displayAlert("Failed to sign up", message: "Try again later")
                }
                return
            }
            
            self.segueAfterSignupOrLogin(userType)
            
        }

    }
    func segueAfterSignupOrLogin(userType: String) {
        if userType == "Professor" {
            self.performSegueWithIdentifier("professorSegue", sender: nil)
        } else if userType == "Student" {
            self.performSegueWithIdentifier("studentSegue", sender: nil)
        } else {
            print("Error, userType should be Professor or Student")
        }

    }
    
    func loginExistingUser() {
        
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            guard error == nil else {
                if let errorString = error!.userInfo["error"] as? String {
                    self.displayAlert("Failed to log in", message: errorString)
                } else {
                    self.displayAlert("Failed to log in", message: "Try again later")
                }
                return
            }
            
            guard let userType = user?["type"] as? String else {
                print("Current user does not have type...that's weird")
                return
            }
            
            self.segueAfterSignupOrLogin(userType)
            
        }
    }
    
//    @IBAction func loginPressed(sender: UIButton) {
//       
//        if signupActive {
//            toggleBetweenSignupAndLoginMode("Log In",label: "Not registered?", loginButtonText: "Sign Up")
//        } else {
//            toggleBetweenSignupAndLoginMode("Sign Up",label: "Already Registered?", loginButtonText: "Log In")
//        }
//        
//    }
    
//    func toggleBetweenSignupAndLoginMode(mode: String, label: String, loginButtonText: String) {
//        signUpButton.setTitle(mode, forState: .Normal)
//        registeredText.text = label
//        loginButton.setTitle(loginButtonText, forState: .Normal)
//        signupActive = !signupActive
//    }
    
    func runActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    
    //I will leave this here for now but this is unnecessary since we can always get the current user from Parse
    //we do not need to pass it during the segue
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let segueIdentifier = segue.identifier
//        
//        if segueIdentifier == "professorSegue" {
//            guard let destination = segue.destinationViewController as? ProfessorCreateOrViewController else {
//                print("Error: Destination is not ProfessorCreateOrViewController")
//                return
//            }
//            
//            //We can force unwrap currentUser since we are sure we are logged in at this point
////            destination.user = PFUser.currentUser()!
//        } else if segueIdentifier == "studentSegue" {
//            guard let destination = segue.destinationViewController as? StudentChooseQueueViewController else {
//                print("Error: Destination is not StudentChooseQueueViewController")
//                return
//            }
//            
//            //We can force unwrap currentUser since we are sure we are logged in at this point
////            destination.user = PFUser.currentUser()!
//        }
//    }
    

    @IBAction func back(segue:UIStoryboardSegue){
        if let source = segue.sourceViewController as? LogInInfoViewController{
            guard let fn = source.firstName,
            ln = source.lastName,
            un = source.userName,
                pw = source.password1 else{
                    return
            }
            if source.image != nil{
                //you can put the image into parse
                print("picture obtained")
            }
           
            //you can now use fn, ln, un, pw, reason to input into parse
            print(fn, ln, un, pw)
        }
        //here is where we would code another unWind from another view if we need to
    }
    
    
}//end of class



