//
//  Producto.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 6/10/26.
//

import Foundation
import SwiftData

@Model
final class Producto{
    var id:UUID
    var nombre:String
    var descripcion:String
    
    var subCategoria:SubCategoria?
    
    init(id: UUID=UUID(), nombre: String, descripcion: String, subCategoria: SubCategoria? = nil) {
        self.id = id
        self.nombre = nombre
        self.descripcion = descripcion
        self.subCategoria = subCategoria
    }
}
