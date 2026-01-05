//
//  CounterTests.swift
//  CounterTests
//
//  Created by Victor Kilyungi on 03/01/2026.
//

import ComposableArchitecture
@testable import Counter
import Foundation
import Testing

@MainActor
struct CounterTests {
    @Test func incrementButton_increasesCount() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }

        await store.send(.incrementButtonTapped) { $0.count = 1 }
    }

    @Test func decrementButton_decreasesCount() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }

        await store.send(.decrementButtonTapped) { $0.count = -1 }
    }

    @Test func timer_emitsTicks_everySecond() async {
        let clock = TestClock()

        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }

        await store.send(.toggleTimerButtonTapped) { $0.isTimerOn = true }

        await clock.advance(by: .seconds(3))
        await store.receive(.timerTicked) { $0.count = 1 }
        await store.receive(.timerTicked) { $0.count = 2 }
        await store.receive(.timerTicked) { $0.count = 3 }

        await store.send(.toggleTimerButtonTapped) { $0.isTimerOn = false }
    }

    @Test func timer_cancelsOnStop_noFurtherTicks() async {
        let clock = TestClock()

        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }

        await store.send(.toggleTimerButtonTapped) { $0.isTimerOn = true }

        await clock.advance(by: .seconds(1))
        await store.receive(.timerTicked) { $0.count = 1 }

        await store.send(.toggleTimerButtonTapped) { $0.isTimerOn = false }

        // Advance time; if a tick arrives after cancellation, the test should fail.
        await clock.advance(by: .seconds(2))

        // Assert no more actions are received.
        await store.finish()
    }

    @Test func timer_canRestart_afterStop() async {
        let clock = TestClock()

        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }

        await store.send(.toggleTimerButtonTapped) { $0.isTimerOn = true }

        await clock.advance(by: .seconds(1))
        await store.receive(.timerTicked) { $0.count = 1 }

        await store.send(.toggleTimerButtonTapped) { $0.isTimerOn = false }
        await store.send(.toggleTimerButtonTapped) { $0.isTimerOn = true }

        await clock.advance(by: .seconds(1))
        await store.receive(.timerTicked) { $0.count = 2 }

        await store.send(.toggleTimerButtonTapped) { $0.isTimerOn = false }
    }

    @Test func getFact_success_setsFact_andStopsLoading() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.factClient.fetch = { "A cat has five toes." }
        }

        await store.send(.getFactButtonTapped) {
            $0.fact = nil
            $0.isLoadingFact = true
        }

        await store.receive(.factResponse("A cat has five toes.")) {
            $0.fact = "A cat has five toes."
            $0.isLoadingFact = false
        }
    }

    @Test func getFact_failure_showsError_andStopsLoading() async {
        struct TestError: LocalizedError {
            let errorDescription: String? = "Network down"
        }

        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.factClient.fetch = { throw TestError() }
        }

        await store.send(.getFactButtonTapped) {
            $0.fact = nil
            $0.isLoadingFact = true
        }

        await store.receive(.factFailed("Network down")) {
            $0.fact = "Failed to load fact: Network down"
            $0.isLoadingFact = false
        }
    }

    @Test func getFact_twice_clearsPreviousFact_beforeSecondResponse() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.factClient.fetch = { "Fact" } // same response is fine for behavior testing
        }

        await store.send(.getFactButtonTapped) {
            $0.fact = nil
            $0.isLoadingFact = true
        }
        await store.receive(.factResponse("Fact")) {
            $0.fact = "Fact"
            $0.isLoadingFact = false
        }

        await store.send(.getFactButtonTapped) {
            $0.fact = nil // cleared immediately
            $0.isLoadingFact = true
        }
        await store.receive(.factResponse("Fact")) {
            $0.fact = "Fact"
            $0.isLoadingFact = false
        }
    }
}
