//
//  MetroBilbaoWidget.swift
//  MetroBilbaoWidget
//
//  Created by Aimar Pelea on 11/30/24.
//

import WidgetKit
import SwiftUI
import AppIntents


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
        let currentDate = Date()
        print("📅 Timeline ejecutado a las: \(currentDate)")

        // Obtener las horas para cada fila

        let horas1 = await obtenerHoras(salida: configuration.origen1?.id ?? "", llegada: configuration.destino1?.id ?? "")
        let horas2 = await obtenerHoras(salida: configuration.origen2?.id ?? "", llegada: configuration.destino2?.id ?? "")
        let horas3 = await obtenerHoras(salida: configuration.origen3?.id ?? "", llegada: configuration.destino3?.id ?? "")
        let horas4 = await obtenerHoras(salida: configuration.origen4?.id ?? "", llegada: configuration.destino4?.id ?? "")

        // Combinar todas las horas
        let horasTotales = [horas1, horas2, horas3, horas4]

        // Crear la entrada con todas las filas
        let entry = SimpleEntry(date: currentDate, configuration: configuration, horas: horasTotales)
        
        // Programar la próxima actualización para dentro de 1 minuto
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        print("⏰ Próxima actualización programada para: \(nextUpdate)")

        // Devolver el Timeline con la entrada actual y la siguiente actualización
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
    
    func obtenerHoras(salida: String, llegada: String) async -> [String] {
        guard !salida.isEmpty, !llegada.isEmpty else {
            print("Estaciones no configuradas")
            return ["", ""]
        }

        let urlString = "https://api.metrobilbao.eus/metro/real-time/\(salida)/\(llegada)"
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return ["", ""]
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let trains = json["trains"] as? [[String: Any]] {
                
                let primerasHoras = trains.prefix(2).compactMap { $0["timeRounded"] as? String }
                return primerasHoras + Array(repeating: "", count: max(0, 2 - primerasHoras.count))
            } else {
                print("Formato de JSON inesperado")
                return ["", ""]
            }
        } catch {
            print("Error al obtener datos: \(error.localizedDescription)")
            return ["", ""]
        }

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

extension DateFormatter {
    static var shortTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter
    }
}

struct MetroBilbaoWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            // Título
            HStack {
                Text("Próximos Trenes:")
                    .font(.headline)

                Spacer() // Para separar el título de la hora de actualización

                Text("Act.: \(entry.date, formatter: DateFormatter.shortTime)")
                    .font(.caption)
                    .foregroundColor(.gray)
                // Botón para actualizar el widget
                Button(intent: ActualizarWidgetIntent()) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.blue)
                }
                .buttonStyle(.borderless)  // Evita que el botón afecte el diseño
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 5)
            
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
        .configurationDisplayName("MetroApp")
        .description("Consulta los horarios actualizados del Metro de Bilbao.")
        .supportedFamilies([.systemMedium, .systemLarge]) // Puedes agregar otros tamaños si quieres
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
