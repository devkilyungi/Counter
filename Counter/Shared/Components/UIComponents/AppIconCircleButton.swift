//
//  AppIconCircleButton.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import SwiftUI

struct AppIconCircleButton: View {
    let systemName: String
    let label: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title2.weight(.semibold))
                .foregroundStyle(Theme.ink)
                .frame(width: 64, height: 64)
                .background(tint)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Theme.surfaceAlt, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}

#Preview {
    ScreenBackground {
        HStack(spacing: 16) {
            AppIconCircleButton(
                systemName: "minus",
                label: "Decrement",
                tint: Theme.accentSoft,
                action: {}
            )

            AppIconCircleButton(
                systemName: "plus",
                label: "Increment",
                tint: Theme.accentSoft,
                action: {}
            )
        }
        .padding()
    }
}

#Preview("Dark") {
    ScreenBackground {
        HStack(spacing: 16) {
            AppIconCircleButton(
                systemName: "minus",
                label: "Decrement",
                tint: Theme.accentSoft,
                action: {}
            )

            AppIconCircleButton(
                systemName: "plus",
                label: "Increment",
                tint: Theme.accentSoft,
                action: {}
            )
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
