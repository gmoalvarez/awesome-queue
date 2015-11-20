//
//  LogInInfoViewController.swift
//  FInalProject
//
//  Created by Archie on 11/17/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import UIKit

class LogInInfoViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate {
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passWordText: UITextField!
    @IBOutlet weak var password2Text: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var passwordsError: UILabel!
    
    var image:UIImage?
    var firstName:String?
    var lastName:String?
    var userName:String?
    var password1:String?
    var password2:String?
    
    
    @IBAction func touchBackground(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBAction func cancel(sender: UIBarButtonItem) {
        performSegueWithIdentifier("backToLogIn", sender: self)
        
    }
    
    @IBAction func signUp(sender: UIBarButtonItem) {
        passwordsError.hidden = true
        errorMessage.hidden = true
        if firstNameText.text == "" ||
            lastNameText.text == "" ||
            userNameText.text == "" ||
            passWordText.text == "" ||
            password2Text.text == "" {
                errorMessage.hidden = false
                return
        }
        if passWordText.text != password2Text.text {
            passwordsError.hidden = false
            return
        }
        setValuesToPassBack()
        performSegueWithIdentifier("backToLogIn", sender: self)
    }
    
    func setValuesToPassBack(){
        //self.image = image
        firstName = firstNameText.text
        lastName = lastNameText.text
        userName = userNameText.text
        password1 = passWordText.text
        password2 = password2Text.text
    }
    
    
    //fires when image is tapped on
    @IBAction func tapped(sender: UITapGestureRecognizer) {
        print("tapped")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        firstNameText.delegate = self
        lastNameText.delegate = self
        userNameText.delegate = self
        password2Text.delegate = self
        passWordText.delegate = self
        errorMessage.hidden = true
        passwordsError.hidden = true
        // Do any additional setup after loading the view.
      
    }
    
    func testTimer(){
        print("yes")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.

    }
    
    @IBAction func back(segue:UIStoryboardSegue){
    }
    
}

//test
