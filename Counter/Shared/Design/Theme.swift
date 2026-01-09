//
//  Theme.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import SwiftUI

enum Theme {
    static let backgroundTop = Color(light: .init(red: 0.98, green: 0.95, blue: 0.91, alpha: 1),
                                     dark: .init(red: 0.10, green: 0.11, blue: 0.12, alpha: 1))
    static let backgroundBottom = Color(light: .init(red: 0.90, green: 0.94, blue: 0.93, alpha: 1),
                                        dark: .init(red: 0.05, green: 0.06, blue: 0.07, alpha: 1))
    static let surface = Color(light: .init(red: 0.99, green: 0.98, blue: 0.96, alpha: 1),
                               dark: .init(red: 0.14, green: 0.15, blue: 0.16, alpha: 1))
    static let surfaceAlt = Color(light: .init(red: 0.95, green: 0.97, blue: 0.96, alpha: 1),
                                  dark: .init(red: 0.18, green: 0.20, blue: 0.22, alpha: 1))
    static let accent = Color(light: .init(red: 0.16, green: 0.52, blue: 0.47, alpha: 1),
                              dark: .init(red: 0.18, green: 0.50, blue: 0.45, alpha: 1))
    static let accentSoft = Color(light: .init(red: 0.82, green: 0.91, blue: 0.88, alpha: 1),
                                  dark: .init(red: 0.18, green: 0.29, blue: 0.27, alpha: 1))
    static let danger = Color(light: .init(red: 0.80, green: 0.24, blue: 0.24, alpha: 1),
                              dark: .init(red: 0.92, green: 0.38, blue: 0.36, alpha: 1))
    static let ink = Color(light: .init(red: 0.17, green: 0.18, blue: 0.19, alpha: 1),
                           dark: .init(red: 0.94, green: 0.94, blue: 0.92, alpha: 1))
    static let inkSubtle = Color(light: .init(red: 0.45, green: 0.48, blue: 0.50, alpha: 1),
                                 dark: .init(red: 0.70, green: 0.72, blue: 0.74, alpha: 1))
    static let neutralButton = Color(light: .init(red: 0.17, green: 0.18, blue: 0.19, alpha: 1),
                                     dark: .init(red: 0.26, green: 0.28, blue: 0.30, alpha: 1))

    static let cornerRadius: CGFloat = 26
    static let cardShadow = Color.black.opacity(0.18)

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [backgroundTop, backgroundBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

private extension Color {
    init(light: UIColor, dark: UIColor) {
        self = Color(uiColor: UIColor { trait in
            trait.userInterfaceStyle == .dark ? dark : light
        })
    }
}
