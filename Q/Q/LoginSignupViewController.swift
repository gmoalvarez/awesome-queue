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

    var signupActive = true
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registeredText: UILabel!
    
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func signupPressed(sender: UIButton) {
        
        guard usernameTextField.text != "" &&
            passwordTextField.text != "" &&
        userTypeSegmentedControl.selectedSegmentIndex != -1 else {
                
                displayAlert("Empty Field(s)",
                    message: "Please enter a username, password, and select user type")
                return
        }
        
        runActivityIndicator()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if signupActive {
            setUpNewUser()
        } else {
            loginExistingUser()
        }
        
        
        
    }
    
    func setUpNewUser() {
        let user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user["type"] = userTypeSegmentedControl.titleForSegmentAtIndex(
            userTypeSegmentedControl.selectedSegmentIndex)
        
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
            
            //TODO: - successfully signed up, segue to appropriate view
            print("Sign up successful")
            
        }

    }
    
    func loginExistingUser() {
        
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!) { (user, error) -> Void in
            
            guard error == nil else {
                if let errorString = error!.userInfo["error"] as? String {
                    self.displayAlert("Failed to log in", message: errorString)
                } else {
                    self.displayAlert("Failed to log in", message: "Try again later")
                }
                return
            }
            
            
            
        }
    }
    
    @IBAction func loginPressed(sender: UIButton) {
       
        if signupActive {
            toggleBetweenSignupAndLoginMode("Log In",label: "Not registered?", loginButtonText: "Sign Up")
        } else {
            toggleBetweenSignupAndLoginMode("Sign Up",label: "Already Registered?", loginButtonText: "Log In")
        }
        
    }
    
    func toggleBetweenSignupAndLoginMode(mode: String, label: String, loginButtonText: String) {
        signUpButton.setTitle(mode, forState: .Normal)
        registeredText.text = label
        loginButton.setTitle(loginButtonText, forState: .Normal)
        signupActive = !signupActive
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
