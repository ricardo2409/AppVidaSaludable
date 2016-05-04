//
//  TableViewControllerDiasEditar.swift
//  AppVidaSaludable
//
//  Created by RicardoTrevino on 5/3/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit

class TableViewControllerDiasEditar: UITableViewController {

    var arregloDias: [Int] = []
    var arregloFrecuencias: [String] = []
    @IBOutlet weak var botonOk: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 7
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        arregloDias.append(indexPath.row)
        print(arregloDias)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        
        
        arregloDias.removeAtIndex(buscaValor(arregloDias, valor: indexPath.row))
        print(arregloDias)
    }
    
    func buscaValor(arreglo : [Int], valor : Int) -> Int{
        for i in 0...arreglo.count - 1 {
            if arreglo[i] == valor{
                return i
            }
        }
        return 0
    }
    
    
    
    
    
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
                arregloFrecuencias.append("Lunes")
                break
            case 1:
                arregloFrecuencias.append("Martes")
                break
            case 2:
                arregloFrecuencias.append("Miércoles")
                break
            case 3:
                arregloFrecuencias.append("Jueves")
                break
            case 4:
                arregloFrecuencias.append("Viernes")
                break
            case 5:
                arregloFrecuencias.append("Sábado")
                break
            case 6:
                arregloFrecuencias.append("Domingo")
                break
            default:
                break
                
            }
        }
        if (sender as! UIButton == botonOk){
            let viewEditar: TableViewControllerEditarActividad = segue.destinationViewController as! TableViewControllerEditarActividad
            viewEditar.arregloDias = self.arregloDias
            viewEditar.frecuencia = self.arregloFrecuencias
            print("Esto es lo que mando en el OK")
            print(arregloDias)
        }else{
            //Boton Cancelar
            let viewEditar: TableViewControllerEditarActividad = segue.destinationViewController as! TableViewControllerEditarActividad
            viewEditar.arregloDias = []
            
        }
        
    }
    
    
}
