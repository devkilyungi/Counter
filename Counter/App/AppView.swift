//
//  AppView.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    @Perception.Bindable var store: StoreOf<AppFeature>

    var body: some View {
        WithPerceptionTracking {
            TabView(selection: $store.activeTab.sending(\.tabSelected)) {
                PrimaryCounterTab(store: store)
                    .tabItem {
                        Label("Primary", systemImage: "1.circle.fill")
                    }
                    .tag(AppFeature.State.Tab.primary)

                OptionalCounterTab(store: store)
                    .tabItem {
                        Label("Optional", systemImage: "questionmark.circle.fill")
                    }
                    .tag(AppFeature.State.Tab.optional)

                CombinedCountersTab(store: store)
                    .tabItem {
                        Label("Combined", systemImage: "plus.forwardslash.minus")
                    }
                    .tag(AppFeature.State.Tab.combined)
            }
            .sheet(
                item: $store.scope(
                    state: \.destination?.counterSheet,
                    action: \.destination.counterSheet
                )
            ) { store in
                WithPerceptionTracking {
                    NavigationStack {
                        ScreenBackground {
                            ScrollView {
                                VStack(spacing: 24) {
                                    ScreenHeader(
                                        title: "Sheet Counter",
                                        subtitle: "This counter is presented in a sheet."
                                    )

                                    CounterView(store: store)
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 24)
                                .padding(.bottom, 32)
                            }
                        }
                        .navigationTitle("Sheet")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    store.send(.dismissTapped)
                                }
                            }
                        }
                    }
                }
            }
            .fullScreenCover(
                item: $store.scope(
                    state: \.destination?.counterFullScreenCover,
                    action: \.destination.counterFullScreenCover
                )
            ) { store in
                WithPerceptionTracking {
                    NavigationStack {
                        ScreenBackground {
                            ScrollView {
                                VStack(spacing: 24) {
                                    ScreenHeader(
                                        title: "Full Screen Counter",
                                        subtitle: "This counter takes over the entire screen."
                                    )

                                    CounterView(store: store)
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 24)
                                .padding(.bottom, 32)
                            }
                        }
                        .navigationTitle("Full Screen")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    store.send(.dismissTapped)
                                }
                            }
                        }
                    }
                }
            }
            .sheet(
                item: $store.scope(
                    state: \.destination?.settings,
                    action: \.destination.settings
                )
            ) { store in
                WithPerceptionTracking {
                    SettingsView(store: store)
                }
            }
        }
    }
}

struct PrimaryCounterTab: View {
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
                                title: "Primary Counter",
                                subtitle: "Simple taps with a little rhythm."
                            )

                            CounterView(
                                store: store.scope(
                                    state: \.primaryCounter,
                                    action: \.primaryCounter
                                )
                            )

                            VStack(spacing: 12) {
                                Button {
                                    store.send(.showCounterInSheet)
                                } label: {
                                    Label("Open Counter in Sheet", systemImage: "rectangle.portrait.and.arrow.right")
                                }
                                .buttonStyle(
                                    AppCapsuleButtonStyle(
                                        background: palette.neutralButton,
                                        foreground: .white
                                    )
                                )

                                Button {
                                    store.send(.showCounterInFullScreenCover)
                                } label: {
                                    Label("Open Counter Full Screen", systemImage: "arrow.up.left.and.arrow.down.right")
                                }
                                .buttonStyle(
                                    AppCapsuleButtonStyle(
                                        background: palette.neutralButton,
                                        foreground: .white
                                    )
                                )

                                Button {
                                    store.send(.showSettings)
                                } label: {
                                    Label("Settings", systemImage: "gearshape.fill")
                                }
                                .buttonStyle(
                                    AppCapsuleButtonStyle(
                                        background: palette.accent,
                                        foreground: .white
                                    )
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 32)
                    }
                }
                .navigationTitle("Primary")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

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

struct CombinedCountersTab: View {
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
                                title: "Combined Counters",
                                subtitle: "Two counters, one combined total."
                            )

                            AppCard {
                                VStack(spacing: 8) {
                                    Text("Total")
                                        .font(.system(.headline, design: .serif))
                                        .foregroundStyle(palette.inkSubtle)

                                    Text("\(store.combinedTotal)")
                                        .font(.system(size: 54, weight: .black, design: .rounded))
                                        .foregroundStyle(palette.ink)
                                        .monospacedDigit()
                                }
                                .frame(maxWidth: .infinity)
                            }

                            CounterSection(
                                title: "Counter One",
                                store: store.scope(
                                    state: \.firstCounter,
                                    action: \.firstCounter
                                )
                            )

                            CounterSection(
                                title: "Counter Two",
                                store: store.scope(
                                    state: \.secondCounter,
                                    action: \.secondCounter
                                )
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 32)
                    }
                }
                .navigationTitle("Combined")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

private struct CounterSection: View {
    @Environment(\.colorScheme) private var colorScheme

    let title: String
    let store: StoreOf<CounterFeature>

    var body: some View {
        let palette = ThemePalette(scheme: colorScheme)

        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(.headline, design: .serif))
                .foregroundStyle(palette.ink)

            CounterView(store: store)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AppView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
                ._printChanges()
        }
    )
}
