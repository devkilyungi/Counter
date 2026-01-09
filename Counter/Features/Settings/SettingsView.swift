//
//  SettingsView.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) private var colorScheme

    let store: StoreOf<SettingsFeature>

    var body: some View {
        WithPerceptionTracking {
            @Perception.Bindable var store = store
            let palette = ThemePalette(scheme: colorScheme)

            NavigationStack {
                ScreenBackground {
                    ScrollView {
                        VStack(spacing: 24) {
                            ScreenHeader(
                                title: "Settings",
                                subtitle: "Customize your counter experience."
                            )

                            AppCard {
                                VStack(spacing: 20) {
                                    SettingRow(
                                        icon: "moon.fill",
                                        title: "Dark Mode",
                                        subtitle: "Toggle dark appearance",
                                        palette: palette
                                    ) {
                                        Toggle("", isOn: $store.isDarkModeEnabled.sending(\.darkModeToggled))
                                    }

                                    Divider()

                                    SettingRow(
                                        icon: "bell.fill",
                                        title: "Notifications",
                                        subtitle: "Enable counter alerts",
                                        palette: palette
                                    ) {
                                        Toggle("", isOn: $store.notificationsEnabled.sending(\.notificationsToggled))
                                    }

                                    Divider()

                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            Image(systemName: "speedometer")
                                                .foregroundStyle(palette.accent)

                                            VStack(alignment: .leading, spacing: 2) {
                                                Text("Auto-Increment Speed")
                                                    .font(.headline)

                                                Text("Timer interval in seconds")
                                                    .font(.caption)
                                                    .foregroundStyle(palette.inkSubtle)
                                            }

                                            Spacer()

                                            Text("\(store.autoIncrementSpeed, specifier: "%.1f")s")
                                                .font(.headline.monospacedDigit())
                                                .foregroundStyle(palette.accent)
                                        }

                                        Slider(
                                            value: $store.autoIncrementSpeed.sending(\.autoIncrementSpeedChanged),
                                            in: 0.5...5.0,
                                            step: 0.5
                                        )
                                        .tint(palette.accent)
                                    }
                                }
                            }

                            Button {
                                store.send(.dismissTapped)
                            } label: {
                                Label("Done", systemImage: "checkmark.circle.fill")
                            }
                            .buttonStyle(
                                AppCapsuleButtonStyle(
                                    background: palette.accent,
                                    foreground: .white
                                )
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 32)
                    }
                }
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

private struct SettingRow<Content: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    let palette: ThemePalette
    let content: Content

    init(
        icon: String,
        title: String,
        subtitle: String,
        palette: ThemePalette,
        @ViewBuilder content: () -> Content
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.palette = palette
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(palette.accent)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(palette.inkSubtle)
            }

            Spacer()

            content
        }
    }
}

#Preview {
    SettingsView(
        store: Store(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }
    )
}
