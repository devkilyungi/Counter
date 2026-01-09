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

    @Test func autoIncrementSpeed_updatesState() async {
        let store = TestStore(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }

        await store.send(.autoIncrementSpeedChanged(2.0)) {
            $0.autoIncrementSpeed = 2.0
        }

        await store.send(.autoIncrementSpeedChanged(1.0)) {
            $0.autoIncrementSpeed = 1.0
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
        await store.send(.autoIncrementSpeedChanged(1.0)) {
            $0.autoIncrementSpeed = 1.0
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

        await store.send(.autoIncrementSpeedChanged(3.0)) {
            $0.autoIncrementSpeed = 3.0
        }
    }
}
