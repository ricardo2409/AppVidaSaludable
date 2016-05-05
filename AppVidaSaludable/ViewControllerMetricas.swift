//
//  ViewControllerMetricas.swift
//  AppVidaSaludable
//
//  Created by Fabian Montemayor on 5/2/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class ViewControllerMetricas: UIViewController {

    @IBOutlet weak var alimentacion: PieChartView!

    @IBOutlet weak var hidratacion: PieChartView!
    @IBOutlet weak var fisicas: PieChartView!
    
    @IBOutlet weak var sociales: PieChartView!
    @IBOutlet weak var scrollView: UIScrollView!
    var pAlimentacion = [0.0, 0.0]
    var pHidratacion = [0.0, 0.0]
    var pFisicas = [0.0, 0.0]
    var pSociales = [0.0, 0.0]
    let concepto = ["Realizado", "No Realizado"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenHeight : Int = Int(UIScreen.mainScreen().bounds.size.height)
        switch screenHeight {
        case 568:
            scrollView.contentSize = CGSize(width: 375.0, height: 2170.0)
            break
        case 667:
            scrollView.contentSize = CGSize(width: 375.0, height: 2400.0)
            break
        case 736:
            scrollView.contentSize = CGSize(width: 375.0, height: 2600.0)
            break
        default:
            scrollView.contentSize = CGSize(width: 375.0, height: 2170.0)
        }
        
        // Do any additional setup after loading the view.
        scrollView.setContentOffset(CGPointMake(0, -self.scrollView.contentInset.top), animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        // Llena los datos en arreglos
        self.llenaDatos()
        var total : Double
        // Los convierta a porcentajes
        if !(pAlimentacion[0] == 0 && pAlimentacion[1] == 0) {
            total = pAlimentacion[0] + pAlimentacion[1]
            pAlimentacion[0] = pAlimentacion[0] * 100 / total
            pAlimentacion[1] = pAlimentacion[1] * 100 / total
            setChart(concepto, values: pAlimentacion, description: "Alimentación", pieChartView: alimentacion)
        }
        
        if !(pHidratacion[0] == 0 && pHidratacion[1] == 0) {
            total = pHidratacion[0] + pHidratacion[1]
            pHidratacion[0] = pHidratacion[0] * 100 / total
            pHidratacion[1] = pHidratacion[1] * 100 / total
            setChart(concepto, values: pHidratacion, description: "Hidratación", pieChartView: hidratacion)
        }
        
        if !(pFisicas[0] == 0 && pFisicas[1] == 0) {
            total = pFisicas[0] + pFisicas[1]
            pFisicas[0] = pFisicas[0] * 100 / total
            pFisicas[1] = pFisicas[1] * 100 / total
            setChart(concepto, values: pFisicas, description: "Actividades Físicas", pieChartView: fisicas)
        }
        
        if !(pSociales[0] == 0 && pSociales[1] == 0) {
            total = pSociales[0] + pSociales[1]
            pSociales[0] = pSociales[0] * 100 / total
            pSociales[1] = pSociales[1] * 100 / total
            setChart(concepto, values: pSociales, description: "Actividades Sociales", pieChartView: sociales)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reset(sender: AnyObject) {
        let alerta = UIAlertController(title: "Reset", message: "¿Desea borrar toda la información histórica? No podrá volverla a accesar.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            var Acts : Results<ActividadRealizada>?
            Acts = uiRealm.objects(ActividadRealizada)
            try! uiRealm.write {
                uiRealm.delete(Acts!)
            }
            self.scrollView.setContentOffset(CGPointMake(0, -self.scrollView.contentInset.top), animated: true)
            self.alimentacion.data = nil
            self.hidratacion.data = nil
            self.fisicas.data = nil
            self.sociales.data = nil
            
        }))
        
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .Default, handler: nil))
        
        presentViewController(alerta, animated: true, completion: nil)
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
    
    // MARK: - Funciones para Charts
    
    // Chart de alimentación.
    func setChart(dataPoints: [String], values: [Double], description: String, pieChartView : PieChartView) {
        // Settings generales
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawSlicesUnderHoleEnabled = false
        pieChartView.holeRadiusPercent = 0.58
        pieChartView.transparentCircleRadiusPercent = 0.61
        //pieChartView.descriptionText = description
        
        // Formateador de porciento
        let perFormatter : NSNumberFormatter = NSNumberFormatter()
        perFormatter.numberStyle = .PercentStyle
        perFormatter.maximumFractionDigits = 1
        perFormatter.multiplier = 1
        perFormatter.percentSymbol = " %"
        
        // Datos de la grafica
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        //pieChartDataSet.yValuePosition = .OutsideSlice
        pieChartDataSet.valueTextColor = UIColor.blackColor()
        //pieChartDataSet.xValuePosition = .OutsideSlice
        
        pieChartData.setValueFormatter(perFormatter)
        
        // Colores
        var colors: [UIColor] = []
        
        if description == "Alimentación" {
            var color = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            colors.append(color)
            color = UIColor(red: 231/255, green: 146/255, blue: 60/255, alpha: 1)
            colors.append(color)
        }
        else if description == "Hidratación" {
            var color = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 0.8)
            colors.append(color)
            color = UIColor(red: 57/255, green: 64/255, blue: 196/255, alpha: 1)
            colors.append(color)
        }
        else if description == "Actividades Físicas" {
            var color = UIColor(red: 26/255, green: 188/255, blue: 156/255, alpha: 1)
            colors.append(color)
            color = UIColor(red: 41/255, green: 102/255, blue: 196/255, alpha: 1)
            colors.append(color)
        }
        else if description == "Actividades Sociales" {
            var color = UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
            colors.append(color)
            color = UIColor(red: 230/255, green: 267/255, blue: 34/255, alpha: 1)
            colors.append(color)
        }

        pieChartDataSet.colors = colors
        pieChartView.data = pieChartData
        pieChartView.animate(xAxisDuration: 1, yAxisDuration: 1.4, easingOption: ChartEasingOption.EaseInOutCirc)
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
