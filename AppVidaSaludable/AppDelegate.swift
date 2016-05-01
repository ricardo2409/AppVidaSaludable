//
//  AppDelegate.swift
//  AppVidaSaludable
//
//  Created by RicardoTrevino on 4/12/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit
import RealmSwift

let uiRealm = try! Realm()

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
        secondAction.activationMode = UIUserNotificationActivationMode.Background
        secondAction.destructive = false
        secondAction.authenticationRequired = false
        
        
        
        //categories
        
        let firstCategory : UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        firstCategory.identifier = "First_Cat"
        let defaultActions:NSArray = [firstAction, secondAction]
        let minimalActions:NSArray = [firstAction, secondAction]
        
        firstCategory.setActions((defaultActions as! [UIUserNotificationAction]), forContext: UIUserNotificationActionContext.Default)
        firstCategory.setActions((minimalActions as! [UIUserNotificationAction]), forContext: UIUserNotificationActionContext.Minimal)
        
        //NSSet of all cats
        
        let categories: NSSet = NSSet(object: firstCategory)
        
        
        let types: UIUserNotificationType = UIUserNotificationType.Alert.union(UIUserNotificationType.Badge).union(UIUserNotificationType.Sound)
        let mySettings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categories as? Set<UIUserNotificationCategory>)
        UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)

        // Cambiar colores de barras
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.whiteColor() // Back buttons and such
        navigationBarAppearace.barTintColor = UIColor(red: 89/255, green: 149/255, blue: 237/255, alpha: 1)  // Bar's background color
        
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]  // Title's text color
        
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor(red: 4/255, green: 67/255, blue: 137/255, alpha: 1)
        tabBarAppearance.barTintColor = UIColor(red: 89/255, green: 149/255, blue: 237/255, alpha: 1)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 4/255, green: 67/255, blue: 137/255, alpha: 1)], forState:.Selected)
        
        
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.separatorColor = UIColor(red: 89/255, green: 149/255, blue: 237/255, alpha: 1)
        tableViewAppearance.tintColor = UIColor(red: 4/255, green: 67/255, blue: 137/255, alpha: 1)
        
        
        return true
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        let Act = ActividadRealizada()

        if identifier == "First_Action"{
            
            NSNotificationCenter.defaultCenter().postNotificationName("actionOnePressed", object: nil)
            
            //Write en tabla de acts realizadas un 1 en la categoria y 0 en las demás
            print(notification.alertTitle!)
            switch notification.alertTitle! {
            case "Alimentación":
                print("Alimentación")
                Act.Alimentacion = 1
                Act.Hidratacion = 0
                Act.ActividadFisica = 0
                Act.ActividadSocial = 0
            case "Hidratación":
                print("Hidratación")
                Act.Alimentacion = 0
                Act.Hidratacion = 1
                Act.ActividadFisica = 0
                Act.ActividadSocial = 0
            case "Actividad Física":
                print("Actividad Físicaa")
                Act.Alimentacion = 0
                Act.Hidratacion = 0
                Act.ActividadFisica = 1
                Act.ActividadSocial = 0
            case "Actividad Social":
                print("Actividad Social")
                Act.Alimentacion = 0
                Act.Hidratacion = 0
                Act.ActividadFisica = 0
                Act.ActividadSocial = 1

            default:
                break
            }
            try! uiRealm.write{
                uiRealm.add(Act)
            }

            
        }else if identifier == "Second_Action"{
            
            NSNotificationCenter.defaultCenter().postNotificationName("actionTwoPressed", object: nil)
            //Write en tabla de acts realizadas un 0 en la categoria y 0 en las demás
            switch notification.alertTitle! {
            case "Alimentación":
                print("Alimentación")
                Act.Alimentacion = 2
                Act.Hidratacion = 0
                Act.ActividadFisica = 0
                Act.ActividadSocial = 0
            case "Hidratación":
                print("Hidratación")
                Act.Alimentacion = 0
                Act.Hidratacion = 2
                Act.ActividadFisica = 0
                Act.ActividadSocial = 0
            case "Actividad Física":
                print("Actividad Físicaa")
                Act.Alimentacion = 0
                Act.Hidratacion = 0
                Act.ActividadFisica = 2
                Act.ActividadSocial = 0
            case "Actividad Social":
                print("Actividad Social")
                Act.Alimentacion = 0
                Act.Hidratacion = 0
                Act.ActividadFisica = 0
                Act.ActividadSocial = 2
                
            default:
                break
            }
            try! uiRealm.write{
                uiRealm.add(Act)
            }

            //Snooze
            
//            notification.fireDate = NSDate().dateByAddingTimeInterval(600)
//            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
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
//        let tabBarController = self.window?.rootViewController as! UITabBarController
//        tabBarController.selectedIndex = 1
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

