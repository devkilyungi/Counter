//
//  Theme.swift
//  Counter
//
//  Created by Victor Kilyungi on 09/01/2026.
//

import SwiftUI

struct ThemePalette {
    let scheme: ColorScheme

    var backgroundTop: Color {
        scheme == .dark
            ? Color(red: 0.10, green: 0.11, blue: 0.12)
            : Color(red: 0.98, green: 0.95, blue: 0.91)
    }

    var backgroundBottom: Color {
        scheme == .dark
            ? Color(red: 0.05, green: 0.06, blue: 0.07)
            : Color(red: 0.90, green: 0.94, blue: 0.93)
    }

    var surface: Color {
        scheme == .dark
            ? Color(red: 0.14, green: 0.15, blue: 0.16)
            : Color(red: 0.99, green: 0.98, blue: 0.96)
    }

    var surfaceAlt: Color {
        scheme == .dark
            ? Color(red: 0.18, green: 0.20, blue: 0.22)
            : Color(red: 0.95, green: 0.97, blue: 0.96)
    }

    var accent: Color {
        scheme == .dark
            ? Color(red: 0.18, green: 0.50, blue: 0.45)
            : Color(red: 0.16, green: 0.52, blue: 0.47)
    }

    var accentSoft: Color {
        scheme == .dark
            ? Color(red: 0.18, green: 0.29, blue: 0.27)
            : Color(red: 0.82, green: 0.91, blue: 0.88)
    }

    var danger: Color {
        scheme == .dark
            ? Color(red: 0.92, green: 0.38, blue: 0.36)
            : Color(red: 0.80, green: 0.24, blue: 0.24)
    }

    var ink: Color {
        scheme == .dark
            ? Color(red: 0.94, green: 0.94, blue: 0.92)
            : Color(red: 0.17, green: 0.18, blue: 0.19)
    }

    var inkSubtle: Color {
        scheme == .dark
            ? Color(red: 0.70, green: 0.72, blue: 0.74)
            : Color(red: 0.45, green: 0.48, blue: 0.50)
    }

    var neutralButton: Color {
        scheme == .dark
            ? Color(red: 0.26, green: 0.28, blue: 0.30)
            : Color(red: 0.17, green: 0.18, blue: 0.19)
    }

    let cornerRadius: CGFloat = 26

    var cardShadow: Color {
        scheme == .dark
            ? Color.black.opacity(0.35)
            : Color.black.opacity(0.18)
    }

    var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [backgroundTop, backgroundBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
