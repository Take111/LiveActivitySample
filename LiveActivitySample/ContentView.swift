//
//  ContentView.swift
//  LiveActivitySample
//
//  Created by 竹ノ内愛斗 on 2022/07/30.
//

import SwiftUI
import ActivityKit
import LiveActivityWidgetExtension

struct ContentView: View {

    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .task {
            viewModel.onAppear()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

@MainActor
final class ContentViewModel: ObservableObject {

    private var timer: Timer?
    private var count: Int = 0

    private var timerActivity: Activity<TimerAttributes>?

    func onAppear() {
        let timeAttributes = TimerAttributes(textName: "Timer Count Up")
        let initialStatus = TimerAttributes.TimerStatus(timerNumber: 0)

        do {
            timerActivity = try Activity<TimerAttributes>.request(attributes: timeAttributes, contentState: initialStatus, pushType: nil)
            print("request has started", timerActivity)
        } catch (let error) {
            print("error has occured", error)
        }

        timerSetUp()
    }

    func timerSetUp() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countUp), userInfo: nil, repeats: true)
    }

    @objc private func countUp() {
        Task {
            self.count += 1
            await self.updateLiveActivity(count: self.count)
        }
    }

    func updateLiveActivity(count: Int) async {
        let status = TimerAttributes.TimerStatus(timerNumber: self.count)
        await timerActivity?.update(using: status)
    }
}

