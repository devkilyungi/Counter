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
        var primaryCounter = CounterFeature.State(timerToken: UUID())
        var optionalCounter: CounterFeature.State?
        var firstCounter = CounterFeature.State(timerToken: UUID())
        var secondCounter = CounterFeature.State(timerToken: UUID())
        var settings = SettingsFeature.State()
        var activeTab = Tab.primary

        @Presents var destination: Destination.State?

        enum Tab: Hashable {
            case primary
            case optional
            case combined
            case settings
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
        case settings(SettingsFeature.Action)
        case tabSelected(State.Tab)
        case optionalCounterToggleTapped
        case destination(PresentationAction<Destination.Action>)
        case showCounterInSheet
        case showCounterInFullScreenCover
        case showSettings
    }

    @Dependency(\.uuid) var uuidGenerator

    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case counterSheet(CounterFeature.State)
            case counterFullScreenCover(CounterFeature.State)
        }

        enum Action {
            case counterSheet(CounterFeature.Action)
            case counterFullScreenCover(CounterFeature.Action)
        }

        var body: some Reducer<State, Action> {
            Scope(state: \.counterSheet, action: \.counterSheet) {
                CounterFeature()
            }
            Scope(state: \.counterFullScreenCover, action: \.counterFullScreenCover) {
                CounterFeature()
            }
        }
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

        Scope(state: \.settings, action: \.settings) {
            SettingsFeature()
        }

        Reduce { state, action in
            switch action {
            case .primaryCounter, .optionalCounter, .firstCounter, .secondCounter, .settings(.dismissTapped), .settings(.appearance):
                return .none

            case let .tabSelected(tab):
                state.activeTab = tab
                return .none

            case .optionalCounterToggleTapped:
                state.optionalCounter = state.optionalCounter == nil
                    ? CounterFeature.State(
                        timerToken: uuidGenerator(),
                        timerIntervalSeconds: 1.0 / max(state.settings.autoIncrementSpeed, 0.1)
                    )
                    : nil
                return .none

            case .destination:
                return .none

            case .showCounterInSheet:
                state.destination = .counterSheet(
                    CounterFeature.State(
                        timerToken: uuidGenerator(),
                        timerIntervalSeconds: 1.0 / max(state.settings.autoIncrementSpeed, 0.1)
                    )
                )
                return .none

            case .showCounterInFullScreenCover:
                state.destination = .counterFullScreenCover(
                    CounterFeature.State(
                        timerToken: uuidGenerator(),
                        timerIntervalSeconds: 1.0 / max(state.settings.autoIncrementSpeed, 0.1)
                    )
                )
                return .none

            case .showSettings:
                return .none

            case .settings(.autoIncrementSpeedChanged):
                let speed = state.settings.autoIncrementSpeed
                var effects: [Effect<Action>] = [
                    .send(.primaryCounter(.timerSpeedChanged(speed))),
                    .send(.firstCounter(.timerSpeedChanged(speed))),
                    .send(.secondCounter(.timerSpeedChanged(speed))),
                ]

                if state.optionalCounter != nil {
                    effects.append(.send(.optionalCounter(.timerSpeedChanged(speed))))
                }

                if case .counterSheet = state.destination {
                    effects.append(.send(.destination(.presented(.counterSheet(.timerSpeedChanged(speed))))))
                } else if case .counterFullScreenCover = state.destination {
                    effects.append(.send(.destination(.presented(.counterFullScreenCover(.timerSpeedChanged(speed))))))
                }

                return .merge(effects)
            }
        }
        .ifLet(\.optionalCounter, action: \.optionalCounter) {
            CounterFeature()
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}
