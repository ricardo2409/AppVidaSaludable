//
//  AppDelegate.swift
//  AppVidaSaludable
//
//  Created by RicardoTrevino on 4/12/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let firstAction : UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        firstAction.identifier = "First_Action"
        firstAction.title = "Sí"
        firstAction.activationMode = UIUserNotificationActivationMode.Background
        firstAction.destructive = true
        firstAction.authenticationRequired = false
        
        
        let secondAction : UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        secondAction.identifier = "Second_Action"
        secondAction.title = "No"
        secondAction.activationMode = UIUserNotificationActivationMode.Foreground
        secondAction.destructive = false
        secondAction.authenticationRequired = false
        
        let thirdAction : UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        thirdAction.identifier = "Third_Action"
        thirdAction.title = "Third Action"
        thirdAction.activationMode = UIUserNotificationActivationMode.Background
        thirdAction.destructive = false
        thirdAction.authenticationRequired = false
        
        //categories
        
        let firstCategory : UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        firstCategory.identifier = "First_Cat"
        let defaultActions:NSArray = [firstAction, secondAction, thirdAction]
        let minimalActions:NSArray = [firstAction, secondAction]
        
        firstCategory.setActions((defaultActions as! [UIUserNotificationAction]), forContext: UIUserNotificationActionContext.Default)
        firstCategory.setActions((minimalActions as! [UIUserNotificationAction]), forContext: UIUserNotificationActionContext.Minimal)
        
        //NSSet of all cats
        
        let categories: NSSet = NSSet(object: firstCategory)
        
        
        let types: UIUserNotificationType = UIUserNotificationType.Alert.union(UIUserNotificationType.Badge).union(UIUserNotificationType.Sound)
        let mySettings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categories as? Set<UIUserNotificationCategory>)
        UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)

        
        return true
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        if identifier == "First_Action"{
            
            NSNotificationCenter.defaultCenter().postNotificationName("actionOnePressed", object: nil)
            
        }else if identifier == "Second_Action"{
            
            NSNotificationCenter.defaultCenter().postNotificationName("actionTwoPressed", object: nil)
            
            
        }
        completionHandler()
    }
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
//        var topController : UIViewController = (application.keyWindow?.rootViewController)!
//        
//        while ((topController.presentedViewController) != nil) {
//            
//            topController = topController.presentedViewController!
//        }
//        
//        let alert = UIAlertController(title: "Alerta", message: notification.alertBody, preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in}))
//        
//        topController.presentViewController(alert, animated: true, completion: nil)

        
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
        
        //Empieza en la segunda tab mientras se crea la base de datos y se carga la información desde ahí
        let tabBarController = self.window?.rootViewController as! UITabBarController
        tabBarController.selectedIndex = 1
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDidFinishLaunching(application: UIApplication) {
        if !NSUserDefaults.standardUserDefaults().boolForKey("InfoUsuario") {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "InfoUsuario")
        }
    }


}

