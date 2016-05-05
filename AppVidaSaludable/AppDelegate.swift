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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(86400)

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
        
//        UIApplication.setMinimumBackgroundFetchInterval(100)
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
    var diaDeHoy : String!

    func getDiaDeHoy(){

        let fecha: NSDate = NSDate()
        let formato: NSDateFormatter = NSDateFormatter()
        formato.dateFormat = "EEEE"
        diaDeHoy = formato.stringFromDate(fecha)
        switch diaDeHoy {
        case "Monday":
            diaDeHoy = "Lu"
        case "Tuesday":
            diaDeHoy = "Ma"
        case "Wednesday":
            diaDeHoy = "Mi"
        case "Thursday":
            diaDeHoy = "Ju"
        case "Friday":
            diaDeHoy = "Vi"
        case "Saturday":
            diaDeHoy = "Sa"
        case "Sunday":
            diaDeHoy = "Do"
        default:
            break
        }
        print(diaDeHoy)
    }
    func getMonth() -> Int{
        let fecha: NSDate = NSDate()
        let formato7: NSDateFormatter = NSDateFormatter()
        formato7.dateFormat = "MM"
        let month: String = formato7.stringFromDate(fecha)
        print("este es el mes")
        print(month)
        return Int(month)!
    }
    func getYear() -> Int{
        let fecha: NSDate = NSDate()
        let formato5: NSDateFormatter = NSDateFormatter()
        formato5.dateFormat = "yyyy"
        let year: String = formato5.stringFromDate(fecha)
        print("Este es el año")
        print(year)
        return Int(year)!
    }
    func getDay() -> Int{
        let fecha: NSDate = NSDate()
        let formato6: NSDateFormatter = NSDateFormatter()
        formato6.dateFormat = "dd"
        let day: String = formato6.stringFromDate(fecha)
        print("Este es el dia")
        print(day)
        return Int(day)!
        
    }
    func creaNotificaciones(){
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        var notifyArray = UIApplication.sharedApplication().scheduledLocalNotifications
        print("Cantidad de notificaciones:")
        print(notifyArray!.count)
        
        if ActividadesHoy!.count > 0{
            for i in 0...ActividadesHoy!.count - 1{
                
                let dateComp: NSDateComponents = NSDateComponents()
                dateComp.year = getYear()
                dateComp.month = getMonth()
                dateComp.day = getDay()
                dateComp.hour = ActividadesHoy![i].Hora
                dateComp.minute = ActividadesHoy![i].Minutos
                dateComp.timeZone = NSTimeZone.systemTimeZone()
                
                let calendar : NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
                let date : NSDate = calendar.dateFromComponents(dateComp)!
                let notification : UILocalNotification = UILocalNotification()
                notification.category = "First_Cat"
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.alertBody = ActividadesHoy![i].Nombre
                notification.alertTitle = ActividadesHoy![i].Categoria
                notification.fireDate = date
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                print("Esta es la notificacion que creé ")
              
                
            }
        }else{
            print("Está vacío")
        }
        
        notifyArray = UIApplication.sharedApplication().scheduledLocalNotifications
        print("Cantidad de notificaciones creadas:")
        print(notifyArray!.count)
    }
    var ActividadesHoy:Results<Actividades>?

    func fetchData(){
        getDiaDeHoy()
            ActividadesHoy = uiRealm.objects(Actividades).filter("Frecuencia CONTAINS %@", diaDeHoy)
    }
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.NewData)
        fetchData()
        creaNotificaciones()
    }
    
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        let Act = ActividadRealizada()

        if identifier == "First_Action"{
            
            NSNotificationCenter.defaultCenter().postNotificationName("actionOnePressed", object: nil)
            
            //Write en tabla de acts realizadas un 1 en la categoria y 0 en las demás
            print(notification.alertTitle!)
            var ActividadAlerta:Results<Actividades>?
            
            ActividadAlerta = uiRealm.objects(Actividades).filter("Nombre == %@",notification.alertBody!)
            try! uiRealm.write {
                ActividadAlerta![0].snoozeCount = 0
            }
            switch notification.alertTitle! {
            case "Alimentación":
                print("Alimentación Sí")
                Act.Alimentacion = 1
                Act.Hidratacion = 0
                Act.ActividadFisica = 0
                Act.ActividadSocial = 0
                break
            case "Hidratación":
                print("Hidratación Sí")
                Act.Alimentacion = 0
                Act.Hidratacion = 1
                Act.ActividadFisica = 0
                Act.ActividadSocial = 0
                break
            case "Actividad Física":
                print("Actividad Física Sí")
                Act.Alimentacion = 0
                Act.Hidratacion = 0
                Act.ActividadFisica = 1
                Act.ActividadSocial = 0
                break
            case "Actividad Social":
                print("Actividad Social Sí")
                Act.Alimentacion = 0
                Act.Hidratacion = 0
                Act.ActividadFisica = 0
                Act.ActividadSocial = 1
                break
            default:
                break
            }
            try! uiRealm.write{
                uiRealm.add(Act)
            }

            
        }else if identifier == "Second_Action"{
            
            NSNotificationCenter.defaultCenter().postNotificationName("actionTwoPressed", object: nil)
            var ActividadAlerta:Results<Actividades>?
            ActividadAlerta = uiRealm.objects(Actividades).filter("Nombre == %@",notification.alertBody!)
            
            if ActividadAlerta![0].snoozeCount < 2 {
                try! uiRealm.write {
                    ActividadAlerta![0].snoozeCount += 1
                }
                // REPROGRAMA 10min mas
                notification.fireDate = NSDate().dateByAddingTimeInterval(10)
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
            else {
                try! uiRealm.write {
                    ActividadAlerta![0].snoozeCount = 0
                }
            //Write en tabla de acts realizadas un 2 en la categoria y 0 en las demás
            switch notification.alertTitle! {
            case "Alimentación":
                print("Alimentación No")
                Act.Alimentacion = 2
                Act.Hidratacion = 0
                Act.ActividadFisica = 0
                Act.ActividadSocial = 0
                break
            case "Hidratación":
                print("Hidratación No")
                Act.Alimentacion = 0
                Act.Hidratacion = 2
                Act.ActividadFisica = 0
                Act.ActividadSocial = 0
                break
            case "Actividad Física":
                print("Actividad Física No")
                Act.Alimentacion = 0
                Act.Hidratacion = 0
                Act.ActividadFisica = 2
                Act.ActividadSocial = 0
                break
            case "Actividad Social":
                print("Actividad Social No")
                Act.Alimentacion = 0
                Act.Hidratacion = 0
                Act.ActividadFisica = 0
                Act.ActividadSocial = 2
                break
            default:
                break
            }
               
                
            try! uiRealm.write{
                uiRealm.add(Act)
            }

            }
            
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
                    var ActividadAlerta:Results<Actividades>?
                    
                    ActividadAlerta = uiRealm.objects(Actividades).filter("Nombre == %@",notification.alertBody!)
                    try! uiRealm.write {
                        ActividadAlerta![0].snoozeCount = 0
                    }
                    
                    switch notification.alertTitle! {
                    case "Alimentación":
                        print("Alimentación Sí")
                        Act.Alimentacion = 1
                        Act.Hidratacion = 0
                        Act.ActividadFisica = 0
                        Act.ActividadSocial = 0
                        break
                    case "Hidratación":
                        print("Hidratación Sí")
                        Act.Alimentacion = 0
                        Act.Hidratacion = 1
                        Act.ActividadFisica = 0
                        Act.ActividadSocial = 0
                        break
                    case "Actividad Física":
                        print("Actividad Física Sí")
                        Act.Alimentacion = 0
                        Act.Hidratacion = 0
                        Act.ActividadFisica = 1
                        Act.ActividadSocial = 0
                        break
                    case "Actividad Social":
                        print("Actividad Social Sí")
                        Act.Alimentacion = 0
                        Act.Hidratacion = 0
                        Act.ActividadFisica = 0
                        Act.ActividadSocial = 1
                        break
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
                    var ActividadAlerta:Results<Actividades>?
                    ActividadAlerta = uiRealm.objects(Actividades).filter("Nombre == %@",notification.alertBody!)
                    
                    if ActividadAlerta![0].snoozeCount < 2 {
                        try! uiRealm.write {
                            ActividadAlerta![0].snoozeCount += 1
                        }
                        // REPROGRAMA 10min mas
                        notification.fireDate = NSDate().dateByAddingTimeInterval(10)
                        UIApplication.sharedApplication().scheduleLocalNotification(notification)
                    }
                    else {
                        try! uiRealm.write {
                            ActividadAlerta![0].snoozeCount = 0
                        }
                        
                        switch notification.alertTitle! {
                        case "Alimentación":
                            print("Alimentación No")
                            Act.Alimentacion = 2
                            Act.Hidratacion = 0
                            Act.ActividadFisica = 0
                            Act.ActividadSocial = 0
                            break
                        case "Hidratación":
                            print("Hidratación No")
                            Act.Alimentacion = 0
                            Act.Hidratacion = 2
                            Act.ActividadFisica = 0
                            Act.ActividadSocial = 0
                            break
                        case "Actividad Física":
                            print("Actividad Física No")
                            Act.Alimentacion = 0
                            Act.Hidratacion = 0
                            Act.ActividadFisica = 2
                            Act.ActividadSocial = 0
                            break
                        case "Actividad Social":
                            print("Actividad Social No")
                            Act.Alimentacion = 0
                            Act.Hidratacion = 0
                            Act.ActividadFisica = 0
                            Act.ActividadSocial = 2
                            break
                        default:
                            break
                        }
                    }
                    try! uiRealm.write{
                        uiRealm.add(Act)
                    }
                    
                    
                    
                   
                    

                }
                
                 alertView.showInfo(notification.alertBody!, subTitle: notification.alertTitle!, closeButtonTitle: "", duration: 30, colorStyle: 0x5995ED, colorTextButton: 0xFFFFFF, circleIconImage: UIImage(named: alertViewIcon))


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

