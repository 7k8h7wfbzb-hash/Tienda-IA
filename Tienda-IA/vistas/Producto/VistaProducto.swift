//  VistaProducto.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 6/10/26.
//

import SwiftData
import SwiftUI

struct VistaProducto: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Producto.nombre) private var productos: [Producto]

    // Usamos @State para mantener la instancia del ViewModel estable
    @State private var vm = ModeloVistaProducto()

    var body: some View {
        Group {
            if productos.isEmpty {
                ContentUnavailableView(
                    "No hay productos",
                    systemImage: "cube.box",
                    description: Text(
                        "Agrega tu primer producto usando el botón superior."
                    )
                )
            } else {
                List {
                    ForEach(productos) { producto in
                        NavigationLink(
                            destination: VistaDetalleProducto(producto: producto)
                        ) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(producto.nombre)
                                        .font(.headline)
                                    
                                    // Mostramos la subcategoría y categoría relacionada de forma segura
                                    if let sub = producto.subCategoria {
                                        Text("\(sub.categoria?.nombre ?? "Sin categoría") › \(sub.nombre)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: eliminar)
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Productos")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: FormularioProducto(productoAEditar: nil)
                ) {
                    Image(systemName: "plus")
                    Text("Agregar")
                }
            }
        }
    }

    // Función de eliminación delegada al ViewModel
    private func eliminar(indexSet: IndexSet) {
        for indices in indexSet {
            let productoAEliminar = productos[indices]
            vm.eliminar(producto: productoAEliminar, contexto: modelContext)
        }
    }
}

#Preview {
    NavigationStack {
        VistaProducto()
    }
    .modelContainer(for: [Producto.self, Categoria.self, SubCategoria.self], inMemory: true)
}

struct VistaDetalleProducto: View {
    let producto: Producto

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(producto.nombre)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Sección visual de categorías en el detalle
                if let sub = producto.subCategoria, let cat = sub.categoria {
                    HStack(spacing: 12) {
                        Label(cat.nombre, systemImage: "folder")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        
                        Label(sub.nombre, systemImage: "tag")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .font(.subheadline)
                }

                Divider()

                Text("Descripción:")
                    .font(.headline)
                    .foregroundColor(.secondary)

                Text(producto.descripcion)
                    .font(.body)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: FormularioProducto(productoAEditar: producto)
                ) {
                    Text("Editar")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        VistaDetalleProducto(
            producto: Producto(
                nombre: "Arroz",
                descripcion: "Arroz canilla de 5kg"
            )
        )
    }
    .modelContainer(for: [Producto.self, Categoria.self, SubCategoria.self], inMemory: true)
}


