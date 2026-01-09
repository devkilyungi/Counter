//
//  AppFeature.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var primaryCounter = CounterFeature.State()
        var optionalCounter: CounterFeature.State?
        var firstCounter = CounterFeature.State()
        var secondCounter = CounterFeature.State()
        var activeTab = Tab.primary

        enum Tab: Hashable {
            case primary
            case optional
            case combined
        }

        var combinedTotal: Int {
            firstCounter.value + secondCounter.value
        }
    }

    enum Action {
        case primaryCounter(CounterFeature.Action)
        case optionalCounter(CounterFeature.Action)
        case firstCounter(CounterFeature.Action)
        case secondCounter(CounterFeature.Action)
        case tabSelected(State.Tab)
        case optionalCounterToggleTapped
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.primaryCounter, action: \.primaryCounter) {
            CounterFeature()
        }

        Scope(state: \.firstCounter, action: \.firstCounter) {
            CounterFeature()
        }

        Scope(state: \.secondCounter, action: \.secondCounter) {
            CounterFeature()
        }

        Reduce { state, action in
            switch action {
            case .primaryCounter, .optionalCounter, .firstCounter, .secondCounter:
                return .none

            case let .tabSelected(tab):
                state.activeTab = tab
                return .none

            case .optionalCounterToggleTapped:
                state.optionalCounter = state.optionalCounter == nil
                    ? CounterFeature.State()
                    : nil
                return .none
            }
        }
        .ifLet(\.optionalCounter, action: \.optionalCounter) {
            CounterFeature()
        }
    }
}
