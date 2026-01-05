//
//  CounterApp.swift
//  Counter
//
//  Created by Victor Kilyungi on 03/01/2026.
//

import ComposableArchitecture
import SwiftUI

@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: CounterFeature.State()) {
                CounterFeature()
            })
        }
    }
}
