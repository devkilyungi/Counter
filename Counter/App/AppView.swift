//
//  AppView.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    @Environment(\.colorScheme) private var colorScheme

    @Perception.Bindable var store: StoreOf<AppFeature>

    var body: some View {
        WithPerceptionTracking {
            let palette = ThemePalette(scheme: colorScheme)

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

                SettingsTab(store: store)
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .tag(AppFeature.State.Tab.settings)
            }
            .tint(palette.accent)
            .toolbarBackground(palette.surface, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .preferredColorScheme(store.settings.appearance.selection.colorScheme)
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
            ) { settingsStore in
                WithPerceptionTracking {
                    SettingsView(
                        store: settingsStore,
                        onOpenSheet: { store.send(.showCounterInSheet) },
                        onOpenFullScreen: { store.send(.showCounterInFullScreenCover) }
                    )
                }
            }
        }
    }
}

struct PrimaryCounterTab: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
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
    @State private var selectedCounter = CombinedCounterTab.first

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

                            Picker("Counter", selection: $selectedCounter) {
                                ForEach(CombinedCounterTab.allCases, id: \.self) { tab in
                                    Text(tab.title).tag(tab)
                                }
                            }
                            .pickerStyle(.segmented)

                            TabView(selection: $selectedCounter) {
                                CombinedCounterPage(
                                    title: "Counter One",
                                    store: store.scope(
                                        state: \.firstCounter,
                                        action: \.firstCounter
                                    )
                                )
                                .tag(CombinedCounterTab.first)

                                CombinedCounterPage(
                                    title: "Counter Two",
                                    store: store.scope(
                                        state: \.secondCounter,
                                        action: \.secondCounter
                                    )
                                )
                                .tag(CombinedCounterTab.second)
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            .frame(height: 520)
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

private enum CombinedCounterTab: String, CaseIterable {
    case first
    case second

    var title: String {
        switch self {
        case .first:
            return "Counter One"
        case .second:
            return "Counter Two"
        }
    }
}

private struct CombinedCounterPage: View {
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

struct SettingsTab: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        WithPerceptionTracking {
            SettingsView(
                store: store.scope(
                    state: \.settings,
                    action: \.settings
                ),
                onOpenSheet: { store.send(.showCounterInSheet) },
                onOpenFullScreen: { store.send(.showCounterInFullScreenCover) }
            )
        }
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
