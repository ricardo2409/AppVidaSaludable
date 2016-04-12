//
//  ViewControllerInicio.swift
//  AppVidaSaludable
//
//  Created by Fabian Montemayor on 4/12/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit

class ViewControllerInicio: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tfNomResponsable: UITextField!
    
    @IBOutlet weak var tfCorreoResponsable: UITextField!
    
    @IBOutlet weak var tfNomDoctor: UITextField!
    
    @IBOutlet weak var tfCorreoDoctor: UITextField!
    
    @IBOutlet weak var tfNomUsuario: UITextField!
    
    // MARK: - Funciones

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func infoDada(sender: UIButton) {
        // Función que hace:
        //  - Revisa que todos los campos estén llenos con información correcta.
        //  - Guarda la información en la base de datos.
        
        // Cambia los User Defaults para que no se vuelva a mostrar.
        // *** Si quieres que salga otra vez para testing: 1. Tirar la aplicación del simulador.
        // *** Si quieres que salga SIEMPRE, cambiar el valor debajo a false.
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "InfoUsuario")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
