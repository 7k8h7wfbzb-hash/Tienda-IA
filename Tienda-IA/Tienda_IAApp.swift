//
//  Tienda_IAApp.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 1/10/26.
//

import SwiftUI
import SwiftData

@main
struct Tienda_IAApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Cliente.self,
            Categoria.self,
            SubCategoria.self,
            Producto.self,
            
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MenuPrestanas()
        }
        .modelContainer(sharedModelContainer)
    }
}
