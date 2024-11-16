//
//  MetroWidgetEntryView.swift
//  Metro
//
//  Created by Aimar  Pelea on 16/11/24.
//


//
//  MetroWidgetEntryView.swift
//  Metro
//
//  Created by Aimar Pelea on 16/11/24.
//

import SwiftUI
import WidgetKit

struct MetroWidgetEntryView: View {
    var entry: MetroWidgetProvider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.title)
                .font(.headline)
            Text(entry.subtitle)
                .font(.caption)
            ForEach(entry.routes, id: \.self) { route in
                Text(route)
                    .font(.subheadline)
            }
        }
        .padding()
    }
}