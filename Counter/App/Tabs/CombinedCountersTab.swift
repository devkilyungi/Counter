//
//  CombinedCountersTab.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import ComposableArchitecture
import SwiftUI

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

#Preview {
    CombinedCountersTab(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}
