//
//  CustomColourScheme.swift
//  NeuraStride
//
//  Created by Ashwin Ravikumar on 16/04/2023.
//

import SwiftUI

enum CustomColorScheme {
    case light
    case dark
    
    var primary: Color {
        switch self {
        case .light:
            return Color(hex: "#3F51B5")
        case .dark:
            return Color(hex: "#536DFE")
        }
    }
    
    var secondary: Color {
        switch self {
        case .light:
            return Color(hex: "#F2F2F2")
        case .dark:
            return Color(hex: "#2D2D2D")
        }
    }
    
    var secondary2: Color {
        switch self {
        case .light: return Color(.systemGroupedBackground)
        case .dark: return Color(.systemBackground)
        }
    }
    
    var secondary3: Color {
        switch self {
        case .light:
            return Color.white
        case .dark:
            return Color(hex: "#2D2D2D")
        }
    }
    
    var accent1: Color {
        switch self {
        case .light:
            return Color(hex: "#F44336")
        case .dark:
            return Color(hex: "#EF5350")
        }
    }
    
    var accent2: Color {
        switch self {
        case .light:
            return Color(hex: "#0F9EE1")
        case .dark:
            return Color(hex: "#3BBDFA")
        }
    }
    
    var subText: Color {
        switch self {
        case .light:
            return Color(hex: "#757575")
        case .dark:
            return Color(hex: "#9E9E9E")
        }
    }
    
    var subText2: Color {
        switch self {
        case .light:
            return Color(hex: "#9E9E9E")
        case .dark:
            return Color(hex: "#757575")
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        
        guard scanner.scanHexInt64(&hexNumber) else {
            self.init(.black)
            return
        }
        
        let red = Double((hexNumber & 0xff0000) >> 16) / 255.0
        let green = Double((hexNumber & 0x00ff00) >> 8) / 255.0
        let blue = Double(hexNumber & 0x0000ff) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct CustomColorSchemeKey: EnvironmentKey {
    static let defaultValue: CustomColorScheme = .light
}

extension EnvironmentValues {
    var customColorScheme: CustomColorScheme {
        get { self[CustomColorSchemeKey.self] }
        set { self[CustomColorSchemeKey.self] = newValue }
    }
}

struct CustomColorSchemeModifier: ViewModifier {
    @Environment(\.colorScheme) private var environmentColorScheme
    private var customColorScheme: CustomColorScheme {
        environmentColorScheme == .dark ? .dark : .light
    }
    
    func body(content: Content) -> some View {
        content
            .environment(\.customColorScheme, customColorScheme)
    }
}

extension View {
    func applyCustomColorScheme() -> some View {
        self.modifier(CustomColorSchemeModifier())
    }
}
