//
//  PrimaryCounterTab.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import ComposableArchitecture
import SwiftUI

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

#Preview {
    PrimaryCounterTab(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}
