//
//  MetroWidgetProvider.swift
//  Metro
//
//  Created by Aimar Pelea on 16/11/24.
//

import WidgetKit
import SwiftUI

struct MetroWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "Próximo Metro", subtitle: "Sin datos disponibles", routes: ["Trayecto 1", "Trayecto 2", "Trayecto 3", "Trayecto 4"])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), title: "Próximo Metro", subtitle: "Sin datos disponibles", routes: ["Trayecto 1", "Trayecto 2", "Trayecto 3", "Trayecto 4"])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Datos de trayectos por defecto
        let defaultRoutes = ["Trayecto 1", "Trayecto 2", "Trayecto 3", "Trayecto 4"]
        let currentDate = Date()
        
        // Generar actualizaciones cada minuto durante 60 minutos
        for minuteOffset in 0..<60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = SimpleEntry(
                date: entryDate,
                title: "Actualización de Metro",
                subtitle: "Última actualización: \(formattedDate(entryDate))",
                routes: defaultRoutes
            )
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
}
