//
//  AppDelegate.swift
//  AppVidaSaludable
//
//  Created by RicardoTrevino on 4/12/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit
import RealmSwift
import SCLAlertView
import SwiftDate

let uiRealm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Elige el storyboard a desplegar
    func setStoryboard() {
        let storyboard : UIStoryboard = self.grabStoryboard()
        self.setInitialScreen(storyboard)
    }
    
    // Decide el storyboard a mostrar con base al tamaño de pantalla
    func grabStoryboard() -> UIStoryboard {
        let screenHeight : Int = Int(UIScreen.mainScreen().bounds.size.height)
        //print(screenHeight)
        
        var storyboard : UIStoryboard
        
        switch screenHeight {
        case 568:
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            break
        case 667:
            storyboard = UIStoryboard(name: "MainIPhone6", bundle: nil)
            break
        case 736:
            storyboard = UIStoryboard(name: "MainIPhone6Plus", bundle: nil)
            break
        default:
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        }
        
        return storyboard
    }
    
    // Decide la pantalla principal de la aplicación.
    // Por ejemplo si el usuario ya habia hecho login empieza en cierta pantalla
    // y si no presenta la de login.
    func setInitialScreen(storyboard : UIStoryboard) {
        var initViewController : UIViewController
        
        initViewController = storyboard.instantiateViewControllerWithIdentifier("First")
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = initViewController
        self.window?.makeKeyAndVisible()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.setStoryboard()
        
        // Override point for customization after application launch.
        let firstAction : UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        firstAction.identifier = "First_Action"
        firstAction.title = "Sí"
        firstAction.activationMode = UIUserNotificationActivationMode.Background
        firstAction.destructive = false
        firstAction.authenticationRequired = false
        
        
        let secondAction : UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        secondAction.identifier = "Second_Action"
        secondAction.title = "No"
        secondAction.activationMode = UIUserNotificationActivationMode.Background
        secondAction.destructive = true
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
        
        
        //MARK: Realm Migrations
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            // bump the schema version to 2
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                migration.enumerate(Actividades.className()) { oldObject, newObject in
                    // make sure to check the version accordingly
                    if (oldSchemaVersion < 2) {
                        // the magic happens here: `id` is the property you specified
                        // as your primary key on your Model
                        newObject!["Nombre"] = oldObject!["Nombre"]
                    }
                }
            }
        )
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
                print("Alimentación Sí")
                Act.Alimentacion = 1
                Act.Hidratacion = 0
                Act.ActividadFisica = 0
                Act.ActividadSocial = 0
            case "Hidratación":
                print("Hidratación Sí")
                Act.Alimentacion = 0
                Act.Hidratacion = 1
                Act.ActividadFisica = 0
                Act.ActividadSocial = 0
            case "Actividad Física":
                print("Actividad Física Sí")
                Act.Alimentacion = 0
                Act.Hidratacion = 0
                Act.ActividadFisica = 1
                Act.ActividadSocial = 0
            case "Actividad Social":
                print("Actividad Social Sí")
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
            //Write en tabla de acts realizadas un 2 en la categoria y 0 en las demás
            switch notification.alertTitle! {
            case "Alimentación":
                print("Alimentación No")
                Act.Alimentacion = 2
                Act.Hidratacion = 0
                Act.ActividadFisica = 0
                Act.ActividadSocial = 0
            case "Hidratación":
                print("Hidratación No")
                Act.Alimentacion = 0
                Act.Hidratacion = 2
                Act.ActividadFisica = 0
                Act.ActividadSocial = 0
            case "Actividad Física":
                print("Actividad Física No")
                Act.Alimentacion = 0
                Act.Hidratacion = 0
                Act.ActividadFisica = 2
                Act.ActividadSocial = 0
            case "Actividad Social":
                print("Actividad Social No")
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
        
        let hoy = NSDate()
        
      
        print("fecha")
        print(hoy)
        print("notification firedate")
        print(notification.fireDate!)
        let Act = ActividadRealizada()

        
        if (application.applicationState == UIApplicationState.Active ) {
            print("Entré al if active")
            if notification.fireDate! >= hoy {
                print("No entré al if fecha")

            }else{
                print("Entré al if fecha")
                
                let alertView = SCLAlertView()
                alertView.showCircularIcon = true
                alertView.showCloseButton = false
                var alertViewIcon: String = ""
                switch notification.alertTitle! {
                case "Alimentación":
                    alertViewIcon = "Alimentacion"
                case "Hidratación":
                    alertViewIcon = "Hidratacion"
                case "Actividad Física":
                    alertViewIcon = "Actividad Fisica"
                case "Actividad Social":
                    alertViewIcon = "Actividad Social"
                default:
                    break;
                }
               
                alertView.addButton("Sí"){
                    print("Sí")
                    switch notification.alertTitle! {
                    case "Alimentación":
                        print("Alimentación Sí")
                        Act.Alimentacion = 1
                        Act.Hidratacion = 0
                        Act.ActividadFisica = 0
                        Act.ActividadSocial = 0
                    case "Hidratación":
                        print("Hidratación Sí")
                        Act.Alimentacion = 0
                        Act.Hidratacion = 1
                        Act.ActividadFisica = 0
                        Act.ActividadSocial = 0
                    case "Actividad Física":
                        print("Actividad Física Sí")
                        Act.Alimentacion = 0
                        Act.Hidratacion = 0
                        Act.ActividadFisica = 1
                        Act.ActividadSocial = 0
                    case "Actividad Social":
                        print("Actividad Social Sí")
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
                    UIApplication.sharedApplication().cancelLocalNotification(notification)
                    //Borra arregloActivadadesHoy[0] (el primero, quien es el que ejecuta la notificacion)
                    
                }
                alertView.addButton("No") {
                    print("No")
                    switch notification.alertTitle! {
                    case "Alimentación":
                        print("Alimentación No")
                        Act.Alimentacion = 2
                        Act.Hidratacion = 0
                        Act.ActividadFisica = 0
                        Act.ActividadSocial = 0
                    case "Hidratación":
                        print("Hidratación No")
                        Act.Alimentacion = 0
                        Act.Hidratacion = 2
                        Act.ActividadFisica = 0
                        Act.ActividadSocial = 0
                    case "Actividad Física":
                        print("Actividad Física No")
                        Act.Alimentacion = 0
                        Act.Hidratacion = 0
                        Act.ActividadFisica = 2
                        Act.ActividadSocial = 0
                    case "Actividad Social":
                        print("Actividad Social No")
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

                }
                
                 alertView.showInfo(notification.alertBody!, subTitle: notification.alertTitle!, closeButtonTitle: "", duration: 30, colorStyle: 0x5995ED, colorTextButton: 0xFFFFFF, circleIconImage: UIImage(named: alertViewIcon))
//                alertView.showInfo(notification.alertBody!, subTitle: notification.alertTitle!, circleIconImage: alertViewIcon)

            }
        }else{
            print("No entré al if")
        }
        
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

