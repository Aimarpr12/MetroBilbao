//
//  MetroBilbaoWidgetLiveActivity.swift
//  MetroBilbaoWidget
//
//  Created by Aimar Pelea on 11/30/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MetroBilbaoWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MetroBilbaoWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MetroBilbaoWidgetAttributes.self) { context in
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

extension MetroBilbaoWidgetAttributes {
    fileprivate static var preview: MetroBilbaoWidgetAttributes {
        MetroBilbaoWidgetAttributes(name: "World")
    }
}

extension MetroBilbaoWidgetAttributes.ContentState {
    fileprivate static var smiley: MetroBilbaoWidgetAttributes.ContentState {
        MetroBilbaoWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MetroBilbaoWidgetAttributes.ContentState {
         MetroBilbaoWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MetroBilbaoWidgetAttributes.preview) {
   MetroBilbaoWidgetLiveActivity()
} contentStates: {
    MetroBilbaoWidgetAttributes.ContentState.smiley
    MetroBilbaoWidgetAttributes.ContentState.starEyes
}
