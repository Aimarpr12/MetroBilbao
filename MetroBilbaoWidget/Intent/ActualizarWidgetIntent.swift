//
//  ActualizarWidgetIntent.swift
//  Metro
//
//  Created by Aimar Pelea on 2/22/25.
//


import AppIntents
import WidgetKit

struct ActualizarWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "Actualizar Widget"
    static var description = IntentDescription("Fuerza la actualización de los datos del widget.")

    @MainActor
    func perform() async throws -> some IntentResult {
        print("🔄 Botón de actualización presionado.")
        WidgetCenter.shared.reloadAllTimelines()  // Fuerza la recarga del widget
        return .result()
    }
}
