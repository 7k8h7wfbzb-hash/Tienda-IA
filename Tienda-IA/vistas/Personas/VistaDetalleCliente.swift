//
//  VistaDetalleCliente.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 5/10/26.
//

import SwiftUI
import SwiftData

struct VistaDetalleCliente: View {
    var cliente: Cliente
    
    @State private var mostrarEdicion: Bool = false

    var body: some View {
        List {
            // Sección de Cabecera
            Section {
                HStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue.gradient)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(cliente.nombres) \(cliente.apellidos)")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Label(cliente.cedula, systemImage: "creditcard")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }
            
            // Sección de Datos de Contacto
            Section(header: Text("Información de Contacto")) {
                LabeledContent {
                    Text(cliente.telefono.isEmpty ? "No registrado" : cliente.telefono)
                        .foregroundColor(cliente.telefono.isEmpty ? .secondary : .primary)
                } label: {
                    Label("Teléfono", systemImage: "phone")
                }
                
                LabeledContent {
                    Text(cliente.email.isEmpty ? "No registrado" : cliente.email)
                        .foregroundColor(cliente.email.isEmpty ? .secondary : .primary)
                } label: {
                    Label("Correo", systemImage: "envelope")
                }
                
                LabeledContent {
                    Text(cliente.direccion.isEmpty ? "No registrada" : cliente.direccion)
                        .foregroundColor(cliente.direccion.isEmpty ? .secondary : .primary)
                } label: {
                    Label("Dirección", systemImage: "map")
                }
            }
            
            // Sección de Datos Personales
            Section(header: Text("Datos Personales")) {
                LabeledContent {
                    Text(cliente.fechaNacimiento, style: .date)
                } label: {
                    Label("Fecha de Nacimiento", systemImage: "calendar")
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Detalle del Cliente")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Botón en la barra de herramientas para abrir la edición
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    mostrarEdicion = true
                } label: {
                    Label("Editar", systemImage: "pencil")
                }
            }
        }
        // Presenta el formulario como una hoja modal (sheet) pasándole el cliente
        .sheet(isPresented: $mostrarEdicion) {
            FormularioCliente(clienteAEditar: cliente)
        }
    }
}

#Preview {
    VistaDetalleCliente(cliente: Cliente(cedula: "", nombres: "", apellidos: "", direccion: "", fechaNacimiento: .now, telefono: "", email: "", imagen: ""))
}
