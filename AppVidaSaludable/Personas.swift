//
//  Personas.swift
//  AppVidaSaludable
//
//  Created by Dago González on 4/20/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import Foundation
import RealmSwift

class Personas: Object {
    
    dynamic var Responsable_nom = ""
    dynamic var Responsable_correo = ""
    dynamic var Doctor_nom = ""
    dynamic var Doctor_correo = ""
    dynamic var Usuario_nom = ""


// Specify properties to ignore (Realm won't persist these)

//  override static func ignoredProperties() -> [String] {
//    return []
//
}