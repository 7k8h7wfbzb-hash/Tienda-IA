//
//  ModeloVistaCliente.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 3/10/26.
//

import Foundation
import Observation
import SwiftData

@Observable

class ModeloVistaCliente {
    
    func guardarCliente(cliente: Cliente, contexto:ModelContext){
        contexto.insert(cliente)
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func eliminarCliente(cliente: Cliente, contexto:ModelContext){
        contexto.delete(cliente)
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func actualizarCliente(cliente: Cliente, contexto:ModelContext){
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
