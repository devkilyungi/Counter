//
//  OptionalCounterTab.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import ComposableArchitecture
import SwiftUI

struct OptionalCounterTab: View {
    @Environment(\.colorScheme) private var colorScheme

    let store: StoreOf<AppFeature>

    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                let palette = ThemePalette(scheme: colorScheme)

                ScreenBackground {
                    ScrollView {
                        VStack(spacing: 24) {
                            ScreenHeader(
                                title: "Optional Counter",
                                subtitle: "Spawn or hide a counter on demand."
                            )

                            Button {
                                store.send(.optionalCounterToggleTapped)
                            } label: {
                                Label(
                                    store.optionalCounter == nil
                                        ? "Show Counter"
                                        : "Hide Counter",
                                    systemImage: store.optionalCounter == nil
                                        ? "eye.fill"
                                        : "eye.slash.fill"
                                )
                            }
                            .buttonStyle(
                                AppCapsuleButtonStyle(
                                    background: palette.accent,
                                    foreground: .white
                                )
                            )

                            if let counterStore = store.scope(
                                state: \.optionalCounter,
                                action: \.optionalCounter
                            ) {
                                CounterView(store: counterStore)
                            } else {
                                AppCard {
                                    VStack(spacing: 12) {
                                        Image(systemName: "questionmark.circle")
                                            .font(.system(size: 46))
                                            .foregroundStyle(palette.inkSubtle)

                                        Text("Counter state is nil")
                                            .font(.headline)
                                            .foregroundStyle(palette.ink)

                                        Text("Tap the button above to create it.")
                                            .font(.subheadline)
                                            .foregroundStyle(palette.inkSubtle)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 32)
                    }
                }
                .navigationTitle("Optional")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    OptionalCounterTab(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}
