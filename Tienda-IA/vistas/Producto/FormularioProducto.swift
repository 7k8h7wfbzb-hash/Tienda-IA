//
//  FormularioProducto.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 7/10/26.
//
import SwiftUI
import SwiftData

struct FormularioProducto: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var vm = ModeloVistaProducto()

    @Query private var categorias: [Categoria]
    @Query private var subcategorias: [SubCategoria]
    
    let productoAEditar: Producto?

    @State private var nombre: String = ""
    @State private var descripcion: String = ""
    @State private var categoriaSeleccionada: Categoria?
    @State private var subCategoriaSeleccionada: SubCategoria?

    init(productoAEditar: Producto? = nil) {
        self.productoAEditar = productoAEditar
        _nombre = State(initialValue: productoAEditar?.nombre ?? "")
        _descripcion = State(initialValue: productoAEditar?.descripcion ?? "")
        
        // Usamos la propiedad exacta de tu modelo: subCategoria
        let subActual = productoAEditar?.subCategoria
        _subCategoriaSeleccionada = State(initialValue: subActual)
        _categoriaSeleccionada = State(initialValue: subActual?.categoria)
    }

    var subcategoriasFiltradas: [SubCategoria] {
        guard let categoriaSeleccionada else { return [] }
        return subcategorias.filter { $0.categoria == categoriaSeleccionada }
    }

    var body: some View {
        Form {
            Section(header: Text("Información del Producto")) {
                TextField("Nombre del producto", text: $nombre)
                TextField("Descripción", text: $descripcion)
            }
            
            Section(header: Text("Clasificación")) {
                Picker("Categoría", selection: $categoriaSeleccionada) {
                    Text("Selecciona una categoría").tag(Categoria?.none)
                    ForEach(categorias) { categoria in
                        Text(categoria.nombre).tag(Optional(categoria))
                    }
                }
                .onChange(of: categoriaSeleccionada) { _, nuevaCategoria in
                    if let subActual = subCategoriaSeleccionada, subActual.categoria != nuevaCategoria {
                        subCategoriaSeleccionada = nil
                    }
                }

                Picker("Subcategoría", selection: $subCategoriaSeleccionada) {
                    Text("Selecciona una subcategoría").tag(SubCategoria?.none)
                    ForEach(subcategoriasFiltradas) { subCategoria in
                        Text(subCategoria.nombre).tag(Optional(subCategoria))
                    }
                }
                .disabled(categoriaSeleccionada == nil)
            }

            Button(action: guardarOActualizarProducto) {
                Text(productoAEditar == nil ? "Guardar Producto" : "Actualizar Producto")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .disabled(nombre.trimmingCharacters(in: .whitespaces).isEmpty || subCategoriaSeleccionada == nil)
        }
        .navigationTitle(productoAEditar == nil ? "Nuevo Producto" : "Editar Producto")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu{
                    Section("Clasificación"){
                        NavigationLink(destination: VistaCategoria()) {
                            Label("Administrar Categorías", systemImage: "folder.badge.gearshape")
                        }
                    }
                    Section("Inventario"){
                        
                            
                        
                    }
                                    } label: {
                                        Image(systemName: "ellipsis.circle.fill")
                                            .font(.title3)                }
            }
        }
    }

    private func guardarOActualizarProducto() {
        let nombreLimpio = nombre.trimmingCharacters(in: .whitespaces)
        guard !nombreLimpio.isEmpty, let subCategoriaSeleccionada else { return }

        if let productoExistente = productoAEditar {
            productoExistente.nombre = nombreLimpio
            productoExistente.descripcion = descripcion
            productoExistente.subCategoria = subCategoriaSeleccionada // Asignación correcta
            vm.actualizar(producto: productoExistente, contexto: modelContext)
        } else {
            let nuevoProducto = Producto(
                nombre: nombreLimpio,
                descripcion: descripcion,
                subCategoria: subCategoriaSeleccionada // Inicialización correcta
            )
            vm.guardar(producto: nuevoProducto, contexto: modelContext)
        }

        dismiss()
    }
}

#Preview {
    NavigationStack {
        FormularioProducto(productoAEditar: nil)
    }
    .modelContainer(for: [Producto.self, Categoria.self, SubCategoria.self], inMemory: true)
}
