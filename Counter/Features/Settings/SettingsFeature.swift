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
        var autoIncrementSpeed = 1.0
        var appearance = AppearanceFeature.State()
    }

    enum Action {
        case autoIncrementSpeedChanged(Double)
        case dismissTapped
        case appearance(AppearanceFeature.Action)
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .autoIncrementSpeedChanged(speed):
                state.autoIncrementSpeed = speed
                return .none

            case .dismissTapped:
                return .run { _ in
                    await self.dismiss()
                }

            case .appearance:
                return .none
            }
        }
        Scope(state: \.appearance, action: \.appearance) {
            AppearanceFeature()
        }
    }
}
