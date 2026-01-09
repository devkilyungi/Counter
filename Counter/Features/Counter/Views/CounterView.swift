//
//  CounterView.swift
//  Counter
//
//  Created by Victor Kilyungi on 03/01/2026.
//

import ComposableArchitecture
import SwiftUI

struct CounterView: View {
    @Environment(\.colorScheme) private var colorScheme

    let store: StoreOf<CounterFeature>

    var body: some View {
        WithPerceptionTracking {
            let palette = ThemePalette(scheme: colorScheme)

            AppCard {
                VStack(spacing: 24) {
                    CounterHeader(value: store.value, palette: palette)

                    HStack(spacing: 28) {
                        AppIconCircleButton(
                            systemName: "minus",
                            label: "Decrement",
                            tint: palette.accentSoft
                        ) {
                            store.send(.decrementTapped)
                        }

                        AppIconCircleButton(
                            systemName: "plus",
                            label: "Increment",
                            tint: palette.accentSoft
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
                                background: store.isTimerRunning ? palette.danger : palette.accent,
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
                                background: palette.neutralButton,
                                foreground: .white
                            )
                        )
                    }

                    CounterFactCard(
                        fact: store.factText,
                        isLoading: store.isFactLoading,
                        palette: palette
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
    let palette: ThemePalette

    var body: some View {
        VStack(spacing: 8) {
            Text("Current Count")
                .font(.system(.title3, design: .serif))
                .fontWeight(.semibold)
                .foregroundStyle(palette.inkSubtle)

            Text("\(value)")
                .font(.system(size: 64, weight: .black, design: .rounded))
                .foregroundStyle(palette.ink)
                .monospacedDigit()
        }
    }
}

private struct CounterFactCard: View {
    let fact: String?
    let isLoading: Bool
    let palette: ThemePalette
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Cat Fact")
                    .font(.system(.headline, design: .serif))
                    .foregroundStyle(palette.ink)

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
                .tint(palette.accent)
                .disabled(isLoading)
            }

            if let fact {
                Text(fact)
                    .font(.subheadline)
                    .foregroundStyle(palette.inkSubtle)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text("Tap the button to learn something new.")
                    .font(.subheadline)
                    .foregroundStyle(palette.inkSubtle)
            }
        }
        .padding(16)
        .background(palette.surfaceAlt)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    CounterView(
        store: Store(initialState: CounterFeature.State(timerToken: UUID())) {
            CounterFeature()
        }
    )
}
