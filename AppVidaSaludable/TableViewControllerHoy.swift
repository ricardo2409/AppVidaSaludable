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
    var diaDeHoy : String!
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
            diaDeHoy = "Lunes"
        case "Tuesday":
            diaDeHoy = "Martes"
        case "Wednesday":
            diaDeHoy = "Miércoles"
        case "Thursday":
            diaDeHoy = "Jueves"
        case "Friday":
            diaDeHoy = "Viernes"
        case "Saturday":
            diaDeHoy = "Sábado"
        case "Sunday":
            diaDeHoy = "Domingo"
        default:
            break
        }
        print(diaDeHoy)
    }
    func getArregloActividades(){
        let barViewControllers = self.tabBarController?.viewControllers
        let navigation = barViewControllers![1] as! UINavigationController
        let tvca = navigation.topViewController as! TableViewControllerActividades
        arregloActividades = tvca.arregloActividades
        print(arregloActividades)
    }
    func getArreloActividadesHoy(){
        //Borra lo que ya tenía antes
        arregloActividadesHoy = []
        print("Las actividades de hoy")
        for i in 0...arregloActividades.count - 1 {
            for j in 0...arregloActividades[i].frecuencia.count - 1{
                if arregloActividades[i].frecuencia[j] == diaDeHoy{
                    arregloActividadesHoy.append(arregloActividades[i])
                    print(arregloActividades[i].nombre)
                    
                    
                }
            }
        }
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
    }
    func sortArregloActividadesHoy(){
        //Sort por hora y minutos
        arregloActividadesHoy.sortInPlace({ $0.hora * 60 + $0.minutos  < $1.hora * 60 + $1.minutos })
        print("arreglo sorteado por hora y minutos")
        for i in 0...arregloActividadesHoy.count - 1 {
            print(arregloActividadesHoy[i].nombre)
        }
        print(arregloActividadesHoy)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hoy"
        getArregloActividades()
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
    
    

    
    override func viewDidAppear(animated: Bool) {
        print("Viewdidappear")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableViewControllerHoy.uno(_:)), name: "actionOnePressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableViewControllerHoy.dos(_:)), name: "actionTwoPressed", object: nil)
        
        getDiaDeHoy()
        getArregloActividades()
        getArreloActividadesHoy()
        tableView.reloadData()
        sortArregloActividadesHoy()
        //Crear notificaciones aquí
        creaNotificaciones()
        
    }
    func uno(notification : NSNotification){
        print("action uno")
        //Borrar actividad
        //No me regresa a la app
        
    }
    
    func dos(notification : NSNotification){
        print("action dos")
        //Snooze de 10 min
        //Máximo 3 snoozes
        //Me regresa a la app
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
