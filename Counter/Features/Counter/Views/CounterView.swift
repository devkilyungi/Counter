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
        WithPerceptionTracking {
            AppCard {
                VStack(spacing: 24) {
                    CounterHeader(value: store.value)

                    HStack(spacing: 28) {
                        AppIconCircleButton(
                            systemName: "minus",
                            label: "Decrement",
                            tint: Theme.accentSoft
                        ) {
                            store.send(.decrementTapped)
                        }

                        AppIconCircleButton(
                            systemName: "plus",
                            label: "Increment",
                            tint: Theme.accentSoft
                        ) {
                            store.send(.incrementTapped)
                        }
                    }

                    HStack(spacing: 12) {
                        Button {
                            store.send(.timerButtonTapped)
                        } label: {
                            Label(
                                store.isTimerRunning ? "Stop Timer" : "Start Timer",
                                systemImage: store.isTimerRunning ? "stop.fill" : "play.fill"
                            )
                        }
                        .buttonStyle(
                            AppCapsuleButtonStyle(
                                background: store.isTimerRunning ? Theme.danger : Theme.accent,
                                foreground: .white
                            )
                        )

                        Button {
                            store.send(.resetTapped)
                        } label: {
                            Label("Reset", systemImage: "arrow.counterclockwise")
                        }
                        .buttonStyle(
                            AppCapsuleButtonStyle(
                                background: Theme.neutralButton,
                                foreground: .white
                            )
                        )
                    }

                    CounterFactCard(
                        fact: store.factText,
                        isLoading: store.isFactLoading
                    ) {
                        store.send(.factButtonTapped)
                    }
                }
            }
        }
    }
}

private struct CounterHeader: View {
    let value: Int

    var body: some View {
        VStack(spacing: 8) {
            Text("Current Count")
                .font(.system(.title3, design: .serif))
                .fontWeight(.semibold)
                .foregroundStyle(Theme.inkSubtle)

            Text("\(value)")
                .font(.system(size: 64, weight: .black, design: .rounded))
                .foregroundStyle(Theme.ink)
                .monospacedDigit()
        }
    }
}

private struct CounterFactCard: View {
    let fact: String?
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Cat Fact")
                    .font(.system(.headline, design: .serif))
                    .foregroundStyle(Theme.ink)

                Spacer()

                Button(action: action) {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.9)
                    } else {
                        Text("Get Fact")
                            .font(.subheadline.weight(.semibold))
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.accent)
                .disabled(isLoading)
            }

            if let fact {
                Text(fact)
                    .font(.subheadline)
                    .foregroundStyle(Theme.inkSubtle)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text("Tap the button to learn something new.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.inkSubtle)
            }
        }
        .padding(16)
        .background(Theme.surfaceAlt)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    CounterView(
        store: Store(initialState: CounterFeature.State()) {
            CounterFeature()
        }
    )
}
