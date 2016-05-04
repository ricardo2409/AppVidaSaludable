//
//  ViewControllerContactaMedico.swift
//  AppVidaSaludable
//
//  Created by Fabian Montemayor on 5/3/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit
import MessageUI
import RealmSwift

class ViewControllerContactaMedico: UIViewController, MFMailComposeViewControllerDelegate {

    // MARK: - Variables & Constants
    var nomResponsable : String?
    var correoResponsable : String?
    var nomMedico : String?
    var correoMedico : String?
    var usuario : Results<Personas>?
    var pAlimentacion = [0.0, 0.0]
    var pHidratacion = [0.0, 0.0]
    var pFisicas = [0.0, 0.0]
    var pSociales = [0.0, 0.0]
    
    let mail = MFMailComposeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Carga datos de DB
        mail.mailComposeDelegate = self
        usuario = uiRealm.objects(Personas)
        nomResponsable = usuario![0].Responsable_nom
        correoResponsable = usuario![0].Responsable_correo
        nomMedico = usuario![0].Doctor_nom
        correoMedico = usuario![0].Doctor_correo
        
        self.llenaDatos()
        self.convierteAPorcentajes()
        self.sendEmail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Función que llena los arreglos con los datos de la base de datos.
    func llenaDatos(){
        //Pedir a base de datos las actividades realizadas!
        var Acts:Results<ActividadRealizada>?
        Acts = uiRealm.objects(ActividadRealizada)
        let cont = (Acts?.count)
        
        if(cont > 0)
        {
            for i in 0...cont! - 1
            {
                let Alimentacion = Acts![i].Alimentacion
                let Hidratacion = Acts![i].Hidratacion
                let Fisica = Acts![i].ActividadFisica
                let Social = Acts![i].ActividadSocial
                
                switch Alimentacion {
                case 1:
                    pAlimentacion[0] += 1
                    break
                case 2:
                    pAlimentacion[1] += 1
                    break
                default:
                    break
                }
                
                switch Hidratacion {
                case 1:
                    pHidratacion[0] += 1
                    break
                case 2:
                    pHidratacion[1] += 1
                    break
                default:
                    break
                }
                
                switch Fisica {
                case 1:
                    pFisicas[0] += 1
                    break
                case 2:
                    pFisicas[1] += 1
                    break
                default:
                    break
                }
                
                switch Social {
                case 1:
                    pSociales[0] += 1
                    break
                case 2:
                    pSociales[1] += 1
                    break
                default:
                    break
                }
            }
        }
    }
    
    func convierteAPorcentajes() {
        var total : Double
        if !(pAlimentacion[0] == 0 && pAlimentacion[1] == 0) {
            total = pAlimentacion[0] + pAlimentacion[1]
            pAlimentacion[0] = pAlimentacion[0] * 100 / total
            pAlimentacion[1] = pAlimentacion[1] * 100 / total
        }
        
        if !(pHidratacion[0] == 0 && pHidratacion[1] == 0) {
            total = pHidratacion[0] + pHidratacion[1]
            pHidratacion[0] = pHidratacion[0] * 100 / total
            pHidratacion[1] = pHidratacion[1] * 100 / total
        }
        
        if !(pFisicas[0] == 0 && pFisicas[1] == 0) {
            total = pFisicas[0] + pFisicas[1]
            pFisicas[0] = pFisicas[0] * 100 / total
            pFisicas[1] = pFisicas[1] * 100 / total
        }
        
        if !(pSociales[0] == 0 && pSociales[1] == 0) {
            total = pSociales[0] + pSociales[1]
            pSociales[0] = pSociales[0] * 100 / total
            pSociales[1] = pSociales[1] * 100 / total
        }
    }
    
    // MARK: - Enviar Correo
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            

            mail.setToRecipients([correoMedico!, correoResponsable!])
            mail.setMessageBody("<p> </p><p> </p><p>-----------------------</p><p>Mi desempeño ha sido: </p> <ul><li>Alimentación: " + "\(pAlimentacion[0])" + "% Realizado, " + "\(pAlimentacion[1])" + "% No Realizado</li> <li>Hidratacion: " + "\(pHidratacion[0])" + "% Realizado, " + "\(pHidratacion[1])" + "% No Realizado</li> <li>Actividades Físicas: " + "\(pFisicas[0])" + "% Realizado, " + "\(pFisicas[1])" + "% No Realizado</li> <li>Actividades Sociales: " + "\(pSociales[0])" + "% Realizado, " + "\(pSociales[1])" + "% No Realizado</li></ul>", isHTML: true)
            
            presentViewController(mail, animated: true, completion: nil)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
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
