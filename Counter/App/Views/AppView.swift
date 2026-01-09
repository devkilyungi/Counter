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
            .preferredColorScheme(store.appearance.selection.colorScheme)
            .onAppear {
                store.send(.onAppear)
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
            .onAppear {
                store.send(.onAppear)
            }
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
