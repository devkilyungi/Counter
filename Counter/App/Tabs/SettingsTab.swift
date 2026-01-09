//
//  SettingsTab.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import ComposableArchitecture
import SwiftUI

struct SettingsTab: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        WithPerceptionTracking {
            SettingsView(
                store: store.scope(
                    state: \.settings,
                    action: \.settings
                ),
                appearanceStore: store.scope(
                    state: \.appearance,
                    action: \.appearance
                ),
                onOpenSheet: { store.send(.showCounterInSheet) },
                onOpenFullScreen: { store.send(.showCounterInFullScreenCover) }
            )
        }
    }
}

#Preview {
    SettingsTab(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}
