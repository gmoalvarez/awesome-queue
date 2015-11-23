//
//  AppDelegate.swift
//  Q
//
//  Created by Archie on 10/23/15.
//  Copyright © 2015 SquirrelApps. All rights reserved.
//

import UIKit
import Parse
import Bolts


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("K420nRVqjjS1hYLtMBA48U5wK4GWQXGjgTip6rZu",
            clientKey: "am0Zq157v8j1nEHjWzsVRO1L90XjeFGln59K5TO2")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController = UIViewController()
        if let user = PFUser.currentUser() {
            print("Currently logged in:\(user.username)")
            if let userType = user["type"] as? String {
                if userType == "Student" {
                    viewController = storyboard.instantiateViewControllerWithIdentifier("student")
                } else if userType == "Professor" {
                    viewController = storyboard.instantiateViewControllerWithIdentifier("professor")
                } else {
                    print("Error, there was a user logged in but it is not Student or Professor")
                    return false
                }
            }
        } else {
            viewController = storyboard.instantiateViewControllerWithIdentifier("loginSignup")
        }
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.window?.rootViewController = viewController
        
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

