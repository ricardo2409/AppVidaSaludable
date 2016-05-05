//
//  ViewControllerInicio.swift
//  AppVidaSaludable
//
//  Created by Fabian Montemayor on 4/12/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit
import RealmSwift


class ViewControllerInicio: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var tfNomResponsable: UITextField!
    
    @IBOutlet weak var tfCorreoResponsable: UITextField!
    
    @IBOutlet weak var tfNomDoctor: UITextField!
    
    @IBOutlet weak var tfCorreoDoctor: UITextField!
    
    @IBOutlet weak var tfNomUsuario: UITextField!
    
    let datosPersonas = Personas()
    
    @IBOutlet weak var scrollView: UIScrollView!
    var activeField : UITextField?
    
    // MARK: - Funciones

    override func viewDidLoad() {
        super.viewDidLoad()

        // Define el color del border de los text fields
        let borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        tfNomResponsable.layer.borderColor = borderColor.CGColor;
        tfCorreoResponsable.layer.borderColor = borderColor.CGColor;
        tfNomDoctor.layer.borderColor = borderColor.CGColor;
        tfCorreoDoctor.layer.borderColor = borderColor.CGColor;
        tfNomUsuario.layer.borderColor = borderColor.CGColor;
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewControllerInicio.quitaTeclado))
        self.view.addGestureRecognizer(tap)
        self.scrollView.contentSize = self.view.frame.size
        self.registerForKeyboardNotifications()
        
        
        tfNomResponsable.delegate = self
        tfCorreoResponsable.delegate = self
        tfNomDoctor.delegate = self
        tfCorreoDoctor.delegate = self
        tfNomUsuario.delegate = self
        
        tfNomResponsable.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.deregisterFromKeyboardNotifications()
    }
    
    // Funciones para manejar teclado
    func quitaTeclado() {
        self.view.endEditing(true)
    }
    
    func registerForKeyboardNotifications() {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewControllerInicio.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewControllerInicio.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.scrollEnabled = true
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeFieldPresent = activeField
        {
            if (!CGRectContainsPoint(aRect, activeField!.frame.origin))
            {
                
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
                
            }
        }
        
        
    }
    
    
    func keyboardWillBeHidden(notification: NSNotification) {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.scrollEnabled = false
        
    }
    
    @IBAction func infoDada(sender: UIButton) {
        // Función que hace:
        //  - Revisa que todos los campos estén llenos con información correcta.
        //  - Guarda la información en la base de datos.
        
        // Valida campos
        var bInformacionCorrecta = true
        if !tfNomResponsable.hasText() {
            bInformacionCorrecta = false
            tfNomResponsable.layer.borderWidth = 1.0
            tfNomResponsable.layer.borderColor = UIColor.redColor().CGColor
            tfNomResponsable.layer.cornerRadius = 5.0;
            tfNomResponsable.clipsToBounds = true
        }
        else {
            let borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
            tfNomResponsable.layer.borderColor = borderColor.CGColor;
        }
        
        if !validateEmail(tfCorreoResponsable.text!) {
            bInformacionCorrecta = false
            tfCorreoResponsable.layer.borderWidth = 1.0
            tfCorreoResponsable.layer.borderColor = UIColor.redColor().CGColor
            tfCorreoResponsable.layer.cornerRadius = 5.0;
            tfCorreoResponsable.clipsToBounds = true
        }
        else {
            let borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
            tfCorreoResponsable.layer.borderColor = borderColor.CGColor;
        }
        
        if !tfNomDoctor.hasText() {
            bInformacionCorrecta = false
            tfNomDoctor.layer.borderWidth = 1.0
            tfNomDoctor.layer.borderColor = UIColor.redColor().CGColor
            tfNomDoctor.layer.cornerRadius = 5.0;
            tfNomDoctor.clipsToBounds = true
        }
        else {
            let borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
            tfNomDoctor.layer.borderColor = borderColor.CGColor;
        }
        
        if !validateEmail(tfCorreoDoctor.text!) {
            bInformacionCorrecta = false
            tfCorreoDoctor.layer.borderWidth = 1.0
            tfCorreoDoctor.layer.borderColor = UIColor.redColor().CGColor
            tfCorreoDoctor.layer.cornerRadius = 5.0;
            tfCorreoDoctor.clipsToBounds = true
        }
        else {
            let borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
            tfCorreoDoctor.layer.borderColor = borderColor.CGColor;
        }
        
        if !tfNomUsuario.hasText() {
            bInformacionCorrecta = false
            tfNomUsuario.layer.borderWidth = 1.0
            tfNomUsuario.layer.borderColor = UIColor.redColor().CGColor
            tfNomUsuario.layer.cornerRadius = 5.0;
            tfNomUsuario.clipsToBounds = true
        }
        else {
            let borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
            tfNomUsuario.layer.borderColor = borderColor.CGColor;
        }
        
        // Si pasó todas las validaciones, guarda la información en la base de datos.
        if bInformacionCorrecta {
            datosPersonas.Responsable_nom = tfNomResponsable.text!
            datosPersonas.Responsable_correo = tfCorreoResponsable.text!
            datosPersonas.Doctor_nom = tfNomDoctor.text!
            datosPersonas.Doctor_correo = tfCorreoDoctor.text!
            datosPersonas.Usuario_nom = tfNomUsuario.text!
            
            try! uiRealm.write{
                uiRealm.add(datosPersonas)
            }
            
            // Cambia los User Defaults para que no se vuelva a mostrar.
            // *** Si quieres que salga otra vez para testing: 1. Tirar la aplicación del simulador.
            // *** Si quieres que salga SIEMPRE, cambiar el valor debajo a false.
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "InfoUsuario")
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // Función que valida que un email tenga formato correcto.
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(enteredEmail)
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == tfNomResponsable {
            tfCorreoResponsable.becomeFirstResponder()
        }
        else if textField == tfCorreoResponsable {
            tfNomDoctor.becomeFirstResponder()
        }
        else if textField == tfNomDoctor {
            tfCorreoDoctor.becomeFirstResponder()
        }
        else if textField == tfCorreoDoctor {
            tfNomUsuario.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
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
