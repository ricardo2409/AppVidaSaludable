//
//  TableViewControllerHoy.swift
//  AppVidaSaludable
//
//  Created by Fabian Montemayor on 4/12/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit
import AlarmKit
import SCLAlertView

class TableViewControllerHoy: UITableViewController {
    
    // REUSE IDENTIFIER: "idCelda"
    var arregloActividades: [Actividad] = []
    var arregloActividadesHoy: [Actividad] = []
    var alarm: AlarmKit.Alarm!

    @IBOutlet weak var navigationbar: UINavigationBar!
    // MARK: - Funciones

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hoy"
        let barViewControllers = self.tabBarController?.viewControllers
        let navigation = barViewControllers![1] as! UINavigationController
        let tvca = navigation.topViewController as! TableViewControllerActividades
        arregloActividades = tvca.arregloActividades
        print("Viewdidloadhoy")
        print(arregloActividades)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
        let fecha: NSDate = NSDate()
        let formato: NSDateFormatter = NSDateFormatter()
        formato.dateFormat = "EEEE"
        let dia: String = formato.stringFromDate(fecha)
        print(dia)
        
        //        for i in 0...arregloActividadesHoy.count - 1
        //        {
       
       diaEnTitulo(dia)
      
        }
    func diaEnTitulo(dia : String){
        switch dia {
        case "Monday":
            self.navigationbar.topItem?.title = "Lunes"
        case "Tuesday":
            self.navigationbar.topItem?.title = "Martes"
        case "Wednesday":
            self.navigationbar.topItem?.title = "Miércoles"
        case "Thursday":
            self.navigationbar.topItem?.title = "Jueves"
        case "Friday":
            self.navigationbar.topItem?.title = "Viernes"
        case "Saturday":
            self.navigationbar.topItem?.title = "Sábado"
        case "Sunday":
            self.navigationbar.topItem?.title = "Domingo"
        default:
            break
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Viewdidappear")
        
        let fecha: NSDate = NSDate()
        let formato: NSDateFormatter = NSDateFormatter()
        formato.dateFormat = "EEEE"
        let dia: String = formato.stringFromDate(fecha)
        print(dia)
        
        let barViewControllers = self.tabBarController?.viewControllers
        let navigation = barViewControllers![1] as! UINavigationController
        let tvca = navigation.topViewController as! TableViewControllerActividades
        arregloActividades = tvca.arregloActividades
        print(arregloActividades)
        
        //Borra lo que ya tenía antes
        arregloActividadesHoy = []
        print("Las actividades de hoy")
        for i in 0...arregloActividades.count - 1 {
            for j in 0...arregloActividades[i].frecuencia.count - 1{
                if arregloActividades[i].frecuencia[j] == dia{
                    arregloActividadesHoy.append(arregloActividades[i])
                    print(arregloActividades[i].nombre)

                    
                }
            }
        }
        tableView.reloadData()

        //Sort por hora y minutos
        arregloActividadesHoy.sortInPlace({ $0.hora * 60 + $0.minutos  < $1.hora * 60 + $1.minutos })
        print("arreglo sorteado por hora y minutos")
        for i in 0...arregloActividadesHoy.count - 1 {
            print(arregloActividadesHoy[i].nombre)
        }
        print(arregloActividadesHoy)
        
        
        //Poner alarmas aquí
        
//        let notification = UILocalNotification()
//        notification.alertBody = "Your Daily Motivation is Awaits"
//        // You should set also the notification time zone otherwise the fire date is interpreted as an absolute GMT time
//        notification.timeZone = NSTimeZone.localTimeZone()
//        // you can simplify setting your fire date using dateByAddingTimeInterval
//        notification.fireDate = NSDate().dateByAddingTimeInterval(1800)
//        // set the notification property before scheduleLocalNotification
//        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        
        despliegaAlarma()

    }
    
    func despliegaAlarma(){
        for i in 0...arregloActividadesHoy.count - 1 {
            self.alarm = AlarmKit.Alarm(hour:arregloActividadesHoy[i].hora, minute:arregloActividadesHoy[i].minutos, {
                debugPrint("Alarm triggered!")
                let alertView = SCLAlertView()
                alertView.showCloseButton = false
                
                alertView.addButton("Ya lo hice"){
                    //Hacer algo con este valor
                    print("Ya lo hice")
                    //Actividad se borra de la tabla
                    self.arregloActividadesHoy.removeAtIndex(i)
                    self.tableView.reloadData()
                    
                }
                alertView.addButton("No lo he hecho") {
                    //Hacer algo con este valor
                    //Reprogramar la alarma
                    print("No lo he hecho")
                }
                alertView.showSuccess(self.arregloActividadesHoy[i].nombre, subTitle: self.arregloActividadesHoy[i].categoria)
            })
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        return arregloActividadesHoy.count
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nombreImagen: String!
        let cell = tableView.dequeueReusableCellWithIdentifier("idCelda", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = arregloActividadesHoy[indexPath.row].nombre
        if arregloActividadesHoy[indexPath.row].minutos < 10{
            print("menor de 10")
            cell.detailTextLabel!.text! = String(arregloActividadesHoy[indexPath.row].hora) + ":0" + String(arregloActividadesHoy[indexPath.row].minutos)
        }else{
            cell.detailTextLabel!.text = String(arregloActividadesHoy[indexPath.row].hora) + ":" + String(arregloActividadesHoy[indexPath.row].minutos)
        }
        
        switch (arregloActividadesHoy[indexPath.row].categoria)
        {
        case "Hidratación":
            nombreImagen = "vaso"
            break
        case "Alimentación":
            nombreImagen = "manzanaTrans"
            break
        case "Actividad Física":
            nombreImagen = "ejercicio"
            break
        case "Actividad Social":
            nombreImagen = "amigos2"
            break
        default:
            break
            
        }
        
        cell.imageView!.image = UIImage(named: nombreImagen)
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
