//
//  VistaSubCategoria.swift
//  Tienda-IA
//

import SwiftData
import SwiftUI

struct VistaSubCategoria: View {
    @Environment(\.modelContext) private var modelContext

    let categoria: Categoria

    @State private var nnombre: String = ""
    @State private var descripcion: String = ""

    @State private var vm = ModeloVistaSubCategoria()

    // ✅ Ya NO necesitamos @Query ni #Predicate ni init personalizado.
    // Usamos la relación inversa directamente: es reactiva y siempre
    // está sincronizada con la base de datos.

    // Mantenemos el orden alfabético que antes daba el @Query
    private var subCategorias: [SubCategoria] {
        categoria.subCategorias?.sorted { $0.nombre < $1.nombre } ?? []
    }

    var body: some View {
        VStack {
            Form {
                Section(
                    header: Text(
                        "Nueva subcategoría para: \(categoria.nombre)"
                    )
                ) {
                    TextField("Nombre de la subcategoría", text: $nnombre)
                    TextField("Descripción (opcional)", text: $descripcion)

                    Button(action: agregar) {
                        Text("Agregar Subcategoría")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .disabled(
                        nnombre.trimmingCharacters(in: .whitespaces).isEmpty
                    )
                }
            }
            .frame(height: 250)

            Group {
                if subCategorias.isEmpty {
                    ContentUnavailableView(
                        "No hay subcategorías",
                        systemImage: "folder.badge.questionmark",
                        description: Text(
                            "Crea una nueva subcategoría usando el formulario superior."
                        )
                    )
                } else {
                    List {
                        ForEach(subCategorias) { subCategoria in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(subCategoria.nombre)
                                    .font(.headline)
                                if !subCategoria.descripcion.isEmpty {
                                    Text(subCategoria.descripcion)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: eliminar)
                    }
                    .listStyle(.insetGrouped)
                }
            }
        }
        .navigationTitle("Subcategorías")
        .navigationBarTitleDisplayMode(.inline)
        
    }

    private func agregar() {
        let nombreLimpio = nnombre.trimmingCharacters(in: .whitespaces)
        guard !nombreLimpio.isEmpty else { return }

        let nuevaSub = SubCategoria(
            nombre: nombreLimpio,
            descripcion: descripcion,
            categoria: categoria
        )

        vm.guardarSubCategoria(subCategoria: nuevaSub, contexto: modelContext)

        if vm.mensajeError == nil {
            nnombre = ""
            descripcion = ""
        }
    }

    private func eliminar(indexSet: IndexSet) {
        for index in indexSet {
            let sub = subCategorias[index]
            vm.eliminarSubCategoria(subCategoria: sub, contexto: modelContext)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Categoria.self,
        SubCategoria.self,
        configurations: config
    )
    let categoriaMock = Categoria(
        nombre: "Electrónica",
        descripcion: "Dispositivos y más"
    )
    container.mainContext.insert(categoriaMock)

    return NavigationStack {
        VistaSubCategoria(categoria: categoriaMock)
    }
    .modelContainer(container)
}
