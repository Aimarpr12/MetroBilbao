//
//  MetroBilbaoWidget.swift
//  MetroBilbaoWidget
//
//  Created by Aimar Pelea on 11/30/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        // Placeholder con un array de horas vacío
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), horas: [["08:00", "08:15"]])
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        // Snapshot con datos simulados
        let horasSimuladas = [["08:30", "08:45"]]
        return SimpleEntry(date: Date(), configuration: configuration, horas: horasSimuladas)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        print("saddsdasdada")
        print("saddsdasdada")
        let currentDate = Date()
        var entries: [SimpleEntry] = []
        
        // Crear entradas para los próximos 60 minutos
        for minuteOffset in 0..<60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let horas = await obtenerHoras(salida: configuration.origen1?.id ?? "", llegada: configuration.destino1?.id ?? "")
            let entry = SimpleEntry(date: entryDate, configuration: configuration, horas: [horas])
            entries.append(entry)
        }
        
        // Devolver el timeline con el policy .everyMinute
        return Timeline(entries: entries, policy: .after(Date().addingTimeInterval(TimeInterval(60.0))))
    }
    /*
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        print("Timeline llamado")
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        // Obtener datos reales o simulados
        let horas1 = await obtenerHoras(salida: configuration.origen1?.id ?? "", llegada: configuration.destino1?.id ?? "")
        let horas2 = await obtenerHoras(salida: configuration.origen2?.id ?? "", llegada: configuration.destino2?.id ?? "")
        let horas3 = await obtenerHoras(salida: configuration.origen3?.id ?? "", llegada: configuration.destino3?.id ?? "")
        let horas4 = await obtenerHoras(salida: configuration.origen4?.id ?? "", llegada: configuration.destino4?.id ?? "")

        let horasTotales = [horas1, horas2, horas3, horas4]

        // Crear entradas con actualizaciones cada minuto
        for minuteOffset in 0..<60 { // Actualizar cada minuto
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, horas: horasTotales)
            entries.append(entry)
        }

        // Si no hay entradas, agregar una predeterminada
        if entries.isEmpty {
            entries.append(SimpleEntry(date: Date(), configuration: configuration, horas: [["", ""]]))
        }

        // Devolver el timeline
        return Timeline(entries: entries, policy: .atEnd)
    }
    
    func obtenerHoras(salida: String, llegada: String) async -> [String] {
        let urlString = "https://api.metrobilbao.eus/metro/real-time/\(salida)/\(llegada)"
        print("sadsa")
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return []
        }

        do {
            // Realizar la solicitud usando async/await
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Procesar los datos recibidos
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                var primerasHoras: [String] = []

                // Extraer la información necesaria
                if let trains = json["trains"] as? [[String: Any]] {
                    for train in trains.prefix(2) { // Solo toma los primeros dos trenes
                        if let timeRounded = train["timeRounded"] as? String {
                            primerasHoras.append(timeRounded)
                        }
                    }
                }

                // Completa con valores vacíos si no hay suficientes trenes
                while primerasHoras.count < 2 {
                    primerasHoras.append("")
                }

                return primerasHoras
            } else {
                print("El JSON no contiene la estructura esperada")
                return ["", ""]
            }
        } catch {
            print("Error al realizar la solicitud o procesar los datos: \(error)")
            return ["", ""]
        }
    }*/
    
    
    func obtenerHoras(salida: String, llegada: String) async -> [String] {
        return ["08:00", "08:15"]
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let horas: [[String]]
}

