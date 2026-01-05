//
//  CounterFeature.swift
//  Counter
//
//  Created by Victor Kilyungi on 03/01/2026.
//

import ComposableArchitecture
import Foundation

struct CatFactResponse: Decodable {
    let fact: String
}

private nonisolated enum CancelID: Hashable, Sendable {
    case timer
}

struct CounterFeature: Reducer {
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isLoadingFact: Bool = false
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

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                return .none

            case .getFactButtonTapped:
                state.fact = nil
                state.isLoadingFact = true

                return .run { @MainActor send in
                    do {
                        let url = URL(string: "https://catfact.ninja/fact")!
                        let (data, _) = try await URLSession.shared.data(from: url)
                        let decoded = try JSONDecoder().decode(CatFactResponse.self, from: data)
                        send(.factResponse(decoded.fact))
                    } catch {
                        send(.factFailed(error.localizedDescription))
                    }
                }

            case .incrementButtonTapped:
                state.count += 1
                return .none

            case .toggleTimerButtonTapped:
                state.isTimerOn.toggle()

                if state.isTimerOn {
                    return .run { send in
                        while !Task.isCancelled {
                            try await Task.sleep(for: .seconds(1))
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
