//
//  AppFeatureTests.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import ComposableArchitecture
@testable import Counter
import Foundation
import Testing

@MainActor
struct AppFeatureTests {
    @Test func tabSelection_updatesActiveTab() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }

        await store.send(.tabSelected(.optional)) {
            $0.activeTab = .optional
        }

        await store.send(.tabSelected(.combined)) {
            $0.activeTab = .combined
        }

        await store.send(.tabSelected(.settings)) {
            $0.activeTab = .settings
        }

        await store.send(.tabSelected(.primary)) {
            $0.activeTab = .primary
        }
    }

    @Test func showCounterInSheet_setsDestination() async {
        let token = UUID(uuidString: "3F5E9E54-7C59-4B1B-9A79-6A4E8E1D4C9F")!

        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.uuid = UUIDGenerator { token }
        }

        await store.send(.showCounterInSheet) {
            $0.destination = .counterSheet(
                CounterFeature.State(
                    timerToken: token,
                    timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
                )
            )
        }
    }

    @Test func showCounterInFullScreenCover_setsDestination() async {
        let token = UUID(uuidString: "7D5B2F8D-0D75-4C2B-ABED-4E1F79BB0663")!

        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.uuid = UUIDGenerator { token }
        }

        await store.send(.showCounterInFullScreenCover) {
            $0.destination = .counterFullScreenCover(
                CounterFeature.State(
                    timerToken: token,
                    timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
                )
            )
        }
    }

    @Test func showSettings_setsDestination() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }

        await store.send(.showSettings) {
            $0.destination = .settings(SettingsFeature.State())
        }
    }

    @Test func destination_canSwitchBetweenDifferentCases() async {
        let token = UUID(uuidString: "48C1D4D5-8AE6-4A94-89D7-40B6F00C53A6")!

        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.uuid = UUIDGenerator { token }
        }

        // Open sheet
        await store.send(.showCounterInSheet) {
            $0.destination = .counterSheet(
                CounterFeature.State(
                    timerToken: token,
                    timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
                )
            )
        }

        // Switch to full screen
        await store.send(.showCounterInFullScreenCover) {
            $0.destination = .counterFullScreenCover(
                CounterFeature.State(
                    timerToken: token,
                    timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
                )
            )
        }

        // Switch to settings
        await store.send(.showSettings) {
            $0.destination = .settings(SettingsFeature.State())
        }
    }

    @Test func optionalCounterToggle_createsAndClearsOptionalCounter() async {
        let token = UUID(uuidString: "B5BEB4A3-8B2A-45E4-8C45-0BA60B7B54B4")!

        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.uuid = UUIDGenerator { token }
        }

        await store.send(.optionalCounterToggleTapped) {
            $0.optionalCounter = CounterFeature.State(timerToken: token)
        }

        await store.send(.optionalCounterToggleTapped) {
            $0.optionalCounter = nil
        }
    }

    @Test func optionalCounter_canBeToggledMultipleTimes() async {
        let token = UUID(uuidString: "9D63CC7A-4F4D-4A2C-9B5D-06EACFF9A5B9")!

        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.uuid = UUIDGenerator { token }
        }

        await store.send(.optionalCounterToggleTapped) {
            $0.optionalCounter = CounterFeature.State(timerToken: token)
        }

        await store.send(.optionalCounterToggleTapped) {
            $0.optionalCounter = nil
        }

        await store.send(.optionalCounterToggleTapped) {
            $0.optionalCounter = CounterFeature.State(timerToken: token)
        }
    }

    @Test func combinedTotal_sumsFirstAndSecondCounters() async {
        let store = TestStore(
            initialState: AppFeature.State(
                firstCounter: CounterFeature.State(value: 5),
                secondCounter: CounterFeature.State(value: 10)
            )
        ) {
            AppFeature()
        }

        #expect(store.state.combinedTotal == 15)

        await store.send(.firstCounter(.incrementTapped)) {
            $0.firstCounter.value = 6
        }

        #expect(store.state.combinedTotal == 16)

        await store.send(.secondCounter(.decrementTapped)) {
            $0.secondCounter.value = 9
        }

        #expect(store.state.combinedTotal == 15)
    }

    @Test func childCounterActions_propagateCorrectly() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }

        await store.send(.primaryCounter(.incrementTapped)) {
            $0.primaryCounter.value = 1
        }

        await store.send(.firstCounter(.incrementTapped)) {
            $0.firstCounter.value = 1
        }

        await store.send(.secondCounter(.decrementTapped)) {
            $0.secondCounter.value = -1
        }
    }

    @Test func destinationCounter_canBeInteractedWith() async {
        let token = UUID(uuidString: "E8B0A7E8-4BFA-4A1B-A0A7-5C0A6D1DEB77")!

        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.uuid = UUIDGenerator { token }
        }

        await store.send(.showCounterInSheet) {
            $0.destination = .counterSheet(
                CounterFeature.State(
                    timerToken: token,
                    timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
                )
            )
        }

        await store.send(.destination(.presented(.counterSheet(.incrementTapped)))) {
            $0.destination = .counterSheet(
                CounterFeature.State(
                    value: 1,
                    timerToken: token,
                    timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
                )
            )
        }

        await store.send(.destination(.presented(.counterSheet(.decrementTapped)))) {
            $0.destination = .counterSheet(
                CounterFeature.State(
                    value: 0,
                    timerToken: token,
                    timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
                )
            )
        }
    }

    @Test func destinationDismissal_clearsDestination() async {
        let token = UUID(uuidString: "4F29F8E1-4A8A-4D55-8C33-8B93C7AEBB1B")!

        let store = TestStore(
            initialState: AppFeature.State(
                destination: .counterSheet(
                    CounterFeature.State(
                        timerToken: token,
                        timerIntervalSeconds: 1.0
                    )
                )
            )
        ) {
            AppFeature()
        } withDependencies: {
            $0.dismiss = DismissEffect {}
        }

        await store.send(.destination(.presented(.counterSheet(.dismissTapped))))
        await store.receive(\.destination.dismiss) {
            $0.destination = nil
        }
    }

    @Test func timerInDestination_cancelledOnDismiss() async {
        let clock = TestClock()
        let token = UUID(uuidString: "6A40D5E1-1C5A-4E63-BB14-7746C8A5A22E")!

        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.continuousClock = clock
            $0.dismiss = DismissEffect {}
            $0.uuid = UUIDGenerator { token }
        }

        await store.send(.showCounterInSheet) {
            $0.destination = .counterSheet(
                CounterFeature.State(
                    timerToken: token,
                    timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
                )
            )
        }

        await store.send(.destination(.presented(.counterSheet(.timerButtonTapped)))) {
            $0.destination = .counterSheet(
                CounterFeature.State(
                    isTimerRunning: true,
                    timerToken: token,
                    timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
                )
            )
        }

        await clock.advance(by: .seconds(1))
        await store.receive(\.destination.presented.counterSheet.timerTicked) {
            $0.destination = .counterSheet(
                CounterFeature.State(
                    value: 1,
                    isTimerRunning: true,
                    timerToken: token,
                    timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
                )
            )
        }

        // Dismiss the destination
        await store.send(.destination(.presented(.counterSheet(.dismissTapped))))
        await store.receive(\.destination.dismiss) {
            $0.destination = nil
        }

        // Timer should be cancelled - no more ticks
        await clock.advance(by: .seconds(2))
        await store.finish()
    }

    @Test func optionalCounter_interactsIndependentlyFromPrimaryCounter() async {
        let token = UUID(uuidString: "D6BDA8E2-8E2D-4F16-9DB6-8E2F7E5ED1CF")!

        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.uuid = UUIDGenerator { token }
        }

        await store.send(.optionalCounterToggleTapped) {
            $0.optionalCounter = CounterFeature.State(
                timerToken: token,
                timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
            )
        }

        await store.send(.primaryCounter(.incrementTapped)) {
            $0.primaryCounter.value = 1
        }

        await store.send(.optionalCounter(.incrementTapped)) {
            $0.optionalCounter?.value = 1
        }

        #expect(store.state.primaryCounter.value == 1)
        #expect(store.state.optionalCounter?.value == 1)
    }
}
