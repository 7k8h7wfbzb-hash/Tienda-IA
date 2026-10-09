
//
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

    @State private var vm = ModeloVistaProducto()

    // PASO 4: texto del campo de búsqueda
    @State private var textoBusqueda = ""

    // PASO 4: filtrado en memoria sobre lo que ya trajo la @Query
    private var productosFiltrados: [Producto] {
        let busqueda = textoBusqueda.trimmingCharacters(in: .whitespaces)
        guard !busqueda.isEmpty else { return productos }

        return productos.filter {
            $0.nombre.localizedStandardContains(busqueda)
                || $0.descripcion.localizedStandardContains(busqueda)
        }
    }

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
            } else if productosFiltrados.isEmpty {
                // PASO 4: hay productos, pero ninguno coincide con la búsqueda
                ContentUnavailableView.search
            } else {
                List {
                    // PASO 4: iteramos sobre productosFiltrados, no productos
                    ForEach(productosFiltrados) { producto in
                        NavigationLink(
                            destination: VistaDetalleProducto(producto: producto)
                        ) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(producto.nombre)
                                        .font(.headline)

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
        // PASO 4: campo de búsqueda en la barra de navegación
        .searchable(text: $textoBusqueda, prompt: "Buscar productos")
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

    private func eliminar(indexSet: IndexSet) {
        for index in indexSet {
            // ✅ CRÍTICO: usamos productosFiltrados (no productos) para que
            // el índice del swipe corresponda al producto visible en pantalla
            let productoAEliminar = productosFiltrados[index]
            // ✅ SIN etiqueta "producto:"
            vm.eliminar(producto:productoAEliminar, contexto: modelContext)
        }
    }
}

#Preview {
    NavigationStack {
        VistaProducto()
    }
    .modelContainer(for: [Producto.self, Categoria.self, SubCategoria.self], inMemory: true)
}

// MARK: - VistaDetalleProducto

struct VistaDetalleProducto: View {
    let producto: Producto

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(producto.nombre)
                    .font(.largeTitle)
                    .fontWeight(.bold)

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
