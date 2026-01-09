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
    let store: StoreOf<AppFeature>

    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
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
                                    background: Theme.accent,
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
                                            .foregroundStyle(Theme.inkSubtle)

                                        Text("Counter state is nil")
                                            .font(.headline)
                                            .foregroundStyle(Theme.ink)

                                        Text("Tap the button above to create it.")
                                            .font(.subheadline)
                                            .foregroundStyle(Theme.inkSubtle)
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
    let store: StoreOf<AppFeature>

    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
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
                                        .foregroundStyle(Theme.inkSubtle)

                                    Text("\(store.combinedTotal)")
                                        .font(.system(size: 54, weight: .black, design: .rounded))
                                        .foregroundStyle(Theme.ink)
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
    let title: String
    let store: StoreOf<CounterFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(.headline, design: .serif))
                .foregroundStyle(Theme.ink)

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
