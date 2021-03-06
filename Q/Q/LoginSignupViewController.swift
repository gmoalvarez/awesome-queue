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

    
    override func viewDidAppear(animated: Bool) {
        if let user = PFUser.currentUser() {
            print("Currently logged in as:\(user.username)")
            if let userType = user["type"] as? String{
                activityIndicator.stopAnimating()
                self.segueAfterSignupOrLogin(userType)
            }
        }
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var theTitle: UILabel!
   
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func tapBackground(sender: UITapGestureRecognizer) {
        view.endEditing(true)   
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
    
    @IBAction func loginPressed(sender: UIButton) {
        runActivityIndicator()
        loginExistingUser()
    }
    
    func loginExistingUser() {
        
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            guard error == nil else {
                self.displayErrorString(error, messageTitle: "Failed to log in")
                return
            }
            
            guard let userType = user?["type"] as? String else {
                print("Current user does not have type...that's weird")
                return
            }
            self.activityIndicator.stopAnimating()

            self.segueAfterSignupOrLogin(userType)
            
        }
    }
    
    func runActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Sign up new user data
    @IBAction func loginBack(segue:UIStoryboardSegue){
        self.activityIndicator.stopAnimating()
        if let source = segue.sourceViewController as? LogInInfoViewController{
            guard let firstName = source.firstName,
                lastName = source.lastName,
                email = source.email,
                userName = source.userName,
                userType = source.userType,
                password = source.password1 else{
                    print("Error retrieving fields from signup page")
                 
                    return
            }
            
            //Set up new user
            let user = PFUser()
            user.username = userName
            user.password = password
            user.email = email
            user["firstName"] = firstName
            user["lastName"] = lastName
            user["type"] = userType
            
            
            user.signUpInBackgroundWithBlock { success, error in
                guard error == nil else {
                    self.displayErrorString(error, messageTitle: "Failed to sign up")
                    return
                }
                
                if let image = source.image {
                    let compression:CGFloat = 0.8
                    guard let imageData = UIImageJPEGRepresentation(image, compression) else {
                        print("Could not convert image into data")
                        return
                    }
                    
                    guard let imageFile = PFFile(name: "profile.jpg", data: imageData) else {
                        print("Could not convert image file to Parse file")
                        return
                    }
                    
                    user["picture"] = imageFile
                    user.saveInBackground()
                }
                
                self.segueAfterSignupOrLogin(userType)
            }
            
        }
        
        if let _ = segue.sourceViewController as? ProfessorCreateOrViewController{
            PFUser.logOut()
            print("logged out of prof")
        }
        
        if let source = segue.sourceViewController as? StudentViewController{
            PFUser.logOut()
            if let timer1 = source.timer1{
                timer1.invalidate()
            }
            print("logout of student")
            PFQuery.clearAllCachedResults()
        }
        
        
        
        
        //here is where we would code another unWind from another view if we need to
        if let _ = segue.sourceViewController as? StudentViewController{
            print(PFUser.currentUser())//testing
            usernameTextField.text = ""
            passwordTextField.text = ""
        }
        if let _ = segue.sourceViewController as? ProfessorCreateOrViewController{
            print(PFUser.currentUser())//testing
            usernameTextField.text = ""
            passwordTextField.text = ""
        }
    }
    
    
}//end of class



