//
//  AppIntent.swift
//  MetroBilbaoWidget
//
//  Created by Aimar Pelea on 11/30/24.
//
import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuración de Metro" }
    static var description: IntentDescription { "Configura las estaciones de origen y destino para el widget del Metro Bilbao." }

    // Parámetros configurables (deben ser opcionales)
    @Parameter(title: "Origen 1")
    var origen1: Estacion?

    @Parameter(title: "Destino 1")
    var destino1: Estacion?

    @Parameter(title: "Origen 2")
    var origen2: Estacion?

    @Parameter(title: "Destino 2")
    var destino2: Estacion?

    @Parameter(title: "Origen 3")
    var origen3: Estacion?

    @Parameter(title: "Destino 3")
    var destino3: Estacion?

    @Parameter(title: "Origen 4")
    var origen4: Estacion?

    @Parameter(title: "Destino 4")
    var destino4: Estacion?
}

 
