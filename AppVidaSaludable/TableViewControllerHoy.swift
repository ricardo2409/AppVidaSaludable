//
//  TableViewControllerHoy.swift
//  AppVidaSaludable
//
//  Created by Fabian Montemayor on 4/12/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit
import SCLAlertView
import RealmSwift
import DZNEmptyDataSet

class TableViewControllerHoy: UITableViewController {
    
    // REUSE IDENTIFIER: "idCelda"
    var arregloActividades: [Actividad] = []
    var arregloActividadesHoy: [Actividad] = []
    var diaDeHoy : String!
    var nuevaActividad : Actividad!
    let hora = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
    let min = NSCalendar.currentCalendar().component(.Minute, fromDate: NSDate())
    var control1 = true
    var control2 = true
    

    //@IBOutlet weak var navigationbar: UINavigationBar!
    // MARK: - Funciones
    
    func diaEnTitulo(dia : String){
        switch dia {
        case "Monday":
            self.title = "Lunes"
        case "Tuesday":
            self.title = "Martes"
        case "Wednesday":
            self.title = "Miércoles"
        case "Thursday":
            self.title = "Jueves"
        case "Friday":
            self.title = "Viernes"
        case "Saturday":
            self.title = "Sábado"
        case "Sunday":
            self.title = "Domingo"
        default:
            break
        }
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
    
    func creaNotificaciones(){
        //Cancela todas las anteriores para no duplicar
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        //Ciclo de todas las actividades de hoy
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
            //Crea notificacion
            let notification : UILocalNotification = UILocalNotification()
            notification.category = "First_Cat"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.alertBody = arregloActividadesHoy[i].nombre
            notification.alertTitle = arregloActividadesHoy[i].categoria
            notification.fireDate = date
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
        }else{
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hoy"
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        llenaArreglo()
        creaNotificaciones()
        //Saca el día para ponerlo en título
        let fecha: NSDate = NSDate()
        let formato: NSDateFormatter = NSDateFormatter()
        formato.dateFormat = "EEEE"
        let dia: String = formato.stringFromDate(fecha)
        diaEnTitulo(dia)
        tableView.tableFooterView = UIView()
    }
    
    
    func llenaArreglo(){
       let hora = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        let min = NSCalendar.currentCalendar().component(.Minute, fromDate: NSDate())
        getDiaDeHoy()
        //Pedir a base de datos las actividades guardadas!
        var ActividadesHoyIgual:Results<Actividades>?
        var Acts:Results<Actividades>?
        //Actividades con filtro de hoy y son menores a la hora actual
        ActividadesHoyIgual = uiRealm.objects(Actividades).filter("Frecuencia CONTAINS %@ AND Hora == %@ AND Minutos > %@ OR Frecuencia CONTAINS %@ AND Hora > %@", diaDeHoy, hora, min, diaDeHoy, hora)
        //Ordenar por hora y minutos
        Acts = ActividadesHoyIgual!.sorted([SortDescriptor(property: "Hora"), "Minutos"])
        let cont = (Acts?.count)
        //Borra todo lo que tenía
        arregloActividadesHoy = []
        if(cont > 0)
        {
            //Ciclo para meter en arregloActividadesHoy todas las actividades en Acts
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
    
  override func viewDidAppear(animated: Bool) {
        self.tableView.separatorColor = UIColor(red: 89/255, green: 149/255, blue: 237/255, alpha: 1)
        //Selector para las notificaciones
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableViewControllerHoy.si(_:)), name: "actionOnePressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableViewControllerHoy.no(_:)), name: "actionTwoPressed", object: nil)
        llenaArreglo()
        getDiaDeHoy()
        tableView.reloadData()
    }
    
    //Funciones útiles para las notificaciones
    func si(notification : UILocalNotification){
    }
    
    func no(notification : UILocalNotification){
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
            cell.detailTextLabel!.text! = String(arregloActividadesHoy[indexPath.row].hora) + ":0" + String(arregloActividadesHoy[indexPath.row].minutos)
        }else{
            cell.detailTextLabel!.text = String(arregloActividadesHoy[indexPath.row].hora) + ":" + String(arregloActividadesHoy[indexPath.row].minutos)
        }
        
        switch (arregloActividadesHoy[indexPath.row].categoria)
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
        cell.imageView!.image = UIImage(named: nombreImagen)
        return cell
    }

}
//Protocolo de DZNEmptyDataSet
extension TableViewControllerHoy: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
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
        return NSAttributedString(string: "No hay actividades programadas para más tarde")
    }
}
