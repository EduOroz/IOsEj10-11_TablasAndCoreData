//
//  Grupo.swift
//  Ej10_11_TablasYCoreData
//
//  Created by user125877 on 25/4/17.
//  Copyright © 2017 user125877. All rights reserved.
//

import Foundation
import UIKit

class Grupo: NSObject {
    var idGrupo: Int
    var nombre: String
    var genero: String
    var pais: String
    var año: Int
    
    init(idGrupo: Int, nombre:String, genero:String, pais:String, año:Int) {
        self.idGrupo = idGrupo
        self.nombre = nombre
        self.genero = genero
        self.pais = pais
        self.año = año
    }
}
