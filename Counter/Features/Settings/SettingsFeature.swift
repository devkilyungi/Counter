//
//  SettingsFeature.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import ComposableArchitecture
import Foundation

@Reducer
struct SettingsFeature {
    @ObservableState
    struct State: Equatable {
        var isDarkModeEnabled = false
        var autoIncrementSpeed = 1.0
    }

    enum Action {
        case darkModeToggled(Bool)
        case autoIncrementSpeedChanged(Double)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .darkModeToggled(isEnabled):
                state.isDarkModeEnabled = isEnabled
                return .none

            case let .autoIncrementSpeedChanged(speed):
                state.autoIncrementSpeed = speed
                return .none
            }
        }
    }
}
