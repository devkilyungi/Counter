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

    @Dependency(\.uuid) var uuid

    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case counterSheet(CounterFeature.State)
            case counterFullScreenCover(CounterFeature.State)
            case settings(SettingsFeature.State)
        }

        enum Action {
            case counterSheet(CounterFeature.Action)
            case counterFullScreenCover(CounterFeature.Action)
            case settings(SettingsFeature.Action)
        }

        var body: some Reducer<State, Action> {
            Scope(state: \.counterSheet, action: \.counterSheet) {
                CounterFeature()
            }
            Scope(state: \.counterFullScreenCover, action: \.counterFullScreenCover) {
                CounterFeature()
            }
            Scope(state: \.settings, action: \.settings) {
                SettingsFeature()
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
                    ? CounterFeature.State(timerToken: uuid())
                    : nil
                return .none

            case .destination:
                return .none

            case .showCounterInSheet:
                state.destination = .counterSheet(
                    CounterFeature.State(
                        timerToken: uuid(),
                        timerIntervalSeconds: state.settings.autoIncrementSpeed
                    )
                )
                return .none

            case .showCounterInFullScreenCover:
                state.destination = .counterFullScreenCover(
                    CounterFeature.State(
                        timerToken: uuid(),
                        timerIntervalSeconds: state.settings.autoIncrementSpeed
                    )
                )
                return .none

            case .showSettings:
                state.destination = .settings(SettingsFeature.State())
                return .none

            case .settings(.autoIncrementSpeedChanged):
                let speed = state.settings.autoIncrementSpeed
                state.primaryCounter.timerIntervalSeconds = speed
                state.firstCounter.timerIntervalSeconds = speed
                state.secondCounter.timerIntervalSeconds = speed
                state.optionalCounter?.timerIntervalSeconds = speed

                if case .counterSheet(var counterState) = state.destination {
                    counterState.timerIntervalSeconds = speed
                    state.destination = .counterSheet(counterState)
                } else if case .counterFullScreenCover(var counterState) = state.destination {
                    counterState.timerIntervalSeconds = speed
                    state.destination = .counterFullScreenCover(counterState)
                }

                return .none
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
