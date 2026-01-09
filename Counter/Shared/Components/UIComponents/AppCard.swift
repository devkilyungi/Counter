//
//  AppCard.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import SwiftUI

struct AppCard<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        let palette = ThemePalette(scheme: colorScheme)

        content
            .padding(20)
            .background(palette.surface)
            .clipShape(RoundedRectangle(cornerRadius: palette.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: palette.cornerRadius, style: .continuous)
                    .stroke(palette.surfaceAlt, lineWidth: 1)
            )
            .shadow(color: palette.cardShadow, radius: 14, x: 0, y: 8)
    }
}

#Preview {
    ScreenBackground {
        VStack {
            AppCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Card Title")
                        .font(.headline)

                    Text("Cards can hold any content and inherit the project styling.")
                        .font(.subheadline)
                        .foregroundStyle(ThemePalette(scheme: .light).inkSubtle)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }
}

#Preview("Dark") {
    ScreenBackground {
        VStack {
            AppCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Card Title")
                        .font(.headline)

                    Text("Cards can hold any content and inherit the project styling.")
                        .font(.subheadline)
                        .foregroundStyle(ThemePalette(scheme: .dark).inkSubtle)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
