//
//  AppearanceFeature.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AppearanceFeature {
    @ObservableState
    struct State: Equatable {
        var selection: Appearance = .system
    }

    enum Action: Equatable {
        case onAppear
        case setSelection(Appearance)
        case loadedAppearance(Appearance)
    }

    @Dependency(\.theme) var theme

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let appearance = await theme.appearance()
                    await send(.loadedAppearance(appearance))
                }

            case let .loadedAppearance(appearance):
                state.selection = appearance
                return .none

            case let .setSelection(appearance):
                state.selection = appearance
                return .run { _ in
                    await theme.setAppearance(appearance)
                }
            }
        }
    }
}
