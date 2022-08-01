//
//  TimerAttributes.swift
//  LiveActivitySample
//
//  Created by 竹ノ内愛斗 on 2022/07/30.
//

import Foundation
import ActivityKit
import SwiftUI
import WidgetKit

struct TimerAttributes: ActivityAttributes {
    public typealias TimerStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var timerNumber: Int
    }

    var textName: String
}

struct TimerActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(attributesType: TimerAttributes.self) { context in
            HStack {
                Text(context.attributes.textName)
                Spacer()
                Text(String(context.state.timerNumber))
                    .font(.title)
                    .contentTransition(.numericText())
            }
            .padding()
            .activityBackgroundTint(.gray)
        }
    }
}

struct MyWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        TimerActivityWidget()
    }
}
