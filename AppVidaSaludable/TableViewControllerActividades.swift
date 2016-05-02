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
import RealmSwift

class TableViewControllerActividades: UITableViewController {
    
    // REUSE IDENTIFIER: "idCelda"
    @IBOutlet weak var tableview: UITableView!
    
    var arregloActividades : [Actividad] = []
    var nuevaActividad : Actividad!
    var control: Bool = false
    var actividadAMandar: Actividad!
    // MARK: - Outlets

    @IBOutlet weak var botonAgregar: UIBarButtonItem!
    
    
    // MARK: - Funciones

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.allowsSelectionDuringEditing = true
        llenaArreglo()
        print("viewDidLoadActividades")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        tableView.reloadData()
        /*
        navigationController?.navigationBar.barTintColor = UIColor(red: 199/255, green: 237/255, blue: 228/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 103/255, green: 42/255, blue: 78/255, alpha: 1)]
        navigationController?.navigationBar.tintColor = UIColor(red: 103/255, green: 42/255, blue: 78/255, alpha: 1)
 */
    }
    //Checa si hay una actividad nueva y agrégala al arregloActividades
    override func viewDidAppear(animated: Bool) {

    }
    
    
    func llenaArreglo(){
        
        //Pedir a base de datos las actividades guardadas! 
        
        
        var Acts:Results<Actividades>?
        Acts = uiRealm.objects(Actividades)
        let cont = (Acts?.count)
        
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
            print("Estoy en unwindAgregar")
        if control{
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
                print(BorraActividad)
                uiRealm.delete(BorraActividad)
            }
            
            print("Actividad removida:" + arregloActividades[indexPath.row].nombre)
            arregloActividades.removeAtIndex(indexPath.row)

            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            print(arregloActividades)
            self.tableView.reloadData()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
        }    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Estoy en el didSelectRowAtIndexPath")
        actividadAMandar = arregloActividades[indexPath.row]
        print("esto es actividad a mandar: ")
        print(actividadAMandar)
        
    }

   

    
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
            print(indexpath!.row)
            actividadAMandar = arregloActividades[indexpath!.row]
            viewEditar.activididadRecibida = self.actividadAMandar
            print("Esto es lo que mandé cuando selecciono la cell")
            print(self.actividadAMandar.nombre)
        }
    }
    

}
