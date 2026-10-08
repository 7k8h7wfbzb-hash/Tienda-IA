//
//  FormularioCliente.swift
//  Tienda-IA
//
//  Created by kleber oswaldo muy landi on 4/10/26.
//

import SwiftData
import SwiftUI

struct FormularioCliente: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var clienteAEditar: Cliente? = nil

    @State private var vm = ModeloVistaCliente()

    @State private var cedula: String = ""
    @State private var nombres: String = ""
    @State private var apellidos: String = ""
    @State private var direccion: String = ""
    @State private var fechaNacimiento: Date = Date()
    @State private var telefono: String = ""
    @State private var email: String = ""
    @State private var imagen: String = ""

    @State private var mostrarAlerta: Bool = false
    @State private var mensajeAlerta: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Encabezado visual
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Registro de Cliente")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Ingresa los datos personales del nuevo cliente.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                    // Campos usando tu componente personalizado "textoEntrada"
                    VStack(spacing: 14) {
                        textoEntrada(
                            titulo: "Cédula",
                            icono: "creditcard",
                            texto: $cedula,
                            teclado: .numberPad
                        )

                        textoEntrada(
                            titulo: "Nombres",
                            icono: "person",
                            texto: $nombres
                        )

                        textoEntrada(
                            titulo: "Apellidos",
                            icono: "person.fill",
                            texto: $apellidos
                        )

                        textoEntrada(
                            titulo: "Dirección",
                            icono: "map",
                            texto: $direccion
                        )

                        textoEntrada(
                            titulo: "Teléfono",
                            icono: "phone",
                            texto: $telefono,
                            teclado: .phonePad
                        )

                        textoEntrada(
                            titulo: "Correo Electrónico",
                            icono: "envelope",
                            texto: $email,
                            teclado: .emailAddress
                        )
                    }
                    .padding(.horizontal)

                    // Selector de Fecha limpio
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fecha de Nacimiento")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)

                        DatePicker(
                            "",
                            selection: $fechaNacimiento,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                    // Botón de Guardar Principal
                    Button(action: guardarCliente) {
                        Text(clienteAEditar == nil ? "Guardar" : "Actualizar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.gradient)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .alert("Aviso", isPresented: $mostrarAlerta) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(mensajeAlerta)
            }
            .onAppear {
                if let cliente = clienteAEditar {
                    cedula = cliente.cedula
                    nombres = cliente.nombres
                    apellidos = cliente.apellidos
                    direccion = cliente.direccion
                    fechaNacimiento = cliente.fechaNacimiento
                    telefono = cliente.telefono
                    email = cliente.email
                    imagen = cliente.imagen
                }
            }
        }
    }

    private func guardarCliente() {
        guard !cedula.isEmpty, !nombres.isEmpty, !apellidos.isEmpty else {
            mensajeAlerta =
                "Por favor, completa al menos la cédula, nombres y apellidos."
            mostrarAlerta = true
            return
        }
        if let cliente = clienteAEditar {
            // MODO EDICIÓN: Modificamos las propiedades del objeto existente
            cliente.cedula = cedula
            cliente.nombres = nombres
            cliente.apellidos = apellidos
            cliente.direccion = direccion
            cliente.fechaNacimiento = fechaNacimiento
            cliente.telefono = telefono
            cliente.email = email
            cliente.imagen = imagen
            vm.actualizarCliente(cliente: cliente, contexto: modelContext)
            dismiss()
        } else {
            // MODO CREACIÓN: Creamos uno nuevo e insertamos
            let nuevoCliente = Cliente(
                cedula: cedula,
                nombres: nombres,
                apellidos: apellidos,
                direccion: direccion,
                fechaNacimiento: fechaNacimiento,
                telefono: telefono,
                email: email,
                imagen: imagen
            )
            vm.guardarCliente(cliente: nuevoCliente, contexto: modelContext)
            dismiss()
        }

    }

}

#Preview("Formulario Completo") {
    FormularioCliente()
        .modelContainer(for: [Cliente.self], inMemory: true)
}
