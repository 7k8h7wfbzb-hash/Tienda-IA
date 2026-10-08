//
//  Categoria.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 6/10/26.
//

import Foundation
import SwiftData

@Model
final class Categoria{
    var id:UUID
    var nombre:String
    var descripcion:String
    
    //Releacion de sub categoria
    @Relationship(deleteRule:.cascade ,inverse:\SubCategoria.categoria)
    var subCategorias: [SubCategoria]? = []
    
    init(id: UUID=UUID(), nombre: String, descripcion: String) {
        self.id = id
        self.nombre = nombre
        self.descripcion = descripcion
    }
}
