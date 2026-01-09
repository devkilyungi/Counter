//
//  ThemeClient.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import ComposableArchitecture
import Foundation

struct ThemeClient: Sendable {
    var appearance: @Sendable () async -> Appearance
    var setAppearance: @Sendable (Appearance) async -> Void
}

extension ThemeClient: DependencyKey {
    static let liveValue: ThemeClient = {
        let key = "appearance_preference"
        return ThemeClient(
            appearance: {
                if let raw = UserDefaults.standard.string(forKey: key),
                   let appearance = Appearance(rawValue: raw) {
                    return appearance
                }
                return .system
            },
            setAppearance: { appearance in
                UserDefaults.standard.setValue(appearance.rawValue, forKey: key)
            }
        )
    }()
}

extension DependencyValues {
    nonisolated var theme: ThemeClient {
        get { self[ThemeClient.self] }
        set { self[ThemeClient.self] = newValue }
    }
}
