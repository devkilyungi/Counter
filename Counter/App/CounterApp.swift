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
    private let store = Store(initialState: AppFeature.State()) {
        AppFeature()
        #if DEBUG
            ._printChanges()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}
