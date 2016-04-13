//
//  Actividad.swift
//  AppVidaSaludable
//
//  Created by RicardoTrevino on 4/12/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit

class Actividad: NSObject {
    var nombre : String!
    var categoria : String!
    var hora: Int!
    var minutos: Int!
    var frecuencia: [String] = []
    
    init(nom: String, cat : String, h : Int, m : Int, frec : [String]) {
        nombre = nom
        categoria = cat
        hora = h
        minutos = m
        frecuencia = frec
        
    }

}
