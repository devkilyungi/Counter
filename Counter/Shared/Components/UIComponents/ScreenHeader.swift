//
//  ScreenHeader.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import SwiftUI

struct ScreenHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 32, weight: .bold, design: .serif))
                .foregroundStyle(Theme.ink)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(Theme.inkSubtle)
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
    .background(Theme.surface)
}

#Preview("Dark") {
    ScreenHeader(
        title: "Header Title",
        subtitle: "A supportive subtitle that explains the section."
    )
    .padding()
    .background(Theme.surface)
    .preferredColorScheme(.dark)
}
