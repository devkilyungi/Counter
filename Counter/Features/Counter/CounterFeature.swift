//
//  CounterFeature.swift
//  Counter
//
//  Created by Victor Kilyungi on 03/01/2026.
//

import ComposableArchitecture
import Foundation

private nonisolated enum CancelID: Hashable, Sendable {
    case timer
}

struct CounterFeature: Reducer {
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isLoadingFact = false
        var isTimerOn = false
    }

    enum Action: Equatable {
        case decrementButtonTapped
        case getFactButtonTapped
        case incrementButtonTapped
        case toggleTimerButtonTapped
        case factResponse(String)
        case factFailed(String)
        case timerTicked
    }

    @Dependency(\.continuousClock) var clock
    @Dependency(\.factClient) var factClient

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                return .none

            case .getFactButtonTapped:
                state.fact = nil
                state.isLoadingFact = true

                return .run { send in
                    do {
                        let fact = try await self.factClient.fetch()
                        await send(.factResponse(fact))
                    } catch {
                        await send(.factFailed(error.localizedDescription))
                    }
                }

            case .incrementButtonTapped:
                state.count += 1
                return .none

            case .toggleTimerButtonTapped:
                state.isTimerOn.toggle()

                if state.isTimerOn {
                    return .run { send in
                        for await _ in await self.clock.timer(interval: .seconds(1)) {
                            await send(.timerTicked)
                        }
                    }
                    .cancellable(id: CancelID.timer, cancelInFlight: true)
                } else {
                    return .cancel(id: CancelID.timer)
                }

            case let .factResponse(fact):
                state.fact = fact
                state.isLoadingFact = false
                return .none

            case let .factFailed(message):
                state.fact = "Failed to load fact: \(message)"
                state.isLoadingFact = false
                return .none

            case .timerTicked:
                state.count += 1
                return .none
            }
        }
    }
}
