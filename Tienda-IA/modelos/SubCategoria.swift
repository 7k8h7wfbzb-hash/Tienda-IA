//
//  SubCategoria.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 6/10/26.
//

import Foundation
import SwiftData

@Model
final class SubCategoria{
    var id:UUID
    var nombre:String
    var descripcion:String
    
    var categoria:Categoria?
    
    @Relationship(deleteRule:.cascade,inverse: \Producto.subCategoria) var productos:[Producto]? = []
    
    init(id: UUID=UUID(), nombre: String, descripcion: String, categoria: Categoria? = nil) {
        self.id = id
        self.nombre = nombre
        self.descripcion = descripcion
        self.categoria = categoria
    }
}

