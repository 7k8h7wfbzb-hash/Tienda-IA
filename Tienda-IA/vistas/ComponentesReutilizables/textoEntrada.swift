//
//  textoEntrada.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 6/10/26.
//

import SwiftUI

// MARK: - Componente Personalizado
struct textoEntrada: View {
    var titulo: String
    var icono: String
    @Binding var texto: String
    var teclado: UIKeyboardType = .default
    var esSeguro: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icono)
                .foregroundColor(.secondary)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 24)

            if esSeguro {
                SecureField(titulo, text: $texto)
            } else {
                TextField(titulo, text: $texto)
                    .keyboardType(teclado)
                    .autocapitalization(.none)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(texto.isEmpty ? Color.clear : Color.blue.opacity(0.6), lineWidth: 1.5)
        )
    }
}

// MARK: - Previews
#Preview("Componente Individual") {
    @Previewable @State var textoPrueba = "Ejemplo"
    return textoEntrada(titulo: "Nombres", icono: "person.crop.circle", texto: $textoPrueba)
        .padding()
}
