//
//  MetroWidgetBundle.swift
//  MetroWidget
//
//  Created by Aimar  Pelea on 16/11/24.
//

import WidgetKit
import SwiftUI

@main
struct MetroWidgetBundle: WidgetBundle {
    var body: some Widget {
        MetroWidget()
        MetroWidgetControl()
        MetroWidgetLiveActivity()
    }
}
