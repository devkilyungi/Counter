//
//  CounterView.swift
//  Counter
//
//  Created by Victor Kilyungi on 03/01/2026.
//

import ComposableArchitecture
import SwiftUI

struct CounterView: View {
    let store: StoreOf<CounterFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 20) {
                Spacer()

                // Count Display
                Text("\(viewStore.count)")
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .padding()

                // Increment/Decrement Controls
                HStack(spacing: 32) {
                    Button {
                        viewStore.send(.decrementButtonTapped)
                    } label: {
                        Image(systemName: "minus")
                            .font(.title)
                            .fontWeight(.medium)
                            .frame(width: 64, height: 64)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)

                    Button {
                        viewStore.send(.incrementButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                            .font(.title)
                            .fontWeight(.medium)
                            .frame(width: 64, height: 64)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }

                Spacer()

                // Timer Button
                Button {
                    viewStore.send(.toggleTimerButtonTapped)
                } label: {
                    Label(
                        viewStore.isTimerOn ? "Stop Timer" : "Start Timer",
                        systemImage: viewStore.isTimerOn ? "stop.fill" : "play.fill"
                    )
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(viewStore.isTimerOn ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 32)

                // Fact Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Cat Fact")
                            .font(.headline)

                        Spacer()

                        if viewStore.isLoadingFact {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Button("Get Fact") {
                                viewStore.send(.getFactButtonTapped)
                            }
                            .font(.subheadline)
                            .buttonStyle(.borderedProminent)
                            .tint(.secondary)
                        }
                    }
                    .frame(height: 30)

                    if let fact = viewStore.fact {
                        ScrollView(showsIndicators: false) {
                            Text(fact)
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    } else {
                        Text("Tap to learn something new!")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }
                .padding([.horizontal, .top])
                .frame(height: 165)
                .background(Color.primary.opacity(0.05))
                .cornerRadius(16)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    CounterView(
        store: Store(initialState: CounterFeature.State()) {
            CounterFeature()._printChanges()
        }
    )
}
