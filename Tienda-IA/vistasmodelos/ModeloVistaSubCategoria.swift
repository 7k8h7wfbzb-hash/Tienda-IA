//
//  ModeloVistaSubCategoria.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 6/10/26.
//

import Foundation
import SwiftData

@Observable
final class ModeloVistaSubCategoria{
    
    var mensajeError: String?
    
    func guardarSubCategoria(subCategoria: SubCategoria,contexto:ModelContext){
        contexto.insert(subCategoria)
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func actualizarSubCategoria(subCategoria: SubCategoria,contexto:ModelContext){
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func eliminarSubCategoria(subCategoria: SubCategoria,contexto:ModelContext){
        contexto.delete(subCategoria)
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
