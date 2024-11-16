//
//  MetroWidgetLiveActivity.swift
//  MetroWidget
//
//  Created by Aimar  Pelea on 16/11/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MetroWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MetroWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MetroWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MetroWidgetAttributes {
    fileprivate static var preview: MetroWidgetAttributes {
        MetroWidgetAttributes(name: "World")
    }
}

extension MetroWidgetAttributes.ContentState {
    fileprivate static var smiley: MetroWidgetAttributes.ContentState {
        MetroWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MetroWidgetAttributes.ContentState {
         MetroWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MetroWidgetAttributes.preview) {
   MetroWidgetLiveActivity()
} contentStates: {
    MetroWidgetAttributes.ContentState.smiley
    MetroWidgetAttributes.ContentState.starEyes
}
