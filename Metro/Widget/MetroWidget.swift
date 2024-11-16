//
//  MetroWidget.swift
//  Metro
//
//  Created by Aimar Pelea on 16/11/24.
//

import WidgetKit
import SwiftUI
import Intents


struct MetroWidget: Widget {
    let kind: String = "MetroWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MetroWidgetProvider()) { entry in
            MetroWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Metro Widget")
        .description("Muestra información sobre el próximo metro.")
        .supportedFamilies([.systemMedium]) // Puedes configurar el tamaño según tus necesidades
    }
}
