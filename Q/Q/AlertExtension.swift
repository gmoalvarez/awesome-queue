//
//  Alert.swift
//  FInalProject
//
//  Created by Guillermo on 11/19/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func displayErrorString(error:NSError?) {
        if let errorString = error?.userInfo["error"] as? String {
            self.displayAlert("Error", message: errorString)
        } else {
            self.displayAlert("Error", message: "Try again later")
        }

    }

}