//
//  ModeloVistaProducto.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 6/10/26.
//

import Foundation
import SwiftData

@Observable
final class ModeloVistaProducto{
    
    func guardar(producto:Producto,contexto:ModelContext){
        contexto.insert(producto)
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func actualizar(producto:Producto,contexto:ModelContext){
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func eliminar(producto:Producto,contexto:ModelContext){
        contexto.delete(producto)
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
