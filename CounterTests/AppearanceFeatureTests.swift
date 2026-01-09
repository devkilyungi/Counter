//
//  AppearanceFeatureTests.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import ComposableArchitecture
@testable import Counter
import Foundation
import Testing

@MainActor
struct AppearanceFeatureTests {
    @Test func appearanceSelection_updatesState() async {
        let store = TestStore(initialState: AppearanceFeature.State()) {
            AppearanceFeature()
        } withDependencies: {
            $0.theme.appearance = { .system }
            $0.theme.setAppearance = { _ in }
        }

        await store.send(.setSelection(.dark)) {
            $0.selection = .dark
        }
    }
}
