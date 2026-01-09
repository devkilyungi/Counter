//
//  ScreenBackground.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import SwiftUI

struct ScreenBackground<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            Theme.backgroundGradient
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
                .fill(Theme.surface)
                .frame(height: 120)
                .shadow(color: Theme.cardShadow, radius: 12, x: 0, y: 6)
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
                .fill(Theme.surface)
                .frame(height: 120)
                .shadow(color: Theme.cardShadow, radius: 12, x: 0, y: 6)
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
