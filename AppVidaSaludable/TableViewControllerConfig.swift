//
//  TableViewControllerConfig.swift
//  AppVidaSaludable
//
//  Created by Fabian Montemayor on 4/12/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit

class TableViewControllerConfig: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tfNomResponsable: UITextField!
    @IBOutlet weak var tfCorreoResponsable: UITextField!
    @IBOutlet weak var tfNomMedico: UITextField!
    @IBOutlet weak var tfCorreoMedico: UITextField!
    
    @IBOutlet weak var pickerViewFallos: UIPickerView!
    
    @IBOutlet weak var pickerViewReportes: UIPickerView!
    
    // MARK: - Variables & Constants
    var nomResponsable : String?
    var correoResponsable : String?
    var nomMedico : String?
    var correoMedico : String?
    var cantidadFallos : Int!
    var frecReportes : Int! // Cantidad de días
    var arrFallos : NSArray = ["1", "2", "3", "4", "5"]
    var arrReportes : NSArray = ["Semanal", "Quincenal", "Mensual", "Bimestral"]
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Para probar, hard coded valores.
        if nomResponsable == nil {
            nomResponsable = "Detail"
        }
        if correoResponsable == nil {
            correoResponsable = "Detail"
        }
        if nomMedico == nil {
            nomMedico = "Detail"
        }
        if correoMedico == nil {
            correoMedico = "Detail"
        }
        
        // Muestra valores en tfs.
        tfNomResponsable.text = nomResponsable
        tfCorreoResponsable.text = correoResponsable
        tfNomMedico.text = nomMedico
        tfCorreoMedico.text = correoMedico
        
        // Notificación para revisar cambios en los datos
        tfNomResponsable.addTarget(self, action: #selector(TableViewControllerConfig.cambioNomResponsable(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        
        // Pickers
        self.pickerViewFallos.delegate = self
        self.pickerViewReportes.dataSource = self
        self.pickerViewFallos.dataSource = self
        self.pickerViewReportes.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func cambioNomResponsable(textField: UITextField) {
        if textField.text != nomResponsable {
            nomResponsable = textField.text
        }
    }
    
    // MARK: - Picker View Data Source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewReportes {
            return arrReportes.count
        }
        else {
            return arrFallos.count
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == pickerViewReportes {
            return arrReportes[row] as! String
        }
        else if pickerView == pickerViewFallos {
            return arrFallos[row] as! String
        }
        return nil
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewReportes {
            switch row {
            case 0:
                self.frecReportes = 7
            case 1:
                self.frecReportes = 15
            case 2:
                self.frecReportes = 30
            case 3:
                self.frecReportes = 60
            default:
                15
            }
            
        }
        else{
            self.cantidadFallos = arrFallos[row] as! Int
        }
    }
    
    
    // MARK: - Table view data source
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */
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
