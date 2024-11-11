//
//  ContentView.swift
//  Metro
//
//  Created by Aimar Pelea on 11/3/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    // Utilizamos `@AppStorage` para sincronizar directamente con `UserDefaults`
    @AppStorage("estacionSalida") private var estacionSalidaRawValue: String?
    @AppStorage("estacionLlegada") private var estacionLlegadaRawValue: String?
    
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
                            ForEach(Estacion.allCases.sorted(by: { $0.rawValue < $1.rawValue })) { estacion in
                                Text(estacion.rawValue).tag(estacion as Estacion?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(Color(red: 241/255, green: 78/255, blue: 45/255))
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
            print("Seleccione ambas estaciones")
            return
        }
    
        var urlString = "https://api.metrobilbao.eus/metro/real-time/\(salida)/\(llegada)"
        if(tipoSalida == TipoSalida.programada){
           
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let formattedDate = dateFormatter.string(from: fechaSeleccionada)
            
            let calendar = Calendar.current
            let hourDesde = calendar.component(.hour, from: horaDesde)
            let minuteDesde = calendar.component(.minute, from: horaDesde)
            let formattedTimeDesde = "\(hourDesde).\(minuteDesde)"

            // Obtener la hora y minutos para horaHasta
            let hourHasta = calendar.component(.hour, from: horaHasta)
            let minuteHasta = calendar.component(.minute, from: horaHasta)
            let formattedTimeHasta = "\(hourHasta).\(minuteHasta)"
            
            urlString = "https://api.metrobilbao.eus/metro/obtain-schedule-of-trip/\(salida)/\(llegada)/\(formattedTimeDesde)/\(formattedTimeHasta)/\(formattedDate)/es"
        }
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            print("URL no válida")
            return
        }
        if(tipoSalida == TipoSalida.inmediata){
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error en la solicitud: \(error)")
                    return
                }

                guard let data = data else {
                    print("No se recibió data")
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let trip = json["trip"] as? [String: Any],
                       let trains = json["trains"] as? [[String: Any]],
                       let transbordo = trip["transfer"] as? Bool,
                       let transbordoTexto = transbordo ? "Si" : "No",
                       let duration = trip["duration"] as? Int {

                        var nuevasRutas: [Ruta] = []
                        for train in trains {
                            if let timeRounded = train["timeRounded"] as? String,
                               let estimated = train["estimated"] as? Int {

                                // Calculamos la hora de llegada sumando la duración a la hora de salida
                                let salidaHora = timeRounded
                                let llegadaHora = calcularHoraLlegada(hora: timeRounded, minutos: estimated)

                                // Crear una nueva ruta para cada tren
                                let nuevaRuta = Ruta(horaSalida: salidaHora, horaLlegada: llegadaHora, duracion: duration, trasbordo: transbordoTexto)
                                nuevasRutas.append(nuevaRuta)
                            }
                        }
                        nuevasRutas.sort { ruta1, ruta2 in
                            return ruta1.horaSalida < ruta2.horaSalida
                        }
                        // Actualizamos la lista de rutas en el hilo principal
                        DispatchQueue.main.async {
                            rutas = nuevasRutas
                        }
                    }
                } catch {
                    print("Error al analizar JSON: \(error)")
                }
            }.resume()
        }else{
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error en la solicitud: \(error)")
                    return
                }

                guard let data = data else {
                    print("No se recibió data")
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let trips = json["trips"] as? [String: Any],
                        let transbordo = json["transfer"] as? Bool,
                        let transbordoTexto = transbordo ? "Si" : "No"{
                        
                        var nuevasRutas: [Ruta] = []
                        // Recorremos todas las claves dinámicas dentro de trips
                        for (_, tripArray) in trips {
                            if let tripData = tripArray as? [[String: Any]] {
                                for trip in tripData {
                                    if let originArrivalTimeRounder = trip["originArrivalTimeRounder"] as? String,
                                       let destinyArrivalTimeRounder = trip["destinyArrivalTimeRounder"] as? String,
                                       let originTime = trip["originTime"] as? [String: Any],
                                       let duracion = trip["time"] as? Int {
                                        
                                        // Extraemos la información de las rutas
                                        let salidaHora = originArrivalTimeRounder
                                        let llegadaHora = destinyArrivalTimeRounder
                                        // Crear una nueva ruta para cada elemento
                                        let nuevaRuta = Ruta(horaSalida: salidaHora, horaLlegada: llegadaHora, duracion: duracion, trasbordo: transbordoTexto)
                                        nuevasRutas.append(nuevaRuta)
                                    }
                                }
                            }
                        }
                        nuevasRutas.sort { ruta1, ruta2 in
                            return ruta1.horaSalida < ruta2.horaSalida
                        }
                        // Actualizamos la lista de rutas en el hilo principal
                        DispatchQueue.main.async {
                            rutas = nuevasRutas
                        }
                    }
                } catch {
                    print("Error al analizar JSON: \(error)")
                }
            }.resume()
        }
    }
    
    private func calcularHoraLlegada(hora: String, minutos: Int) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            guard let date = dateFormatter.date(from: hora) else { return "N/A" }
            let llegada = Calendar.current.date(byAdding: .minute, value: minutos, to: date)
            
            return dateFormatter.string(from: llegada ?? date)
        }
    
}
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}


enum TipoSalida {
    case inmediata
    case programada
}
