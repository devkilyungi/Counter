//
//  ScreenHeader.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import SwiftUI

struct ScreenHeader: View {
    @Environment(\.colorScheme) private var colorScheme

    let title: String
    let subtitle: String

    var body: some View {
        let palette = ThemePalette(scheme: colorScheme)

        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 32, weight: .bold, design: .serif))
                .foregroundStyle(palette.ink)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(palette.inkSubtle)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ScreenHeader(
        title: "Header Title",
        subtitle: "A supportive subtitle that explains the section."
    )
    .padding()
    .background(ThemePalette(scheme: .light).surface)
}

#Preview("Dark") {
    ScreenHeader(
        title: "Header Title",
        subtitle: "A supportive subtitle that explains the section."
    )
    .padding()
    .background(ThemePalette(scheme: .dark).surface)
    .preferredColorScheme(.dark)
}
