//
//  TableViewControllerDias.swift
//  AppVidaSaludable
//
//  Created by RicardoTrevino on 4/13/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit

class TableViewControllerDias: UITableViewController {

    var arregloDias: [Int] = []
    var arregloFrecuencias: [String] = []
    @IBOutlet weak var botonOk: UIButton!
    @IBOutlet weak var botonCancelar: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
//    @IBAction func unwindDias(sender: UIStoryboardSegue){
//        let viewAgregar: TableViewControllerAgregar = sender.destinationViewController as! TableViewControllerAgregar
//        viewAgregar.arregloDias = self.arregloDias
//    }

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
        return 7
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        arregloDias.append(indexPath.row)
        print(arregloDias)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        arregloDias.removeAtIndex(indexPath.row)
        print(arregloDias)
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //Sort arregloDias para que no importe el orden en el que se seleccionen los días
        
        arregloDias.sortInPlace()
       
        
        
        
        for i in 0...arregloDias.count - 1{
            switch (arregloDias[i]) {
            case 0:
                arregloFrecuencias.append("Monday")
                break
            case 1:
                arregloFrecuencias.append("Tuesday")
                
                break
            case 2:
                arregloFrecuencias.append("Wednesday")
                
                break
            case 3:
                arregloFrecuencias.append("Thursday")
                
                break
            case 4:
                arregloFrecuencias.append("Friday")
                
                break
            case 5:
                arregloFrecuencias.append("Saturday")
                
                break
            case 6:
                arregloFrecuencias.append("Sunday")
                
                break
            default:
                break
                
            }
        }

        
        
        
        if (sender as! UIButton == botonOk){
            let viewAgregar: TableViewControllerAgregar = segue.destinationViewController as! TableViewControllerAgregar
            viewAgregar.arregloDias = self.arregloDias
            viewAgregar.frecuencia = self.arregloFrecuencias
            print("Esto es lo que mando en el OK")
            print(arregloDias)
        }else{
            //Boton Cancelar
            let viewAgregar: TableViewControllerAgregar = segue.destinationViewController as! TableViewControllerAgregar
            viewAgregar.arregloDias = []

        }
        
    }
    

}
