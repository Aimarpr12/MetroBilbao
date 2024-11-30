//
//  AppIntent.swift
//  MetroBilbaoWidget
//
//  Created by Aimar Pelea on 11/30/24.
//
/*
import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "Widget para mostrar estaciones de Metro Bilbao." }

    // Parámetros configurables para las estaciones
    @Parameter(title: "Origen 1", default: "Bilbao")
    var origen1: String

    @Parameter(title: "Destino 1", default: "Barakaldo")
    var destino1: String

    @Parameter(title: "Origen 2", default: "Barakaldo")
    var origen2: String

    @Parameter(title: "Destino 2", default: "Santurtzi")
    var destino2: String

    @Parameter(title: "Origen 3", default: "Santurtzi")
    var origen3: String

    @Parameter(title: "Destino 3", default: "Sestao")
    var destino3: String

    @Parameter(title: "Origen 4", default: "Sestao")
    var origen4: String

    @Parameter(title: "Destino 4", default: "Portugalete")
    var destino4: String
}
*/

 
 
 
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

 
