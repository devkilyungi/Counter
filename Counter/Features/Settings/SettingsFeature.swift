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
        var notificationsEnabled = true
        var autoIncrementSpeed = 1.0
    }

    enum Action {
        case darkModeToggled(Bool)
        case notificationsToggled(Bool)
        case autoIncrementSpeedChanged(Double)
        case dismissTapped
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .darkModeToggled(isEnabled):
                state.isDarkModeEnabled = isEnabled
                return .none

            case let .notificationsToggled(isEnabled):
                state.notificationsEnabled = isEnabled
                return .none

            case let .autoIncrementSpeedChanged(speed):
                state.autoIncrementSpeed = speed
                return .none

            case .dismissTapped:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
    }
}
