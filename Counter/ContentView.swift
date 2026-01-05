//
//  ContentView.swift
//  Counter
//
//  Created by Victor Kilyungi on 03/01/2026.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    let store: StoreOf<CounterFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    Text("\(viewStore.count)")
                    Button("Increment") { viewStore.send(.incrementButtonTapped) }
                    Button("Decrement") { viewStore.send(.decrementButtonTapped) }
                }

                Section {
                    HStack {
                        Button("Get fact") { viewStore.send(.getFactButtonTapped) }
                        Spacer()
                        if viewStore.isLoadingFact {
                            ProgressView()
                        }
                    }

                    if let fact = viewStore.fact {
                        Text(fact)
                    }
                }

                Section {
                    Button(viewStore.isTimerOn ? "Stop timer" : "Start timer") {
                        viewStore.send(.toggleTimerButtonTapped)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(
        store: Store(initialState: CounterFeature.State()) {
            CounterFeature()._printChanges()
        }
    )
}
