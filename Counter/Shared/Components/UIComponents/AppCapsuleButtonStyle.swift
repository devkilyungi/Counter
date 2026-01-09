//
//  AppCapsuleButtonStyle.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import SwiftUI

struct AppCapsuleButtonStyle: ButtonStyle {
    let background: Color
    let foreground: Color

    init(background: Color, foreground: Color = .white) {
        self.background = background
        self.foreground = foreground
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(foreground)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(background)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.85 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

#Preview {
    ScreenBackground {
        VStack(spacing: 16) {
            Button("Primary") {}
                .buttonStyle(
                    AppCapsuleButtonStyle(background: Theme.accent, foreground: .white)
                )

            Button("Secondary") {}
                .buttonStyle(
                    AppCapsuleButtonStyle(background: Theme.neutralButton, foreground: .white)
                )
        }
        .padding()
    }
}

#Preview("Dark") {
    ScreenBackground {
        VStack(spacing: 16) {
            Button("Primary") {}
                .buttonStyle(
                    AppCapsuleButtonStyle(background: Theme.accent)
                )

            Button("Secondary") {}
                .buttonStyle(
                    AppCapsuleButtonStyle(background: Theme.neutralButton)
                )
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
