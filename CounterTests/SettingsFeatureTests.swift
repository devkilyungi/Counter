//
//  SettingsFeatureTests.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import ComposableArchitecture
@testable import Counter
import Foundation
import Testing

@MainActor
struct SettingsFeatureTests {
    @Test func darkModeToggle_updatesState() async {
        let store = TestStore(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }

        await store.send(.darkModeToggled(true)) {
            $0.isDarkModeEnabled = true
        }

        await store.send(.darkModeToggled(false)) {
            $0.isDarkModeEnabled = false
        }
    }

    @Test func notificationsToggle_updatesState() async {
        let store = TestStore(initialState: SettingsFeature.State(notificationsEnabled: true)) {
            SettingsFeature()
        }

        await store.send(.notificationsToggled(false)) {
            $0.notificationsEnabled = false
        }

        await store.send(.notificationsToggled(true)) {
            $0.notificationsEnabled = true
        }
    }

    @Test func autoIncrementSpeed_updatesState() async {
        let store = TestStore(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }

        await store.send(.autoIncrementSpeedChanged(2.5)) {
            $0.autoIncrementSpeed = 2.5
        }

        await store.send(.autoIncrementSpeedChanged(0.5)) {
            $0.autoIncrementSpeed = 0.5
        }
    }

    @Test func autoIncrementSpeed_clampsToValidRange() async {
        let store = TestStore(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }

        // Test maximum boundary
        await store.send(.autoIncrementSpeedChanged(5.0)) {
            $0.autoIncrementSpeed = 5.0
        }

        // Test minimum boundary
        await store.send(.autoIncrementSpeedChanged(0.5)) {
            $0.autoIncrementSpeed = 0.5
        }
    }

    @Test func dismissTapped_invokesDismissDependency() async {
        var dismissCount = 0

        let store = TestStore(initialState: SettingsFeature.State()) {
            SettingsFeature()
        } withDependencies: {
            $0.dismiss = DismissEffect {
                dismissCount += 1
            }
        }

        await store.send(.dismissTapped)

        #expect(dismissCount == 1)
    }

    @Test func multipleSettings_canBeChanged() async {
        let store = TestStore(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }

        await store.send(.darkModeToggled(true)) {
            $0.isDarkModeEnabled = true
        }

        await store.send(.notificationsToggled(false)) {
            $0.notificationsEnabled = false
        }

        await store.send(.autoIncrementSpeedChanged(3.0)) {
            $0.autoIncrementSpeed = 3.0
        }
    }
}
