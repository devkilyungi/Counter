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

        await store.send(.incrementTapped) { $0.value = 1 }
    }

    @Test func decrementButton_decreasesCount() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }

        await store.send(.decrementTapped) { $0.value = -1 }
    }

    @Test func timer_emitsTicks_everySecond() async {
        let clock = TestClock()

        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }

        await store.send(.timerButtonTapped) { $0.isTimerRunning = true }

        await clock.advance(by: .seconds(3))
        await store.receive(\.timerTicked) { $0.value = 1 }
        await store.receive(\.timerTicked) { $0.value = 2 }
        await store.receive(\.timerTicked) { $0.value = 3 }

        await store.send(.timerButtonTapped) { $0.isTimerRunning = false }
    }

    @Test func timer_cancelsOnStop_noFurtherTicks() async {
        let clock = TestClock()

        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }

        await store.send(.timerButtonTapped) { $0.isTimerRunning = true }

        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTicked) { $0.value = 1 }

        await store.send(.timerButtonTapped) { $0.isTimerRunning = false }

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

        await store.send(.timerButtonTapped) { $0.isTimerRunning = true }

        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTicked) { $0.value = 1 }

        await store.send(.timerButtonTapped) { $0.isTimerRunning = false }
        await store.send(.timerButtonTapped) { $0.isTimerRunning = true }

        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTicked) { $0.value = 2 }

        await store.send(.timerButtonTapped) { $0.isTimerRunning = false }
    }

    @Test func getFact_success_setsFact_andStopsLoading() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.factClient.fetch = { "A cat has five toes." }
        }

        await store.send(.factButtonTapped) {
            $0.factText = nil
            $0.isFactLoading = true
        }

        await store.receive(\.factResponseReceived) {
            $0.factText = "A cat has five toes."
            $0.isFactLoading = false
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

        await store.send(.factButtonTapped) {
            $0.factText = nil
            $0.isFactLoading = true
        }

        await store.receive(\.factRequestFailed) {
            $0.factText = "Failed to load fact: Network down"
            $0.isFactLoading = false
        }
    }

    @Test func getFact_twice_clearsPreviousFact_beforeSecondResponse() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.factClient.fetch = { "Fact" } // same response is fine for behavior testing
        }

        await store.send(.factButtonTapped) {
            $0.factText = nil
            $0.isFactLoading = true
        }
        await store.receive(\.factResponseReceived) {
            $0.factText = "Fact"
            $0.isFactLoading = false
        }

        await store.send(.factButtonTapped) {
            $0.factText = nil // cleared immediately
            $0.isFactLoading = true
        }
        await store.receive(\.factResponseReceived) {
            $0.factText = "Fact"
            $0.isFactLoading = false
        }
    }
}
