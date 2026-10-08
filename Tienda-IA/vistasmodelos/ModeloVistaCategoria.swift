//
//  ModeloVistaCategoria.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 6/10/26.
//

import Foundation
import SwiftData

@Observable
final class CategoriaVistaModelo{
    
    
    func agregarCategoria(categoria:Categoria,contexto:ModelContext){
        contexto.insert(categoria)
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func eliminarCategoria(categoria:Categoria,contexto:ModelContext){
        contexto.delete(categoria)
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func actualizarCategoria(categoria:Categoria,contexto:ModelContext){
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
