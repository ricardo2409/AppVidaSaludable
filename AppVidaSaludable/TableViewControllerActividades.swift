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
                let Frecuencia = [Acts![i].Frecuencia]
                let Hora = Int(Acts![i].Hora)
                let Min = Int(Acts![i].Minutos)
                let actividad = Actividad(nom: Nombre, cat: Categoria, h: Hora, m: Min, frec: Frecuencia)
                self.arregloActividades.append(actividad)
            }
        }
        let actividad = Actividad(nom: "Tomar agua", cat: "Hidratación", h: 7, m: 25, frec: ["Lunes", "Martes"])
        self.arregloActividades.append(actividad)
        
        let actividad2 = Actividad(nom: "Comer carne", cat: "Alimentación", h: 9, m: 50, frec: ["Martes", "Jueves", "Sábado"])
        self.arregloActividades.append(actividad2)
        
        let actividad3 = Actividad(nom: "Caminar en Parque", cat: "Actividad Física", h: 11, m: 30, frec: ["Lunes", "Martes", "Miércoles"])
        self.arregloActividades.append(actividad3)
        
        let actividad4 = Actividad(nom: "Ir al cine con familia", cat: "Actividad Social", h: 6, m: 10, frec: ["Viernes", "Domingo"])
        self.arregloActividades.append(actividad4)
        
        let actividad5 = Actividad(nom: "Cena", cat: "Alimentación", h: 7, m: 3, frec: ["Lunes", "Martes","Miércoles","Jueves","Viernes","Sábado","Domingo"])
        self.arregloActividades.append(actividad5)
        
        let actividad6 = Actividad(nom: "Salir a caminar", cat: "Actividad Física", h: 5, m: 9, frec: ["Sábado","Domingo"])
        self.arregloActividades.append(actividad6)
        
        let Frecuencia = [Acts![1].Frecuencia]
        print([Frecuencia]) 
        
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
            print("menor de 10")
            cell.lblHora.text! = String(arregloActividades[indexPath.row].hora) + ":0" + String(arregloActividades[indexPath.row].minutos)
        }else{
        cell.lblHora.text = String(arregloActividades[indexPath.row].hora) + ":" + String(arregloActividades[indexPath.row].minutos)
        }
        
        
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

        cell.imView?.image = UIImage(named: nombreImagen)
        
        for i in 0...arregloActividades[indexPath.row].frecuencia.count - 1 {
        switch (arregloActividades[indexPath.row].frecuencia[i])
        {
        case "Lunes":
            cell.lblDias.text! += "Lu "
            break
        case "Martes":
            cell.lblDias.text! += "Ma "
            break
        case "Miércoles":
            cell.lblDias.text! += "Mi "
            break
        case "Jueves":
            cell.lblDias.text! += "Ju "
            break
        case "Viernes":
            cell.lblDias.text! += "Vi "
            break
        case "Sábado":
            cell.lblDias.text! += "Sa "
            break
        case "Domingo":
            cell.lblDias.text! += "Do"
            break
        default:
            break
            
        }
            if cell.lblDias.text! == "Lu Ma Mi Ju Vi Sa Do"{
                cell.lblDias.text! = "Diario"
            }
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
            print(arregloActividades)
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
