//
//  TableViewControllerActividades.swift
//  AppVidaSaludable
//
//  Created by Fabian Montemayor on 4/12/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit
import SCLAlertView
import RealmSwift
import DZNEmptyDataSet
class TableViewControllerActividades: UITableViewController {
    
    // REUSE IDENTIFIER: "idCelda"
    @IBOutlet weak var tableview: UITableView!
    
    var arregloActividades : [Actividad] = []
    var nuevaActividad : Actividad!
    var nuevaActividadEditar : Actividad!
    var controlAgregar: Bool = false
    var controlEditar: Bool = false
    var actividadAMandar: Actividad!
    var arregloActividadesHoy: [Actividad] = []
    var diaDeHoy : String!
    var indiceDeEditar: Int!

    // MARK: - Outlets
    @IBOutlet weak var botonAgregar: UIBarButtonItem!
    
    
    // MARK: - Funciones

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.allowsSelectionDuringEditing = true
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        llenaArreglo()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        tableView.reloadData()
        
        tableview.tableFooterView = UIView()
    }
    
    
    func getMonth() -> Int{
        let fecha: NSDate = NSDate()
        let formato7: NSDateFormatter = NSDateFormatter()
        formato7.dateFormat = "MM"
        let month: String = formato7.stringFromDate(fecha)
        return Int(month)!
    }
    func getYear() -> Int{
        let fecha: NSDate = NSDate()
        let formato5: NSDateFormatter = NSDateFormatter()
        formato5.dateFormat = "yyyy"
        let year: String = formato5.stringFromDate(fecha)
        return Int(year)!
    }
    func getDay() -> Int{
        let fecha: NSDate = NSDate()
        let formato6: NSDateFormatter = NSDateFormatter()
        formato6.dateFormat = "dd"
        let day: String = formato6.stringFromDate(fecha)
        return Int(day)!
        
    }

    
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
    }
    func llenaArregloHoy(){
        let hora = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        let min = NSCalendar.currentCalendar().component(.Minute, fromDate: NSDate())
       //Pedir a base de datos las actividades guardadas!
        getDiaDeHoy()
        var ActividadesHoyIgual:Results<Actividades>?
        var Acts:Results<Actividades>?
        ActividadesHoyIgual = uiRealm.objects(Actividades).filter("Frecuencia CONTAINS %@ AND Hora == %@ AND Minutos > %@ OR Frecuencia CONTAINS %@ AND Hora > %@", diaDeHoy, hora, min, diaDeHoy, hora)
        Acts = ActividadesHoyIgual!.sorted([SortDescriptor(property: "Hora"), "Minutos"])
        let cont = (Acts?.count)
        arregloActividadesHoy = []
        if(cont > 0)
        {
            for i in 0...cont! - 1
            {
                let Nombre = String(Acts![i].Nombre)
                let Categoria = String(Acts![i].Categoria)
                let Frecuencia = Acts![i].Frecuencia
                let Hora = Int(Acts![i].Hora)
                let Min = Int(Acts![i].Minutos)
                let actividad = Actividad(nom: Nombre, cat: Categoria, h: Hora, m: Min, frec: [Frecuencia])
                self.arregloActividadesHoy.append(actividad)
            }
        }else{
        }
 
        
    }
    
    func creaNotificaciones(){
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        var notifyArray = UIApplication.sharedApplication().scheduledLocalNotifications
        
        
        if arregloActividadesHoy.count > 0{
            for i in 0...arregloActividadesHoy.count - 1{
                
                let dateComp: NSDateComponents = NSDateComponents()
                dateComp.year = getYear()
                dateComp.month = getMonth()
                dateComp.day = getDay()
                dateComp.hour = arregloActividadesHoy[i].hora
                dateComp.minute = arregloActividadesHoy[i].minutos
                dateComp.timeZone = NSTimeZone.systemTimeZone()
                
                let calendar : NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
                let date : NSDate = calendar.dateFromComponents(dateComp)!
                let notification : UILocalNotification = UILocalNotification()
                notification.category = "First_Cat"
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.alertBody = arregloActividadesHoy[i].nombre
                notification.alertTitle = arregloActividadesHoy[i].categoria
                notification.repeatInterval = NSCalendarUnit.Weekday

                notification.fireDate = date
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
               
                
            }
        }else{
        }
        
        notifyArray = UIApplication.sharedApplication().scheduledLocalNotifications
        
    }


    override func viewDidAppear(animated: Bool) {
        self.tableView.separatorColor = UIColor(red: 89/255, green: 149/255, blue: 237/255, alpha: 1)
        getDiaDeHoy()
        llenaArregloHoy()
        creaNotificaciones()
        //Saca arregloActividadesHoy de Hoy para crear las notificaciones
//        let barViewControllers = self.tabBarController?.viewControllers
//        let svc = barViewControllers![0] as! TableViewControllerHoy
//        svc.arregloActividadesHoy = self.arregloActividadesHoy
        
    }
 
    func llenaArreglo(){
        //Pedir a base de datos las actividades guardadas! 
        var Acts:Results<Actividades>?
        Acts = uiRealm.objects(Actividades)
        let cont = (Acts?.count)
        arregloActividades = []
        if(cont > 0)
        {
            for i in 0...cont! - 1
            {
                let Nombre = String(Acts![i].Nombre)
                let Categoria = String(Acts![i].Categoria)
                let Frecuencia = Acts![i].Frecuencia
                let Hora = Int(Acts![i].Hora)
                let Min = Int(Acts![i].Minutos)
                let actividad = Actividad(nom: Nombre, cat: Categoria, h: Hora, m: Min, frec: [Frecuencia])
                self.arregloActividades.append(actividad)
            }
        }
    }
    
    
    @IBAction func unwindAgregar(sender: UIStoryboardSegue){
        if controlAgregar{
            if nuevaActividad != nil{
                               arregloActividades.append(nuevaActividad)
                self.tableView.reloadData()
            }else{
            }
        }
    }
    
    @IBAction func unwindEditar(sender: UIStoryboardSegue){
        if controlEditar{
            
            if indiceDeEditar != nil{
                llenaArreglo()
                llenaArregloHoy()
                creaNotificaciones()
                self.tableView.reloadData()
        }
        }else{
            //Control editar=false
            //Cancel
       
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
        return arregloActividades.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nombreImagen: String!
        
    let cell = tableView.dequeueReusableCellWithIdentifier("idCelda", forIndexPath: indexPath) as! ActividadesCell
        cell.lblDias.text! = ""
        cell.lblNombre.text = arregloActividades[indexPath.row].nombre
        if arregloActividades[indexPath.row].minutos < 10{
            
            cell.lblHora.text! = String(arregloActividades[indexPath.row].hora) + ":0" + String(arregloActividades[indexPath.row].minutos)
        }else{
        cell.lblHora.text = String(arregloActividades[indexPath.row].hora) + ":" + String(arregloActividades[indexPath.row].minutos)
        }
        
       switch (arregloActividades[indexPath.row].categoria)
        {
        case "Hidratación":
            nombreImagen = "Hidratacion"
            break
        case "Alimentación":
            nombreImagen = "Alimentacion"
            break
        case "Actividad Física":
            nombreImagen = "Actividad Fisica"
            break
        case "Actividad Social":
            nombreImagen = "Actividad Social"
            break
        default:
            break

        }
        cell.imView?.image = UIImage(named: nombreImagen)
        cell.lblDias.text! = (arregloActividades[indexPath.row].frecuencia).joinWithSeparator("")
        if cell.lblDias.text! == "Lu Ma Mi Ju Vi Sa Do"{
            cell.lblDias.text! = "Diario"
        }
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
       
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            try! uiRealm.write {
                let BorraActividad = uiRealm.objects(Actividades).filter("Nombre == %@", arregloActividades[(indexPath.row)].nombre)
                uiRealm.delete(BorraActividad)
            }
            
            arregloActividades.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.reloadData()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
           
        }    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        actividadAMandar = arregloActividades[indexPath.row]
       
        
    }

    /*override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
    }*/

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (sender as? UIBarButtonItem == botonAgregar){
            let viewAgregar: TableViewControllerAgregar = segue.destinationViewController as! TableViewControllerAgregar
            viewAgregar.arregloActividadesAgregar = self.arregloActividades
        }else{
            let viewEditar: TableViewControllerEditarActividad = segue.destinationViewController as! TableViewControllerEditarActividad
            let indexpath = tableview.indexPathForSelectedRow
          
            actividadAMandar = arregloActividades[indexpath!.row]
            viewEditar.activididadRecibida = self.actividadAMandar
            viewEditar.indice = indexpath?.row
        }
    }
}

//Protocolo de DZNEmptyDataSet
extension TableViewControllerActividades: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        self.tableView.separatorColor = UIColor.clearColor()
        let random = Int(arc4random_uniform(4))
        switch random {
        case 0:
            return UIImage(named: "Alimentacion")
        case 1:
            return UIImage(named: "Hidratacion")
        case 2:
            return UIImage(named: "Actividad Fisica")
        case 3:
            return UIImage(named: "Actividad Social")
        default:
            return UIImage(named: "Alimentacion")
        }
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No hay actividades programadas")
    }
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -self.tableView.frame.size.height / 8
    }
}

