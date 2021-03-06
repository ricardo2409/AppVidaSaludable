//
//  TableViewControllerEditarActividad.swift
//  AppVidaSaludable
//
//  Created by RicardoTrevino on 4/19/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewControllerEditarActividad: UITableViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var pvHora: UIPickerView!
    @IBOutlet weak var lblFrecuencia: UILabel!
    @IBOutlet weak var pvCategoria: UIPickerView!
    @IBOutlet weak var botonGuardar: UIBarButtonItem!
    @IBOutlet weak var botonCancel: UIBarButtonItem!
    
    
    var hora = 1
    var minutos = 1
    var categoria = "Alimentación"
    var frecuencia: [String]!
    var activididadRecibida : Actividad!
    var actividadAMandar : Actividad!
    var arreglo: [[AnyObject]] = []
    var actividadNueva: Actividad!
    var indice: Int!
    let Act = Actividades()

    var arregloHoras = ["1", "2", "3", "4", "5", "6", "7","8", "9", "10", "11", "12","13", "14", "15", "16", "17", "18", "19","20", "21", "22", "23"]
    var arregloMinutos = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
    var arregloCategorias: [String] = ["Alimentación", "Hidratación", "Actividad Física", "Actividad Social"]
    var arregloDias: [Int] = []
   

    override func viewDidAppear(animated: Bool) {
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tfNombre.text = activididadRecibida.nombre
        minutos = activididadRecibida.minutos
        hora = activididadRecibida.hora
        categoria = activididadRecibida.categoria
        frecuencia = activididadRecibida.frecuencia
        
        arreglo = [arregloHoras, arregloCategorias]
        self.pvHora.delegate = self
        self.pvHora.dataSource = self
        
        self.pvCategoria.delegate = self
        self.pvCategoria.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
       

        tfNombre.text = activididadRecibida.nombre
        minutos = activididadRecibida.minutos
        hora = activididadRecibida.hora
        categoria = activididadRecibida.categoria
        frecuencia = activididadRecibida.frecuencia
        pvCategoria.selectRow(getRowValue(activididadRecibida.categoria), inComponent: 0, animated: true)
        
        //Une todo lo del arreglo y lo pone en lblFrecuencia.txt
        let stringRepresentation = activididadRecibida.frecuencia.joinWithSeparator("")
        lblFrecuencia.text = stringRepresentation
        pvHora.selectRow((activididadRecibida.hora - 1) + (arregloHoras.count * 10), inComponent: 0, animated: true)
        pvHora.selectRow((activididadRecibida.minutos) + (arregloMinutos.count * 10), inComponent: 1, animated: true)
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindDiasEditar(sender: UIStoryboardSegue){
        
      
        //Agrega a frecuencia
        agregaDiasEnLabel()
    }
    func agregaDiasEnLabel(){
        if arregloDias.count == 0{
            lblFrecuencia.text = ""
        }else {
            lblFrecuencia.text = ""
            for i in 0...arregloDias.count - 1{
                switch (arregloDias[i]) {
                case 0:
                    lblFrecuencia.text! += "Lu"
                    break
                case 1:
                    lblFrecuencia.text! += " Ma"
                    break
                case 2:
                    lblFrecuencia.text! += " Mi"
                    break
                case 3:
                    lblFrecuencia.text! += " Ju"
                    break
                case 4:
                    lblFrecuencia.text! += " Vi"
                    break
                case 5:
                    lblFrecuencia.text! += " Sa"
                    break
                case 6:
                    lblFrecuencia.text! += " Do"
                    break
                default:
                    break
                    
                }
            }
        }
        
    }

    func getRowValue(categoria : String) -> Int{
            switch categoria {
            case "Alimentación":
                return 0
            case "Hidratación":
                return 1
            case "Actividad Física":
                return 2
            case "Actividad Social":
                return 3
            default:
                return 0
            }
        
        
    }
    
    func getDays(frecuencia : [String]) -> String{
        var frase = ""
        for i in 0...frecuencia.count - 1  {
            
            switch frecuencia[i] {
            case "Lu":
                frase += "Lu"
                break
            case "Ma":
                frase += " Ma"
                break
            case "Mi":
                frase += " Mi"
                break
            case "Ju":
                frase += " Ju"
                break
            case "Vi":
                frase += " Vi"
                break
            case "Sa":
                frase += " Sa"
                break
            case "Do":
                frase += " Do"
                break
            default:
                break
            }
        }
        return frase
    }
    
    // MARK: - Picker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView == pvHora {
            return arreglo.count
        }else{
            return 1
        }
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pvHora {
            return 1000
        }else{
            return 1000
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pvHora {
            if component == 0 {
                return arregloHoras[row%arregloHoras.count] as String
            }
            else {
                return arregloMinutos[row%arregloMinutos.count] as String
            }
        }else{
            return arregloCategorias[row%arregloCategorias.count] as String
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pvHora {
            if component == 0{
                self.hora = Int(arregloHoras[row%arregloHoras.count])!
            }else{
                self.minutos = Int(arregloMinutos[row%arregloMinutos.count])!
            }
        }else{
            self.categoria = arregloCategorias[row%arregloCategorias.count]
        }
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

 
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != "tableDiasEdit"{
            if (sender as! UIBarButtonItem == botonGuardar){
                let viewEditar: TableViewControllerActividades = segue.destinationViewController as! TableViewControllerActividades
                
                
                Act.Nombre = tfNombre.text!
                Act.Categoria = categoria
                Act.Frecuencia = lblFrecuencia.text!
                Act.Hora = hora
                Act.Minutos = minutos
                
                actividadAMandar = Actividad(nom: Act.Nombre, cat: Act.Categoria, h: Act.Hora, m: Act.Minutos, frec: [Act.Frecuencia])
                
                viewEditar.nuevaActividadEditar = actividadAMandar
                viewEditar.indiceDeEditar = self.indice
                viewEditar.controlEditar = true
                var EditaAct:Results<Actividades>?
               
                
                EditaAct = uiRealm.objects(Actividades).filter("Nombre == %@", activididadRecibida.nombre)
                
                if (tfNombre.text! == ""){
                    
                    let alertController = UIAlertController(title: "Falta Nombre", message:
                        "Escribir nombre de actividad", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
                
                if (lblFrecuencia.text! == ""){
                    let alertController = UIAlertController(title: "Falta frecuencia", message:
                        "Escoger dias", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }

                if(tfNombre.text! != "" && lblFrecuencia.text! != ""){
                    try! uiRealm.write {
                    uiRealm.delete(EditaAct!)
                    uiRealm.add(Act)
                    }
                }
                

            }else{
                //Boton cancelar
                let viewEditar: TableViewControllerActividades = segue.destinationViewController as! TableViewControllerActividades
                viewEditar.controlEditar = false

        
    }

        
}
    
}
    
    
}
