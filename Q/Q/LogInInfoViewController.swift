//
//  LogInInfoViewController.swift
//  FInalProject
//
//  Created by Archie on 11/17/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import UIKit

class LogInInfoViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBAction func cancel(sender: UIBarButtonItem) {
    }
    
    @IBAction func signUp(sender: UIBarButtonItem) {
    }
    
    
    //fires when image is tapped on
    @IBAction func tapped(sender: UITapGestureRecognizer) {
        
        
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
