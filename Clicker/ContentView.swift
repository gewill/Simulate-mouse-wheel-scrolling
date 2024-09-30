//
//  ContentView.swift
//  Clicker
//
//  Created by will on 2024/9/30.
//

import SwiftUI

struct ContentView: View {
  @State var step: Int = 1
  @State var direction: Int = 1
  var body: some View {
    let _ = Self._printChanges()
    VStack {
      Text("Clicker")
        .font(.largeTitle)
      Stepper(value: $step, in: 1...1000) {
        Text("Step: \(step)")
      }
      Picker(selection: $direction, label: Text("Direction")) {
        Text("Up").tag(1)
        Text("Down").tag(-1)
      }
      Button("Start Click") {
        repeatTenTimesAfterDelay(delay: 1, count: 10) {
          simulateScroll()
        }
      }
    }
    .padding()
  }

  func repeatTenTimesAfterDelay(delay: Double, count: Int = 10, action: @escaping () -> Void) {
    guard count > 0 else { return }
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      action()
      repeatTenTimesAfterDelay(delay: delay, count: count - 1, action: action)
    }
  }

  func simulateScroll() {
    let eventSource = CGEventSource(stateID: .privateState)
    let scrollEvent = CGEvent(
      scrollWheelEvent2Source: eventSource,
      units: .line,
      wheelCount: UInt32(step),
      wheel1: Int32(direction),
      wheel2: 0,
      wheel3: 0
    )
    scrollEvent?.post(tap: .cghidEventTap)
  }
}

#Preview {
  ContentView()
}
