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
    let onOpenSheet: (() -> Void)?
    let onOpenFullScreen: (() -> Void)?

    init(
        store: StoreOf<SettingsFeature>,
        onOpenSheet: (() -> Void)? = nil,
        onOpenFullScreen: (() -> Void)? = nil
    ) {
        self.store = store
        self.onOpenSheet = onOpenSheet
        self.onOpenFullScreen = onOpenFullScreen
    }

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

                            AppearanceSection(store: store.scope(state: \.appearance, action: \.appearance))

                            if onOpenSheet != nil || onOpenFullScreen != nil {
                                AppCard {
                                    VStack(spacing: 12) {
                                        if let onOpenSheet {
                                            Button(action: onOpenSheet) {
                                                Label(
                                                    "Open Counter in Sheet",
                                                    systemImage: "rectangle.portrait.and.arrow.right"
                                                )
                                            }
                                            .buttonStyle(
                                                AppCapsuleButtonStyle(
                                                    background: palette.neutralButton,
                                                    foreground: .white
                                                )
                                            )
                                        }

                                        if let onOpenFullScreen {
                                            Button(action: onOpenFullScreen) {
                                                Label(
                                                    "Open Counter Full Screen",
                                                    systemImage: "arrow.up.left.and.arrow.down.right"
                                                )
                                            }
                                            .buttonStyle(
                                                AppCapsuleButtonStyle(
                                                    background: palette.neutralButton,
                                                    foreground: .white
                                                )
                                            )
                                        }
                                    }
                                }
                            }

                            AppCard {
                                VStack(spacing: 20) {
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

                                            Text("\(store.autoIncrementSpeed, specifier: "%.0f")s")
                                                .font(.headline.monospacedDigit())
                                                .foregroundStyle(palette.accent)
                                        }

                                        Stepper(
                                            value: $store.autoIncrementSpeed.sending(\.autoIncrementSpeedChanged),
                                            in: 1.0...15.0,
                                            step: 1.0
                                        ) {
                                            Text("Interval")
                                                .font(.subheadline)
                                                .foregroundStyle(palette.inkSubtle)
                                        }
                                    }
                                }
                            }
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

private struct AppearanceSection: View {
    let store: StoreOf<AppearanceFeature>

    var body: some View {
        WithPerceptionTracking {
            @Perception.Bindable var store = store

            AppCard {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Appearance")
                        .font(.headline)

                    Picker(
                        "Theme",
                        selection: $store.selection.sending(\.setSelection)
                    ) {
                        ForEach(Appearance.allCases) { appearance in
                            Text(appearance.displayName)
                                .tag(appearance)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onAppear { store.send(.onAppear) }
                }
            }
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
