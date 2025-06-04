//
//  ContentView.swift
//  Metro
//
//  Created by Aimar Pelea on 11/3/24.
//

import SwiftUI
import CoreData
import CoreLocation

extension Color {
    static let primaryColor = Color(red: 241/255, green: 78/255, blue: 45/255)
    static let secondaryColor = Color(red: 120/255, green: 200/255, blue: 150/255)
}

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var lastLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var lastError: Error?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestPermissionIfNeeded() {
        let status = manager.authorizationStatus
        authorizationStatus = status

        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            break
        default:
            break
        }
    }

    func requestOneShotLocation() {
        lastError = nil
        manager.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            requestOneShotLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        lastError = error
    }
}

private struct NearbyStationResponse: Decodable {
    let code: String
    let name: String
    let exit: Exit

    struct Exit: Decodable {
        let name: String
        let address: String
        let latitude: String
        let longitude: String
    }
}

struct ContentView: View {
    
    // Utilizamos `@AppStorage` para sincronizar directamente con `UserDefaults`
    @AppStorage("estacionSalida") private var estacionSalidaRawValue: String?
    @AppStorage("estacionLlegada") private var estacionLlegadaRawValue: String?
    @State private var errorMensaje: String? = nil
    @State private var estacionSalida: Estacion?
    @State private var estacionLlegada: Estacion?
    @State private var rutas: [Ruta] = []
    
