//
//  TableViewControllerConfig.swift
//  AppVidaSaludable
//
//  Created by Fabian Montemayor on 4/12/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit

class TableViewControllerConfig: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tfNomResponsable: UITextField!
    @IBOutlet weak var tfCorreoResponsable: UITextField!
    @IBOutlet weak var tfNomMedico: UITextField!
    @IBOutlet weak var tfCorreoMedico: UITextField!
    
    // MARK: - Variables & Constants
    var nomResponsable : String?
    var correoResponsable : String?
    var nomMedico : String?
    var correoMedico : String?
    var cantidadFallos : Int!
    var frecReportes : Int!

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
