//
//  ContentView.swift
//  Clicker
//
//  Created by will on 2024/9/30.
//

import SwiftUI

struct ContentView: View {
  @State var step: Int = 1
  @State var direction: Int = -1
  @State var count: Int = 10
  @State var isRunning: Bool = false

  var body: some View {
    let _ = Self._printChanges()
    VStack {
      Text("Clicker")
        .font(.largeTitle)
      Text("Running: \(isRunning ? "Yes" : "No")")
        .font(.headline)
        .foregroundColor(isRunning ? .green : .primary)
      VStack(alignment: .leading) {
        Text("Parameters")
          .font(.headline)
        Stepper(value: $step, in: 1 ... 1000) {
          Text("Step: \(step)")
        }
        Picker(selection: $direction, label: Text("Direction: ")) {
          Text("Up").tag(1)
          Text("Down").tag(-1)
        }
        HStack {
          Text("Count: ")
          TextField("Count", value: $count, formatter: NumberFormatter())
        }
      }
      .padding()
      .border(Color.secondary)

      HStack {
        Button("Start Click") {
          isRunning = true
          repeatTenTimesAfterDelay(delay: 1) {
            simulateScroll()
          }
        }
        .buttonStyle(.borderedProminent)
        .disabled(isRunning)

        Button(action: {
          count = 0
          isRunning = false
        }, label: {
          Text("Stop")
            .foregroundStyle(.red)
        })
        .disabled(isRunning == false)

        Button {
          step = 1
          direction = -1
          count = 10
        } label: {
          Text("Reset")
        }
        .disabled(isRunning)
      }
    }
    .padding()
  }

  func repeatTenTimesAfterDelay(delay: Double, action: @escaping () -> Void) {
    guard count > 0 else {
      isRunning = false
      return
    }
    count -= 1
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      action()
      repeatTenTimesAfterDelay(delay: delay, action: action)
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