struct MetroBilbaoWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            // Título
            Text("Próximos Trenes:")
                .font(.headline)
                .padding(.bottom, 5)
                .padding(.leading, 10)

            // Tabla con información
            VStack(spacing: 4) {
                // Encabezados
                let width1: CGFloat = 90
                let width2: CGFloat = 90
                let width3: CGFloat = 50
                let width4: CGFloat = 50

                HStack {
                    Text("Origen")
                        .font(.caption)
                        .bold()
                        .frame(width: width1, alignment: .leading)
                    Text("Destino")
                        .font(.caption)
                        .bold()
                        .frame(width: width2, alignment: .leading)
                    Text("Próx 1")
                        .font(.caption)
                        .bold()
                        .frame(width: width3, alignment: .leading)
                    Text("Próx 2")
                        .font(.caption)
                        .bold()
                        .frame(width: width4, alignment: .leading)
                }
                
                Divider()

                // Fila 1
                HStack {
                    Text(entry.configuration.origen1?.nombre ?? "No configurado")
                        .font(.subheadline)
                        .frame(width: width1, alignment: .leading)
                    Text(entry.configuration.destino1?.nombre ?? "No configurado")
                        .font(.subheadline)
                        .frame(width: width2, alignment: .leading)
                    Text(entry.horas.indices.contains(0) && entry.horas[0].indices.contains(0) ? entry.horas[0][0] : "")
                        .font(.subheadline)
                        .frame(width: width3, alignment: .leading)
                    Text(entry.horas.indices.contains(0) && entry.horas[0].indices.contains(1) ? entry.horas[0][1] : "")
                        .font(.subheadline)
                        .frame(width: width4, alignment: .leading)
                }

                // Fila 2
                HStack {
                    Text(entry.configuration.origen2?.nombre ?? "No configurado")
                        .font(.subheadline)
                        .frame(width: width1, alignment: .leading)
                    Text(entry.configuration.destino2?.nombre ?? "No configurado")
                        .font(.subheadline)
                        .frame(width: width2, alignment: .leading)
                    Text(entry.horas.indices.contains(1) && entry.horas[1].indices.contains(0) ? entry.horas[1][0] : "")
                        .font(.subheadline)
                        .frame(width: width3, alignment: .leading)
                    Text(entry.horas.indices.contains(1) && entry.horas[1].indices.contains(1) ? entry.horas[1][1] : "")
                        .font(.subheadline)
                        .frame(width: width4, alignment: .leading)
                }

                // Fila 3
                HStack {
                    Text(entry.configuration.origen3?.nombre ?? "No configurado")
                        .font(.subheadline)
                        .frame(width: width1, alignment: .leading)
                    Text(entry.configuration.destino3?.nombre ?? "No configurado")
                        .font(.subheadline)
                        .frame(width: width2, alignment: .leading)
                    Text(entry.horas.indices.contains(2) && entry.horas[2].indices.contains(0) ? entry.horas[2][0] : "")
                        .font(.subheadline)
                        .frame(width: width3, alignment: .leading)
                    Text(entry.horas.indices.contains(2) && entry.horas[2].indices.contains(1) ? entry.horas[2][1] : "")
                        .font(.subheadline)
                        .frame(width: width4, alignment: .leading)
                }

                // Fila 4
                HStack {
                    Text(entry.configuration.origen4?.nombre ?? "No configurado")
                        .font(.subheadline)
                        .frame(width: width1, alignment: .leading)
                    Text(entry.configuration.destino4?.nombre ?? "No configurado")
                        .font(.subheadline)
                        .frame(width: width2, alignment: .leading)
                    Text(entry.horas.indices.contains(3) && entry.horas[3].indices.contains(0) ? entry.horas[3][0] : "")
                        .font(.subheadline)
                        .frame(width: width3, alignment: .leading)
                    Text(entry.horas.indices.contains(3) && entry.horas[3].indices.contains(1) ? entry.horas[3][1] : "")
                        .font(.subheadline)
                        .frame(width: width4, alignment: .leading)
                }
            }
            .padding(.horizontal, 8)
        }
    }
}

struct MetroBilbaoWidget: Widget {
    let kind: String = "MetroBilbaoWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: Provider()
        ) { entry in
            MetroBilbaoWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Metro Bilbao")
        .description("A widget that shows the current status of the Metro Bilbao.")
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
    }
    
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        return intent
    }
}

#Preview(as: .systemMedium) {
    MetroBilbaoWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, horas: [["08:00", "08:15"]])
}
