//
//  MetroBilbaoWidgetBundle.swift
//  MetroBilbaoWidget
//
//  Created by Aimar Pelea on 11/30/24.
//

import WidgetKit
import SwiftUI

@main
struct MetroBilbaoWidgetBundle: WidgetBundle {
    var body: some Widget {
        MetroBilbaoWidget()
        MetroBilbaoWidgetControl()
        MetroBilbaoWidgetLiveActivity()
    }
}
