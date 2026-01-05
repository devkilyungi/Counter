//
//  FactClient.swift
//  Counter
//
//  Created by Victor Kilyungi on 03/01/2026.
//

import ComposableArchitecture
import Foundation

struct FactClient: Sendable {
    var fetch: @Sendable () async throws -> String
}

extension FactClient: DependencyKey {
    static let liveValue = FactClient {
        let url = URL(string: "https://catfact.ninja/fact")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(CatFactResponse.self, from: data)
        return decoded.fact
    }
}

extension DependencyValues {
    nonisolated var factClient: FactClient {
        get { self[FactClient.self] }
        set { self[FactClient.self] = newValue }
    }
}
