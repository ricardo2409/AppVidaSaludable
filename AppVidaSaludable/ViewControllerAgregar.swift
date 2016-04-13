//
//  ViewControllerAgregar.swift
//  AppVidaSaludable
//
//  Created by Fabian Montemayor on 4/12/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit

class ViewControllerAgregar: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var pvPickerHora: UIPickerView!
    
    @IBOutlet weak var bbtnCancelar: UIBarButtonItem!
    
    @IBOutlet weak var bbtnGuardar: UIBarButtonItem!
    
    
    // MARK: - Variables
    var arreglo: [[AnyObject]] = []
    var arreglo1 = ["1", "2", "3", "4", "5", "6", "7","8", "9", "10", "11", "12","13", "14", "15", "16", "17", "18", "19","20", "21", "22", "23"]
    var arreglo2 = ["1", "2", "3", "4", "5", "6", "7","8", "9", "10", "11", "12","13", "14", "15", "16", "17", "18", "19","20", "21", "22", "23", "24","25", "26", "27", "28", "29", "30", "31","32", "33", "34", "35", "36","37", "38", "39", "40", "41", "42", "43","44", "45", "46", "47", "48","49", "50", "51", "52", "53", "54", "55","56", "57", "58", "59"]
    
    
    // MARK: - Funciones
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arreglo = [arreglo1, arreglo2]
        self.pvPickerHora.delegate = self
        self.pvPickerHora.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Picker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return arreglo.count
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arreglo[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arreglo[component][row] as? String
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