    @State private var tipoSalida: TipoSalida = .teleindicador
    // Variables para los selectores de fecha
    @State private var fechaSeleccionada: Date = Date()
    @State private var horaDesde: Date = Date()
    @State private var horaHasta: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        HStack(spacing: 8) {
                            Picker("Estación de Salida", selection: Binding<Estacion?>(
                                get: { estacionSalida },
                                set: { newValue in
                                    estacionSalida = newValue
                                    estacionSalidaRawValue = newValue?.rawValue
                                }
                            )) {
                                Text("Seleccione una estación").tag(nil as Estacion?)
                                ForEach(Estacion.allCases.sorted(by: { $0.rawValue < $1.rawValue })) { estacion in
                                    Text(estacion.rawValue)
                                        .lineLimit(1)                 // <- clave
                                        .truncationMode(.tail)
                                        .tag(estacion as Estacion?)
                                }
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading) // <- clave
                            .layoutPriority(1)                                // <- clave
                            .accentColor(Color(red: 241/255, green: 78/255, blue: 45/255))
                            .padding(.vertical)
                            .padding(.leading)

                            Button(action: { buscarEstacionMasCercana() }) {
                                Image(systemName: "location.fill")
                                    .font(.title)
                                    .padding()
                                    .clipShape(Circle())
                                    .foregroundColor(Color(red: 241/255, green: 78/255, blue: 45/255))
                            }
                            .padding(.trailing)
                        }
                        if tipoSalida != .teleindicador {
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
                                Text("Seleccione una estación")
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .tag(nil as Estacion?)
                                ForEach(Estacion.allCases.sorted(by: { $0.rawValue < $1.rawValue })) { estacion in
                                    Text(estacion.rawValue)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .tag(estacion as Estacion?)
                                }
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .layoutPriority(1)
                            .accentColor(Color(red: 241/255, green: 78/255, blue: 45/255))
                            .padding(.vertical)
                            .padding(.leading)
                        }
                    }
                    //Eliminar la flecha para cambiar las direcciones si es teleindicador
                    if tipoSalida != .teleindicador {
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
                        Text("Teleindicador").tag(TipoSalida.teleindicador)
                        Text("Salida Inmediata").tag(TipoSalida.inmediata)
                        Text("Programar Viaje").tag(TipoSalida.programada)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .onChange(of: tipoSalida) { newValue in
                        buscarRuta()
                    }
                    
                    
                    // Mostrar la selección de fecha/hora solo si el usuario elige "Programar Viaje"
                    if tipoSalida == .programada {
                        HStack {
                            Text("Fecha")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                            DatePicker("", selection: $fechaSeleccionada, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .accentColor(Color.primaryColor)
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
                                .accentColor(Color.primaryColor)
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
                                .accentColor(Color.primaryColor)
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
                        if tipoSalida != .teleindicador {
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
                        else {
                            HStack {
                                Text("Destino").bold().frame(width: 100, alignment: .center)
                                Text("Hora").bold().frame(width: 100, alignment: .center)
                                Text("Faltan").bold().frame(width: 100, alignment: .center)
                            }
                            .padding(.horizontal)
                            Divider()
                                .background(Color.black) // Cambia el color de la línea a negro
                                .frame(height: 1)
                            ScrollView {
                                VStack(alignment: .leading) {
                                    ForEach(rutas, id: \.id) { (ruta: Ruta) in
                                        HStack {
                                            Text(ruta.horaSalida).frame(width: 100, alignment: .center)
                                            Text(ruta.horaLlegada).frame(width: 100, alignment: .center)
                                            Text("\(ruta.duracion) min").frame(width: 100, alignment: .center)
                                        }
                                        .padding(.horizontal)
                                        Divider()
                                            .background(Color.black) // Cambia el color de la línea a negro
                                            .frame(height: 1)
                                    }
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
                locationManager.requestPermissionIfNeeded()
                // Cargar estaciones almacenadas al iniciar la vista
                if let salidaRaw = estacionSalidaRawValue {
                    estacionSalida = Estacion(rawValue: salidaRaw)
                }
                if let llegadaRaw = estacionLlegadaRawValue {
                    estacionLlegada = Estacion(rawValue: llegadaRaw)
                }
                // Realizar la primera búsqueda nada más abrir la app
                DispatchQueue.main.async {
                    buscarRuta()
                }
            }
        
    }
    
    private func buscarRuta() {
        // Validación de estaciones según el tipo de salida
        guard let salida = estacionSalida else {
            errorMensaje = "Seleccione la estación de salida"
            return
        }
        
        var llegadaValida: Estacion? = nil
        if tipoSalida != .teleindicador {
            guard let llegadaEstacion = estacionLlegada else {
                errorMensaje = "Seleccione la estación de llegada"
                return
            }
            guard salida != llegadaEstacion else {
                errorMensaje = "La estación de salida y la estación de llegada no pueden ser iguales"
                return
            }
            llegadaValida = llegadaEstacion
        }
        
        errorMensaje = nil
        
        MetroService.shared.buscarRuta(
            salida: "\(salida)",
            llegada: llegadaValida != nil ? "\(llegadaValida!)" : "",
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
    
    private func buscarEstacionMasCercana() {
        locationManager.requestPermissionIfNeeded()
        locationManager.requestOneShotLocation()

        // If we already have a cached location, use it immediately.
        if let loc = locationManager.lastLocation {
            fetchNearbyStation(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude)
            return
        }

        // Otherwise, wait a moment for CoreLocation to return.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            if let err = locationManager.lastError {
                errorMensaje = "No se pudo obtener la ubicación: \(err.localizedDescription)"
                return
            }

            guard let loc2 = locationManager.lastLocation else {
                switch locationManager.authorizationStatus {
                case .denied, .restricted:
                    errorMensaje = "Permiso de ubicación denegado. Actívalo en Ajustes para usar esta función."
                default:
                    errorMensaje = "No se pudo obtener la ubicación. Inténtalo de nuevo."
                }
                return
            }

            fetchNearbyStation(lat: loc2.coordinate.latitude, lon: loc2.coordinate.longitude)
        }
    }

    private func fetchNearbyStation(lat: Double, lon: Double) {
        errorMensaje = nil

        // Build the URL: https://api.metrobilbao.eus/metro/obtain-nearby-station/{lat}/{lon}
        let urlString = "https://api.metrobilbao.eus/metro/obtain-nearby-station/\(lat)/\(lon)"
        print("[NearbyStation] URL -> \(urlString)")

        guard let url = URL(string: urlString) else {
            errorMensaje = "URL inválida para obtener la estación más cercana."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 12
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        Task {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)

                guard let http = response as? HTTPURLResponse else {
                    await MainActor.run {
                        errorMensaje = "Respuesta inválida del servidor."
                    }
                    return
                }

                if !(200...299).contains(http.statusCode) {
                    let body = String(data: data, encoding: .utf8) ?? "(no UTF-8 body)"
                    print("[NearbyStation] HTTP \(http.statusCode) body -> \(body)")
                    await MainActor.run {
                        errorMensaje = "Error del servidor (HTTP \(http.statusCode))."
                    }
                    return
                }

                guard !data.isEmpty else {
                    print("[NearbyStation] Empty body (HTTP \(http.statusCode))")
                    await MainActor.run {
                        errorMensaje = "La API devolvió una respuesta vacía."
                    }
                    return
                }

                // Debug raw JSON (useful while developing)
                if let raw = String(data: data, encoding: .utf8) {
                    print("[NearbyStation] JSON -> \(raw)")
                }

                let decoded = try JSONDecoder().decode(NearbyStationResponse.self, from: data)

                await MainActor.run {
                    // Map using the API CODE (e.g. "ARZ" -> Estacion.ARZ)
                    if let estacion = Estacion(apiCode: decoded.code) {
                        estacionSalida = estacion
                        estacionSalidaRawValue = estacion.rawValue
                        buscarRuta()
                    } else {
                        errorMensaje = "La API devolvió el código \"\(decoded.code)\" pero no existe en tu enum Estacion."
                    }
                }
            } catch {
                // If decoding fails, show the specific decoding error
                if let decErr = error as? DecodingError {
                    print("[NearbyStation] DecodingError -> \(decErr)")
                } else {
                    print("[NearbyStation] Error -> \(error)")
                }

                await MainActor.run {
                    errorMensaje = "Error obteniendo estación cercana: \(error.localizedDescription)"
                }
            }
        }
    }
    
}
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
