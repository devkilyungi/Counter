//
//  AppCard.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import SwiftUI

struct AppCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(20)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius, style: .continuous)
                    .stroke(Theme.surfaceAlt, lineWidth: 1)
            )
            .shadow(color: Theme.cardShadow, radius: 14, x: 0, y: 8)
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
                        .foregroundStyle(Theme.inkSubtle)
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
                        .foregroundStyle(Theme.inkSubtle)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
