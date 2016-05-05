//
//  TableViewControllerAgregar.swift
//  AppVidaSaludable
//
//  Created by RicardoTrevino on 4/13/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit
import RealmSwift
import SCLAlertView

class TableViewControllerAgregar: UITableViewController,UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    

    // MARK: - Outlets
    
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var pickerViewHora: UIPickerView!
    @IBOutlet weak var pickerViewCategoria: UIPickerView!
    @IBOutlet weak var botonCancel: UIBarButtonItem!
    @IBOutlet weak var botonGuardar: UIBarButtonItem!
    @IBOutlet weak var lbFrecuencia: UILabel!
    // MARK: - Variables
    var arreglo: [[AnyObject]] = []
    var arreglo1 = ["1", "2", "3", "4", "5", "6", "7","8", "9", "10", "11", "12","13", "14", "15", "16", "17", "18", "19","20", "21", "22", "23"]
    var arreglo2 = ["0","15","30","45"]
    var arregloCategorias: [String] = ["Alimentación", "Hidratación", "Actividad Física", "Actividad Social"]
    var arregloDias: [Int] = []
    var categoria : String!
    var hora : Int!
    var minutos: Int!
    var frecuencia: [String]!
    var arregloActividadesAgregar : [Actividad]!
    var actividadNueva: Actividad!
    
    let Act = Actividades()
    var cancel = false
    // MARK: - Funciones
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arreglo = [arreglo1, arreglo2]
        self.pickerViewHora.delegate = self
        self.pickerViewHora.dataSource = self
       
        self.pickerViewCategoria.delegate = self
        self.pickerViewCategoria.dataSource = self
        tfNombre.delegate = self
        lbFrecuencia.text = ""
        categoria = "Alimentación"
        hora = 1
        minutos = 1
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        
        self.pickerViewCategoria.selectRow(500, inComponent: 0, animated: false)
        //self.pickerViewHora.selectRow(500, inComponent: 0, animated: false)
        //self.pickerViewHora.selectRow(500, inComponent: 1, animated: false)
        
        print(Realm.Configuration.defaultConfiguration.path!)
        
    }
   
   
    
    func agregaDiasEnLabel(){
        if arregloDias.count == 0{
            lbFrecuencia.text = ""
        }else {
            lbFrecuencia.text = ""
            for i in 0...arregloDias.count - 1{
                print(arregloDias[i])
                switch (arregloDias[i]) {
                case 0:
                    lbFrecuencia.text! += "Lu"
                    break
                case 1:
                    lbFrecuencia.text! += " Ma"
                    break
                case 2:
                    lbFrecuencia.text! += " Mi"
                    break
                case 3:
                    lbFrecuencia.text! += " Ju"
                    break
                case 4:
                    lbFrecuencia.text! += " Vi"
                    break
                case 5:
                    lbFrecuencia.text! += " Sa"
                    break
                case 6:
                    lbFrecuencia.text! += " Do"
                    break
                default:
                    break
                    
                }
            }
        }
        
    }
    @IBAction func quitaTeclado(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.tableView.endEditing(true)
    }
    
    @IBAction func unwindDias(sender: UIStoryboardSegue){
        if cancel {
            print("Estoy en cancel")
        }else{
            print("Esto es lo que recibo del ok")
            print(arregloDias)
            agregaDiasEnLabel()
        }
    }
    

    // MARK: - Picker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView == pickerViewHora {
            return arreglo.count
        }else{
            return 1
        }
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewHora {
            return arreglo[component].count
            //return 100000
        }else{
            //return arregloCategorias.count
            return 100000
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewHora {
            return arreglo[component][row] as? String
        }else{
            return arregloCategorias[row%arregloCategorias.count] as String
        }
    }
  
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewHora {
            if component == 0{
                self.hora = Int(arreglo[component][row] as! String)
                print("hora es:" + String(self.hora))
            }else{
                self.minutos = Int(arreglo[component][row] as! String)
                print("minutos es:" + String(self.minutos))
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

   // MARK: - Text Field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier != "tableDias"{
            if (sender as! UIBarButtonItem == botonGuardar){
                let viewAgregar: TableViewControllerActividades = segue.destinationViewController as! TableViewControllerActividades
             
                
                Act.Nombre = tfNombre.text!
                Act.Categoria = categoria
                Act.Frecuencia = lbFrecuencia.text!
                Act.Hora = hora
                Act.Minutos = minutos

                
                if (tfNombre.text! == ""){
                    
                    let alertController = UIAlertController(title: "Falta Nombre", message:
                        "Escribir nombre de actividad", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
                
                if (lbFrecuencia.text! == ""){
                    let alertController = UIAlertController(title: "Falta frecuencia", message:
                        "Escoger dias", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                    
                else{
                    actividadNueva = Actividad(nom: self.tfNombre.text!, cat: self.categoria, h: self.hora, m: self.minutos, frec: frecuencia)
                }

                
                var ActExiste:Results<Actividades>?
                ActExiste = uiRealm.objects(Actividades).filter("Nombre == %@", tfNombre.text!)
                
                if(ActExiste!.count != 0){
                if (ActExiste![0].Nombre == tfNombre.text!) {

                    let alertController = UIAlertController(title: "Actividad ya existe", message:
                        "Cambiar nombre", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    }
                

                }
                
                if(lbFrecuencia.text! != "" && tfNombre.text! != "") {
                    //add our object to the DB 
                    try! uiRealm.write{
                        uiRealm.add(Act)
                    }
                    actividadNueva = Actividad(nom: Act.Nombre, cat: Act.Categoria, h: Act.Hora, m: Act.Minutos, frec: [Act.Frecuencia])
                    viewAgregar.nuevaActividad = actividadNueva
                    viewAgregar.controlAgregar = true

                }
                
                

                
            }else{
                //Cancelar
              
                let viewAgregar: TableViewControllerActividades = segue.destinationViewController as! TableViewControllerActividades
                viewAgregar.controlAgregar = false

                
            }
            
            
        }

    }
    

}
