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
import RealmSwift

class TableViewControllerHoy: UITableViewController {
    
    // REUSE IDENTIFIER: "idCelda"
    var arregloActividades: [Actividad] = []
    var arregloActividadesHoy: [Actividad] = []
    var alarm: AlarmKit.Alarm!
    var diaDeHoy : String!
    var nuevaActividad : Actividad!
    let hora = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
    let min = NSCalendar.currentCalendar().component(.Minute, fromDate: NSDate())

    
    @IBOutlet weak var navigationbar: UINavigationBar!
    // MARK: - Funciones
    
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
    func getDiaDeHoy(){
        let fecha: NSDate = NSDate()
        let formato: NSDateFormatter = NSDateFormatter()
        formato.dateFormat = "EEEE"
        diaDeHoy = formato.stringFromDate(fecha)
        switch diaDeHoy {
        case "Monday":
            diaDeHoy = "Lu"
        case "Tuesday":
            diaDeHoy = " Ma"
        case "Wednesday":
            diaDeHoy = " Mi"
        case "Thursday":
            diaDeHoy = " Ju"
        case "Friday":
            diaDeHoy = " Vi"
        case "Saturday":
            diaDeHoy = " Sa"
        case "Sunday":
            diaDeHoy = " Do"
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
        
        if arregloActividadesHoy.count > 0{
        for i in 0...arregloActividadesHoy.count - 1{
            
            var dateComp: NSDateComponents = NSDateComponents()
            
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
            notification.fireDate = date
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            print("Esta es la notificacion que creé ")
            print(arregloActividadesHoy[i].nombre)
            print(arregloActividadesHoy[i].hora)
            print(arregloActividadesHoy[i].minutos)

            }
        }else{
            print("Está vacío")
        }
        
        notifyArray = UIApplication.sharedApplication().scheduledLocalNotifications
        print("Cantidad de notificaciones creadas:")
        print(notifyArray!.count)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hoy"
        //getArregloActividades()
        llenaArreglo()
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
        
      
       
        diaEnTitulo(dia)
      
    }
    
    
    func llenaArreglo(){
        
        //Pedir a base de datos las actividades guardadas!
        
        getDiaDeHoy()
        
        var ActividadesHoy:Results<Actividades>?
        var Acts:Results<Actividades>?
        ActividadesHoy = uiRealm.objects(Actividades).filter("Frecuencia CONTAINS %@ AND Hora >= %@ AND Minutos >= %@", diaDeHoy, hora, min)
        Acts = ActividadesHoy!.sorted([SortDescriptor(property: "Hora"), "Minutos"])
        let cont = (ActividadesHoy?.count)
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
            print("está vacio")
        }
        
        
    }
    
  override func viewDidAppear(animated: Bool) {
        print("Viewdidappear")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableViewControllerHoy.uno(_:)), name: "actionOnePressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableViewControllerHoy.dos(_:)), name: "actionTwoPressed", object: nil)
        llenaArreglo()

        getDiaDeHoy()
       // getArregloActividades()
        //getArregloActividadesHoy()
        tableView.reloadData()
//        sortArregloActividadesHoy()
        //Crear notificaciones aquí
        creaNotificaciones()
        
    }
    func uno(notification : NSNotification){
        print("action uno")
        
        //Sí
        //Borrar actividad
        //No me regresa a la app
        
    }
    
    func dos(notification : NSNotification){
        print("action dos")
        //No
        //Snooze de 10 min
        //Máximo 3 snoozes
        //No me regresa a la app
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
            nombreImagen = "water"
            break
        case "Alimentación":
            nombreImagen = "apple"
            break
        case "Actividad Física":
            nombreImagen = "walking"
            break
        case "Actividad Social":
            nombreImagen = "talking"
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
