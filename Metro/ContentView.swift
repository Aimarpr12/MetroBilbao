//
//  ContentView.swift
//  Metro
//
//  Created by Aimar Pelea on 11/3/24.
//

import SwiftUI
import CoreData

extension Color {
    static let primaryColor = Color(red: 241/255, green: 78/255, blue: 45/255)
    static let secondaryColor = Color(red: 120/255, green: 200/255, blue: 150/255)
}

struct ContentView: View {
    
    // Utilizamos `@AppStorage` para sincronizar directamente con `UserDefaults`
    @AppStorage("estacionSalida") private var estacionSalidaRawValue: String?
    @AppStorage("estacionLlegada") private var estacionLlegadaRawValue: String?
    @State private var errorMensaje: String? = nil
    @State private var estacionSalida: Estacion?
    @State private var estacionLlegada: Estacion?
    @State private var rutas: [Ruta] = []
    
    @State private var tipoSalida: TipoSalida = .inmediata
    // Variables para los selectores de fecha
    @State private var fechaSeleccionada: Date = Date()
    @State private var horaDesde: Date = Date()
    @State private var horaHasta: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    
    var body: some View {
            VStack (alignment: .leading) {
                HStack {
                    VStack {
                        // Estación de Salida Dropdown
                        Picker("Estación de Salida", selection: Binding<Estacion?>(
                            get: {
                                estacionSalida
                            },
                            set: { newValue in
                                estacionSalida = newValue
                                estacionSalidaRawValue = newValue?.rawValue // Guardar en UserDefaults
                            }
                        )) {
                            Text("Seleccione una estación").tag(nil as Estacion?)
                                .foregroundColor(Color("PrimaryColor"))
                            ForEach(Estacion.allCases.sorted(by: { $0.rawValue < $1.rawValue })) { estacion in
                                Text(estacion.rawValue).tag(estacion as Estacion?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(Color(red: 241/255, green: 78/255, blue: 45/255)) // Cambia el color de la letra aquí
                        .padding()

                        // Estación de Llegada Dropdown
                        Picker("Estación de Llegada", selection: Binding<Estacion?>(
                            get: {
                                estacionLlegada
                            },
                            set: { newValue in
                                estacionLlegada = newValue
                                estacionLlegadaRawValue = newValue?.rawValue // Guardar en UserDefaults
                            }
                        )) {
                            Text("Seleccione una estación").tag(nil as Estacion?)
                            ForEach(Estacion.allCases.sorted(by: { $0.rawValue < $1.rawValue })) { estacion in
                                Text(estacion.rawValue).tag(estacion as Estacion?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(Color(red: 241/255, green: 78/255, blue: 45/255)) // Cambia el color de la letra aquí
                        .padding()
                    }

                    VStack {
                        // Botón de intercambio con icono, alineado a la derecha
                        Button(action: {
                            // Intercambiar las estaciones de salida y llegada
                            let temp = estacionSalida
                            estacionSalida = estacionLlegada
                            estacionLlegada = temp
                            
                            // Actualizar los valores en UserDefaults si es necesario
                            estacionSalidaRawValue = estacionSalida?.rawValue
                            estacionLlegadaRawValue = estacionLlegada?.rawValue
                        }) {
                            Image(systemName: "arrow.left.arrow.right")
                                .font(.title)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .clipShape(Circle())
                                .foregroundColor(Color(red: 241/255, green: 78/255, blue: 45/255)) // Cambia el color del ícono
                        }
                        .padding(.trailing)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                
                // Mostrar mensaje de error si existe
                if let mensaje = errorMensaje {
                    Text(mensaje)
                        .foregroundColor(.red)
                        .padding(.top, 5)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                VStack {
                    // Radio para elegir entre salida inmediata y programar viaje
                    Picker("Tipo de Salida", selection: $tipoSalida) {
                        Text("Salida Inmediata").tag(TipoSalida.inmediata)
                        Text("Programar Viaje").tag(TipoSalida.programada)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    // Mostrar la selección de fecha/hora solo si el usuario elige "Programar Viaje"
                    if tipoSalida == .programada {
                        HStack {
                            Text("Fecha")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                            DatePicker("", selection: $fechaSeleccionada, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                            
                        }
                        .padding()

                        // Selección de Hora Desde y Hora Hasta si es necesario
                        HStack {
                            Text("Desde")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                            DatePicker("", selection: $horaDesde, displayedComponents: .hourAndMinute)
                                .datePickerStyle(CompactDatePickerStyle())
                                .onChange(of: horaDesde) { newHoraDesde in
                                    horaHasta = Calendar.current.date(byAdding: .hour, value: 1, to: newHoraDesde) ?? newHoraDesde
                                }
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                        
                            Text("Hasta")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                            DatePicker("", selection: $horaHasta, displayedComponents: .hourAndMinute)
                                .datePickerStyle(CompactDatePickerStyle())
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                            
                        }
                        .padding()
                    }
                }
                
                // Botón de búsqueda
                Button(action: buscarRuta) {
                    Text("Buscar")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 241/255, green: 78/255, blue: 45/255))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                if !rutas.isEmpty {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Salida").bold().frame(width: 60, alignment: .center)
                            Text("Llegada").bold().frame(width: 70, alignment: .center)
                            Text("Duración").bold().frame(width: 80, alignment: .center)
                            Text("Trasbordo").bold().frame(width: 90, alignment: .center)
                        }
                        .padding(.horizontal)
                        Divider()
                            .background(Color.black) // Cambia el color de la línea a negro
                            .frame(height: 1)
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(rutas, id: \.id) { (ruta: Ruta) in
                                    HStack {
                                        Text(ruta.horaSalida).frame(width: 70, alignment: .center)
                                        Text(ruta.horaLlegada).frame(width: 70, alignment: .center)
                                        Text("\(ruta.duracion) min").frame(width: 80, alignment: .center)
                                        Text(ruta.trasbordo).frame(width: 80, alignment: .center)
                                    }
                                    .padding(.horizontal)
                                    Divider()
                                        .background(Color.black) // Cambia el color de la línea a negro
                                        .frame(height: 1)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationTitle("Buscar Ruta")
            .onAppear {
                // Cargar estaciones almacenadas al iniciar la vista
                if let salidaRaw = estacionSalidaRawValue {
                    estacionSalida = Estacion(rawValue: salidaRaw)
                }
                if let llegadaRaw = estacionLlegadaRawValue {
                    estacionLlegada = Estacion(rawValue: llegadaRaw)
                }
            }
        
    }
    
    private func buscarRuta() {
        guard let salida = estacionSalida, let llegada = estacionLlegada else {
            errorMensaje = "Seleccione ambas estaciones"
            return
        }
        
        guard salida != llegada else {
            errorMensaje = "La estación de salida y la estación de llegada no pueden ser iguales"
            return
        }
        
        errorMensaje = nil
        
        MetroService.shared.buscarRuta(
            salida: "\(salida)",
            llegada: "\(llegada)",
            tipoSalida: tipoSalida,
            fechaSeleccionada: tipoSalida == .programada ? fechaSeleccionada : nil,
            horaDesde: tipoSalida == .programada ? horaDesde : nil,
            horaHasta: tipoSalida == .programada ? horaHasta : nil
        ) { rutasObtenidas in
            DispatchQueue.main.async {
                self.rutas = rutasObtenidas
            }
        }
    }
    
}
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
