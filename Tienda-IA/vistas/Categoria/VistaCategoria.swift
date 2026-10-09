//
//  VistaCategoria.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 6/10/26.
//

import SwiftUI
import SwiftData

struct VistaCategoria: View {
    @Query(sort: \Categoria.nombre) private var categorias: [Categoria]
    @Environment(\.modelContext) private var modelContext
    
    @State private var nombre: String = ""
    @State private var descripcion: String = ""
    
    // Instancia del ViewModel
    @State private var vm = CategoriaVistaModelo()
    
    var body: some View {
        
            Form {
                // Sección para el formulario de creación
                Section(header: Text("Crear nueva categoría")) {
                    TextField("Nombre", text: $nombre)
                    TextField("Descripción", text: $descripcion)
                    
                    Button(action: guardar) {
                        Text("Guardar categoría")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .disabled(nombre.trimmingCharacters(in: .whitespaces).isEmpty) // Deshabilita si está vacío
                }
                
                // Sección del listado
                Section(header: Text("Categorías existentes")) {
                    if categorias.isEmpty {
                        ContentUnavailableView(
                            "Sin categorías",
                            systemImage: "square.stack.3d.up.slash",
                            description: Text("Agrega una categoría usando el formulario superior.")
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                    } else {
                        ForEach(categorias) { categoria in
                            // Pasamos la categoría seleccionada a la vista de subcategorías
                            NavigationLink(destination: VistaSubCategoria(categoria: categoria)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(categoria.nombre)
                                        .font(.headline)
                                    if !categoria.descripcion.isEmpty {
                                        Text(categoria.descripcion)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete(perform: eliminarCategoria) // Añadido soporte para eliminar deslizando
                    }
                }
            }
            .navigationTitle("Categorías")
        }
    
    
    private func guardar() {
        let nombreLimpio = nombre.trimmingCharacters(in: .whitespaces)
        guard !nombreLimpio.isEmpty else { return }
        
        let nuevaCategoria = Categoria(nombre: nombreLimpio, descripcion: descripcion)
        vm.agregarCategoria(categoria: nuevaCategoria, contexto: modelContext)
        
        // Limpiamos los campos
        nombre = ""
        descripcion = ""
    }
    
    private func eliminarCategoria(at offsets: IndexSet) {
        for index in offsets {
            let categoria = categorias[index]
            vm.eliminarCategoria(categoria: categoria, contexto: modelContext)
        }
    }
}

#Preview {
    NavigationStack{
        VistaCategoria()
            .modelContainer(for: Categoria.self, inMemory: true)
    }
}
