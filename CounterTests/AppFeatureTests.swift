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

private let appFeatureToken = UUID(uuidString: "22222222-2222-2222-2222-222222222222")!

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
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.uuid = UUIDGenerator { appFeatureToken }
        }

        await store.send(.showCounterInSheet) {
            $0.destination = .counterSheet(
                CounterFeature.State(
                    timerToken: appFeatureToken,
                    timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
                )
            )
        }
    }

    @Test func showCounterInFullScreenCover_setsDestination() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.uuid = UUIDGenerator { appFeatureToken }
        }

        await store.send(.showCounterInFullScreenCover) {
            $0.destination = .counterFullScreenCover(
                CounterFeature.State(
                    timerToken: appFeatureToken,
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
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.uuid = UUIDGenerator { appFeatureToken }
        }

        // Open sheet
        await store.send(.showCounterInSheet) {
            $0.destination = .counterSheet(
                CounterFeature.State(
                    timerToken: appFeatureToken,
                    timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
                )
            )
        }

        // Switch to full screen
        await store.send(.showCounterInFullScreenCover) {
            $0.destination = .counterFullScreenCover(
                CounterFeature.State(
                    timerToken: appFeatureToken,
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
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.uuid = UUIDGenerator { appFeatureToken }
        }

        await store.send(.optionalCounterToggleTapped) {
            $0.optionalCounter = CounterFeature.State(timerToken: appFeatureToken)
        }

        await store.send(.optionalCounterToggleTapped) {
            $0.optionalCounter = nil
        }
    }

    @Test func optionalCounter_canBeToggledMultipleTimes() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.uuid = UUIDGenerator { appFeatureToken }
        }

        await store.send(.optionalCounterToggleTapped) {
            $0.optionalCounter = CounterFeature.State(timerToken: appFeatureToken)
        }

        await store.send(.optionalCounterToggleTapped) {
            $0.optionalCounter = nil
        }

        await store.send(.optionalCounterToggleTapped) {
            $0.optionalCounter = CounterFeature.State(timerToken: appFeatureToken)
        }
    }

    @Test func combinedTotal_sumsFirstAndSecondCounters() async {
        let store = TestStore(
            initialState: AppFeature.State(
                firstCounter: CounterFeature.State(value: 5, timerToken: appFeatureToken),
                secondCounter: CounterFeature.State(value: 10, timerToken: appFeatureToken)
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
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.uuid = UUIDGenerator { appFeatureToken }
        }

        await store.send(.showCounterInSheet) {
            $0.destination = .counterSheet(
                CounterFeature.State(
                    timerToken: appFeatureToken,
                    timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
                )
            )
        }

        await store.send(.destination(.presented(.counterSheet(.incrementTapped)))) {
            $0.destination = .counterSheet(
                CounterFeature.State(
                    value: 1,
                    timerToken: appFeatureToken,
                    timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
                )
            )
        }

        await store.send(.destination(.presented(.counterSheet(.decrementTapped)))) {
            $0.destination = .counterSheet(
                CounterFeature.State(
                    value: 0,
                    timerToken: appFeatureToken,
                    timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
                )
            )
        }
    }

    @Test func destinationDismissal_clearsDestination() async {
        let store = TestStore(
            initialState: AppFeature.State(
                destination: .counterSheet(
                    CounterFeature.State(
                        timerToken: appFeatureToken,
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

        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.continuousClock = clock
            $0.dismiss = DismissEffect {}
            $0.uuid = UUIDGenerator { appFeatureToken }
        }

        await store.send(.showCounterInSheet) {
            $0.destination = .counterSheet(
                CounterFeature.State(
                    timerToken: appFeatureToken,
                    timerIntervalSeconds: 1.0 / max($0.settings.autoIncrementSpeed, 0.1)
                )
            )
        }

        await store.send(.destination(.presented(.counterSheet(.timerButtonTapped)))) {
            $0.destination = .counterSheet(
                CounterFeature.State(
                    isTimerRunning: true,
                    timerToken: appFeatureToken,
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
                    timerToken: appFeatureToken,
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
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.uuid = UUIDGenerator { appFeatureToken }
        }

        await store.send(.optionalCounterToggleTapped) {
            $0.optionalCounter = CounterFeature.State(
                timerToken: appFeatureToken,
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
