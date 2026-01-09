//
//  CounterFeature.swift
//  Counter
//
//  Created by Victor Kilyungi on 03/01/2026.
//

import ComposableArchitecture
import Foundation

private nonisolated enum CancelID: Hashable, Sendable {
    case timer(UUID)
}

@Reducer
struct CounterFeature {
    @ObservableState
    struct State: Equatable {
        var value = 0
        var factText: String?
        var isFactLoading = false
        var isTimerRunning = false
        var timerToken: UUID
        var timerIntervalSeconds = 1.0

        init(
            value: Int = 0,
            factText: String? = nil,
            isFactLoading: Bool = false,
            isTimerRunning: Bool = false,
            timerToken: UUID,
            timerIntervalSeconds: Double = 1.0
        ) {
            self.value = value
            self.factText = factText
            self.isFactLoading = isFactLoading
            self.isTimerRunning = isTimerRunning
            self.timerToken = timerToken
            self.timerIntervalSeconds = timerIntervalSeconds
        }
    }

    enum Action {
        case decrementTapped
        case factButtonTapped
        case incrementTapped
        case timerButtonTapped
        case timerSpeedChanged(Double)
        case factResponseReceived(String)
        case factRequestFailed(String)
        case resetTapped
        case timerTicked
        case dismissTapped
    }

    @Dependency(\.continuousClock) var clock
    @Dependency(\.factClient) var factClient
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.uuid) var uuidGenerator

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .decrementTapped:
                state.value -= 1
                return .none

            case .factButtonTapped:
                state.factText = nil
                state.isFactLoading = true

                return .run { send in
                    do {
                        let fact = try await self.factClient.fetch()
                        await send(.factResponseReceived(fact))
                    } catch {
                        await send(.factRequestFailed(error.localizedDescription))
                    }
                }

            case .incrementTapped:
                state.value += 1
                return .none

            case .timerButtonTapped:
                state.isTimerRunning.toggle()

                if state.isTimerRunning {
                    return self.timerEffect(
                        intervalSeconds: state.timerIntervalSeconds,
                        token: state.timerToken
                    )
                } else {
                    return .cancel(id: CancelID.timer(state.timerToken))
                }

            case let .timerSpeedChanged(speed):
                let safeSpeed = max(speed, 0.1)
                state.timerIntervalSeconds = 1.0 / safeSpeed

                if state.isTimerRunning {
                    return self.timerEffect(
                        intervalSeconds: state.timerIntervalSeconds,
                        token: state.timerToken
                    )
                }
                return .none

            case let .factResponseReceived(fact):
                state.factText = fact
                state.isFactLoading = false
                return .none

            case let .factRequestFailed(message):
                state.factText = "Failed to load fact: \(message)"
                state.isFactLoading = false
                return .none

            case .resetTapped:
                let timerToken = state.timerToken
                state = State(
                    timerToken: uuidGenerator(),
                    timerIntervalSeconds: state.timerIntervalSeconds
                )
                return .cancel(id: CancelID.timer(timerToken))

            case .timerTicked:
                state.value += 1
                return .none

            case .dismissTapped:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
    }

    private func timerEffect(intervalSeconds: Double, token: UUID) -> Effect<Action> {
        .run { send in
            for await _ in await self.clock.timer(interval: .seconds(intervalSeconds)) {
                await send(.timerTicked)
            }
        }
        .cancellable(id: CancelID.timer(token), cancelInFlight: true)
    }
}
