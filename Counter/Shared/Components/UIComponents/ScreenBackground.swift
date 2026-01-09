//
//  ScreenBackground.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import SwiftUI

struct ScreenBackground<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        let palette = ThemePalette(scheme: colorScheme)

        ZStack {
            palette.backgroundGradient
                .ignoresSafeArea()

            content
        }
    }
}

#Preview {
    ScreenBackground {
        VStack(spacing: 16) {
            Text("Preview")
                .font(.title2)

            RoundedRectangle(cornerRadius: 20)
                .fill(ThemePalette(scheme: .light).surface)
                .frame(height: 120)
                .shadow(color: ThemePalette(scheme: .light).cardShadow, radius: 12, x: 0, y: 6)
        }
        .padding()
    }
}

#Preview("Dark") {
    ScreenBackground {
        VStack(spacing: 16) {
            Text("Preview")
                .font(.title2)

            RoundedRectangle(cornerRadius: 20)
                .fill(ThemePalette(scheme: .dark).surface)
                .frame(height: 120)
                .shadow(color: ThemePalette(scheme: .dark).cardShadow, radius: 12, x: 0, y: 6)
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
