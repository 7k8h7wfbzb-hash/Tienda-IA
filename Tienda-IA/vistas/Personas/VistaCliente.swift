//
//  VistaCliente.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 3/10/26.
//

import SwiftData
import SwiftUI

struct VistaCliente: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Cliente.apellidos, order: .forward) private var clientes:
        [Cliente]
    @State private var vm = ModeloVistaCliente()

    var body: some View {
        NavigationStack {
            Group {
                if clientes.isEmpty {
                    ContentUnavailableView(
                        "No hay clientes registrados",
                        systemImage: "person.crop.badge.plus",
                        description: Text(
                            "Pulsa el botón '+' en la esquina superior para agregar un nuevo cliente."
                        )
                    )
                } else {
                    List {
                        ForEach(clientes) { cliente in
                            NavigationLink(
                                destination: VistaDetalleCliente(
                                    cliente: cliente
                                )
                            ) {
                                CeldaCliente(cliente: cliente)
                            }
                        }
                        .onDelete(perform: eleminarCliente)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Clientes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FormularioCliente()) {
                        Label("Agregar", systemImage: "plus")
                    }
                }
            }
        }
    }
    func eleminarCliente(at offsets: IndexSet) {
        for indice in offsets {
            let clienteAEleminar = clientes[indice]
            vm.eliminarCliente(
                cliente: clienteAEleminar,
                contexto: modelContext
            )
        }
    }
}

struct CeldaCliente: View {
    let cliente: Cliente

    var body: some View {
        HStack(spacing: 14) {
            // Icono o avatar representativo
            Image(systemName: "person.circle.fill")
                .font(.system(size: 42))
                .foregroundStyle(.blue.gradient)

            VStack(alignment: .leading, spacing: 4) {
                // Apellidos y Nombres destacados
                Text("\(cliente.nombres) \(cliente.apellidos)")
                    .font(.headline)
                    .foregroundColor(.primary)

                // Cédula y Teléfono en línea secundaria
                HStack(spacing: 8) {
                    Label(cliente.cedula, systemImage: "creditcard")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    if !cliente.telefono.isEmpty {
                        Text("•")
                            .foregroundColor(.secondary)
                        Label(cliente.telefono, systemImage: "phone")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {

    let cliente = Cliente(
        cedula: "0104825864",
        nombres: "klever",
        apellidos: "muy",
        direccion: "san vicente",
        fechaNacimiento: .now,
        telefono: "00000000",
        email: "klever56@gmail.com",
        imagen: "date"
    )
    CeldaCliente(cliente: cliente)
}

#Preview {
    VistaCliente().modelContainer(for: [Cliente.self], inMemory: true)
}
