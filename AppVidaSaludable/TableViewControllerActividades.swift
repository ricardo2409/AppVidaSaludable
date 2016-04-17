//
//  TableViewControllerActividades.swift
//  AppVidaSaludable
//
//  Created by Fabian Montemayor on 4/12/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit
import AlarmKit
import SCLAlertView

class TableViewControllerActividades: UITableViewController {
    
    // REUSE IDENTIFIER: "idCelda"
    
    var arregloActividades : [Actividad] = []
    var nuevaActividad : Actividad!
    // MARK: - Outlets

    @IBOutlet weak var botonAgregar: UIBarButtonItem!
    
    
    // MARK: - Funciones

    override func viewDidLoad() {
        super.viewDidLoad()
        llenaArreglo()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        tableView.reloadData()
    }
    //Checa si hay una actividad nueva y agrégala al arregloActividades
    override func viewDidAppear(animated: Bool) {

    }
    
    func llenaArreglo(){
        
        //Pedir a base de datos las actividades guardadas! 
        
        let actividad = Actividad(nom: "Tomar agua", cat: "Hidratación", h: 7, m: 25, frec: ["Lunes", "Martes"])
        self.arregloActividades.append(actividad)
        
        let actividad2 = Actividad(nom: "Comer carne", cat: "Alimentación", h: 9, m: 50, frec: ["Martes", "Jueves", "Sábado"])
        self.arregloActividades.append(actividad2)
        
        let actividad3 = Actividad(nom: "Caminar en Parque", cat: "Actividad Física", h: 11, m: 30, frec: ["Lunes", "Martes", "Miércoles"])
        self.arregloActividades.append(actividad3)
        
        let actividad4 = Actividad(nom: "Ir al cine con familia", cat: "Actividad Social", h: 6, m: 10, frec: ["Viernes"])
        arregloActividades.append(actividad4)
        
        
    }
    @IBAction func unwindAgregar(sender: UIStoryboardSegue){
            print("Estoy en unwindAgregar")
        if nuevaActividad != nil{
            print("Esto tiene actividadAUsar en el unwindAgregar antes de meterse al arreglo")
            print(nuevaActividad.nombre)
            print(nuevaActividad.categoria)
            print(nuevaActividad.hora)
            print(nuevaActividad.frecuencia)

        
            arregloActividades.append(nuevaActividad)
            self.tableView.reloadData()
        }else{
            print("es nil")
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
        let cell = tableView.dequeueReusableCellWithIdentifier("idCelda", forIndexPath: indexPath)

        cell.textLabel!.text = arregloActividades[indexPath.row].nombre
        cell.detailTextLabel?.text = String(arregloActividades[indexPath.row].hora) + ":" + String(arregloActividades[indexPath.row].minutos)
        
        
        switch (arregloActividades[indexPath.row].categoria)
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

        cell.imageView?.image = UIImage(named: nombreImagen)

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
//            datos.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (sender as! UIBarButtonItem == botonAgregar){
            let viewAgregar: TableViewControllerAgregar = segue.destinationViewController as! TableViewControllerAgregar
            viewAgregar.arregloActividadesAgregar = self.arregloActividades
        }
    }
    

}
