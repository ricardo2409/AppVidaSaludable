//
//  TableViewControllerConfig.swift
//  AppVidaSaludable
//
//  Created by Fabian Montemayor on 4/12/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewControllerConfig: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
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
    
    var usuario : Results<Personas>?
    
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Tap geture recognizer
        /*UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        self.tableView addGestureRecognizer:gestureRecognizer;
        */
        //let tapGestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TableViewControllerConfig.quitaTeclado))
        
        
        
        // Carga los valores de la base de datos y los pone en el placeholder.
        usuario = uiRealm.objects(Personas)
        
        nomResponsable = usuario![0].Responsable_nom
        correoResponsable = usuario![0].Responsable_correo
        nomMedico = usuario![0].Doctor_nom
        correoMedico = usuario![0].Doctor_correo
        
        // Muestra valores en tfs.
        tfNomResponsable.text = nomResponsable
        tfNomResponsable.delegate = self
        tfCorreoResponsable.text = correoResponsable
        tfCorreoResponsable.delegate = self
        tfNomMedico.text = nomMedico
        tfNomMedico.delegate = self
        tfCorreoMedico.text = correoMedico
        tfCorreoResponsable.delegate = self
        
        // Notificación para revisar cambios en los datos
        tfNomResponsable.addTarget(self, action: #selector(TableViewControllerConfig.cambioNomResponsable(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        tfCorreoResponsable.addTarget(self, action: #selector(TableViewControllerConfig.cambioCorreoResponsable(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        tfNomMedico.addTarget(self, action: #selector(TableViewControllerConfig.cambioNomMedico(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        tfCorreoResponsable.addTarget(self, action: #selector(TableViewControllerConfig.cambioCorreoResponsable(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        
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

    // Función que valida que un email tenga formato correcto.
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(enteredEmail)
    }
    
    // Función que actualiza el nombre del responsable en la base de datos, cuando este cambia en el
    //  text field.
    func cambioNomResponsable(textField: UITextField) {
        if textField.text != nomResponsable {
            // Valida que no se encuentre vacío.
            if !textField.hasText() {
                textField.layer.borderWidth = 1.0
                textField.layer.borderColor = UIColor.redColor().CGColor
                textField.layer.cornerRadius = 5.0;
                textField.clipsToBounds = true
            }
            else {
                textField.borderStyle = .None
                textField.layer.borderWidth = 0
                // Actualiza la variable
                nomResponsable = textField.text
                
                // Cambiar base de datos.
                try! uiRealm.write {
                    usuario![0].Responsable_nom = nomResponsable!
                }
            }
        }
    }
 
    // Función que actualiza el correo del responsable en la base de datos, cuando este cambia en el
    //  text field.
    func cambioCorreoResponsable(textField: UITextField) {
        if textField.text != correoResponsable {
            // Valida el nuevo correo
            if !validateEmail(textField.text!) {
                textField.layer.borderWidth = 1.0
                textField.layer.borderColor = UIColor.redColor().CGColor
                textField.layer.cornerRadius = 5.0;
                textField.clipsToBounds = true
            }
            else {
                textField.borderStyle = .None
                textField.layer.borderWidth = 0
                // Actualiza la variable
                correoResponsable = textField.text
                
                // Cambiar base de datos.
                try! uiRealm.write {
                    usuario![0].Responsable_correo = correoResponsable!
                }
            }
        }
    }
    
    // Función que actualiza el nombre del médico en la base de datos, cuando este cambia en el
    //  text field.
    func cambioNomMedico(textField: UITextField) {
        if textField.text != nomMedico {
            // Valida que no esté vacío.
            if !textField.hasText() {
                textField.layer.borderWidth = 1.0
                textField.layer.borderColor = UIColor.redColor().CGColor
                textField.layer.cornerRadius = 5.0;
                textField.clipsToBounds = true
            }
            else {
                textField.borderStyle = .None
                textField.layer.borderWidth = 0
                // Actualiza la variable
                nomMedico = textField.text
                
                // Cambiar base de datos.
                try! uiRealm.write {
                    usuario![0].Doctor_nom = nomMedico!
                }
            } 
        }
    }
    
    // Función que actualiza el correo del médico en la base de datos, cuando este cambia en el
    //  text field.
    func cambioCorreoMedico(textField: UITextField) {
        if textField.text != correoMedico {
            // Valida el nuevo correo
            if !validateEmail(textField.text!) {
                textField.layer.borderWidth = 1.0
                textField.layer.borderColor = UIColor.redColor().CGColor
                textField.layer.cornerRadius = 5.0;
                textField.clipsToBounds = true
            }
            else {
                textField.borderStyle = .None
                textField.layer.borderWidth = 0
                // Actualiza la variable
                correoMedico = textField.text
                
                // Cambiar base de datos.
                try! uiRealm.write {
                    usuario![0].Doctor_correo = correoMedico!
                }
            }
        }
    }
    
    // MARK: - TextFieldDelegate
    // Función que hace que desaparezca el teclado y termine de editar el textfield al darle enter.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewReportes {
            return arrReportes[row] as? String
        }
        else if pickerView == pickerViewFallos {
            return arrFallos[row] as? String
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
        else {
            self.cantidadFallos = Int(arrFallos[row] as! String)
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
