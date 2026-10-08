//  VistaSubCategoria.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 6/10/26.
//

import SwiftData
import SwiftUI

struct VistaSubCategoria: View {
    @Environment(\.modelContext) private var modelContext

    let categoria: Categoria

    // Consulta reactiva filtrada por la categoría actual
    @Query private var subCategorias: [SubCategoria]

    @State private var nnombre: String = ""
    @State private var descripcion: String = ""

    // ViewModel correctamente instanciado con @State
    @State private var vm = ModeloVistaSubCategoria()

    // Inicializador para filtrar las subcategorías por la categoría recibida
    init(categoria: Categoria) {
        self.categoria = categoria
        let categoriaID = categoria.id

        _subCategorias = Query(
            filter: #Predicate<SubCategoria> { sub in
                // Ajusta esto según cómo relacione tu modelo SubCategoria la categoría (por ID o por relación directa)
                sub.categoria?.id == categoriaID
            },
            sort: \SubCategoria.nombre
        )
    }

    var body: some View {
        NavigationStack {
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
                .frame(height: 250)  // Limitamos la altura del formulario superior para dar espacio a la lista

                // Listado filtrado
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
    }

    private func agregar() {
        let nombreLimpio = nnombre.trimmingCharacters(in: .whitespaces)
        guard !nombreLimpio.isEmpty else { return }

        let nuevaSub = SubCategoria(
            nombre: nombreLimpio,
            descripcion: descripcion,
            categoria: categoria  // Pasamos la relación directa con la categoría
        )

        vm.guardarSubCategoria(subCategoria: nuevaSub, contexto: modelContext)

        // Limpiamos los campos tras guardar
        nnombre = ""
        descripcion = ""
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

    return VistaSubCategoria(categoria: categoriaMock)
        .modelContainer(container)
}
