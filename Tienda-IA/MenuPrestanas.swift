//
//  MenuPrestanas.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 6/10/26.
//

import SwiftUI

struct MenuPrestanas: View {
    var body: some View {
        TabView {

            Text("Hello, World!")
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            NavigationStack {
                VistaCliente()
            }
            .tabItem {
                Label("Clientes", systemImage: "person.crop.circle")
            }
            
            NavigationStack {
                VistaProducto()
            }
            .tabItem {
                Label("Productos", systemImage: "cart.fill")
            }

        }
    }
}

#Preview {
    MenuPrestanas()
}
