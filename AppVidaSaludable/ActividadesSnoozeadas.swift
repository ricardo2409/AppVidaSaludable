//
//  ActividadesSnoozeadas.swift
//  AppVidaSaludable
//
//  Created by RicardoTrevino on 5/4/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import Foundation
import RealmSwift

class ActividadesSnoozeadas: Object {
    
    dynamic var nombre = ""
    dynamic var count = 0
    dynamic var id = 0
    override class func primaryKey() -> String? {
        return "id"
    }
}
