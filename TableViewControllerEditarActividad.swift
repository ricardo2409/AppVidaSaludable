//
//  TableViewControllerEditarActividad.swift
//  AppVidaSaludable
//
//  Created by RicardoTrevino on 4/19/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit

class TableViewControllerEditarActividad: UITableViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var pvHora: UIPickerView!
    @IBOutlet weak var lblFrecuencia: UILabel!
    @IBOutlet weak var pvCategoria: UIPickerView!
    var hora = 1
    var minutos = 1
    var categoria = "Alimentación"
    var activididadRecibida : Actividad!
    var actividadAMandar : Actividad!
    var arreglo: [[AnyObject]] = []
    var arreglo1 = ["1", "2", "3", "4", "5", "6", "7","8", "9", "10", "11", "12","13", "14", "15", "16", "17", "18", "19","20", "21", "22", "23"]
    var arreglo2 = ["1", "2", "3", "4", "5", "6", "7","8", "9", "10", "11", "12","13", "14", "15", "16", "17", "18", "19","20", "21", "22", "23", "24","25", "26", "27", "28", "29", "30", "31","32", "33", "34", "35", "36","37", "38", "39", "40", "41", "42", "43","44", "45", "46", "47", "48","49", "50", "51", "52", "53", "54", "55","56", "57", "58", "59"]
    var arregloCategorias: [String] = ["Alimentación", "Hidratación", "Actividad Física", "Actividad Social"]
    var arregloDias: [Int] = []
   

    override func viewDidLoad() {
        super.viewDidLoad()

        arreglo = [arreglo1, arreglo2]
        self.pvHora.delegate = self
        self.pvHora.dataSource = self
        
        self.pvCategoria.delegate = self
        self.pvCategoria.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        tfNombre.text = activididadRecibida.nombre
        pvCategoria.selectRow(getRowValue(activididadRecibida.categoria), inComponent: 0, animated: true)
        lblFrecuencia.text = getDays(activididadRecibida.frecuencia)
        pvHora.selectRow(activididadRecibida.hora - 1, inComponent: 0, animated: true)
        pvHora.selectRow(activididadRecibida.minutos - 1, inComponent: 1, animated: true)
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            case "Monday":
                frase += "Lu"
            case "Tuesday":
                frase += " Ma"
            case "Wednesday":
                frase += " Mi"
            case "Thursday":
                frase += " Ju"
            case "Friday":
                frase += " Vi"
            case "Saturday":
                frase += " Sa"
            case "Sunday":
                frase += " Do"
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
            return arreglo[component].count
        }else{
            return arregloCategorias.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pvHora {
            return arreglo[component][row] as? String
        }else{
            return arregloCategorias[row] as String
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pvHora {
            if component == 0{
                self.hora = Int(arreglo[component][row] as! String)!
                print("hora es:" + String(self.hora))
            }else{
                self.minutos = Int(arreglo[component][row] as! String)!
                print("minutos es:" + String(self.minutos))
            }
        }else{
            self.categoria = arregloCategorias[row]
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
