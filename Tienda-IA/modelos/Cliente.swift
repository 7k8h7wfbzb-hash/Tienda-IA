//
//  Cliente.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 3/10/26.
//

import Foundation
import SwiftData

@Model
final class Cliente{
    var id:UUID
    var cedula:String
    var nombres:String
    var apellidos:String
    var direccion:String
    var fechaNacimiento:Date
    var telefono:String
    var email:String
    var imagen:String
    
    init(id: UUID=UUID(), cedula: String, nombres: String, apellidos: String, direccion: String, fechaNacimiento: Date, telefono: String, email: String, imagen: String) {
        self.id = id
        self.cedula = cedula
        self.nombres = nombres
        self.apellidos = apellidos
        self.direccion = direccion
        self.fechaNacimiento = fechaNacimiento
        self.telefono = telefono
        self.email = email
        self.imagen = imagen
    }
}
